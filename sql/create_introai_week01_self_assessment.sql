-- =============================================================
-- Migration: Create table for Intro AI Week 01 Self-Assessment survey
-- Context:   Students rate their confidence (1–5) across 5 topic areas
--            at the start of the Intro to AI course (Week 1).
-- Date:      2026-07-04
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week01_self_assessment (
  id               BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name     TEXT        NOT NULL,
  student_email    TEXT        NOT NULL,

  -- Section A: What is AI?
  q1_explain_ai       SMALLINT NOT NULL CHECK (q1_explain_ai BETWEEN 1 AND 5),
  q2_rule_vs_ai       SMALLINT NOT NULL CHECK (q2_rule_vs_ai BETWEEN 1 AND 5),
  q3_real_world_apps  SMALLINT NOT NULL CHECK (q3_real_world_apps BETWEEN 1 AND 5),

  -- Section B: Machine Learning & Data
  q4_ml_understanding SMALLINT NOT NULL CHECK (q4_ml_understanding BETWEEN 1 AND 5),
  q5_training_data    SMALLINT NOT NULL CHECK (q5_training_data BETWEEN 1 AND 5),
  q6_ai_bias          SMALLINT NOT NULL CHECK (q6_ai_bias BETWEEN 1 AND 5),

  -- Section C: Responsible & Ethical AI Use
  q7_ethical_concerns SMALLINT NOT NULL CHECK (q7_ethical_concerns BETWEEN 1 AND 5),
  q8_responsible_use  SMALLINT NOT NULL CHECK (q8_responsible_use BETWEEN 1 AND 5),
  q9_fact_check_ai    SMALLINT NOT NULL CHECK (q9_fact_check_ai BETWEEN 1 AND 5),

  -- Section D: Working with AI Tools
  q10_chatbot_comfort   SMALLINT NOT NULL CHECK (q10_chatbot_comfort BETWEEN 1 AND 5),
  q11_prompt_writing    SMALLINT NOT NULL CHECK (q11_prompt_writing BETWEEN 1 AND 5),
  q12_ai_creation_tools SMALLINT NOT NULL CHECK (q12_ai_creation_tools BETWEEN 1 AND 5),

  -- Section E: AI & Society
  q13_industry_impact SMALLINT NOT NULL CHECK (q13_industry_impact BETWEEN 1 AND 5),
  q14_ai_opinion      SMALLINT NOT NULL CHECK (q14_ai_opinion BETWEEN 1 AND 5),
  q15_excitement      SMALLINT NOT NULL CHECK (q15_excitement BETWEEN 1 AND 5),

  -- Computed averages (stored for fast teacher dashboard queries)
  avg_section_a   NUMERIC(3,2),  -- What is AI?
  avg_section_b   NUMERIC(3,2),  -- ML & Data
  avg_section_c   NUMERIC(3,2),  -- Responsible AI
  avg_section_d   NUMERIC(3,2),  -- Working with Tools
  avg_section_e   NUMERIC(3,2),  -- AI & Society
  overall_avg     NUMERIC(3,2),  -- Mean of all 15 questions

  submitted_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_self_assessment
  IS 'Week 1 student confidence self-assessment for the Introduction to AI course. Students rate themselves 1–5 across 5 topic areas.';

COMMENT ON COLUMN introai_week01_self_assessment.overall_avg
  IS 'Mean of all 15 question ratings. Computed by the client and stored for quick sorting in the teacher dashboard.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week01_self_assessment ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT only (student page uses anon key)
CREATE POLICY "anon_insert_self_assessment"
  ON introai_week01_self_assessment
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_self_assessment"
  ON introai_week01_self_assessment
  FOR SELECT TO authenticated
  USING (true);
