-- ── Table: introai_week09_poc_brainstormer ──────────────────────────────
-- Week 9 Exercise: Final Project POC Brainstormer & Tracker
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week09_poc_brainstormer (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- AI Modality Ratings & Preference Profile (JSON)
  modality_ratings    TEXT NOT NULL,
  primary_modality    TEXT NOT NULL,
  secondary_modality  TEXT NOT NULL,
  target_domain       TEXT NOT NULL,

  -- Proof of Concept (POC) Pitch Details
  poc_title           TEXT NOT NULL,
  poc_description     TEXT NOT NULL,
  mvp_scope           TEXT NOT NULL,

  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w09_poc_brainstormer_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week09_poc_brainstormer
  IS 'Week 9 Exercise: Final Project POC Brainstormer & Tracker';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week09_poc_brainstormer ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "anon_select_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "anon_update_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "anon_all_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "auth_select_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w09_poc_brainstormer"
  ON introai_week09_poc_brainstormer
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w09_poc_brainstormer"
  ON introai_week09_poc_brainstormer
  FOR SELECT
  TO authenticated
  USING (true);
