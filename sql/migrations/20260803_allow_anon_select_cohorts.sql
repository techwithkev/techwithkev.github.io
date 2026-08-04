-- =============================================================
-- Migration: Enable RLS on cohorts and allow anon select
-- Context:   Allows student-facing pages to query the list of active
--            cohorts/classes configured by the teacher.
-- Date:      2026-07-05
-- =============================================================

ALTER TABLE public.cohorts ENABLE ROW LEVEL SECURITY;

-- Clean up existing policy to avoid conflict
DROP POLICY IF EXISTS "anon_select_cohorts" ON public.cohorts;
DROP POLICY IF EXISTS "auth_all_cohorts" ON public.cohorts;

-- Create policies
CREATE POLICY "anon_select_cohorts" ON public.cohorts
  FOR SELECT TO anon
  USING (true);

CREATE POLICY "auth_all_cohorts" ON public.cohorts
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);
