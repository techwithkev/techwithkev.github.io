-- ── Table: introai_week13_ai_career_mapping ─────────────────────────────────
-- Week 13 Exercise 1: AI Career Mapping (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week13_ai_career_mapping (
  id                        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name              TEXT NOT NULL,
  student_email             TEXT,

  -- Step 1: Career Pick
  selected_career_category  TEXT NOT NULL,
  career_title              TEXT NOT NULL,

  -- Step 2: Research Details
  typical_day_desc          TEXT NOT NULL,
  required_skills_classes   TEXT NOT NULL,

  -- Step 3: Personal Connection & Surprises
  personal_connection       TEXT NOT NULL,
  surprising_discovery      TEXT NOT NULL,

  -- Rating
  enjoyment_rating          SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w13_ai_career_mapping_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week13_ai_career_mapping
  IS 'Week 13 Exercise 1: AI Career Mapping';

-- ── Safe Schema Migration (if table already exists) ──────────────────────────
ALTER TABLE introai_week13_ai_career_mapping ADD COLUMN IF NOT EXISTS selected_career_category TEXT;

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week13_ai_career_mapping ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w13_ai_career_mapping" ON introai_week13_ai_career_mapping;
DROP POLICY IF EXISTS "anon_select_w13_ai_career_mapping" ON introai_week13_ai_career_mapping;
DROP POLICY IF EXISTS "anon_update_w13_ai_career_mapping" ON introai_week13_ai_career_mapping;
DROP POLICY IF EXISTS "anon_all_w13_ai_career_mapping" ON introai_week13_ai_career_mapping;
DROP POLICY IF EXISTS "auth_select_w13_ai_career_mapping" ON introai_week13_ai_career_mapping;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w13_ai_career_mapping"
  ON introai_week13_ai_career_mapping
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w13_ai_career_mapping"
  ON introai_week13_ai_career_mapping
  FOR SELECT
  TO authenticated
  USING (true);
