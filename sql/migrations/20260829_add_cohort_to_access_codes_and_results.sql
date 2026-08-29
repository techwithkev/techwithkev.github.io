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
