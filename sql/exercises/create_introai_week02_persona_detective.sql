-- =============================================================
-- Migration: Create table for Intro AI Week 02 Persona Detective exercise
-- Context:   Students secretly draw a persona, write a prompt to adopt
--            the character, and have peers guess the persona from the response.
-- Date:      2026-07-05
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week02_persona_detective (
  id                  BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Assigned secret persona
  secret_persona      TEXT NOT NULL,

  -- Game question & prompt details
  teacher_question    TEXT NOT NULL,
  prompt_used         TEXT NOT NULL,
  chatbot_used        TEXT NOT NULL, -- 'ChatGPT', 'Gemini', 'Claude', etc.
  ai_response         TEXT NOT NULL,

  -- Game outcomes
  was_guessed         BOOLEAN NOT NULL,
  guess_time_seconds  SMALLINT, -- How fast it was guessed

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week02_persona_detective
  IS 'Week 2 Exercise 2: AI Persona Detective game results, testing adopting and maintaining chatbot personas.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week02_persona_detective ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_persona_detective"
  ON introai_week02_persona_detective
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_persona_detective"
  ON introai_week02_persona_detective
  FOR SELECT TO authenticated
  USING (true);
