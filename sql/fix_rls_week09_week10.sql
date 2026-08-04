-- =============================================================
-- Migration: Tighten RLS on Week 9 & 10 tables
-- Context:   Week 9–10 tables were created with "FOR ALL TO anon"
--            which grants anonymous DELETE and UPDATE in addition
--            to INSERT/SELECT. This migration replaces them with
--            the same scoped pattern used on Week 1–8 tables.
-- Date:      2026-08-04
-- Run in:    Supabase Dashboard → SQL Editor
-- =============================================================

DO $$
BEGIN

  -- ── Week 9: NPC Logic ────────────────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week09_npc_logic') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w09_npc_logic" ON introai_week09_npc_logic';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w09_npc_logic" ON introai_week09_npc_logic';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w09_npc_logic" ON introai_week09_npc_logic';
    EXECUTE 'CREATE POLICY "anon_insert_w09_npc_logic" ON introai_week09_npc_logic FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w09_npc_logic" ON introai_week09_npc_logic FOR SELECT TO anon USING (true)';
  END IF;

  -- ── Week 9: AI Feature Pitch ─────────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week09_ai_feature_pitch') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch';
    EXECUTE 'CREATE POLICY "anon_insert_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch FOR SELECT TO anon USING (true)';
  END IF;

  -- ── Week 9: POC Brainstormer ─────────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week09_poc_brainstormer') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w09_poc_brainstormer" ON introai_week09_poc_brainstormer';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w09_poc_brainstormer" ON introai_week09_poc_brainstormer';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w09_poc_brainstormer" ON introai_week09_poc_brainstormer';
    EXECUTE 'CREATE POLICY "anon_insert_w09_poc_brainstormer" ON introai_week09_poc_brainstormer FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w09_poc_brainstormer" ON introai_week09_poc_brainstormer FOR SELECT TO anon USING (true)';
  END IF;

  -- ── Week 9: Project Brief ────────────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week09_project_brief') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w09_project_brief" ON introai_week09_project_brief';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w09_project_brief" ON introai_week09_project_brief';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w09_project_brief" ON introai_week09_project_brief';
    EXECUTE 'CREATE POLICY "anon_insert_w09_project_brief" ON introai_week09_project_brief FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w09_project_brief" ON introai_week09_project_brief FOR SELECT TO anon USING (true)';
  END IF;

  -- ── Week 10: AI Design Sprint ─────────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week10_ai_design_sprint') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w10_ai_design_sprint" ON introai_week10_ai_design_sprint';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w10_ai_design_sprint" ON introai_week10_ai_design_sprint';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w10_ai_design_sprint" ON introai_week10_ai_design_sprint';
    EXECUTE 'CREATE POLICY "anon_insert_w10_ai_design_sprint" ON introai_week10_ai_design_sprint FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w10_ai_design_sprint" ON introai_week10_ai_design_sprint FOR SELECT TO anon USING (true)';
  END IF;

  -- ── Week 10: Mockup Critique ──────────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week10_mockup_critique') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w10_mockup_critique" ON introai_week10_mockup_critique';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w10_mockup_critique" ON introai_week10_mockup_critique';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w10_mockup_critique" ON introai_week10_mockup_critique';
    EXECUTE 'CREATE POLICY "anon_insert_w10_mockup_critique" ON introai_week10_mockup_critique FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w10_mockup_critique" ON introai_week10_mockup_critique FOR SELECT TO anon USING (true)';
  END IF;

  -- ── Week 10: Project Tracker ──────────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week10_project_tracker') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w10_project_tracker" ON introai_week10_project_tracker';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w10_project_tracker" ON introai_week10_project_tracker';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w10_project_tracker" ON introai_week10_project_tracker';
    EXECUTE 'DROP POLICY IF EXISTS "anon_update_own_w10_project_tracker" ON introai_week10_project_tracker';
    EXECUTE 'CREATE POLICY "anon_insert_w10_project_tracker" ON introai_week10_project_tracker FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w10_project_tracker" ON introai_week10_project_tracker FOR SELECT TO anon USING (true)';
    EXECUTE 'CREATE POLICY "anon_update_own_w10_project_tracker" ON introai_week10_project_tracker FOR UPDATE TO anon USING (true) WITH CHECK (true)';
  END IF;

  -- ── Week 10: Project Tracker Logs ────────────────────────────
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'introai_week10_project_tracker_logs') THEN
    EXECUTE 'DROP POLICY IF EXISTS "anon_all_w10_project_tracker_logs" ON introai_week10_project_tracker_logs';
    EXECUTE 'DROP POLICY IF EXISTS "anon_insert_w10_tracker_logs" ON introai_week10_project_tracker_logs';
    EXECUTE 'DROP POLICY IF EXISTS "anon_select_w10_tracker_logs" ON introai_week10_project_tracker_logs';
    EXECUTE 'CREATE POLICY "anon_insert_w10_tracker_logs" ON introai_week10_project_tracker_logs FOR INSERT TO anon WITH CHECK (true)';
    EXECUTE 'CREATE POLICY "anon_select_w10_tracker_logs" ON introai_week10_project_tracker_logs FOR SELECT TO anon USING (true)';
  END IF;

END $$;
