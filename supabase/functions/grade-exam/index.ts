import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { corsHeaders } from './cors.ts';

// ─────────────────────────────────────────────────────────────────────────────
// ANSWER KEYS — stored server-side only, never sent to the browser
// ─────────────────────────────────────────────────────────────────────────────

const MCQ: Record<string, string> = {
  q1: 'B', q2: 'B', q3: 'C', q4: 'B', q5: 'C',
  q6: 'B', q7: 'A', q8: 'B', q9: 'C', q10: 'B',
  q11: 'B', q12: 'B', q13: 'C', q14: 'B', q15: 'C',
};

const BLANKS: Record<string, string[]> = {
  // Q16 — A* Search
  q16_b1: ['0', '0.0', 'int(0)'],
  q16_b2: ['heappop', 'heapq.heappop'],
  q16_b3: ['h[neighbor]', 'h.get(neighbor)', 'h[neighbor_node]'],
  q16_b4: ['heappush', 'heapq.heappush'],
  q16_b5: ['node', 'current'],
  q16_b6: ['append'],
  // Q19 — k-Means
  q19_b1: ['cluster'],
  q19_b2: ['3', '3.0'],
  q19_b3: ['fit', 'fit_predict'],
  q19_b4: ['labels', 'labels_'],
  q19_b5: ['inertia', 'inertia_'],
  q19_b6: ['labels', 'km.labels_', 'labels_'],
  // Q20 — Q-learning
  q20_b1: ['state', 's'],
  q20_b2: ['action', 'a'],
  q20_b3: ['max', 'amax', 'np.max', 'np.amax'],
  q20_b4: ['best_next', 'max_next', 'np.max(q[next_state])', 'max(q[next_state])'],
  q20_b5: ['alpha', 'lr', 'learning_rate'],
};

// Rubrics shown to instructors in dashboard / audit
const RUBRICS: Record<number, string> = {
  16: 'b1:0  b2:heappop  b3:h[neighbor]  b4:heappush  b5:node  b6:append',
  17: 'Centroid A=(3,2.67) · Centroid B=(9,7) · Inertia(A): dist²((1,2),(3,2.67))=4+0.449=4.449 · dist²((3,4),(3,2.67))=0+1.778=1.778 · dist²((5,2),(3,2.67))=4+0.449=4.449 · Total=10.67',
  18: 'Score(Spam)=0.40×0.80×0.70=0.224 · Score(NotSpam)=0.60×0.10×0.05=0.003 · P(Spam|email)=0.224/0.227≈0.987 → Spam',
  19: 'b1:cluster  b2:3  b3:fit  b4:labels  b5:inertia  b6:labels',
  20: 'b1:state  b2:action  b3:max  b4:best_next  b5:alpha',
  21: 'A*: fixed map, known costs, admissible heuristic → optimal path guaranteed. Q-learning: dynamic environment, unknown map, learns from rewards. State=position; Action=move direction; Reward=negative distance penalty/+bonus on arrival. γ=0.9 → future rewards count heavily; robot motivated to reach goal quickly rather than accumulate small rewards along the way.',
};

const BLANK_IDS: Record<string, string[]> = {
  q16: ['q16_b1', 'q16_b2', 'q16_b3', 'q16_b4', 'q16_b5', 'q16_b6'],
  q19: ['q19_b1', 'q19_b2', 'q19_b3', 'q19_b4', 'q19_b5', 'q19_b6'],
  q20: ['q20_b1', 'q20_b2', 'q20_b3', 'q20_b4', 'q20_b5'],
};

const ACCESS_TABLE = 'access_codes';
const RESULTS_TABLE = 'caio_final_exam_results';
const EXAM_CLASS = 16;

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

function matchBlank(id: string, val: string | undefined): boolean {
  if (!val) return false;
  const n = val.toLowerCase().trim().replace(/['"]/g, '').replace(/\s/g, '');
  if (!n) return false;
  return (BLANKS[id] || []).some((ans) => {
    const an = ans.toLowerCase().trim().replace(/['"]/g, '').replace(/\s/g, '');
    return n === an;
  });
}

function gradeAll(answers: Record<string, string>) {
  let mcqScore = 0;
  let blankScore = 0;
  const breakdown: Record<string, unknown> = {};

  // Grade MCQ (Q1–15, 2pts each, max 30)
  for (let q = 1; q <= 15; q++) {
    const key = `q${q}`;
    const submitted = answers[key] ?? null;
    const correct = MCQ[key];
    const ok = submitted === correct;
    if (ok) mcqScore += 2;
    breakdown[key] = { ok, submitted, correctAnswer: correct };
  }

  // Grade fill-in-blank groups (5pts each, max 15)
  function blanksGroup(groupKey: string, ids: string[]) {
    const items = ids.map((id) => ({
      id,
      val: answers[id] ?? '',
      ok: matchBlank(id, answers[id]),
    }));
    const correct = items.filter((i) => i.ok).length;
    const pts = Math.round((correct / ids.length) * 5);
    blankScore += pts;
    breakdown[groupKey] = { type: 'blanks', pts, cor: correct, of: ids.length, items };
  }

  blanksGroup('q16', BLANK_IDS.q16);
  blanksGroup('q19', BLANK_IDS.q19);
  blanksGroup('q20', BLANK_IDS.q20);

  // Open-ended — no auto-grade, just store text
  [17, 18, 21].forEach((q) => {
    breakdown[`q${q}`] = { type: 'oe', text: answers[`q${q}_text`] || '' };
  });

  return { mcqScore, blankScore, autoScore: mcqScore + blankScore, breakdown };
}

// ─────────────────────────────────────────────────────────────────────────────
// EDGE FUNCTION HANDLER
// ─────────────────────────────────────────────────────────────────────────────

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  try {
    const body = await req.json();
    const { studentName, accessCode, sessionId, answers } = body;

    // ── Basic input validation ───────────────────────────────────────────────
    if (!studentName || typeof studentName !== 'string' || studentName.trim().length < 2) {
      return new Response(JSON.stringify({ error: 'Invalid student name.' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }
    if (!accessCode || typeof accessCode !== 'string') {
      return new Response(JSON.stringify({ error: 'Access code required.' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }
    if (!answers || typeof answers !== 'object') {
      return new Response(JSON.stringify({ error: 'Answers payload missing.' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // ── Supabase service-role client (bypasses RLS for trusted writes) ───────
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? Deno.env.get('SUPABASE_SERVICE_KEY') ?? Deno.env.get('SUPABASE_ANON_KEY')!;
    const db = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false },
    });

    // ── Validate access code server-side ────────────────────────────────────
    const { data: codeRow, error: codeErr } = await db
      .from(ACCESS_TABLE)
      .select('id, class_number, max_uses, uses_count, is_active, cohort')
      .eq('code', accessCode.toUpperCase())
      .single();

    if (codeErr || !codeRow) {
      return new Response(JSON.stringify({ error: `Invalid access code: ${codeErr?.message || 'Code not found'}` }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }
    if (!codeRow.is_active) {
      return new Response(JSON.stringify({ error: 'Access code has been deactivated.' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }
    if (codeRow.class_number !== EXAM_CLASS) {
      return new Response(
        JSON.stringify({ error: `Code is for Class ${codeRow.class_number}, not Class ${EXAM_CLASS}.` }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }
    if (codeRow.uses_count > codeRow.max_uses) {
      return new Response(JSON.stringify({ error: 'Access code has exceeded its use limit.' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // ── Grade answers ────────────────────────────────────────────────────────
    const { mcqScore, blankScore, autoScore, breakdown } = gradeAll(answers);

    // ── Build DB payload ─────────────────────────────────────────────────────
    const mcqDetails: Record<string, unknown> = {};
    for (let q = 1; q <= 15; q++) {
      const b = breakdown[`q${q}`] as { ok: boolean; submitted: string };
      mcqDetails[`q${q}`] = { answer: b.submitted, correct: b.ok };
    }

    const dbPayload = {
      student_name: studentName.trim(),
      class_number: EXAM_CLASS,
      access_code: accessCode.toUpperCase(),
      submitted_at: new Date().toISOString(),
      mcq_score: mcqScore,
      blank_score: blankScore,
      auto_score: autoScore,
      mcq_details: mcqDetails,
      // Q16 blanks
      q16_b1: answers.q16_b1, q16_b2: answers.q16_b2, q16_b3: answers.q16_b3,
      q16_b4: answers.q16_b4, q16_b5: answers.q16_b5, q16_b6: answers.q16_b6,
      // Q19 blanks
      q19_b1: answers.q19_b1, q19_b2: answers.q19_b2, q19_b3: answers.q19_b3,
      q19_b4: answers.q19_b4, q19_b5: answers.q19_b5, q19_b6: answers.q19_b6,
      // Q20 blanks
      q20_b1: answers.q20_b1, q20_b2: answers.q20_b2, q20_b3: answers.q20_b3,
      q20_b4: answers.q20_b4, q20_b5: answers.q20_b5,
      // Open-ended
      q17_text: answers.q17_text,
      q18_text: answers.q18_text,
      q21_text: answers.q21_text,
      // Cohort — taken from the DB row, not from the client, to prevent spoofing
      cohort: codeRow.cohort ?? null,
      // Session tracking — session_id upsert key; started_at is intentionally
      // omitted here so the value written at exam-start is preserved by Postgres.
      session_id:   sessionId && /^[0-9a-f-]{36}$/i.test(sessionId) ? sessionId : null,
      submitted_at: new Date().toISOString(),
    };

    // ── Save results ─────────────────────────────────────────────────────────
    // Use upsert only when session_id is present (requires the migration to have
    // run). Fall back to plain insert pre-migration so submissions always work.
    const validSessionId = sessionId && /^[0-9a-f-]{36}$/i.test(sessionId)
      ? sessionId
      : null;

    // Strip session_id / started_at from the payload if migration hasn't run yet
    // (those columns won't exist and will cause a 500).
    const savePayload = validSessionId
      ? dbPayload  // includes session_id already set above
      : (() => { const p = { ...dbPayload }; delete p.session_id; return p; })();

    const { error: insertErr } = validSessionId
      ? await db.from(RESULTS_TABLE).upsert(savePayload, {
          onConflict: 'session_id',
          ignoreDuplicates: false,
        })
      : await db.from(RESULTS_TABLE).insert(savePayload);
    if (insertErr) {
      console.error('Insert error:', insertErr);
      return new Response(JSON.stringify({ error: `Failed to save results: ${insertErr.message || JSON.stringify(insertErr)}` }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // ── Return graded results + rubrics (safe to send post-submission) ───────
    return new Response(
      JSON.stringify({ mcqScore, blankScore, autoScore, breakdown, rubrics: RUBRICS }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (err) {
    console.error('Unhandled error:', err);
    return new Response(JSON.stringify({ error: 'Server error. Please contact your instructor.' }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});
