-- =============================================================
-- Migration: Create tables for Intro AI Week 01 "Is it AI?" activity
-- Context:   Students must register (name + email) before the activity,
--            and their final score is recorded on completion.
-- Date:      2026-07-04
-- =============================================================

-- ── Table 1: registrations ────────────────────────────────────
-- Records every student who starts the Week 01 activity.
CREATE TABLE IF NOT EXISTS introai_week01_registrations (
  id             BIGSERIAL PRIMARY KEY,
  student_name   TEXT        NOT NULL,
  student_email  TEXT        NOT NULL,
  registered_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_registrations
  IS 'Tracks students who registered for the Week 01 Is-it-AI sorting activity.';

COMMENT ON COLUMN introai_week01_registrations.student_name
  IS 'Full name entered by the student on the registration gate.';

COMMENT ON COLUMN introai_week01_registrations.student_email
  IS 'Email address entered by the student on the registration gate.';

-- ── Table 2: scores ──────────────────────────────────────────
-- Records the final score once a student completes all 10 cards.
CREATE TABLE IF NOT EXISTS introai_week01_scores (
  id             BIGSERIAL PRIMARY KEY,
  student_name   TEXT        NOT NULL,
  student_email  TEXT        NOT NULL,
  score          INT         NOT NULL CHECK (score >= 0),
  total          INT         NOT NULL CHECK (total > 0),
  rank           TEXT,                          -- 'AI Master', 'AI Specialist', etc.
  completed_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_scores
  IS 'Final scores for the Week 01 Is-it-AI sorting activity.';

COMMENT ON COLUMN introai_week01_scores.score
  IS 'Number of cards classified correctly (0–10).';

COMMENT ON COLUMN introai_week01_scores.total
  IS 'Total number of cards in the activity (currently 10).';

COMMENT ON COLUMN introai_week01_scores.rank
  IS 'Rank label derived from score: AI Master / Specialist / Apprentice / Novice.';

-- ── Row-Level Security ────────────────────────────────────────
-- Allow anonymous inserts (the page uses the anon key).
-- Reads are intentionally blocked for students; use the service role for teacher views.

ALTER TABLE introai_week01_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE introai_week01_scores        ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT only
CREATE POLICY "anon_insert_registrations"
  ON introai_week01_registrations
  FOR INSERT TO anon
  WITH CHECK (true);

CREATE POLICY "anon_insert_scores"
  ON introai_week01_scores
  FOR INSERT TO anon
  WITH CHECK (true);
