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

  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w10_proj_tracker_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_project_tracker
  IS 'Main final AI project registry for students';

-- ── Table 2: introai_project_progress_logs ──────────────────────────────
-- Class-by-class progress update logs
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_project_progress_logs (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_email           TEXT NOT NULL,
  class_label             TEXT NOT NULL, -- e.g. "Class 10", "Class 11 - Day 1"

  -- Log Details
  milestone_completed     TEXT NOT NULL,
  blockers_faced          TEXT,
  next_goal               TEXT NOT NULL,
  progress_pct            SMALLINT NOT NULL CHECK (progress_pct BETWEEN 0 AND 100),

  logged_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_project_progress_logs
  IS 'Class-by-class progress update logs for final AI projects';

-- ── Row-Level Security: introai_project_tracker ───────────────────────────────
ALTER TABLE introai_project_tracker ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all_w10_proj_tracker" ON introai_project_tracker;
DROP POLICY IF EXISTS "auth_select_w10_proj_tracker" ON introai_project_tracker;

CREATE POLICY "anon_all_w10_proj_tracker"
  ON introai_project_tracker
  FOR ALL
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
DROP POLICY IF EXISTS "auth_select_w10_proj_logs" ON introai_project_progress_logs;

CREATE POLICY "anon_all_w10_proj_logs"
  ON introai_project_progress_logs
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

CREATE POLICY "auth_select_w10_proj_logs"
  ON introai_project_progress_logs
  FOR SELECT
  TO authenticated
  USING (true);
