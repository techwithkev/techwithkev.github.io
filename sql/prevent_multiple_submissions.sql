-- =============================================================
-- Migration: Prevent multiple submissions by adding UNIQUE constraints
-- Context:   Ensures students can only submit one copy of each exercise.
--            Cleans up duplicate submissions first by keeping the latest.
-- Date:      2026-07-18
-- =============================================================

-- 1. Week 1 Chatbots (introai_week01_chatbots)
DELETE FROM introai_week01_chatbots WHERE id NOT IN (
  SELECT max(id) FROM introai_week01_chatbots GROUP BY student_email
);
ALTER TABLE introai_week01_chatbots DROP CONSTRAINT IF EXISTS unique_week01_chatbots_email;
ALTER TABLE introai_week01_chatbots ADD CONSTRAINT unique_week01_chatbots_email UNIQUE (student_email);

-- 2. Week 1 Scavenger Hunt (introai_week01_scavenger_hunt)
DELETE FROM introai_week01_scavenger_hunt WHERE id NOT IN (
  SELECT max(id) FROM introai_week01_scavenger_hunt GROUP BY student_email
);
ALTER TABLE introai_week01_scavenger_hunt DROP CONSTRAINT IF EXISTS unique_week01_scavenger_hunt_email;
ALTER TABLE introai_week01_scavenger_hunt ADD CONSTRAINT unique_week01_scavenger_hunt_email UNIQUE (student_email);

-- 3. Week 1 Self Assessment (introai_week01_self_assessment)
DELETE FROM introai_week01_self_assessment WHERE id NOT IN (
  SELECT max(id) FROM introai_week01_self_assessment GROUP BY student_email
);
ALTER TABLE introai_week01_self_assessment DROP CONSTRAINT IF EXISTS unique_week01_self_assessment_email;
ALTER TABLE introai_week01_self_assessment ADD CONSTRAINT unique_week01_self_assessment_email UNIQUE (student_email);

-- 4. Week 1 Scores (introai_week01_scores)
DELETE FROM introai_week01_scores WHERE id NOT IN (
  SELECT max(id) FROM introai_week01_scores GROUP BY student_email
);
ALTER TABLE introai_week01_scores DROP CONSTRAINT IF EXISTS unique_week01_scores_email;
ALTER TABLE introai_week01_scores ADD CONSTRAINT unique_week01_scores_email UNIQUE (student_email);

-- 5. Week 2 Persona Detective (introai_week02_persona_detective)
DELETE FROM introai_week02_persona_detective WHERE id NOT IN (
  SELECT max(id) FROM introai_week02_persona_detective GROUP BY student_email
);
ALTER TABLE introai_week02_persona_detective DROP CONSTRAINT IF EXISTS unique_week02_persona_detective_email;
ALTER TABLE introai_week02_persona_detective ADD CONSTRAINT unique_week02_persona_detective_email UNIQUE (student_email);

-- 6. Week 2 Creative Prompting (introai_week02_creative_prompting)
DELETE FROM introai_week02_creative_prompting WHERE id NOT IN (
  SELECT max(id) FROM introai_week02_creative_prompting GROUP BY student_email
);
ALTER TABLE introai_week02_creative_prompting DROP CONSTRAINT IF EXISTS unique_week02_creative_prompting_email;
ALTER TABLE introai_week02_creative_prompting ADD CONSTRAINT unique_week02_creative_prompting_email UNIQUE (student_email);

-- 7. Week 3 AI Pictionary (introai_week03_ai_pictionary)
DELETE FROM introai_week03_ai_pictionary WHERE id NOT IN (
  SELECT max(id) FROM introai_week03_ai_pictionary GROUP BY student_email
);
ALTER TABLE introai_week03_ai_pictionary DROP CONSTRAINT IF EXISTS unique_week03_ai_pictionary_email;
ALTER TABLE introai_week03_ai_pictionary ADD CONSTRAINT unique_week03_ai_pictionary_email UNIQUE (student_email);

-- 8. Week 3 Prompt Comparison (introai_week03_prompt_comparison)
DELETE FROM introai_week03_prompt_comparison WHERE id NOT IN (
  SELECT max(id) FROM introai_week03_prompt_comparison GROUP BY student_email
);
ALTER TABLE introai_week03_prompt_comparison DROP CONSTRAINT IF EXISTS unique_week03_prompt_comparison_email;
ALTER TABLE introai_week03_prompt_comparison ADD CONSTRAINT unique_week03_prompt_comparison_email UNIQUE (student_email);

-- 9. Week 4 Music Generation (introai_week04_music_generation)
DELETE FROM introai_week04_music_generation WHERE id NOT IN (
  SELECT max(id) FROM introai_week04_music_generation GROUP BY student_email
);
ALTER TABLE introai_week04_music_generation DROP CONSTRAINT IF EXISTS unique_week04_music_generation_email;
ALTER TABLE introai_week04_music_generation ADD CONSTRAINT unique_week04_music_generation_email UNIQUE (student_email);

-- 10. Week 4 Instrument Swap (introai_week04_instrument_swap)
DELETE FROM introai_week04_instrument_swap WHERE id NOT IN (
  SELECT max(id) FROM introai_week04_instrument_swap GROUP BY student_email
);
ALTER TABLE introai_week04_instrument_swap DROP CONSTRAINT IF EXISTS unique_week04_instrument_swap_email;
ALTER TABLE introai_week04_instrument_swap ADD CONSTRAINT unique_week04_instrument_swap_email UNIQUE (student_email);

-- 11. Week 5 Train Your Model (introai_week05_train_your_model)
DELETE FROM introai_week05_train_your_model WHERE id NOT IN (
  SELECT max(id) FROM introai_week05_train_your_model GROUP BY student_email
);
ALTER TABLE introai_week05_train_your_model DROP CONSTRAINT IF EXISTS unique_week05_train_your_model_email;
ALTER TABLE introai_week05_train_your_model ADD CONSTRAINT unique_week05_train_your_model_email UNIQUE (student_email);

-- 12. Final Project Definitions (final_project_definitions)
DELETE FROM final_project_definitions WHERE id NOT IN (
  SELECT max(id) FROM final_project_definitions GROUP BY student_name
);
ALTER TABLE final_project_definitions DROP CONSTRAINT IF EXISTS unique_final_project_definitions_name;
ALTER TABLE final_project_definitions ADD CONSTRAINT unique_final_project_definitions_name UNIQUE (student_name);
