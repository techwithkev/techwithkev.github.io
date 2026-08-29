-- ============================================================
-- Migration: add cohort support to access_codes & exam results
-- Date: 2026-08-29
-- ============================================================

-- 1. Add cohort to access_codes
--    Nullable so existing rows stay valid; populate manually per code.
ALTER TABLE access_codes
  ADD COLUMN IF NOT EXISTS cohort TEXT;

COMMENT ON COLUMN access_codes.cohort IS
  'Optional cohort label (e.g. ''morning'', ''cohort-a''). '
  'Populated by the instructor when creating/assigning access codes.';

-- 2. Add cohort to caio_final_exam_results
--    Copied from the validated access_codes row at submission time (server-side).
ALTER TABLE caio_final_exam_results
  ADD COLUMN IF NOT EXISTS cohort TEXT;

COMMENT ON COLUMN caio_final_exam_results.cohort IS
  'Cohort label copied from access_codes.cohort at submission time. '
  'Allows filtering/grouping results by cohort in the dashboard.';

-- 3. Index for fast cohort queries on the results table
CREATE INDEX IF NOT EXISTS idx_caio_final_exam_results_cohort
  ON caio_final_exam_results (cohort);

-- ============================================================
-- OPTIONAL: seed cohort values for existing access codes
-- Uncomment and adjust to match your real codes.
-- ============================================================
-- UPDATE access_codes SET cohort = 'morning'  WHERE code IN ('XYZABC', 'DEF123');
-- UPDATE access_codes SET cohort = 'evening'  WHERE code IN ('GHI456', 'JKL789');

-- ============================================================
-- Register Class 16 in class_config
-- Required so "Class 16" appears in the Generate Access Codes
-- class selector dropdown (loaded from this table).
-- ============================================================
INSERT INTO public.class_config (
  class_number,
  title,
  subtitle,
  description,
  homework_title,
  module_badge,
  difficulty_badge
)
VALUES (
  16,
  'Final Exam',
  'AI Junior — Class 16',
  'Part 1 of the final practice exam covering Classes 1–16.',
  'Final Exam Part 1',
  'AI Junior',
  'Advanced'
)
ON CONFLICT (class_number) DO UPDATE
SET
  title            = EXCLUDED.title,
  subtitle         = EXCLUDED.subtitle,
  description      = EXCLUDED.description,
  homework_title   = EXCLUDED.homework_title,
  module_badge     = EXCLUDED.module_badge,
  difficulty_badge = EXCLUDED.difficulty_badge;

-- ============================================================
-- 4. Session tracking for "Active Now" monitoring
--    session_id: client-generated UUID, written at exam start
--    started_at: timestamp when student clicks "Begin Exam"
--    submitted_at already exists; null = still in progress
-- ============================================================
ALTER TABLE caio_final_exam_results
  ADD COLUMN IF NOT EXISTS session_id UUID;

ALTER TABLE caio_final_exam_results
  ADD COLUMN IF NOT EXISTS started_at TIMESTAMPTZ;

-- Unique index so the Edge Function can upsert on session_id
CREATE UNIQUE INDEX IF NOT EXISTS idx_caio_final_exam_results_session_id
  ON caio_final_exam_results (session_id)
  WHERE session_id IS NOT NULL;

COMMENT ON COLUMN caio_final_exam_results.session_id IS
  'Client-generated UUID written when the student starts the exam. '
  'Used as the upsert key so the Edge Function can fill in scores without creating a duplicate row.';

COMMENT ON COLUMN caio_final_exam_results.started_at IS
  'Timestamp when the student clicked Begin Exam (before submitting). '
  'Rows with started_at set but submitted_at NULL are currently in progress.';
