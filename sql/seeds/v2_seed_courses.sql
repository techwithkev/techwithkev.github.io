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
  -- Week 14 (Inserted: AI in Science & Research)
  ('week14_science_research',   'Week 14 — AI in Science & Research',   14, 1),
  -- Week 15 (Inserted: AI for Business & Entrepreneurship)
  ('week15_business_entrepreneurship', 'Week 15 — AI for Business & Entrepreneurship', 15, 1),
  -- Week 16 (Inserted: Robotics & Physical AI)
  ('week16_robotics_physical_ai', 'Week 16 — Robotics & Physical AI',   16, 1),
  -- Week 17 (Renumbered from 14: Project Build Session)
  ('week17_checkin',            'Week 17 — Project Build Session',      17, 1),
  ('week17_progress_notes',     'Week 17 — Progress Notes',             17, 2),
  ('week14_checkin',            'Week 17 — Project Build Session (Legacy slug)', 17, 3),
  -- Week 18 (Renumbered from 15: Project Build Session & Rehearsal)
  ('week18_checkin',            'Week 18 — Project Build Session & Rehearsal', 18, 1),
  ('week15_checkin',            'Week 18 — Project Build Session & Rehearsal (Legacy slug)', 18, 2),
  -- Week 19 (Renumbered from 16: Showcase, Debate & What's Next)
  ('week19_final_submission',   'Week 19 — Showcase, Debate & What''s Next', 19, 1),
  ('week16_final_submission',   'Week 19 — Final Project Submission (Legacy slug)', 19, 2)
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
  ('class01_array_shape_transformer',          'Class 1 — Array Shape Transformer',                          1,  1),
  ('class01_pixel_matrix_explorer',            'Class 1 — Pixel Matrix Explorer',                             1,  2),
  ('class02_subgroup_bias_dragger',            'Class 2 — Subgroup Bias Dragger',                             2,  1),
  ('class02_learning_curve_gap',               'Class 2 — Learning Curve Gap',                                2,  2),
  ('class03_min_max_vs_z_score_normalizer',    'Class 3 — Min-Max vs Z-Score Normalizer',                     3,  1),
  ('class03_z_score_gradient_descent',         'Class 3 — Z-Score Gradient Descent',                          3,  2),
  ('class04_k_fold_carousel',                  'Class 4 — K-Fold Carousel',                                   4,  1),
  ('class04_overfitting_polynomial',           'Class 4 — Overfitting Polynomial',                            4,  2),
  ('class05_the_geometric_mse_square',         'Class 5 — Geometric MSE Square',                              5,  1),
  ('class06_gradient_descent',                 'Class 6 — Gradient Descent',                                  6,  1),
  ('class07_entropy_splitter',                 'Class 7 — Decision Trees: Entropy Splitter',                  7,  1),
  ('class08_naive_bayes_knn',                  'Class 8 — Naive Bayes & K-NN Classifier',                     8,  1),
  ('class09_kernel_trick',                     'Class 9 — The Kernel Trick',                                  9,  1),
  ('class09_svm_soft_margin',                  'Class 9 — SVM Soft Margin (C Parameter)',                     9,  2),
  ('class10_midterm_exam',                     'Class 10 — Midterm Exam (Classes 1–9)',                      10,  1),
  ('class10_cheatsheet',                       'Class 10 — Midterm Cheatsheet',                              10,  2),
  ('class11_search_visualizer',                'Class 11 — Search Algorithms (Uninformed & Informed)',        11,  1),
  ('class12_constraint_propagation',           'Class 12 — Constraint Propagation & Minimax',                12,  1),
  ('class13_k_means_clustering',               'Class 13 — k-Means Clustering',                              13,  1),
  ('class13_principal_component_analysis',     'Class 13 — Principal Component Analysis (PCA)',              13,  2),
  ('class13_t_sne_process_visualizer',         'Class 13 — t-SNE Process Visualizer',                         13,  3),
  ('class14_extended_clustering',              'Class 14 — Extended Clustering (DBSCAN / GMM)',              14,  1),
  ('class15_mae_rmse',                         'Class 15 — Outlier Penalty (MAE vs RMSE)',                   15,  1),
  ('class15_r2_coefficient_of_determination',  'Class 15 — R² Coefficient of Determination',                 15,  2),
  ('class15_roc_auc',                          'Class 15 — ROC Curve & AUC',                                 15,  3),
  ('class15_visualization',                    'Class 15 — Bias-Variance & L2 Regularization',               15,  4),
  ('class15_learning_curves',                  'Class 15 — Learning Curves Diagnostic',                      15,  5),
  ('class16_agent_environment_loop',           'Class 16 — Agent-Environment Loop',                          16,  1),
  ('class16_mdp',                              'Class 16 — Markov Decision Process',                         16,  2),
  ('class16_bellman_gridworld',                'Class 16 — Bellman Gridworld',                               16,  3),
  ('class16_epsilon_visualizer',               'Class 16 — The Bandit Lab (Exploration vs Exploitation)',    16,  4),
  ('class16_qlearning',                        'Class 16 — Q-Learning Algorithm Update',                     16,  5),
  ('class17_cosine_similarity',                'Class 17 — Recommender Systems (Cosine Similarity)',         17,  1),
  ('class18_self_attention',                   'Class 18 — Self-Attention Web',                              18,  1),
  ('class18_latent_space',                     'Class 18 — Latent Space Interpolation',                      18,  2),
  ('class19_final_exam',                       'Class 19 — Final Exam (Classes 1–18)',                       19,  1)
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
