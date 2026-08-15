-- ── Table: introai_week10_ai_design_sprint ─────────────────────────────────
-- Week 10 Exercise 1: AI Design Tool Sprint (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week10_ai_design_sprint (
  id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name             TEXT NOT NULL,
  student_email            TEXT,

  -- Step 1: Brief
  product_brief            TEXT NOT NULL,

  -- Step 2: Visual Prompts
  visual_prompt_1          TEXT NOT NULL,
  visual_prompt_2          TEXT NOT NULL,
  visual_prompt_3          TEXT NOT NULL,

  -- Step 3: Screen UI Layout & Mockup Slide Link
  focal_component          TEXT NOT NULL,
  screen_layout_desc       TEXT NOT NULL,
  slides_link              TEXT NOT NULL,

  -- Step 4: Justification & Reflection
  key_choice_justification TEXT NOT NULL,
  ux_risk_reflection       TEXT NOT NULL,

  -- Rating
  enjoyment_rating         SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w10_ai_design_sprint_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week10_ai_design_sprint
  IS 'Week 10 Exercise 1: AI Design Tool Sprint';

-- ── Safe Schema Migration (if table already exists) ──────────────────────────
ALTER TABLE introai_week10_ai_design_sprint ADD COLUMN IF NOT EXISTS slides_link TEXT;

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week10_ai_design_sprint ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "anon_select_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "anon_update_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "anon_all_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "auth_select_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;

-- Allow anonymous students to INSERT, SELECT, and UPDATE own submission (for upsert & retrieval) — never DELETE
CREATE POLICY "anon_insert_w10_ai_design_sprint"
  ON introai_week10_ai_design_sprint
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "anon_select_w10_ai_design_sprint"
  ON introai_week10_ai_design_sprint
  FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "anon_update_w10_ai_design_sprint"
  ON introai_week10_ai_design_sprint
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w10_ai_design_sprint"
  ON introai_week10_ai_design_sprint
  FOR SELECT
  TO authenticated
  USING (true);
