-- ── Table: introai_week08_mini_ethics_trial ──────────────────────────────
-- Path: sql/create_introai_week08_mini_ethics_trial.sql
-- Week 8 Exercise 5: Mini Ethics Trial
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_mini_ethics_trial (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Trial Role & Argument
  role_selected       TEXT NOT NULL,
  case_argument       TEXT NOT NULL,
  followup_qa         TEXT NOT NULL,
  verdict_ruling      TEXT NOT NULL,

  -- Debrief
  debrief_reflection  TEXT NOT NULL,
  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_mini_ethics_trial_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_mini_ethics_trial
  IS 'Week 8 Exercise 5: Mini Ethics Trial';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_mini_ethics_trial ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_mini_ethics_trial" ON introai_week08_mini_ethics_trial;
DROP POLICY IF EXISTS "auth_select_w08_mini_ethics_trial" ON introai_week08_mini_ethics_trial;

-- Allow anonymous students to submit
CREATE POLICY "anon_insert_w08_mini_ethics_trial"
  ON introai_week08_mini_ethics_trial
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_mini_ethics_trial"
  ON introai_week08_mini_ethics_trial
  FOR SELECT TO authenticated
  USING (true);
