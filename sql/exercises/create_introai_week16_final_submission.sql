-- ── Table: introai_week16_final_submission ────────────────────────────────
-- Week 16 Exercise: Final Project & Presentation Submission
-- Stores presentation slide deck link, project demo link (optional), project overview, and reflections.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week16_final_submission (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT NOT NULL,
  project_title           TEXT NOT NULL,
  team_members            TEXT,
  presentation_link       TEXT NOT NULL,
  project_link            TEXT,
  project_summary         TEXT NOT NULL,
  key_learnings           TEXT NOT NULL,
  proudest_accomplishment TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w16_final_submission_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week16_final_submission
  IS 'Week 16 Exercise: Final Project & Presentation Submission';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week16_final_submission ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w16_final_submission"
  ON introai_week16_final_submission
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w16_final_submission"
  ON introai_week16_final_submission
  FOR SELECT TO authenticated
  USING (true);
