-- ── Table: introai_week06_be_the_algorithm ─────────────────────────────────
-- Week 6 Exercise: Be the Algorithm! — Recommendation Systems
-- Students review student profiles with multiple parameters and decide
-- which movie to recommend, then reflect on their reasoning process.
-- ───────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week06_be_the_algorithm (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,

  -- Which profiles they were assigned
  profiles_used           TEXT NOT NULL,  -- e.g. 'A, B, C'

  -- Recommendations per profile (movie title chosen)
  profile_a_recommendation  TEXT,
  profile_b_recommendation  TEXT,
  profile_c_recommendation  TEXT,
  profile_d_recommendation  TEXT,
  profile_e_recommendation  TEXT,

  -- Key parameter(s) student focused on for each profile
  profile_a_key_param     TEXT,
  profile_b_key_param     TEXT,
  profile_c_key_param     TEXT,
  profile_d_key_param     TEXT,
  profile_e_key_param     TEXT,

  -- Reflections
  hardest_profile         TEXT NOT NULL,   -- Which profile was hardest to recommend for
  algorithm_strategy      TEXT NOT NULL,   -- What "rule" or strategy they used
  class_consensus         TEXT NOT NULL,   -- Did the class agree or disagree?
  real_world_connection   TEXT NOT NULL,   -- How does this connect to real recommendation systems?
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w06_algo_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week06_be_the_algorithm
  IS 'Week 6 Exercise: Be the Algorithm! — Students act as recommendation engines for fictional student profiles.';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week06_be_the_algorithm ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w06_algo"
  ON introai_week06_be_the_algorithm
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w06_algo"
  ON introai_week06_be_the_algorithm
  FOR SELECT TO authenticated
  USING (true);
