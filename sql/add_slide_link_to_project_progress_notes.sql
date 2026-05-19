-- =============================================================
-- Migration: Add slide_link column to project_progress_notes
-- Context:   Week 14 progress report form collects a URL to the
--            student's presentation slides (Google Slides, Canva, etc.)
-- Date:      2026-05-23
-- =============================================================

-- Step 1: Add the new column (nullable so existing rows are unaffected)
ALTER TABLE project_progress_notes
  ADD COLUMN IF NOT EXISTS slide_link TEXT;

-- Step 2: (Optional) Add a comment to document the column's purpose
COMMENT ON COLUMN project_progress_notes.slide_link
  IS 'URL to the student''s presentation slides (e.g. Google Slides, Canva). Collected from Week 14 onwards.';

-- Step 3: (Optional) Add a CHECK constraint to loosely validate URL format
-- Uncomment the line below if you want to enforce that the value looks like a URL
-- ALTER TABLE project_progress_notes
--   ADD CONSTRAINT chk_slide_link_url CHECK (slide_link IS NULL OR slide_link ~* '^https?://');
