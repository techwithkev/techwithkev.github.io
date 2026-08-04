-- =============================================================
-- Migration: Create table for Intro AI Week 02 Creative Prompting exercise
-- Context:   Students learn prompting by writing a prompt for a creative scenario
--            with specific constraints (Task, Tone, Persona, Format).
-- Date:      2026-07-05
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week02_creative_prompting (
  id                  BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Platform used
  chatbot_used        TEXT NOT NULL, -- 'ChatGPT', 'Gemini', 'Claude', etc.

  -- The prompt and chatbot response
  initial_prompt      TEXT NOT NULL,
  initial_response    TEXT NOT NULL,

  -- Constraint checklist evaluation
  followed_task       BOOLEAN NOT NULL, -- Wrote a poem?
  followed_tone       BOOLEAN NOT NULL, -- Funny tone?
  followed_persona    BOOLEAN NOT NULL, -- Frustrated robot persona?
  followed_format     BOOLEAN NOT NULL, -- 4-6 lines?
  actual_line_count   SMALLINT,         -- How many lines did the chatbot actually write?

  -- Refinement (optional second iteration)
  refined_prompt      TEXT,
  refined_response    TEXT,

  -- Overall takeaway / Reflection
  learning_takeaway   TEXT,

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week02_creative_prompting
  IS 'Week 2 Creative Prompting: Students prompt a chatbot to write a robot toast poem and evaluate its adherence to constraints.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week02_creative_prompting ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_creative_prompting"
  ON introai_week02_creative_prompting
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_creative_prompting"
  ON introai_week02_creative_prompting
  FOR SELECT TO authenticated
  USING (true);
