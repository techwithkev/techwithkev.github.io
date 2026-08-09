-- ─────────────────────────────────────────────────────────────────────────────
-- Migration: Enable DELETE / ALL Row-Level Security Policies for Exercise Tables
-- Date: 2026-08-09
-- Description:
--   Allows anon and authenticated (teacher) roles to DELETE exercise submissions
--   from the Teacher Dashboard.
-- ─────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
  t TEXT;
  tables TEXT[] := ARRAY[
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
    'introai_week09_npc_logic',
    'introai_week09_ai_feature_pitch',
    'introai_week09_project_brief',
    'introai_week09_poc_brainstormer',
    'introai_project_tracker',
    'introai_project_progress_logs',
    'introai_week10_ai_design_sprint',
    'introai_week10_mockup_critique',
    'introai_week11_synthetic_media',
    'introai_week11_what_would_you_do',
    'introai_week12_mini_chatbot',
    'introai_week12_bot_vs_llm'
  ];
BEGIN
  FOREACH t IN ARRAY tables LOOP
    -- Drop existing delete/all policies to prevent duplicate policy errors
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_all_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'auth_all_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'anon_delete_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I;', 'auth_delete_' || t, t);

    -- Create ALL policies for anon and authenticated roles
    EXECUTE format('CREATE POLICY %I ON %I FOR ALL TO anon USING (true) WITH CHECK (true);', 'anon_all_' || t, t);
    EXECUTE format('CREATE POLICY %I ON %I FOR ALL TO authenticated USING (true) WITH CHECK (true);', 'auth_all_' || t, t);
  END LOOP;
END $$;

-- Force PostgREST schema cache reload
NOTIFY pgrst, 'reload schema';
