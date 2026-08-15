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
      max_tokens: 1000,
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
// ACTION: student_analyzer
// Evaluates a single student's submissions across all Intro to AI exercises.
// ─────────────────────────────────────────────────────────────────────────────
async function handleStudentAnalyzer(payload: Record<string, unknown>, groqKey: string): Promise<Response> {
  const { student_name, student_email, submissions_summary } = payload as {
    student_name: string;
    student_email: string;
    submissions_summary: Array<{
      exercise_id: string;
      exercise_title: string;
      week: number;
      submitted_at: string;
      enjoyment_rating?: number;
      key_answers: Record<string, any>;
    }>;
  };

  const systemPrompt = `You are an expert AI & Computer Science educator providing empathetic, highly perceptive, and constructive teacher commentary for a student enrolled in an "Intro to AI" course for middle and high school students.
Your goal is to evaluate the student's overall progress across their submitted AI exercises and generate professional teacher commentary.

Format your response in clear, markdown with bold section headers and bullet points:
1. 🌟 **Overall Student Performance Summary** (2-3 sentences summarizing engagement, consistency, and general quality)
2. 🧠 **AI Concept Mastery & Strengths** (Highlight specific concepts where the student demonstrates understanding e.g., prompting techniques, AI bias detection, ethical analysis, machine learning model training, rule-based vs LLM chatbot logic, AI career mapping)
3. 💡 **Areas for Growth & Encouragement** (Constructive advice on areas where their answers were brief or where concepts could be deepened)
4. 📝 **Teacher Comment for Report Card / 1-on-1 Feedback** (A ready-to-use, polished 2-sentence teacher comment for report cards or parent communications)

Keep the tone encouraging, warm, professional, and pedagogical.`;

  const userPrompt = `Generate a teacher evaluation report for student: "${student_name}" (${student_email || 'No email provided'}).
They have completed ${submissions_summary.length} Intro to AI exercise(s).

Here are their exercise submissions across the course:
${JSON.stringify(submissions_summary, null, 2)}

Provide the complete teacher analysis report now.`;

  const analysis = await callGroq(systemPrompt, userPrompt, groqKey);
  return json({ analysis });
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

      case 'student_analyzer':
        return handleStudentAnalyzer(payload, groqKey);

      default:
        return json({ error: `Unknown action: ${action}` }, 400);
    }

  } catch (err) {
    console.error('ai-dashboard error:', err);
    return json({ error: 'Server error. Please try again.' }, 500);
  }
});
