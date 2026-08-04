-- =============================================================
-- Migration: Create table for Intro AI Week 01 Intro to Chatbots exercise
-- Context:   Students use an AI chatbot for 4 tasks and record results.
--            Tasks: define AI/ML, factual Q, summarise text, creative task.
-- Date:      2026-07-04
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week01_chatbots (
  id               BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name     TEXT NOT NULL,
  student_email    TEXT NOT NULL,

  -- Which chatbot was used
  chatbot_used     TEXT NOT NULL,
  -- 'ChatGPT' | 'Gemini' | 'Claude' | 'Copilot' | 'Perplexity' | 'Other'

  -- Task 1: Define AI or ML
  t1_chatbot_definition TEXT,   -- What the chatbot said
  t1_comparison         TEXT,   -- 'very_similar' | 'mostly_similar' | 'quite_different' | 'very_different'
  t1_notes              TEXT,   -- Optional observations

  -- Task 2: Factual Question
  t2_question           TEXT,   -- The question asked
  t2_chatbot_answer     TEXT,   -- The chatbot's answer
  t2_accuracy           TEXT,   -- 'accurate' | 'partially_accurate' | 'inaccurate'

  -- Task 3: Summarise Text
  t3_original_text      TEXT,   -- The paragraph provided
  t3_chatbot_summary    TEXT,   -- The chatbot's summary
  t3_summary_quality    TEXT,   -- 'excellent' | 'good' | 'okay' | 'poor'

  -- Task 4: Creative Task
  t4_creative_prompt    TEXT,   -- What they asked the chatbot to create
  t4_creative_response  TEXT,   -- The chatbot's creative output

  -- Overall reflection
  overall_impression    SMALLINT CHECK (overall_impression BETWEEN 1 AND 5),
  reflection            TEXT,   -- Open-ended "what surprised you"

  submitted_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_chatbots
  IS 'Week 1 Exercise 2: Students explore an AI chatbot across 4 structured tasks and record their findings.';

COMMENT ON COLUMN introai_week01_chatbots.chatbot_used
  IS 'The chatbot platform used: ChatGPT, Gemini, Claude, Copilot, Perplexity, or Other.';

COMMENT ON COLUMN introai_week01_chatbots.t1_comparison
  IS 'How the chatbot definition compared to the class definition: very_similar, mostly_similar, quite_different, very_different.';

COMMENT ON COLUMN introai_week01_chatbots.t2_accuracy
  IS 'Whether the chatbot answered the factual question accurately: accurate, partially_accurate, inaccurate.';

COMMENT ON COLUMN introai_week01_chatbots.t3_summary_quality
  IS 'Quality rating for the chatbot summary: excellent, good, okay, poor.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week01_chatbots ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_chatbots"
  ON introai_week01_chatbots
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_chatbots"
  ON introai_week01_chatbots
  FOR SELECT TO authenticated
  USING (true);
