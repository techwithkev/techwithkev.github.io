-- =============================================================
-- Migration: Add Week 2 Co-Writer Story to class_config using Range Partitioning
-- Context:   Allows teachers to select 'AI Co-Writer Story' in the
--            Access Code Generator and issue class-specific entry codes.
--            Uses class_number 102 to avoid conflicts with AI Junior classes.
-- Date:      2026-07-05
-- =============================================================

-- Clean up class_number 17 if it was created
DELETE FROM public.class_config WHERE class_number = 17;

-- Insert class_number 102 for Intro AI
INSERT INTO public.class_config (
  class_number, 
  title, 
  subtitle, 
  description, 
  homework_title, 
  module_badge, 
  difficulty_badge
)
VALUES (
  102, 
  'AI Co-Writer Story', 
  'Intro to AI — Week 2', 
  'Collaborative class storytelling with AI assistance.', 
  'Storybook Paragraph', 
  'Intro AI', 
  'Beginner'
)
ON CONFLICT (class_number) DO UPDATE
SET 
  title = EXCLUDED.title,
  subtitle = EXCLUDED.subtitle,
  description = EXCLUDED.description,
  homework_title = EXCLUDED.homework_title,
  module_badge = EXCLUDED.module_badge,
  difficulty_badge = EXCLUDED.difficulty_badge;
