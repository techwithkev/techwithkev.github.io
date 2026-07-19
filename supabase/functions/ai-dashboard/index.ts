import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { corsHeaders } from './cors.ts';

// ─────────────────────────────────────────────────────────────────────────────
// CONFIG
// ─────────────────────────────────────────────────────────────────────────────
const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const GROQ_MODEL = 'llama-3.3-70b-versatile'; // fast, smart, free-tier friendly

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

async function callGroq(systemPrompt: string, userPrompt: string, groqKey: string): Promise<string> {
  const res = await fetch(GROQ_API_URL, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${groqKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: GROQ_MODEL,
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user',   content: userPrompt },
      ],
      temperature: 0.5,
      max_tokens: 600,
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Groq API error ${res.status}: ${err}`);
  }

  const json = await res.json();
  return json.choices?.[0]?.message?.content?.trim() ?? '(no response)';
}

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION: cohort_summary
// Accepts pre-computed stats from the client — no DB query needed.
// ─────────────────────────────────────────────────────────────────────────────
async function handleCohortSummary(payload: Record<string, unknown>, groqKey: string): Promise<Response> {
  const { cohort, stats } = payload as {
    cohort: string;
    stats: {
      totalStudents: number;
      totalSubmissions: number;
      avgScore: number;
      maxScore: number;
      scoreDistribution: Record<string, number>;
      classCounts: Record<string, number>;
      topStudents: Array<{ name: string; avg: number; count: number }>;
      lowStudents: Array<{ name: string; avg: number; count: number }>;
      lowestClasses: Array<{ class: string; count: number }>;
    };
  };

  const systemPrompt = `You are an assistant for a teacher running an introductory AI course for middle and high school students.
Your job is to provide clear, warm, and actionable cohort performance summaries.
Be concise (3–5 sentences). Use plain language — no jargon. Do NOT use markdown headers or bullet lists.
Focus on: overall performance trend, standout students, students who may need support, and which classes have the least engagement.
Always end with one specific actionable suggestion for the teacher.`;

  const userPrompt = `Generate a performance summary for cohort: "${cohort || 'All students'}".

Key stats:
- Total unique students: ${stats.totalStudents}
- Total homework submissions: ${stats.totalSubmissions}
- Average homework score: ${stats.avgScore} / ${stats.maxScore}
- Score distribution: ${JSON.stringify(stats.scoreDistribution)}
- Submissions per class: ${JSON.stringify(stats.classCounts)}
- Top 3 students (highest avg): ${stats.topStudents.slice(0, 3).map(s => `${s.name} (avg ${s.avg}/20, ${s.count} submissions)`).join(', ')}
- Students who may need support (lowest avg): ${stats.lowStudents.slice(0, 3).map(s => `${s.name} (avg ${s.avg}/20, ${s.count} submissions)`).join(', ')}
- Classes with fewest submissions: ${stats.lowestClasses.slice(0, 3).map(c => `Class ${c.class} (${c.count} submissions)`).join(', ')}

Write the summary now.`;

  const summary = await callGroq(systemPrompt, userPrompt, groqKey);
  return json({ summary });
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN HANDLER
// ─────────────────────────────────────────────────────────────────────────────
Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  if (req.method !== 'POST') {
    return json({ error: 'Method not allowed' }, 405);
  }

  try {
    // ── Read secrets ─────────────────────────────────────────────────────────
    const groqKey = Deno.env.get('GROQ_API_KEY');
    if (!groqKey) return json({ error: 'GROQ_API_KEY secret not configured.' }, 500);

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY')!;

    // ── Verify teacher is authenticated ──────────────────────────────────────
    // The browser sends the Supabase session JWT in the Authorization header.
    const authHeader = req.headers.get('Authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return json({ error: 'Unauthorized. Please sign in.' }, 401);
    }

    const sb = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
      auth: { persistSession: false },
    });

    // Verify the JWT resolves to a real user
    const { data: { user }, error: userErr } = await sb.auth.getUser();
    if (userErr || !user) {
      return json({ error: 'Invalid or expired session. Please sign in again.' }, 401);
    }

    // ── Parse body ───────────────────────────────────────────────────────────
    const body = await req.json();
    const { action, payload } = body as { action: string; payload: Record<string, unknown> };

    if (!action) return json({ error: 'Missing "action" field.' }, 400);

    // ── Dispatch actions ─────────────────────────────────────────────────────
    switch (action) {
      case 'cohort_summary':
        return handleCohortSummary(payload, groqKey);

      default:
        return json({ error: `Unknown action: ${action}` }, 400);
    }

  } catch (err) {
    console.error('ai-dashboard error:', err);
    return json({ error: 'Server error. Please try again.' }, 500);
  }
});
