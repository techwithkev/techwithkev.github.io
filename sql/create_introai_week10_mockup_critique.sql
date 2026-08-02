-- ── Table: introai_week10_mockup_critique ─────────────────────────────────
-- Week 10 Exercise 2: Mockup Critique & Ethical UI Redesign (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week10_mockup_critique (
  id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name             TEXT NOT NULL,
  student_email            TEXT,

  -- Step 1: Selected Interface Screenshot Pattern
  selected_pattern         TEXT NOT NULL,
  pattern_name_id          TEXT NOT NULL,

  -- Step 2: Benefit vs Harm Critique
  who_benefits             TEXT NOT NULL,
  who_is_harmed            TEXT NOT NULL,

  -- Step 3: Honest UI Redesign & Google Slides Link
  honest_rewrite_summary   TEXT NOT NULL,
  slides_link              TEXT NOT NULL,

  -- Step 4: Class Share Takeaway
  class_share_takeaway     TEXT NOT NULL,

  -- Rating
  enjoyment_rating         SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w10_mockup_critique_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week10_mockup_critique
  IS 'Week 10 Exercise 2: Mockup Critique & Ethical UI Redesign';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week10_mockup_critique ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "anon_select_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "anon_update_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "anon_all_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "auth_select_w10_mockup_critique" ON introai_week10_mockup_critique;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w10_mockup_critique"
  ON introai_week10_mockup_critique
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w10_mockup_critique"
  ON introai_week10_mockup_critique
  FOR SELECT
  TO authenticated
  USING (true);
