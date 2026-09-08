import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { corsHeaders } from './cors.ts';

// ─────────────────────────────────────────────────────────────────────────────
// ANSWER KEYS & RUBRICS — stored server-side only, never sent to student browser
// ─────────────────────────────────────────────────────────────────────────────

const MCQ: Record<string, string> = {
  q1: 'B', q2: 'B', q3: 'C', q4: 'B', q5: 'C',
  q6: 'B', q7: 'A', q8: 'B', q9: 'C', q10: 'B',
  q11: 'B', q12: 'B', q13: 'C', q14: 'B', q15: 'C',
};

const BLANKS: Record<string, string[]> = {
  // Q16 — A* Search (5 pts total)
  q16_b1: ['0', '0.0', 'int(0)'],
  q16_b2: ['heappop', 'heapq.heappop'],
  q16_b3: ['h[neighbor]', 'h.get(neighbor)', 'h[neighbor_node]', 'h.get(neighbor,0)'],
  q16_b4: ['heappush', 'heapq.heappush'],
  q16_b5: ['node', 'current', 'came_from[node]'],
  q16_b6: ['append'],
  // Q19 — k-Means (5 pts total)
  q19_b1: ['cluster'],
  q19_b2: ['3', '3.0'],
  q19_b3: ['fit', 'fit_predict', 'fit(x)', 'fit(X)'],
  q19_b4: ['labels', 'labels_'],
  q19_b5: ['inertia', 'inertia_'],
  q19_b6: ['labels', 'km.labels_', 'labels_', 'km.labels'],
  // Q20 — Q-learning (5 pts total)
  q20_b1: ['state', 's'],
  q20_b2: ['action', 'a'],
  q20_b3: ['max', 'amax', 'np.max', 'np.amax'],
  q20_b4: ['best_next', 'max_next', 'np.max(q[next_state])', 'max(q[next_state])', 'np.max(Q[next_state])', 'max(Q[next_state])'],
  q20_b5: ['alpha', 'lr', 'learning_rate'],
};

const RUBRICS: Record<number, string> = {
  16: 'b1:0  b2:heappop  b3:h[neighbor]  b4:heappush  b5:node  b6:append',
  17: 'Centroid A=(3,2.67) · Centroid B=(9,7) · Inertia(A): dist²((1,2),(3,2.67))=4+0.449=4.449 · dist²((3,4),(3,2.67))=0+1.778=1.778 · dist²((5,2),(3,2.67))=4+0.449=4.449 · Total=10.67',
  18: 'Score(Spam)=0.40×0.80×0.70=0.224 · Score(NotSpam)=0.60×0.10×0.05=0.003 · P(Spam|email)=0.224/0.227≈0.987 (98.7%) → Spam',
  19: 'b1:cluster  b2:3  b3:fit  b4:labels_  b5:inertia_  b6:labels_',
  20: 'b1:state  b2:action  b3:max  b4:best_next  b5:alpha',
  21: 'A*: fixed map, known costs, admissible heuristic → optimal path guaranteed. Q-learning: dynamic environment, unknown map, learns from rewards. State=position; Action=move direction; Reward=negative distance penalty/+bonus on arrival. γ=0.9 → future rewards count heavily; robot motivated to reach goal quickly rather than accumulate small rewards along the way.',
};

const BLANK_IDS: Record<string, string[]> = {
  q16: ['q16_b1', 'q16_b2', 'q16_b3', 'q16_b4', 'q16_b5', 'q16_b6'],
  q19: ['q19_b1', 'q19_b2', 'q19_b3', 'q19_b4', 'q19_b5', 'q19_b6'],
  q20: ['q20_b1', 'q20_b2', 'q20_b3', 'q20_b4', 'q20_b5'],
};

const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const GROQ_MODEL = 'llama-3.3-70b-versatile';

const ACCESS_TABLE = 'access_codes';
const RESULTS_TABLE = 'caio_final_exam_results';

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

function gradeDeterministic(answers: Record<string, string>) {
  let mcqScore = 0;
  let blankScore = 0;
  const mcqBreakdown: Record<string, { ok: boolean; submitted: string | null; correctAnswer: string }> = {};
  const blanksBreakdown: Record<string, { pts: number; cor: number; of: number; items: Array<{ id: string; val: string; ok: boolean }> }> = {};

  // Grade MCQ (Q1–15, 2pts each, max 30)
  for (let q = 1; q <= 15; q++) {
    const key = `q${q}`;
    const submitted = answers[key] ?? null;
    const correct = MCQ[key];
    const ok = submitted === correct;
    if (ok) mcqScore += 2;
    mcqBreakdown[key] = { ok, submitted, correctAnswer: correct };
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
    blanksBreakdown[groupKey] = { pts, cor: correct, of: ids.length, items };
  }

  blanksGroup('q16', BLANK_IDS.q16);
  blanksGroup('q19', BLANK_IDS.q19);
  blanksGroup('q20', BLANK_IDS.q20);

  return { mcqScore, blankScore, mcqBreakdown, blanksBreakdown };
}

interface OpenEndedGrade {
  score: number;
  feedback: string;
}

async function gradeOpenEndedWithGroq(
  q17Text: string,
  q18Text: string,
  q21Text: string,
  groqKey: string | undefined
): Promise<Record<string, OpenEndedGrade>> {
  const defaultFallback: Record<string, OpenEndedGrade> = {
    q17: { score: 0, feedback: q17Text ? 'Evaluated manually / pending review.' : 'No response provided.' },
    q18: { score: 0, feedback: q18Text ? 'Evaluated manually / pending review.' : 'No response provided.' },
    q21: { score: 0, feedback: q21Text ? 'Evaluated manually / pending review.' : 'No response provided.' },
  };

  if (!groqKey) {
    console.warn('GROQ_API_KEY not configured. Skipping LLM auto-grading.');
    return defaultFallback;
  }

  const systemPrompt = `You are an expert AI & Machine Learning examiner and strict academic grader evaluating a high school student's final exam.
Evaluate the student's written answers for Q17, Q18, and Q21 strictly against the provided rubrics.
Award an integer score from 0 to 5 for each question, and provide 1-2 concise sentences of constructive feedback explaining the marks awarded or lost.

Rubric Details:
- Q17 (k-Means Centroids & Inertia, max 5 pts):
  * Part 1 (1.5 pts): Centroid A = (3, 2.67) [mean of x=(1+3+5)/3=3, mean of y=(2+4+2)/3=2.67].
  * Part 2 (1.5 pts): Centroid B = (9, 7) [mean of x=(8+10)/2=9, mean of y=(8+6)/2=7].
  * Part 3 (2.0 pts): Inertia of Cluster A = dist²((1,2),(3,2.67)) + dist²((3,4),(3,2.67)) + dist²((5,2),(3,2.67)) = 4.449 + 1.778 + 4.449 = 10.67 (Accept 10.6 to 10.7, or correct working).
  * If student gives empty/blank response, score = 0.

- Q18 (Naive Bayes Spam Classification, max 5 pts):
  * Part 1 (1.5 pts): Unnormalized Score(Spam) = 0.40 × 0.80 × 0.70 = 0.224.
  * Part 2 (1.5 pts): Unnormalized Score(Not Spam) = 0.60 × 0.10 × 0.05 = 0.003.
  * Part 3 (2.0 pts): Normalized probability P(Spam|email) = 0.224 / (0.224 + 0.003) = 0.224 / 0.227 ≈ 0.9868 (~98.7%) and classified as Spam.
  * If student gives empty/blank response, score = 0.

- Q21 (A* vs Q-Learning Robotics, max 5 pts):
  * Part 1 (1.5 pts): A* is better when map is known/static. Admissible heuristic ensures shortest path efficiently without overestimating.
  * Part 2 (2.0 pts): Q-learning is better in unknown/dynamic environments. State = robot grid position, Action = direction of movement, Reward = penalty for time/step and positive reward for goal.
  * Part 3 (1.5 pts): Discount factor γ = 0.9 heavily weights future rewards (patient agent), guiding the robot to find efficient routes to the destination rather than wandering.
  * If student gives empty/blank response, score = 0.

OUTPUT FORMAT: Return ONLY a valid JSON object with keys "q17", "q18", "q21". Each key must have "score" (integer 0-5) and "feedback" (string). No markdown formatting or explanation outside JSON.`;

  const userPrompt = `STUDENT SUBMISSIONS TO GRADE:

--- Question 17 (k-Means) Student Response ---
${q17Text || '(No response provided)'}

--- Question 18 (Naive Bayes) Student Response ---
${q18Text || '(No response provided)'}

--- Question 21 (A* vs Q-Learning) Student Response ---
${q21Text || '(No response provided)'}

Grade the 3 questions and return the JSON.`;

  try {
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
          { role: 'user', content: userPrompt },
        ],
        temperature: 0.1,
        max_tokens: 600,
        response_format: { type: 'json_object' },
      }),
    });

    if (!res.ok) {
      const errText = await res.text();
      console.error('Groq API error:', res.status, errText);
      return defaultFallback;
    }

    const data = await res.json();
    const content = data.choices?.[0]?.message?.content?.trim() || '{}';
    const parsed = JSON.parse(content);

    const sanitizeResult = (item: any, userText: string): OpenEndedGrade => {
      if (!userText.trim()) return { score: 0, feedback: 'No response submitted.' };
      const rawScore = Number(item?.score);
      const score = Number.isFinite(rawScore) ? Math.min(5, Math.max(0, Math.round(rawScore))) : 0;
      const feedback = typeof item?.feedback === 'string' && item.feedback.trim()
        ? item.feedback.trim()
        : 'Automated evaluation completed.';
      return { score, feedback };
    };

    return {
      q17: sanitizeResult(parsed.q17, q17Text),
      q18: sanitizeResult(parsed.q18, q18Text),
      q21: sanitizeResult(parsed.q21, q21Text),
    };
  } catch (err) {
    console.error('Groq grading failed:', err);
    return defaultFallback;
  }
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

    // ── Supabase service-role client ─────────────────────────────────────────
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? Deno.env.get('SUPABASE_SERVICE_KEY') ?? Deno.env.get('SUPABASE_ANON_KEY')!;
    const groqKey = Deno.env.get('GROQ_API_KEY');
    const db = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false },
    });

    // ── Validate access code server-side ────────────────────────────────────
    const { data: codeRow, error: codeErr } = await db
      .from(ACCESS_TABLE)
      .select('id, purpose, max_uses, uses_count, is_active, cohort_id, class_id, cohorts(name, slug), classes(label, sequence_order)')
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
    const targetExamClass = body.examClass || 19;
    const codeClassSeq = (codeRow as any).classes?.sequence_order ?? null;
    if (codeRow.class_id && codeClassSeq !== null && codeClassSeq !== targetExamClass && codeClassSeq !== 16) {
      return new Response(
        JSON.stringify({ error: `Code is for ${(codeRow as any).classes?.label || 'another class'}, not Class ${targetExamClass}.` }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }
    if (codeRow.uses_count > codeRow.max_uses) {
      return new Response(JSON.stringify({ error: 'Access code has exceeded its use limit.' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // ── 1. Grade MCQ & Fill-in-the-Blanks (Deterministic) ────────────────────
    const { mcqScore, blankScore, mcqBreakdown, blanksBreakdown } = gradeDeterministic(answers);

    // ── 2. Grade Open-Ended with Groq LLM (Q17, Q18, Q21) ───────────────────
    const q17Text = (answers.q17_text || answers.q17 || '').trim();
    const q18Text = (answers.q18_text || answers.q18 || '').trim();
    const q21Text = (answers.q21_text || answers.q21 || '').trim();

    const openEndedGrades = await gradeOpenEndedWithGroq(q17Text, q18Text, q21Text, groqKey);
    const openEndedScore = (openEndedGrades.q17?.score || 0) + (openEndedGrades.q18?.score || 0) + (openEndedGrades.q21?.score || 0);

    // Total Score out of 60
    const autoScore = mcqScore + blankScore + openEndedScore;

    // ── 3. Build Detailed Teacher Payload ────────────────────────────────────
    const mcqDetails: Record<string, unknown> = {};

    // Root-level MCQ questions (q1..q15) for backward compatibility
    for (let q = 1; q <= 15; q++) {
      const b = mcqBreakdown[`q${q}`];
      mcqDetails[`q${q}`] = { answer: b.submitted, correct: b.ok, correctAnswer: b.correctAnswer };
    }

    // Blanks details
    mcqDetails['q16'] = { ...blanksBreakdown.q16, rubric: RUBRICS[16] };
    mcqDetails['q19'] = { ...blanksBreakdown.q19, rubric: RUBRICS[19] };
    mcqDetails['q20'] = { ...blanksBreakdown.q20, rubric: RUBRICS[20] };

    // Groq AI graded open-ended details
    mcqDetails['q17'] = {
      score: openEndedGrades.q17.score,
      max: 5,
      feedback: openEndedGrades.q17.feedback,
      student_text: q17Text,
      rubric: RUBRICS[17],
    };
    mcqDetails['q18'] = {
      score: openEndedGrades.q18.score,
      max: 5,
      feedback: openEndedGrades.q18.feedback,
      student_text: q18Text,
      rubric: RUBRICS[18],
    };
    mcqDetails['q21'] = {
      score: openEndedGrades.q21.score,
      max: 5,
      feedback: openEndedGrades.q21.feedback,
      student_text: q21Text,
      rubric: RUBRICS[21],
    };

    // Summary block
    mcqDetails['summary'] = {
      mcq_score: mcqScore,
      mcq_max: 30,
      blank_score: blankScore,
      blank_max: 15,
      open_ended_score: openEndedScore,
      open_ended_max: 15,
      total_score: autoScore,
      total_max: 60,
      graded_by_ai: Boolean(groqKey),
    };

    const dbPayload = {
      student_name: studentName.trim(),
      class_number: targetExamClass,
      access_code: accessCode.toUpperCase(),
      submitted_at: new Date().toISOString(),
      mcq_score: mcqScore,
      blank_score: blankScore,
      auto_score: autoScore,
      mcq_details: mcqDetails,
      // Q16 blanks
      q16_b1: answers.q16_b1 || '', q16_b2: answers.q16_b2 || '', q16_b3: answers.q16_b3 || '',
      q16_b4: answers.q16_b4 || '', q16_b5: answers.q16_b5 || '', q16_b6: answers.q16_b6 || '',
      // Q19 blanks
      q19_b1: answers.q19_b1 || '', q19_b2: answers.q19_b2 || '', q19_b3: answers.q19_b3 || '',
      q19_b4: answers.q19_b4 || '', q19_b5: answers.q19_b5 || '', q19_b6: answers.q19_b6 || '',
      // Q20 blanks
      q20_b1: answers.q20_b1 || '', q20_b2: answers.q20_b2 || '', q20_b3: answers.q20_b3 || '',
      q20_b4: answers.q20_b4 || '', q20_b5: answers.q20_b5 || '',
      // Open-ended text
      q17_text: q17Text,
      q18_text: q18Text,
      q21_text: q21Text,
      // Cohort
      cohort: (codeRow as any).cohorts?.name || (codeRow as any).cohorts?.slug || body.cohort || null,
      session_id: sessionId && /^[0-9a-f-]{36}$/i.test(sessionId) ? sessionId : null,
    };

    // ── 4. Save results to Database ──────────────────────────────────────────
    const validSessionId = sessionId && /^[0-9a-f-]{36}$/i.test(sessionId) ? sessionId : null;
    let insertErr: any = null;

    if (validSessionId) {
      const { data: existing, error: selectErr } = await db
        .from(RESULTS_TABLE)
        .select('id')
        .eq('session_id', validSessionId)
        .maybeSingle();

      if (!selectErr && existing && existing.id) {
        const { error: updateErr } = await db
          .from(RESULTS_TABLE)
          .update(dbPayload)
          .eq('id', existing.id);
        insertErr = updateErr;
      } else {
        const { error: insErr } = await db
          .from(RESULTS_TABLE)
          .insert(dbPayload);

        if (insErr && insErr.message && insErr.message.includes('session_id')) {
          const { session_id, ...payloadWithoutSession } = dbPayload;
          const { error: retryErr } = await db
            .from(RESULTS_TABLE)
            .insert(payloadWithoutSession);
          insertErr = retryErr;
        } else {
          insertErr = insErr;
        }
      }
    } else {
      const { session_id, ...payloadWithoutSession } = dbPayload;
      const { error: insErr } = await db
        .from(RESULTS_TABLE)
        .insert(payloadWithoutSession);
      insertErr = insErr;
    }

    if (insertErr) {
      console.error('Insert error:', insertErr);
      return new Response(JSON.stringify({ error: `Failed to save results: ${insertErr.message || JSON.stringify(insertErr)}` }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // ── 5. Increment access code uses_count ──────────────────────────────────
    await db
      .from(ACCESS_TABLE)
      .update({ uses_count: (codeRow.uses_count || 0) + 1 })
      .eq('id', codeRow.id);

    // ── 6. Student Response: PRIVACY PROTECTED — no scores or answers returned ─
    return new Response(
      JSON.stringify({
        ok: true,
        message: 'Assessment submitted successfully! Your submission has been securely recorded.',
      }),
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

