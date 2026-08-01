-- ── Table: introai_week09_project_brief ─────────────────────────────────
-- Week 9 Kickoff Task: Your Project Brief (Final AI project planning)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week09_project_brief (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  group_members           TEXT NOT NULL,

  -- Project Brief Items
  project_goal            TEXT NOT NULL,
  intended_audience       TEXT NOT NULL,
  ai_tools_methods        TEXT NOT NULL,
  division_of_labor       TEXT NOT NULL,
  ethical_considerations  TEXT NOT NULL,
  definition_of_done      TEXT NOT NULL,

  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w09_project_brief_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week09_project_brief
  IS 'Week 9 Kickoff Task: Your Project Brief';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week09_project_brief ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT, SELECT, and UPDATE (student page uses anon key with retrieval & upsert)
CREATE POLICY "anon_insert_w09_project_brief"
  ON introai_week09_project_brief
  FOR INSERT TO anon
  WITH CHECK (true);

CREATE POLICY "anon_select_w09_project_brief"
  ON introai_week09_project_brief
  FOR SELECT TO anon
  USING (true);

CREATE POLICY "anon_update_w09_project_brief"
  ON introai_week09_project_brief
  FOR UPDATE TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w09_project_brief"
  ON introai_week09_project_brief
  FOR SELECT TO authenticated
  USING (true);

