-- =============================================================
-- Migration: Create table for Intro AI Week 02 Guided Prompt Practice
-- Context:   Students practice prompt engineering across 3 scenarios
--            using 5 core elements (Task, Context, Persona, Format, Tone).
-- Date:      2026-09-19
-- =============================================================

-- ── 1. Create Dedicated Table (Optional / Direct Logging) ─────
CREATE TABLE IF NOT EXISTS introai_week02_prompt_practice (
  id                      BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  cohort_id               BIGINT,

  -- Scenario 1: Extension Request
  scenario_1_chatbot      TEXT NOT NULL,
  scenario_1_prompt       TEXT NOT NULL,
  scenario_1_response     TEXT NOT NULL,
  scenario_1_evaluation   TEXT NOT NULL,
  scenario_1_notes        TEXT,

  -- Scenario 2: Fantasy NPC
  scenario_2_chatbot      TEXT NOT NULL,
  scenario_2_prompt       TEXT NOT NULL,
  scenario_2_response     TEXT NOT NULL,
  scenario_2_evaluation   TEXT NOT NULL,
  scenario_2_notes        TEXT,

  -- Scenario 3: 5th Grader AI Explainer
  scenario_3_chatbot      TEXT NOT NULL,
  scenario_3_prompt       TEXT NOT NULL,
  scenario_3_response     TEXT NOT NULL,
  scenario_3_evaluation   TEXT NOT NULL,
  scenario_3_notes        TEXT,

  -- Synthesis & Reflection
  key_element_takeaway    TEXT NOT NULL,
  enjoyment_rating        SMALLINT CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w02_prompt_practice_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week02_prompt_practice
  IS 'Week 2 Guided Prompt Practice: Students practice prompt engineering across 3 scenarios using Task, Context, Persona, Format, Tone.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week02_prompt_practice ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT
CREATE POLICY "anon_insert_prompt_practice"
  ON introai_week02_prompt_practice
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated teachers can SELECT
CREATE POLICY "auth_select_prompt_practice"
  ON introai_week02_prompt_practice
  FOR SELECT TO authenticated
  USING (true);


-- ── 2. Register in exercise_definitions for Teacher Portal ────
-- This makes the exercise instantly appear in the Teacher Submissions Portal
-- and Cohort Visibility views.
DO $$
DECLARE
  v_course_id BIGINT;
BEGIN
  SELECT id INTO v_course_id FROM courses WHERE slug = 'introai';

  IF v_course_id IS NOT NULL THEN
    INSERT INTO exercise_definitions (
      course_id,
      exercise_slug,
      label,
      week_number,
      sequence_order,
      is_active
    )
    VALUES (
      v_course_id,
      'week02_prompt_practice',
      'Week 2 — Guided Prompt Practice',
      2,
      2,
      true
    )
    ON CONFLICT (course_id, exercise_slug)
    DO UPDATE SET
      label = EXCLUDED.label,
      week_number = EXCLUDED.week_number,
      sequence_order = EXCLUDED.sequence_order,
      is_active = true;
  END IF;
END $$;
