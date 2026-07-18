-- =============================================================
-- Migration: Create table for Intro AI Week 05 Train Your Model exercise
-- Context:   Students train an Image, Audio, or Pose classifier using
--            Google Teachable Machine, export their link, test it live,
--            and reflect on the results.
-- Date:      2026-07-18
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week05_train_your_model (
  id                      BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name            TEXT NOT NULL,
  student_email           TEXT,

  -- Project details
  project_type            TEXT NOT NULL, -- 'Image', 'Audio', 'Pose'
  project_title           TEXT NOT NULL,
  classes_trained         TEXT NOT NULL,
  examples_per_class      TEXT NOT NULL,

  -- Teachable Machine details
  model_url               TEXT NOT NULL,

  -- Reflections & enjoyments
  accuracy_rating         TEXT NOT NULL,
  challenges_reflections  TEXT NOT NULL,
  improvement_ideas       TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL,

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week05_train_your_model
  IS 'Week 5 Exercise: Google Teachable Machine student trained models, metadata, and reflections.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week05_train_your_model ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_train_your_model"
  ON introai_week05_train_your_model
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_train_your_model"
  ON introai_week05_train_your_model
  FOR SELECT TO authenticated
  USING (true);
