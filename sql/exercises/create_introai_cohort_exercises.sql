-- ── Table: introai_cohort_exercises ──────────────────────────────────────────
-- Cohort-based exercise visibility and active status controls
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_cohort_exercises (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cohort       TEXT NOT NULL DEFAULT 'aijr',       -- e.g. 'aijr', 'fall2024', 'sat_10am'
  exercise_id  TEXT NOT NULL,                      -- e.g. 'week01_is_it_ai', 'week11_synthetic_media'
  is_active    BOOLEAN NOT NULL DEFAULT true,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_cohort_exercise UNIQUE (cohort, exercise_id)
);

COMMENT ON TABLE introai_cohort_exercises
  IS 'Stores active/inactive visibility toggles for Intro to AI exercises per cohort';

-- Row Level Security
ALTER TABLE introai_cohort_exercises ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_cohort_exercises" ON introai_cohort_exercises;
DROP POLICY IF EXISTS "anon_all_cohort_exercises" ON introai_cohort_exercises;
DROP POLICY IF EXISTS "auth_all_cohort_exercises" ON introai_cohort_exercises;

-- Anonymous students can read exercise active statuses
CREATE POLICY "anon_select_cohort_exercises"
  ON introai_cohort_exercises FOR SELECT TO anon USING (true);

-- Only authenticated teachers (via the teacher dashboard's login wall) manage toggles —
-- anon never writes to this table, so no anon FOR ALL grant here (see TODOS.md history).
CREATE POLICY "auth_all_cohort_exercises"
  ON introai_cohort_exercises FOR ALL TO authenticated USING (true) WITH CHECK (true);
