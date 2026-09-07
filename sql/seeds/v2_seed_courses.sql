-- ============================================================================
-- techwithkev.github.io — Schema v2: Seed Data
-- ============================================================================
-- Run AFTER schema_v2.sql AND schema_v2_aijr.sql.
--
-- Seeds:
--   1. courses     — introai + aijr
--   2. exercise_definitions — all Intro AI exercises
--   3. Placeholder cohort for immediate use
--
-- To create your real Fall 2026 cohorts, use the teacher dashboard
-- (pages/teacher/cohorts.html) after deploying — these are admin seeds only.
-- ============================================================================

-- ── 1. COURSES ───────────────────────────────────────────────────────────────
INSERT INTO courses (slug, name, description, color_theme, is_active)
VALUES
  ('introai', 'Introduction to AI',
   'A hands-on introductory course exploring AI tools, concepts, ethics, and applications.',
   'rose', true),
  ('aijr',    'AI Junior Competition',
   'Machine learning fundamentals for the Canadian AI Junior Competition (CAIO).',
   'indigo', true)
ON CONFLICT (slug) DO UPDATE SET
  name        = EXCLUDED.name,
  description = EXCLUDED.description,
  color_theme = EXCLUDED.color_theme;

-- ── 2. EXERCISE DEFINITIONS — Intro AI ───────────────────────────────────────
-- Matches the exercise_slug convention: {week_number}_{page_slug}
-- sequence_order is ordering within the week (for display in dashboard).

WITH introai AS (SELECT id FROM courses WHERE slug = 'introai')
INSERT INTO exercise_definitions (course_id, exercise_slug, label, week_number, sequence_order, is_active)
SELECT
  introai.id, slug, label, week_num, seq, true
FROM introai, (VALUES
  -- Week 1
  ('week01_is_it_ai',           'Week 1 — Is It AI?',                    1, 1),
  ('week01_ai_scavenger_hunt',  'Week 1 — AI Scavenger Hunt',            1, 2),
  ('week01_intro_to_chatbots',  'Week 1 — Intro to Chatbots',            1, 3),
  ('week01_ai_self_assessment', 'Week 1 — AI Self-Assessment',           1, 4),
  -- Week 2
  ('week02_creative_prompting', 'Week 2 — Creative Prompting',           2, 1),
  ('week02_persona_detective',  'Week 2 — Persona Detective',            2, 2),
  ('week02_co_writer_story',    'Week 2 — Co-Writer Story',              2, 3),
  -- Week 3
  ('week03_ai_pictionary',      'Week 3 — AI Pictionary',                3, 1),
  ('week03_prompt_comparison',  'Week 3 — Prompt Comparison',            3, 2),
  -- Week 4
  ('week04_music_generation',   'Week 4 — Music Generation',             4, 1),
  ('week04_instrument_swap',    'Week 4 — Instrument Swap',              4, 2),
  -- Week 5
  ('week05_train_your_model',   'Week 5 — Train Your Model',             5, 1),
  -- Week 6
  ('week06_be_the_algorithm',   'Week 6 — Be the Algorithm',             6, 1),
  ('week06_analyze_your_feed',  'Week 6 — Analyze Your Feed',            6, 2),
  ('week06_design_a_recommender','Week 6 — Design a Recommender',        6, 3),
  ('week06_knowledge_check',    'Week 6 — Knowledge Check',              6, 4),
  -- Week 7
  ('week07_spot_the_bias',      'Week 7 — Spot the Bias',                7, 1),
  ('week07_data_audit',         'Week 7 — Data Audit',                   7, 2),
  ('week07_build_dataset',      'Week 7 — Build a Dataset',              7, 3),
  ('week07_data_detective',     'Week 7 — Data Detective',               7, 4),
  -- Week 8
  ('week08_bias_card_twist',    'Week 8 — Bias Card Twist',              8, 1),
  ('week08_bias_detective_stations','Week 8 — Bias Detective Stations',  8, 2),
  ('week08_fix_the_dataset',    'Week 8 — Fix the Dataset',              8, 3),
  ('week08_promise_vs_problem', 'Week 8 — Promise vs Problem',           8, 4),
  ('week08_mini_ethics_trial',  'Week 8 — Mini Ethics Trial',            8, 5),
  -- Week 9
  ('week09_npc_logic',          'Week 9 — NPC Logic',                    9, 1),
  ('week09_ai_feature_pitch',   'Week 9 — AI Feature Pitch',             9, 2),
  ('week09_project_brief',      'Week 9 — Project Brief',                9, 3),
  ('week09_poc_brainstormer',   'Week 9 — POC Brainstormer',             9, 4),
  -- Week 10
  ('week10_ai_design_sprint',   'Week 10 — AI Design Sprint',           10, 1),
  ('week10_mockup_critique',    'Week 10 — Mockup Critique',            10, 2),
  ('week10_project_tracker',    'Week 10 — Project Tracker',            10, 3),
  -- Week 11
  ('week11_synthetic_media',    'Week 11 — Synthetic Media',            11, 1),
  ('week11_what_would_you_do',  'Week 11 — What Would You Do?',         11, 2),
  ('week11_checkin',            'Week 11 — Build Check-In',             11, 3),
  -- Week 12
  ('week12_mini_chatbot',       'Week 12 — Mini Chatbot',               12, 1),
  ('week12_bot_vs_llm',         'Week 12 — Bot vs LLM',                 12, 2),
  ('week12_checkin',            'Week 12 — Build Check-In',             12, 3),
  -- Week 13
  ('week13_ai_career_mapping',  'Week 13 — AI Career Mapping',          13, 1),
  ('week13_will_ai_take_this_job','Week 13 — Will AI Take This Job?',   13, 2),
  ('week13_checkin',            'Week 13 — Build Check-In',             13, 3),
  -- Week 14
  ('week14_checkin',            'Week 14 — Build Check-In',             14, 1),
  -- Week 15
  ('week15_checkin',            'Week 15 — Final Build Check-In',       15, 1),
  -- Week 16
  ('week16_final_submission',   'Week 16 — Final Project Submission',   16, 1)
) AS t(slug, label, week_num, seq)
ON CONFLICT (course_id, exercise_slug) DO UPDATE SET
  label          = EXCLUDED.label,
  week_number    = EXCLUDED.week_number,
  sequence_order = EXCLUDED.sequence_order;

-- ── 3. EXERCISE DEFINITIONS — AIJR ───────────────────────────────────────────
WITH aijr AS (SELECT id FROM courses WHERE slug = 'aijr')
INSERT INTO exercise_definitions (course_id, exercise_slug, label, week_number, sequence_order, is_active)
SELECT
  aijr.id, slug, label, class_num, seq, true
FROM aijr, (VALUES
  ('class01_array_shape_transformer',  'Class 1 — Array Shape Transformer',  1,  1),
  ('class01_pixel_matrix_explorer',    'Class 1 — Pixel Matrix Explorer',     1,  2),
  ('class02_learning_curve_gap',       'Class 2 — Learning Curve Gap',        2,  1),
  ('class02_subgroup_bias_dragger',    'Class 2 — Subgroup Bias Dragger',     2,  2),
  ('class03_min_max_vs_z_score',       'Class 3 — Min-Max vs Z-Score',        3,  1),
  ('class03_z_score_gradient_descent', 'Class 3 — Z-Score Gradient Descent',  3,  2),
  ('class04_k_fold_carousel',          'Class 4 — K-Fold Carousel',           4,  1),
  ('class04_overfitting_polynomial',   'Class 4 — Overfitting Polynomial',    4,  2),
  ('class05_geometric_mse_square',     'Class 5 — Geometric MSE Square',      5,  1),
  ('class06_gradient_descent',         'Class 6 — Gradient Descent',          6,  1),
  ('class07_kernel_trick',             'Class 7 — Kernel Trick',              7,  1),
  ('class08_part1',                    'Class 8 — Test Part 1',               8,  1),
  ('class08_cheatsheet',               'Class 8 — Cheatsheet',                8,  2),
  ('class09_entropy_splitter',         'Class 9 — Entropy Splitter',          9,  1),
  ('class09_svm_soft_margin',          'Class 9 — SVM Soft Margin',           9,  2),
  ('class11_k_means_clustering',       'Class 11 — K-Means Clustering',       11, 1),
  ('class11_pca',                      'Class 11 — PCA',                      11, 2),
  ('class11_tsne',                     'Class 11 — t-SNE Visualizer',         11, 3),
  ('class13_agent_environment_loop',   'Class 13 — Agent Environment Loop',   13, 1),
  ('class13_bellman_gridworld',        'Class 13 — Bellman Gridworld',        13, 2),
  ('class13_qlearning',                'Class 13 — Q-Learning',               13, 3),
  ('class15_latent_space',             'Class 15 — Latent Space',             15, 1),
  ('class15_self_attention',           'Class 15 — Self-Attention',           15, 2),
  ('class16_final_exam',               'Class 16 — Final Exam',               16, 1)
) AS t(slug, label, class_num, seq)
ON CONFLICT (course_id, exercise_slug) DO UPDATE SET
  label          = EXCLUDED.label,
  week_number    = EXCLUDED.week_number,
  sequence_order = EXCLUDED.sequence_order;

-- ── NOTE: Cohort creation ─────────────────────────────────────────────────────
-- Create your real cohorts via the teacher dashboard (pages/teacher/cohorts.html).
-- Example of what the dashboard will INSERT:
--
--   INSERT INTO cohorts (course_id, slug, name, term)
--   VALUES ((SELECT id FROM courses WHERE slug = 'introai'),
--           'fall-2026-sat-10am', 'Fall 2026 — Saturday 10am', 'Fall 2026');
