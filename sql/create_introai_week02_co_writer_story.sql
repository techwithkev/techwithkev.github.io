-- =============================================================
-- Migration: Create table for Intro AI Week 02 Co-Writer Story
-- Context:   Students build a collaborative story by class number,
--            adding paragraphs co-written with AI.
-- Date:      2026-07-05
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week02_co_writer_story (
  id                  BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Class / cohort association
  class_number        TEXT NOT NULL,

  -- Story content
  prompt_used         TEXT,
  story_text          TEXT NOT NULL,

  -- Ordering sequence (1-indexed sequence of blocks)
  sequence_order      INTEGER NOT NULL,
  
  -- Flag to allow soft-deleting/filtering by teacher
  is_visible          BOOLEAN NOT NULL DEFAULT true,

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week02_co_writer_story
  IS 'Week 2 Activity 2: Collaborative class storytelling where students contribute blocks co-written with AI.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week02_co_writer_story ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT and SELECT
CREATE POLICY "anon_select_co_writer_story"
  ON introai_week02_co_writer_story
  FOR SELECT TO anon
  USING (is_visible = true);

CREATE POLICY "anon_insert_co_writer_story"
  ON introai_week02_co_writer_story
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated (teachers) can do anything (SELECT, INSERT, UPDATE, DELETE)
CREATE POLICY "auth_all_co_writer_story"
  ON introai_week02_co_writer_story
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);
