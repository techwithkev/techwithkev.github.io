import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { corsHeaders } from './cors.ts';

// ─────────────────────────────────────────────────────────────────────────────
// EXAM DEFINITIONS & ANSWER KEYS — Server-Side Only (Never sent to students)
// ─────────────────────────────────────────────────────────────────────────────

// ── CLASS 19: FINAL EXAM (Classes 1–18) ──────────────────────────────────────
const FINAL_MCQ: Record<string, string> = {
  q1: 'B', q2: 'B', q3: 'C', q4: 'B', q5: 'C',
  q6: 'B', q7: 'A', q8: 'B', q9: 'C', q10: 'B',
  q11: 'B', q12: 'B', q13: 'C', q14: 'B', q15: 'C',
};

const FINAL_BLANKS: Record<string, string[]> = {
  q16_b1: ['0', '0.0', 'int(0)'],
  q16_b2: ['heappop', 'heapq.heappop'],
  q16_b3: ['h[neighbor]', 'h.get(neighbor)', 'h[neighbor_node]', 'h.get(neighbor,0)'],
  q16_b4: ['heappush', 'heapq.heappush'],
  q16_b5: ['node', 'current', 'came_from[node]'],
  q16_b6: ['append'],
  q19_b1: ['cluster'],
  q19_b2: ['3', '3.0'],
  q19_b3: ['fit', 'fit_predict', 'fit(x)', 'fit(X)'],
  q19_b4: ['labels', 'labels_'],
  q19_b5: ['inertia', 'inertia_'],
  q19_b6: ['labels', 'km.labels_', 'labels_', 'km.labels'],
  q20_b1: ['state', 's'],
  q20_b2: ['action', 'a'],
  q20_b3: ['max', 'amax', 'np.max', 'np.amax'],
  q20_b4: ['best_next', 'max_next', 'np.max(q[next_state])', 'max(q[next_state])', 'np.max(Q[next_state])', 'max(Q[next_state])'],
  q20_b5: ['alpha', 'lr', 'learning_rate'],
};

const FINAL_RUBRICS: Record<number, string> = {
  16: 'b1:0  b2:heappop  b3:h[neighbor]  b4:heappush  b5:node  b6:append',
  17: 'Centroid A=(3,2.67) · Centroid B=(9,7) · Inertia(A): dist²((1,2),(3,2.67))=4+0.449=4.449 · dist²((3,4),(3,2.67))=0+1.778=1.778 · dist²((5,2),(3,2.67))=4+0.449=4.449 · Total=10.67',
  18: 'Score(Spam)=0.40×0.80×0.70=0.224 · Score(NotSpam)=0.60×0.10×0.05=0.003 · P(Spam|email)=0.224/0.227≈0.987 (98.7%) → Spam',
  19: 'b1:cluster  b2:3  b3:fit  b4:labels_  b5:inertia_  b6:labels_',
  20: 'b1:state  b2:action  b3:max  b4:best_next  b5:alpha',
  21: 'A*: fixed map, known costs, admissible heuristic → optimal path guaranteed. Q-learning: dynamic environment, unknown map, learns from rewards. State=position; Action=move direction; Reward=negative distance penalty/+bonus on arrival. γ=0.9 → future rewards count heavily; robot motivated to reach goal quickly rather than accumulate small rewards along the way.',
};

// ── CLASS 10: MIDTERM EXAM (Classes 1–9) ─────────────────────────────────────
const MIDTERM_MCQ: Record<string, string> = {
  q1: 'B', q2: 'A', q3: 'A', q4: 'B', q5: 'B',
  q6: 'A', q7: 'A', q8: 'A', q9: 'A', q10: 'A',
  q11: 'A', q12: 'A', q13: 'A', q14: 'A', q15: 'B',
};

const MIDTERM_BLANKS: Record<string, string[]> = {
  // Q16 (Class 3 Data Preprocessing)
  q16_b1: ['fillna', 'fillna(0)'],
  q16_b2: ['fillna', "fillna(df['discount'].mean())"],
  q16_b3: ["df['units_sold']*df['price']*(1-df['discount'])", "df['units_sold'] * df['price'] * (1 - df['discount'])", "units_sold*price*(1-discount)", "units_sold * price * (1 - discount)"],
  q16_b4: ["'store_id'", '"store_id"', "store_id"],
  q16_b5: ['sum', 'sum()'],
  q16_b6: ['sort_values(ascending=False)', 'sort_values(ascending=false)', 'sort_values(ascending = False)'],
  // Q17 (Class 5 MSE Cost Function)
  q17_b1: ['w*x[i]+b', 'w * x[i] + b', 'w*x[i] + b', 'w * x[i]+b'],
  q17_b2: ['(f_wb-y[i])**2', '(f_wb - y[i])**2', '(f_wb - y[i]) ** 2', 'np.square(f_wb-y[i])'],
  // Q18 (Class 6 Metrics)
  q18_b1: ['(tp+tn)/(tp+fp+fn+tn)', '(TP+TN)/(TP+FP+FN+TN)', '(TP + TN) / (TP + FP + FN + TN)'],
  q18_b2: ['tp/(tp+fp)', 'TP/(TP+FP)', 'TP / (TP + FP)'],
  q18_b3: ['tp/(tp+fn)', 'TP/(TP+FN)', 'TP / (TP + FN)'],
  q18_b4: ['2*precision*recall/(precision+recall)', '2 * precision * recall / (precision + recall)', '(2*precision*recall)/(precision+recall)'],
  // Q19 (Class 6 Sigmoid / Predict)
  q19_b1: ['1/(1+np.exp(-z))', '1 / (1 + np.exp(-z))', '1/(1+math.exp(-z))'],
  q19_b2: ['w@x.t+b', 'w @ X.T + b', 'w@X.T+b', 'np.dot(w,x.t)+b', 'np.dot(w, X.T) + b'],
  q19_b3: ['sigmoid(z)'],
  q19_b4: ['astype(int)', 'astype(np.int64)', 'astype(bool).astype(int)'],
  // Q20 (Class 9 Kernel Trick)
  q20_b1: ['(x*xp+1)**2', '(x * xp + 1) ** 2', '(np.dot(x,xp)+1)**2', '(np.dot(x, xp) + 1)**2'],
  q20_b2: ['[x,x**2]', '[x, x**2]', '[x, x ** 2]', 'np.array([x, x**2])'],
  q20_b3: ['math.exp(-gamma*distance**2)', 'math.exp(-gamma * distance ** 2)', 'np.exp(-gamma*distance**2)', 'np.exp(-gamma * distance ** 2)'],
};

const MIDTERM_RUBRICS: Record<number, string> = {
  16: "fillna · fillna · units_sold*price*(1-discount) · 'store_id' · sum · sort_values(ascending=False)",
  17: 'f_wb = w*x[i]+b  |  cost_sum += (f_wb-y[i])**2  →  J(0.8,0.9)=0.525',
  18: 'accuracy=(TP+TN)/total · precision=TP/(TP+FP) · recall=TP/(TP+FN) · f1=2·P·R/(P+R)',
  19: 'sigmoid: 1/(1+np.exp(-z)) · z=w@X.T+b · probabilities=sigmoid(z) · .astype(int)',
  20: 'kernel: (x*xp+1)**2 · phi: [x,x**2] · rbf: math.exp(-gamma*distance**2)',
  21: 'Train R² ≫ Test R² = high variance/overfitting (Class 2). Fixes: more data, regularization, simpler model, more k-fold CV (Class 4). Full credit needs diagnosis + a named fix + the bias/variance link.',
};

const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const GROQ_MODEL = 'llama-3.3-70b-versatile';
const ACCESS_TABLE = 'access_codes';

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

function matchBlank(blankDict: Record<string, string[]>, id: string, val: string | undefined): boolean {
  if (!val) return false;
  const n = val.toLowerCase().trim().replace(/['"]/g, '').replace(/\s/g, '');
  if (!n) return false;
  return (blankDict[id] || []).some((ans) => {
    const an = ans.toLowerCase().trim().replace(/['"]/g, '').replace(/\s/g, '');
    return n === an || n.includes(an) || an.includes(n);
  });
}

interface OpenEndedGrade {
  score: number;
  feedback: string;
}

// ── GROQ AI GRADER FOR CLASS 19 FINAL EXAM ──────────────────────────────────
async function gradeFinalExamWithGroq(
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
    console.warn('GROQ_API_KEY not configured.');
    return defaultFallback;
  }

  const systemPrompt = `You are an expert AI & Machine Learning examiner and strict academic grader evaluating a student's final exam.
Evaluate student answers strictly against the rubrics below. Award an integer score (0-5) and 1-2 sentences of feedback.

Rubrics:
- Q17 (k-Means, max 5 pts): Centroid A=(3, 2.67), Centroid B=(9, 7). Inertia A = 4.449+1.778+4.449 = 10.67 (Accept 10.6 to 10.7).
- Q18 (Naive Bayes, max 5 pts): Score(Spam)=0.224, Score(Not Spam)=0.003, P(Spam|email)=0.9868 (~98.7%) -> Classified as Spam.
- Q21 (A* vs Q-Learning, max 5 pts): A* for known/static map with admissible heuristic. Q-learning for unknown/dynamic map (State=pos, Action=move, Reward=step penalty/goal). gamma=0.9 prioritizes efficient long-term reward.

OUTPUT FORMAT: Return ONLY valid JSON: {"q17":{"score":5,"feedback":"..."},"q18":{"score":5,"feedback":"..."},"q21":{"score":5,"feedback":"..."}}`;

  const userPrompt = `Q17:\n${q17Text || '(None)'}\n\nQ18:\n${q18Text || '(None)'}\n\nQ21:\n${q21Text || '(None)'}`;

  try {
    const res = await fetch(GROQ_API_URL, {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${groqKey}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: GROQ_MODEL,
        messages: [{ role: 'system', content: systemPrompt }, { role: 'user', content: userPrompt }],
        temperature: 0.1,
        max_tokens: 600,
        response_format: { type: 'json_object' },
      }),
    });
    if (!res.ok) return defaultFallback;
    const data = await res.json();
    const parsed = JSON.parse(data.choices?.[0]?.message?.content?.trim() || '{}');
    const sanitize = (item: any, txt: string): OpenEndedGrade => {
      if (!txt.trim()) return { score: 0, feedback: 'No response submitted.' };
      const raw = Number(item?.score);
      const score = Number.isFinite(raw) ? Math.min(5, Math.max(0, Math.round(raw))) : 0;
      return { score, feedback: String(item?.feedback || 'Evaluated.').trim() };
    };
    return {
      q17: sanitize(parsed.q17, q17Text),
      q18: sanitize(parsed.q18, q18Text),
      q21: sanitize(parsed.q21, q21Text),
    };
  } catch (err) {
    console.error('Groq grading error:', err);
    return defaultFallback;
  }
}

// ── GROQ AI GRADER FOR CLASS 10 MIDTERM EXAM ─────────────────────────────────
async function gradeMidtermWithGroq(
  q21Text: string,
  groqKey: string | undefined
): Promise<OpenEndedGrade> {
  const fallback: OpenEndedGrade = {
    score: 0,
    feedback: q21Text ? 'Evaluated manually / pending review.' : 'No response provided.',
  };

  if (!groqKey || !q21Text.trim()) return fallback;

  const systemPrompt = `You are an expert AI & Machine Learning examiner grading Question 21 of a high-school AI Midterm exam.
Question: A model reports Train R² = 0.98 and Test R² = 0.41. In 3–5 sentences: explain what is happening, name one technique from class to fix it, and connect to the bias/variance concept.

Rubric (Max 5 pts total):
- Part 1 (1.5 pts): Diagnosis of High Variance / Overfitting (memorizing training data instead of generalizing).
- Part 2 (2.0 pts): One concrete fix from class (Regularization L1/L2, more data, simpler model/fewer polynomial features, k-fold CV).
- Part 3 (1.5 pts): Explicit connection to Bias-Variance tradeoff (low bias, high variance; need to slightly increase bias to reduce variance).

OUTPUT FORMAT: Return ONLY valid JSON: {"score": 5, "feedback": "Accurate diagnosis of overfitting with correct regularization fix and bias-variance link."}`;

  try {
    const res = await fetch(GROQ_API_URL, {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${groqKey}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: GROQ_MODEL,
        messages: [{ role: 'system', content: systemPrompt }, { role: 'user', content: `STUDENT ANSWER:\n${q21Text}` }],
        temperature: 0.1,
        max_tokens: 300,
        response_format: { type: 'json_object' },
      }),
    });
    if (!res.ok) return fallback;
    const data = await res.json();
    const parsed = JSON.parse(data.choices?.[0]?.message?.content?.trim() || '{}');
    const raw = Number(parsed.score);
    const score = Number.isFinite(raw) ? Math.min(5, Math.max(0, Math.round(raw))) : 0;
    return { score, feedback: String(parsed.feedback || 'Evaluated.').trim() };
  } catch (err) {
    console.error('Groq midterm grading error:', err);
    return fallback;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDGE FUNCTION HANDLER
// ─────────────────────────────────────────────────────────────────────────────

Deno.serve(async (req) => {
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
    const { studentName, accessCode, sessionId, answers, examClass } = body;
    const targetClass = Number(examClass) || 19;

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
    const db = createClient(supabaseUrl, serviceKey, { auth: { persistSession: false } });

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
    const codeClassSeq = (codeRow as any).classes?.sequence_order ?? null;
    if (codeRow.class_id && codeClassSeq !== null && codeClassSeq !== targetClass && !(targetClass === 19 && codeClassSeq === 16)) {
      return new Response(
        JSON.stringify({ error: `Code is for ${(codeRow as any).classes?.label || 'another class'}, not Class ${targetClass}.` }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }
    if (codeRow.uses_count > codeRow.max_uses) {
      return new Response(JSON.stringify({ error: 'Access code has exceeded its use limit.' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // ═════════════════════════════════════════════════════════════════════════
    // BRANCH: CLASS 10 (MIDTERM EXAM)
    // ═════════════════════════════════════════════════════════════════════════
    if (targetClass === 10) {
      let mcqScore = 0;
      let blankScore = 0;
      const mcqDetails: Record<string, unknown> = {};

      // 1. Grade MCQ (Q1–15, 2pts each, max 30)
      for (let q = 1; q <= 15; q++) {
        const key = `q${q}`;
        const submitted = answers[key] ?? null;
        const correct = MIDTERM_MCQ[key];
        const ok = submitted === correct;
        if (ok) mcqScore += 2;
        mcqDetails[key] = { answer: submitted, correct: ok, correctAnswer: correct };
      }

      // 2. Grade Blanks (Q16–20, 5pts each, max 25)
      const midtermBlankGroups: Record<string, string[]> = {
        q16: ['q16_b1', 'q16_b2', 'q16_b3', 'q16_b4', 'q16_b5', 'q16_b6'],
        q17: ['q17_b1', 'q17_b2'],
        q18: ['q18_b1', 'q18_b2', 'q18_b3', 'q18_b4'],
        q19: ['q19_b1', 'q19_b2', 'q19_b3', 'q19_b4'],
        q20: ['q20_b1', 'q20_b2', 'q20_b3'],
      };

      const blanksDetails: Record<string, unknown> = {};
      for (const [gKey, ids] of Object.entries(midtermBlankGroups)) {
        const items = ids.map(id => ({
          id,
          val: answers[id] ?? '',
          ok: matchBlank(MIDTERM_BLANKS, id, answers[id]),
        }));
        const correct = items.filter(i => i.ok).length;
        const pts = Math.round((correct / ids.length) * 5);
        blankScore += pts;
        const qNum = Number(gKey.replace('q', ''));
        blanksDetails[gKey] = { pts, cor: correct, of: ids.length, items, rubric: MIDTERM_RUBRICS[qNum] };
      }

      // 3. Grade Open-Ended Q21 with Groq LLM (max 5 pts)
      const q21Text = (answers.q21_text || answers.q21 || '').trim();
      const q21Grade = await gradeMidtermWithGroq(q21Text, groqKey);
      const openEndedScore = q21Grade.score;

      const autoScore = mcqScore + blankScore + openEndedScore;

      // 4. Build JSONB question_detail payload for test_submissions
      const questionDetail = {
        mcq: mcqDetails,
        ...blanksDetails,
        q21: {
          score: q21Grade.score,
          max: 5,
          feedback: q21Grade.feedback,
          student_text: q21Text,
          rubric: MIDTERM_RUBRICS[21],
        },
        summary: {
          mcq_score: mcqScore,
          mcq_max: 30,
          blank_score: blankScore,
          blank_max: 25,
          open_ended_score: openEndedScore,
          open_ended_max: 5,
          total_score: autoScore,
          total_max: 60,
          graded_by_ai: Boolean(groqKey),
        },
      };

      const dbPayload = {
        student_name: studentName.trim(),
        test_id: 'classes1to7_test',
        access_code: accessCode.toUpperCase(),
        mcq_score: mcqScore,
        blank_score: blankScore,
        auto_score: autoScore,
        total_possible: 60,
        pct: Math.round((autoScore / 60) * 100),
        question_detail: questionDetail,
        submitted_at: new Date().toISOString(),
      };

      const { error: insErr } = await db.from('test_submissions').insert([dbPayload]);
      if (insErr) {
        console.error('Midterm insert error:', insErr);
        return new Response(JSON.stringify({ error: `Failed to save midterm: ${insErr.message}` }), {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        });
      }

      await db.from(ACCESS_TABLE).update({ uses_count: (codeRow.uses_count || 0) + 1 }).eq('id', codeRow.id);

      return new Response(
        JSON.stringify({ ok: true, message: 'Midterm assessment submitted successfully! Your submission has been securely recorded.' }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // ═════════════════════════════════════════════════════════════════════════
    // BRANCH: CLASS 19 (FINAL EXAM)
    // ═════════════════════════════════════════════════════════════════════════
    let mcqScore = 0;
    let blankScore = 0;
    const mcqBreakdown: Record<string, { ok: boolean; submitted: string | null; correctAnswer: string }> = {};
    const blanksBreakdown: Record<string, { pts: number; cor: number; of: number; items: Array<{ id: string; val: string; ok: boolean }> }> = {};

    for (let q = 1; q <= 15; q++) {
      const key = `q${q}`;
      const submitted = answers[key] ?? null;
      const correct = FINAL_MCQ[key];
      const ok = submitted === correct;
      if (ok) mcqScore += 2;
      mcqBreakdown[key] = { ok, submitted, correctAnswer: correct };
    }

    const finalBlankGroups: Record<string, string[]> = {
      q16: ['q16_b1', 'q16_b2', 'q16_b3', 'q16_b4', 'q16_b5', 'q16_b6'],
      q19: ['q19_b1', 'q19_b2', 'q19_b3', 'q19_b4', 'q19_b5', 'q19_b6'],
      q20: ['q20_b1', 'q20_b2', 'q20_b3', 'q20_b4', 'q20_b5'],
    };

    for (const [gKey, ids] of Object.entries(finalBlankGroups)) {
      const items = ids.map(id => ({ id, val: answers[id] ?? '', ok: matchBlank(FINAL_BLANKS, id, answers[id]) }));
      const correct = items.filter(i => i.ok).length;
      const pts = Math.round((correct / ids.length) * 5);
      blankScore += pts;
      blanksBreakdown[gKey] = { pts, cor: correct, of: ids.length, items };
    }

    const q17Text = (answers.q17_text || answers.q17 || '').trim();
    const q18Text = (answers.q18_text || answers.q18 || '').trim();
    const q21Text = (answers.q21_text || answers.q21 || '').trim();

    const openEndedGrades = await gradeFinalExamWithGroq(q17Text, q18Text, q21Text, groqKey);
    const openEndedScore = (openEndedGrades.q17?.score || 0) + (openEndedGrades.q18?.score || 0) + (openEndedGrades.q21?.score || 0);

    const autoScore = mcqScore + blankScore + openEndedScore;

    const mcqDetails: Record<string, unknown> = {};
    for (let q = 1; q <= 15; q++) {
      const b = mcqBreakdown[`q${q}`];
      mcqDetails[`q${q}`] = { answer: b.submitted, correct: b.ok, correctAnswer: b.correctAnswer };
    }

    mcqDetails['q16'] = { ...blanksBreakdown.q16, rubric: FINAL_RUBRICS[16] };
    mcqDetails['q19'] = { ...blanksBreakdown.q19, rubric: FINAL_RUBRICS[19] };
    mcqDetails['q20'] = { ...blanksBreakdown.q20, rubric: FINAL_RUBRICS[20] };

    mcqDetails['q17'] = { score: openEndedGrades.q17.score, max: 5, feedback: openEndedGrades.q17.feedback, student_text: q17Text, rubric: FINAL_RUBRICS[17] };
    mcqDetails['q18'] = { score: openEndedGrades.q18.score, max: 5, feedback: openEndedGrades.q18.feedback, student_text: q18Text, rubric: FINAL_RUBRICS[18] };
    mcqDetails['q21'] = { score: openEndedGrades.q21.score, max: 5, feedback: openEndedGrades.q21.feedback, student_text: q21Text, rubric: FINAL_RUBRICS[21] };

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

    const finalDbPayload = {
      student_name: studentName.trim(),
      class_number: targetClass,
      access_code: accessCode.toUpperCase(),
      submitted_at: new Date().toISOString(),
      mcq_score: mcqScore,
      blank_score: blankScore,
      auto_score: autoScore,
      mcq_details: mcqDetails,
      q16_b1: answers.q16_b1 || '', q16_b2: answers.q16_b2 || '', q16_b3: answers.q16_b3 || '',
      q16_b4: answers.q16_b4 || '', q16_b5: answers.q16_b5 || '', q16_b6: answers.q16_b6 || '',
      q19_b1: answers.q19_b1 || '', q19_b2: answers.q19_b2 || '', q19_b3: answers.q19_b3 || '',
      q19_b4: answers.q19_b4 || '', q19_b5: answers.q19_b5 || '', q19_b6: answers.q19_b6 || '',
      q20_b1: answers.q20_b1 || '', q20_b2: answers.q20_b2 || '', q20_b3: answers.q20_b3 || '',
      q20_b4: answers.q20_b4 || '', q20_b5: answers.q20_b5 || '',
      q17_text: q17Text,
      q18_text: q18Text,
      q21_text: q21Text,
      cohort: (codeRow as any).cohorts?.name || (codeRow as any).cohorts?.slug || body.cohort || null,
      session_id: sessionId && /^[0-9a-f-]{36}$/i.test(sessionId) ? sessionId : null,
    };

    const validSessionId = sessionId && /^[0-9a-f-]{36}$/i.test(sessionId) ? sessionId : null;
    let insertErr: any = null;

    if (validSessionId) {
      const { data: existing, error: selectErr } = await db.from('caio_final_exam_results').select('id').eq('session_id', validSessionId).maybeSingle();
      if (!selectErr && existing && existing.id) {
        const { error: updateErr } = await db.from('caio_final_exam_results').update(finalDbPayload).eq('id', existing.id);
        insertErr = updateErr;
      } else {
        const { error: insErr } = await db.from('caio_final_exam_results').insert(finalDbPayload);
        if (insErr && insErr.message && insErr.message.includes('session_id')) {
          const { session_id, ...payloadWithoutSession } = finalDbPayload;
          const { error: retryErr } = await db.from('caio_final_exam_results').insert(payloadWithoutSession);
          insertErr = retryErr;
        } else {
          insertErr = insErr;
        }
      }
    } else {
      const { session_id, ...payloadWithoutSession } = finalDbPayload;
      const { error: insErr } = await db.from('caio_final_exam_results').insert(payloadWithoutSession);
      insertErr = insErr;
    }

    if (insertErr) {
      console.error('Final exam insert error:', insertErr);
      return new Response(JSON.stringify({ error: `Failed to save results: ${insertErr.message}` }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    await db.from(ACCESS_TABLE).update({ uses_count: (codeRow.uses_count || 0) + 1 }).eq('id', codeRow.id);

    return new Response(
      JSON.stringify({ ok: true, message: 'Assessment submitted successfully! Your submission has been securely recorded.' }),
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


