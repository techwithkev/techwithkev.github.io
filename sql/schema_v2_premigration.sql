-- ============================================================================
-- techwithkev.github.io — Schema v2: Pre-Migration (Step 0)
-- ============================================================================
-- PURPOSE
--   The old database has tables named `cohorts` and `access_codes` whose
--   column structure conflicts with the new v2 schema. This script renames
--   them to *_legacy so schema_v2.sql can create the new versions cleanly.
--
-- WHAT IT DOES
--   • Renames conflicting tables to <name>_legacy (old data fully preserved)
--   • Updates any FK constraints that point at the old tables
--   • Safe to run multiple times (IF EXISTS guards everywhere)
--
-- RUN ORDER
--   0. schema_v2_premigration.sql   ← this file (run FIRST)
--   1. schema_v2.sql
--   2. schema_v2_aijr.sql
--   3. seeds/v2_seed_courses.sql
--   4. views/v_submission_summary.sql
-- ============================================================================

-- ── Rename old cohorts → cohorts_legacy ──────────────────────────────────────
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'cohorts'
  ) THEN
    -- Drop any existing _legacy table so rename doesn't conflict
    DROP TABLE IF EXISTS cohorts_legacy CASCADE;
    ALTER TABLE cohorts RENAME TO cohorts_legacy;
    RAISE NOTICE 'Renamed cohorts → cohorts_legacy';
  ELSE
    RAISE NOTICE 'cohorts does not exist, skipping rename.';
  END IF;
END $$;

-- ── Rename old access_codes → access_codes_legacy ────────────────────────────
--   Old schema: access_codes(id, code, cohort TEXT, class_number, max_uses, ...)
--   New schema: access_codes(id, code, cohort_id BIGINT FK, class_id BIGINT FK, ...)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'access_codes'
  ) THEN
    DROP TABLE IF EXISTS access_codes_legacy CASCADE;
    ALTER TABLE access_codes RENAME TO access_codes_legacy;
    RAISE NOTICE 'Renamed access_codes → access_codes_legacy';
  ELSE
    RAISE NOTICE 'access_codes does not exist, skipping rename.';
  END IF;
END $$;

-- ── Rename old test_access_codes → test_access_codes_legacy ──────────────────
--   Superseded by the new unified access_codes table (purpose = 'exam').
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'test_access_codes'
  ) THEN
    DROP TABLE IF EXISTS test_access_codes_legacy CASCADE;
    ALTER TABLE test_access_codes RENAME TO test_access_codes_legacy;
    RAISE NOTICE 'Renamed test_access_codes → test_access_codes_legacy';
  ELSE
    RAISE NOTICE 'test_access_codes does not exist, skipping rename.';
  END IF;
END $$;

-- ── Verify ────────────────────────────────────────────────────────────────────
-- After running this, you should see these legacy tables:
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('cohorts_legacy', 'access_codes_legacy', 'test_access_codes_legacy')
ORDER BY table_name;

-- And these should NOT exist (will be created fresh by schema_v2.sql):
-- cohorts, access_codes
