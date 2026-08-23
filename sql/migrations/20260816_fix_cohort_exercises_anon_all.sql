-- ─────────────────────────────────────────────────────────────────────────────
-- Migration: Remove unnecessary anon FOR ALL grant on introai_cohort_exercises
-- Date: 2026-08-16
-- Context:
--   introai_cohort_exercises (per-cohort exercise active/inactive toggles) was
--   created with a "FOR ALL TO anon" policy — the same anti-pattern fixed on
--   the 36 exercise-submission tables in 20260815_fix_rls_anon_all_regression.sql,
--   just lower severity here (a config toggle table, not student data).
--
--   Verified against the client code before removing: the only write path is
--   pages/teacher/teacher_dashboard.html's toggleSingleExercise() /
--   batchSetCohortExercises(), both reachable only after a real Supabase Auth
--   login (the dashboard's #app container is hidden until sb.auth.getSession()
--   or signInWithPassword() succeeds — see teacher_dashboard.html:11605-11618).
--   That means every real write already runs as the 'authenticated' role,
--   already covered by auth_all_cohort_exercises. The only anon-context reader
--   (pages/introai/index.html) only does a GET, covered separately by
--   anon_select_cohort_exercises, which this migration does not touch.
--
--   So unlike 20260815, this table doesn't need a replacement anon policy —
--   the anon FOR ALL grant is simply removed.
-- Run in: Supabase Dashboard → SQL Editor
-- ─────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
  pol RECORD;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_cohort_exercises') THEN
    RAISE NOTICE 'Skipping introai_cohort_exercises, table does not exist';
  ELSE
    FOR pol IN
      SELECT policyname FROM pg_policies
      WHERE schemaname = 'public' AND tablename = 'introai_cohort_exercises' AND cmd = 'ALL' AND 'anon' = ANY(roles)
    LOOP
      EXECUTE format('DROP POLICY %I ON introai_cohort_exercises;', pol.policyname);
    END LOOP;
  END IF;
END $$;

-- Force PostgREST schema cache reload
NOTIFY pgrst, 'reload schema';
