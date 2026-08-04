-- ── Table: introai_week08_promise_vs_problem ─────────────────────────────
-- Path: sql/create_introai_week08_promise_vs_problem.sql
-- Week 8 Exercise 4: Promise vs. Problem Placemat
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_promise_vs_problem (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  partner_name            TEXT,

  -- AlphaFold
  alphafold_promise       TEXT NOT NULL,
  alphafold_problem       TEXT NOT NULL,

  -- Woebot
  woebot_promise          TEXT NOT NULL,
  woebot_problem          TEXT NOT NULL,

  -- BeMyEyes
  bemyeyes_promise        TEXT NOT NULL,
  bemyeyes_problem        TEXT NOT NULL,

  -- Ocean Cleanup
  ocean_cleanup_promise   TEXT NOT NULL,
  ocean_cleanup_problem   TEXT NOT NULL,

  -- Debrief
  debrief_reflection      TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_promise_vs_problem_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_promise_vs_problem
  IS 'Week 8 Exercise 4: Promise vs. Problem Placemat';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_promise_vs_problem ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_promise_vs_problem" ON introai_week08_promise_vs_problem;
DROP POLICY IF EXISTS "auth_select_w08_promise_vs_problem" ON introai_week08_promise_vs_problem;

-- Allow anonymous students to submit
CREATE POLICY "anon_insert_w08_promise_vs_problem"
  ON introai_week08_promise_vs_problem
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_promise_vs_problem"
  ON introai_week08_promise_vs_problem
  FOR SELECT TO authenticated
  USING (true);
