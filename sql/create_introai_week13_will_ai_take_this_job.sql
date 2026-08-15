-- ── Table: introai_week13_will_ai_take_this_job ─────────────────────────────
-- Week 13 Exercise 2: "Will AI Take This Job?" Analysis (Group or Individual)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week13_will_ai_take_this_job (
  id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name                TEXT NOT NULL,
  student_email               TEXT,

  -- Job #1 Analysis
  job1_title                  TEXT NOT NULL,
  job1_automation_difficulty  TEXT NOT NULL,
  job1_ai_helpful_tasks       TEXT NOT NULL,
  job1_human_required_tasks   TEXT NOT NULL,

  -- Job #2 Analysis
  job2_title                  TEXT NOT NULL,
  job2_automation_difficulty  TEXT NOT NULL,
  job2_ai_helpful_tasks       TEXT NOT NULL,
  job2_human_required_tasks   TEXT NOT NULL,

  -- Job #3 Analysis
  job3_title                  TEXT NOT NULL,
  job3_automation_difficulty  TEXT NOT NULL,
  job3_ai_helpful_tasks       TEXT NOT NULL,
  job3_human_required_tasks   TEXT NOT NULL,

  -- 10-Year Change Ranking & Defense
  rank_1_job                  TEXT NOT NULL,
  rank_2_job                  TEXT NOT NULL,
  rank_3_job                  TEXT NOT NULL,
  ranking_defense_sentence    TEXT NOT NULL,

  -- Rating
  enjoyment_rating            SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w13_will_ai_take_job_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week13_will_ai_take_this_job
  IS 'Week 13 Exercise 2: "Will AI Take This Job?" Analysis';

-- ── Safe Schema Migration (if table already exists) ──────────────────────────
ALTER TABLE introai_week13_will_ai_take_this_job ADD COLUMN IF NOT EXISTS ranking_defense_sentence TEXT;

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week13_will_ai_take_this_job ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w13_will_ai_take_this_job" ON introai_week13_will_ai_take_this_job;
DROP POLICY IF EXISTS "anon_select_w13_will_ai_take_this_job" ON introai_week13_will_ai_take_this_job;
DROP POLICY IF EXISTS "anon_update_w13_will_ai_take_this_job" ON introai_week13_will_ai_take_this_job;
DROP POLICY IF EXISTS "anon_all_w13_will_ai_take_this_job" ON introai_week13_will_ai_take_this_job;
DROP POLICY IF EXISTS "auth_select_w13_will_ai_take_this_job" ON introai_week13_will_ai_take_this_job;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w13_will_ai_take_this_job"
  ON introai_week13_will_ai_take_this_job
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w13_will_ai_take_this_job"
  ON introai_week13_will_ai_take_this_job
  FOR SELECT
  TO authenticated
  USING (true);
