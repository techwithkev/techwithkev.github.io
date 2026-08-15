-- ── Table 1: introai_project_tracker ─────────────────────────────────────
-- Main project registry per student/team
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_project_tracker (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT NOT NULL,
  team_members            TEXT,

  -- Project Overview
  project_name            TEXT NOT NULL,
  project_goal            TEXT NOT NULL,
  project_url             TEXT,
  overall_progress_pct    SMALLINT NOT NULL DEFAULT 10 CHECK (overall_progress_pct BETWEEN 0 AND 100),
  current_status          TEXT NOT NULL DEFAULT 'Planning & Ideation',

  -- Project Definition Details (from project_definition.html Q1-Q14)
  project_type            TEXT,
  one_sentence            TEXT,
  ai_tools                TEXT, -- JSON array string or comma-separated tools
  audience                TEXT,
  problem_solved          TEXT,
  how_used                TEXT,
  core_feature            TEXT,
  feature_1               TEXT,
  feature_2               TEXT,
  feature_3               TEXT,
  success_looks_like      TEXT,
  limitations             TEXT,
  responsible_checks      TEXT, -- JSON array string
  responsible_choice      TEXT,
  elevator_pitch          TEXT,
  most_excited            TEXT,

  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w10_proj_tracker_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_project_tracker
  IS 'Main final AI project registry for students';

-- ── Table 2: introai_project_progress_logs ──────────────────────────────
-- Class-by-class progress update logs for Build Check-Ins 1 through 5+
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_project_progress_logs (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_email           TEXT NOT NULL,
  class_label             TEXT NOT NULL, -- e.g. "Class 10 - Build Check-In 1", "Class 11 - Build Check-In 2"
  checkin_type            TEXT DEFAULT 'general', -- 'checkin_1', 'checkin_2', 'checkin_3', 'checkin_4', 'build_goals', 'ready_class15'

  -- Core Log Details
  milestone_completed     TEXT NOT NULL,
  progress_pct            SMALLINT NOT NULL CHECK (progress_pct BETWEEN 0 AND 100),
  next_goal               TEXT NOT NULL,

  -- Build Check-In 1 (Class 10)
  tool_access_status      TEXT,          -- Tool access confirmation status
  mockup_sketch_url       TEXT,          -- Google Slides or feature sketch link

  -- Shared Across Check-Ins 1, 2 & Class 15
  ethics_review_update    TEXT,          -- Ethical pre-review updates & Class 15 finished review
  blockers_faced          TEXT,          -- Flagged blockers to teacher (Check-Ins 1-4)

  -- Build Check-In 2 (Class 11)
  blocker_solution_plan   TEXT,          -- How group will solve blocker before leaving today

  -- Build Check-In 3 (Class 12)
  behind_reason_and_fix   TEXT,          -- Single biggest reason if behind & way to fix it
  goal_drift_check        TEXT,          -- Does project match original brief goal or has it drifted?

  -- Build Check-In 4 (Class 13)
  current_state_honesty   TEXT,          -- Current project state & what's not working yet
  top_priorities_left     TEXT,          -- 2-3 most important things left to finish
  non_essentials_cut      TEXT,          -- What non-essential features were cut

  -- Build Goals (Class 14)
  priorities_confirmation TEXT,          -- Confirmation of Class 13 priorities (still right or changed?)
  team_member_tasks       TEXT,          -- Task assignments: who is doing what for next stretch
  user_testing_notes      TEXT,          -- Stranger user testing feedback if finished early

  -- Ready for Class 15 & Presentation (Class 15/16)
  working_version_url     TEXT,          -- Working demo / prototype URL
  presentation_rough_idea TEXT,          -- Rough idea of what student will say at Class 16 presentation
  unsure_questions        TEXT,          -- One thing still unsure about to ask in Class 15

  -- Catch-all for extra check-in metadata
  checkin_data            JSONB DEFAULT '{}'::jsonb,

  logged_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Safely add columns if table already exists in Supabase
DO $$
BEGIN
  -- Build Check-In 1 & General
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='checkin_type') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN checkin_type TEXT DEFAULT 'general';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='tool_access_status') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN tool_access_status TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='mockup_sketch_url') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN mockup_sketch_url TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='ethics_review_update') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN ethics_review_update TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='blockers_faced') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN blockers_faced TEXT;
  END IF;

  -- Build Check-In 2
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='blocker_solution_plan') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN blocker_solution_plan TEXT;
  END IF;

  -- Build Check-In 3
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='behind_reason_and_fix') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN behind_reason_and_fix TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='goal_drift_check') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN goal_drift_check TEXT;
  END IF;

  -- Build Check-In 4
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='current_state_honesty') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN current_state_honesty TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='top_priorities_left') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN top_priorities_left TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='non_essentials_cut') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN non_essentials_cut TEXT;
  END IF;

  -- Build Goals (Class 14)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='priorities_confirmation') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN priorities_confirmation TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='team_member_tasks') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN team_member_tasks TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='user_testing_notes') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN user_testing_notes TEXT;
  END IF;

  -- Class 15 & Demo Day
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='working_version_url') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN working_version_url TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='presentation_rough_idea') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN presentation_rough_idea TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='unsure_questions') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN unsure_questions TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='checkin_data') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN checkin_data JSONB DEFAULT '{}'::jsonb;
  END IF;
END $$;

COMMENT ON TABLE introai_project_progress_logs
  IS 'Class-by-class progress update logs for final AI projects across all Build Check-Ins';

-- ── Row-Level Security: introai_project_tracker ───────────────────────────────
ALTER TABLE introai_project_tracker ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all_w10_proj_tracker" ON introai_project_tracker;
DROP POLICY IF EXISTS "anon_insert_w10_proj_tracker" ON introai_project_tracker;
DROP POLICY IF EXISTS "anon_select_w10_proj_tracker" ON introai_project_tracker;
DROP POLICY IF EXISTS "anon_update_w10_proj_tracker" ON introai_project_tracker;
DROP POLICY IF EXISTS "auth_select_w10_proj_tracker" ON introai_project_tracker;

-- Written via upsert (on_conflict=student_email) and a direct student_email-keyed
-- PATCH from the check-in pages, so anon needs UPDATE in addition to INSERT/SELECT — never DELETE.
CREATE POLICY "anon_insert_w10_proj_tracker"
  ON introai_project_tracker
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "anon_select_w10_proj_tracker"
  ON introai_project_tracker
  FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "anon_update_w10_proj_tracker"
  ON introai_project_tracker
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

CREATE POLICY "auth_select_w10_proj_tracker"
  ON introai_project_tracker
  FOR SELECT
  TO authenticated
  USING (true);

-- ── Row-Level Security: introai_project_progress_logs ─────────────────────────
ALTER TABLE introai_project_progress_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all_w10_proj_logs" ON introai_project_progress_logs;
DROP POLICY IF EXISTS "anon_insert_w10_proj_logs" ON introai_project_progress_logs;
DROP POLICY IF EXISTS "anon_select_w10_proj_logs" ON introai_project_progress_logs;
DROP POLICY IF EXISTS "auth_select_w10_proj_logs" ON introai_project_progress_logs;

-- Append-only check-in log (one new row per check-in, never revised) — anon gets INSERT + SELECT only.
CREATE POLICY "anon_insert_w10_proj_logs"
  ON introai_project_progress_logs
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "anon_select_w10_proj_logs"
  ON introai_project_progress_logs
  FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "auth_select_w10_proj_logs"
  ON introai_project_progress_logs
  FOR SELECT
  TO authenticated
  USING (true);
