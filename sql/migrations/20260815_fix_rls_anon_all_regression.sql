-- ─────────────────────────────────────────────────────────────────────────────
-- Migration: Fix anon FOR ALL regression from 20260809_allow_delete_exercise_submissions.sql
--            (and any older FOR ALL TO anon policy left over from original
--            table creation, under whatever name it was originally given)
-- Date: 2026-08-15
-- Context:
--   20260809_allow_delete_exercise_submissions.sql granted "FOR ALL TO anon"
--   (INSERT + SELECT + UPDATE + DELETE) on 36 exercise tables so the teacher
--   dashboard's delete-submission feature would work. It only needed
--   "FOR ALL TO authenticated" (real teacher sessions) for that — the anon
--   grant was unnecessary and re-opened anonymous DELETE access that
--   20260804_fix_rls_week09_week10.sql had deliberately closed 5 days earlier.
--   The anon key is public (embedded in every student page), so this let
--   anyone issue raw REST DELETE calls against any of these tables.
--
--   Separately: 8 of these 36 tables (introai_week09_*, introai_week10_*,
--   introai_project_tracker, introai_project_progress_logs) were ALSO created
--   with a "FOR ALL TO anon" policy baked in from the start, under a SHORT
--   policy name (e.g. "anon_all_w09_npc_logic") — a different name than the
--   one 20260809 uses (e.g. "anon_all_introai_week09_npc_logic"). A migration
--   that only drops the 20260809-style name would leave that original policy
--   live. Rather than hardcode every legacy name, this migration looks up
--   pg_policies directly and drops ANY existing policy on each table that
--   grants "FOR ALL" to "anon", whatever it's named.
--
--   Also: not every table in the 36-table list necessarily exists in every
--   environment (e.g. introai_week07_build_dataset caused the original run
--   of this fix to fail with "relation does not exist" — which also means
--   20260809 itself may never have successfully applied, since Postgres
--   DO blocks are atomic and would have rolled back on the same error).
--   Each table is existence-checked before being touched, matching the
--   defensive pattern already used in 20260804_fix_rls_week09_week10.sql.
--
--   This migration replaces every anon "FOR ALL" policy found with scoped
--   policies per table, based on how each table is actually written to
--   client-side (checked against every page in pages/introai/ and
--   pages/aijr/ that writes to these tables):
--
--   • INSERT_ONLY tables: written via plain POST (supabaseInsert /
--     sb.insert()), never re-submitted. anon gets INSERT + SELECT only.
--   • UPSERT tables: written via PostgREST upsert (?on_conflict=student_email,
--     Prefer: resolution=merge-duplicates) or a direct PATCH keyed on
--     student_email, so a student can revise an existing submission in place.
--     anon gets INSERT + SELECT + UPDATE — but still NEVER DELETE; nothing
--     client-side ever deletes as anon, and delete-submission is a teacher-only
--     (authenticated) action via the dashboard.
--
--   auth_all_* (FOR ALL TO authenticated) is left untouched — that's what the
--   teacher dashboard's delete-submission feature actually needs.
-- Run in: Supabase Dashboard → SQL Editor
-- ─────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
  t TEXT;
  pol RECORD;
  insert_only_tables TEXT[] := ARRAY[
    'introai_week01_self_assessment',
    'introai_week01_scavenger_hunt',
    'introai_week01_chatbots',
    'introai_week02_creative_prompting',
    'introai_week02_persona_detective',
    'introai_week02_co_writer_story',
    'introai_week03_ai_pictionary',
    'introai_week03_prompt_comparison',
    'introai_week04_music_generation',
    'introai_week04_instrument_swap',
    'introai_week05_train_your_model',
    'introai_week06_be_the_algorithm',
    'introai_week06_analyze_your_feed',
    'introai_week06_design_a_recommender',
    'introai_week06_knowledge_check',
    'introai_week07_spot_the_bias',
    'introai_week07_data_audit',
    'introai_week07_build_dataset',
    'introai_week07_data_detective',
    'introai_week08_bias_card_twist',
    'introai_week08_bias_detective_stations',
    'introai_week08_fix_the_dataset',
    'introai_week08_promise_vs_problem',
    'introai_week08_mini_ethics_trial',
    'introai_project_progress_logs'
  ];
  -- Written via PostgREST upsert (on_conflict=student_email) or a direct
  -- student_email-keyed PATCH — students revise these in place, so anon
  -- needs UPDATE in addition to INSERT + SELECT (never DELETE).
  upsert_tables TEXT[] := ARRAY[
    'introai_week09_npc_logic',
    'introai_week09_ai_feature_pitch',
    'introai_week09_project_brief',
    'introai_week09_poc_brainstormer',
    'introai_project_tracker',
    'introai_week10_ai_design_sprint',
    'introai_week10_mockup_critique',
    'introai_week11_synthetic_media',
    'introai_week11_what_would_you_do',
    'introai_week12_mini_chatbot',
    'introai_week12_bot_vs_llm'
  ];
BEGIN
  FOREACH t IN ARRAY insert_only_tables LOOP
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = t) THEN
      RAISE NOTICE 'Skipping %, table does not exist', t;
      CONTINUE;
    END IF;

    -- Drop ANY existing policy that grants FOR ALL to anon, whatever it's named
    FOR pol IN
      SELECT policyname FROM pg_policies
      WHERE schemaname = 'public' AND tablename = t AND cmd = 'ALL' AND 'anon' = ANY(roles)
    LOOP
      EXECUTE format('DROP POLICY %I ON %I;', pol.policyname, t);
    END LOOP;

    -- Drop and recreate the scoped policies (idempotent re-run safe)
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_insert_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_select_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_update_' || t, t);

    EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO anon WITH CHECK (true);', 'anon_insert_' || t, t);
    EXECUTE format('CREATE POLICY %I ON %I FOR SELECT TO anon USING (true);', 'anon_select_' || t, t);
  END LOOP;

  FOREACH t IN ARRAY upsert_tables LOOP
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = t) THEN
      RAISE NOTICE 'Skipping %, table does not exist', t;
      CONTINUE;
    END IF;

    FOR pol IN
      SELECT policyname FROM pg_policies
      WHERE schemaname = 'public' AND tablename = t AND cmd = 'ALL' AND 'anon' = ANY(roles)
    LOOP
      EXECUTE format('DROP POLICY %I ON %I;', pol.policyname, t);
    END LOOP;

    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_insert_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_select_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_update_' || t, t);

    EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO anon WITH CHECK (true);', 'anon_insert_' || t, t);
    EXECUTE format('CREATE POLICY %I ON %I FOR SELECT TO anon USING (true);', 'anon_select_' || t, t);
    EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO anon USING (true) WITH CHECK (true);', 'anon_update_' || t, t);
  END LOOP;
END $$;

-- Force PostgREST schema cache reload
NOTIFY pgrst, 'reload schema';
