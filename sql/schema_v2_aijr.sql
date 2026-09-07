-- ============================================================================
-- techwithkev.github.io — Schema v2: AIJR-Specific Tables
-- ============================================================================
-- Run AFTER schema_v2.sql.
--
-- Covers:
--   1. exam_submissions — unified typed table for all AIJR exams/tests.
--      Consolidates: caio_final_exam_results + test_submissions.
--   2. Migration: add cohort_id FK to existing homework_submissions table.
-- ============================================================================

-- ── 1. EXAM SUBMISSIONS ───────────────────────────────────────────────────────
--   Typed (not JSONB) because AIJR exam scoring is complex:
--     • MCQ scores + per-question breakdown
--     • Fill-in-the-blank scores + per-blank answers
--     • Partial auto-grading + teacher override scores
--
--   Consolidates:
--     • caio_final_exam_results  (legacy Final Exam, Classes 1–16)
--     • test_submissions          (Classes 1–7 online test)
--   source_table column preserves which legacy table the row came from.
CREATE TABLE IF NOT EXISTS exam_submissions (
  id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cohort_id        BIGINT NOT NULL REFERENCES cohorts(id) ON DELETE RESTRICT,
  class_id         BIGINT REFERENCES classes(id) ON DELETE SET NULL,

  -- Student identity
  student_name     TEXT NOT NULL,
  access_code      TEXT,                   -- raw code stored for audit trail

  -- Exam identity
  exam_slug        TEXT NOT NULL,          -- 'classes1to7_test' | 'final_exam_c16'
  exam_label       TEXT NOT NULL,          -- 'Classes 1–7 Test' | 'Final Exam'

  -- Scoring
  mcq_score        INT,
  blank_score      INT,
  auto_score       INT,
  teacher_score    INT,                    -- manual override (nullable)
  total_possible   INT NOT NULL DEFAULT 60,
  pct              NUMERIC(5,2),

  -- Detailed answer breakdown (JSONB — complex structure)
  question_detail  JSONB NOT NULL DEFAULT '{}',

  -- Session tracking
  started_at       TIMESTAMPTZ,
  submitted_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Provenance (for legacy data migration)
  source_table     TEXT,                   -- 'caio_final_exam_results' | 'test_submissions' | 'v2'
  legacy_id        TEXT                    -- original id from source_table (for dedup)
);

COMMENT ON TABLE exam_submissions IS
  'Unified AIJR exam results. Consolidates caio_final_exam_results and test_submissions. question_detail JSONB holds MCQ choices, blank answers, and per-section breakdowns.';

CREATE INDEX IF NOT EXISTS idx_exam_sub_cohort   ON exam_submissions(cohort_id);
CREATE INDEX IF NOT EXISTS idx_exam_sub_slug      ON exam_submissions(exam_slug);
CREATE INDEX IF NOT EXISTS idx_exam_sub_email     ON exam_submissions(student_name, submitted_at DESC);

ALTER TABLE exam_submissions ENABLE ROW LEVEL SECURITY;

-- Students (anon) write results; teachers (auth) read + manage all
CREATE POLICY "anon_insert_exam_submissions" ON exam_submissions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_select_exam_submissions" ON exam_submissions FOR SELECT TO anon USING (true);
CREATE POLICY "auth_all_exam_submissions"    ON exam_submissions FOR ALL TO authenticated USING (true) WITH CHECK (true);


-- ── 2. HOMEWORK SUBMISSIONS — add cohort_id FK ────────────────────────────────
--   homework_submissions table stays as-is (typed columns, proven schema).
--   We add cohort_id so the dashboard can filter server-side instead of
--   resolving access_code → cohort client-side on every load.
--
--   Migration steps:
--     a. Add nullable cohort_id column.
--     b. Back-fill from access_codes WHERE code = homework_submissions.access_code.
--     c. Make NOT NULL after back-fill.
--     d. Add FK constraint.

-- Step a: add the column (safe to run even if it exists)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'homework_submissions' AND column_name = 'cohort_id'
  ) THEN
    ALTER TABLE homework_submissions ADD COLUMN cohort_id BIGINT;
    RAISE NOTICE 'Added cohort_id column to homework_submissions.';
  ELSE
    RAISE NOTICE 'homework_submissions.cohort_id already exists, skipping.';
  END IF;
END $$;

-- Step b: back-fill cohort_id from the new access_codes table
--   NOTE: This JOIN works once the new access_codes table is populated.
--         Run after sql/seeds/v2_seed_courses.sql creates your first cohort
--         and you have migrated (or re-created) access codes in the new table.
--
-- UPDATE homework_submissions hw
-- SET cohort_id = ac.cohort_id
-- FROM access_codes ac
-- WHERE UPPER(hw.access_code) = UPPER(ac.code)
--   AND hw.cohort_id IS NULL;

-- Step c + d: FK constraint (run after back-fill is complete and column has no NULLs)
-- ALTER TABLE homework_submissions
--   ALTER COLUMN cohort_id SET NOT NULL,
--   ADD CONSTRAINT homework_submissions_cohort_id_fkey
--     FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE RESTRICT;

-- Index for server-side filtering
CREATE INDEX IF NOT EXISTS idx_hw_sub_cohort ON homework_submissions(cohort_id);

COMMENT ON COLUMN homework_submissions.cohort_id IS
  'FK to cohorts.id. Set from access_code lookup at submit time. Enables server-side cohort filtering in teacher dashboard.';
