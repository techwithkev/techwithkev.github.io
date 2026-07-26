-- ============================================================
-- AI Junior Competition — Classes 1–7 Online Test — Supabase Setup
-- Run this once in the Supabase SQL Editor (same project as homework.html)
-- ============================================================

-- ── 1. Access codes table ───────────────────────────────────
CREATE TABLE IF NOT EXISTS test_access_codes (
  id          BIGSERIAL PRIMARY KEY,
  code        TEXT UNIQUE NOT NULL,
  test_id     TEXT NOT NULL,
  cohort      TEXT,
  max_uses    INT NOT NULL DEFAULT 1,
  uses_count  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- ── 2. Submissions table ────────────────────────────────────
CREATE TABLE IF NOT EXISTS test_submissions (
  id               BIGSERIAL PRIMARY KEY,
  student_name     TEXT NOT NULL,
  test_id          TEXT NOT NULL,
  access_code      TEXT,
  mcq_score        INT,
  blank_score      INT,
  auto_score       INT,
  total_possible   INT,
  pct              NUMERIC,
  question_detail  JSONB,
  started_at       TIMESTAMPTZ,
  submitted_at     TIMESTAMPTZ DEFAULT now()
);

-- ── 3. Row Level Security ───────────────────────────────────
ALTER TABLE test_access_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_submissions  ENABLE ROW LEVEL SECURITY;

-- Students (anon key) need to read a code to validate it, and
-- increment its use count. They also need to insert a submission.
DROP POLICY IF EXISTS "anon select test_access_codes" ON test_access_codes;
CREATE POLICY "anon select test_access_codes" ON test_access_codes
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "anon update test_access_codes" ON test_access_codes;
CREATE POLICY "anon update test_access_codes" ON test_access_codes
  FOR UPDATE USING (true);

DROP POLICY IF EXISTS "anon insert test_submissions" ON test_submissions;
CREATE POLICY "anon insert test_submissions" ON test_submissions
  FOR INSERT WITH CHECK (true);

-- Optional: allow the instructor to read submissions with the anon key too
-- (remove this policy if you'd rather only read submissions from the
-- Supabase dashboard / a service-role key).
DROP POLICY IF EXISTS "anon select test_submissions" ON test_submissions;
CREATE POLICY "anon select test_submissions" ON test_submissions
  FOR SELECT USING (true);

-- Instructor management policies for authenticated teachers
DROP POLICY IF EXISTS "auth all test_access_codes" ON test_access_codes;
CREATE POLICY "auth all test_access_codes" ON test_access_codes
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth all test_submissions" ON test_submissions;
CREATE POLICY "auth all test_submissions" ON test_submissions
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── 4. Seed an access code ──────────────────────────────────
-- Change the code, cohort, and max_uses to fit your class size.
INSERT INTO test_access_codes (code, test_id, cohort, max_uses, is_active)
VALUES ('C1TO7TEST', 'classes1to7_test', 'aijr', 100, true)
ON CONFLICT (code) DO UPDATE SET
  test_id    = EXCLUDED.test_id,
  cohort     = EXCLUDED.cohort,
  max_uses   = EXCLUDED.max_uses,
  is_active  = EXCLUDED.is_active;

-- ── 5. Handy queries for reviewing results ──────────────────
-- All submissions, most recent first:
--   SELECT student_name, auto_score, total_possible, pct, submitted_at
--   FROM test_submissions ORDER BY submitted_at DESC;

-- Just the pending-review open-ended answers (Q21):
--   SELECT student_name, question_detail->'q21'->>'text' AS q21_answer
--   FROM test_submissions ORDER BY submitted_at DESC;
