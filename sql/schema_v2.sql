-- ============================================================================
-- techwithkev.github.io — Schema v2
-- ============================================================================
-- Purpose:  Unified multi-course data architecture.
--           Replaces the 50+ per-exercise tables with a single
--           exercise_submissions table. Introduces a three-level hierarchy:
--           courses → cohorts → classes.
--
-- Deployment order:
--   0. Run sql/schema_v2_premigration.sql  (renames old cohorts + access_codes to _legacy).
--   1. Run this file (schema_v2.sql) in the Supabase SQL Editor.
--   2. Run sql/schema_v2_aijr.sql  (exam_submissions + hw migration).
--   3. Run sql/seeds/v2_seed_courses.sql  (seed courses + exercise_definitions).
--   4. Run sql/views/v_submission_summary.sql  (dashboard convenience view).
--
-- BACKWARD COMPATIBILITY
--   All existing introai_week* tables remain untouched and readable.
--   New cohorts write to exercise_submissions; legacy cohorts stay in old tables.
-- ============================================================================

-- ── 1. COURSES ──────────────────────────────────────────────────────────────
--   Registry of all courses offered. Single source of truth for course identity.
CREATE TABLE IF NOT EXISTS courses (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  slug        TEXT NOT NULL UNIQUE,        -- 'introai' | 'aijr' | 'python'
  name        TEXT NOT NULL,               -- 'Introduction to AI'
  description TEXT,
  color_theme TEXT NOT NULL DEFAULT 'rose',-- CSS theme token used by activity pages
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE courses IS
  'Registry of all courses. slug is the stable identifier used by student pages and exercise definitions.';

-- ── 2. COHORTS ───────────────────────────────────────────────────────────────
--   A cohort is a specific run/section of a course (e.g. "Fall 2026 — Sat 10am").
--   Students are assigned to exactly one cohort when they enter an access code.
CREATE TABLE IF NOT EXISTS cohorts (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  course_id   BIGINT NOT NULL REFERENCES courses(id) ON DELETE RESTRICT,
  slug        TEXT NOT NULL,               -- 'fall-2026-sat-10am'
  name        TEXT NOT NULL,               -- 'Fall 2026 — Saturday 10am'
  term        TEXT,                        -- 'Fall 2026' (human-readable grouping)
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_by  UUID REFERENCES auth.users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (course_id, slug)
);

COMMENT ON TABLE cohorts IS
  'A cohort is one section/semester of a course. Students belong to exactly one cohort per enrollment.';

-- ── 3. CLASSES ───────────────────────────────────────────────────────────────
--   Individual sessions or weeks within a cohort.
--   Used for: access code scoping, homework per-class filtering, sequencing.
CREATE TABLE IF NOT EXISTS classes (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cohort_id      BIGINT NOT NULL REFERENCES cohorts(id) ON DELETE CASCADE,
  label          TEXT NOT NULL,            -- 'Week 1', 'Class 7', 'Final Exam'
  sequence_order SMALLINT NOT NULL DEFAULT 1,
  is_active      BOOLEAN NOT NULL DEFAULT true,
  UNIQUE (cohort_id, sequence_order)
);

COMMENT ON TABLE classes IS
  'Individual sessions within a cohort. Used to scope access codes and homework submissions.';

-- ── 4. ACCESS CODES ──────────────────────────────────────────────────────────
--   Unified access code table covering all use cases:
--     • AIJR homework per-class codes    (class_id IS NOT NULL, purpose = 'homework')
--     • AIJR exam codes                  (class_id IS NOT NULL, purpose = 'exam')
--     • IntroAI cohort-wide codes        (class_id IS NULL,     purpose = 'general')
--
--   Replaces: access_codes (AIJR), test_access_codes (AIJR exam).
CREATE TABLE IF NOT EXISTS access_codes (
  id          UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  code        TEXT NOT NULL UNIQUE,
  cohort_id   BIGINT NOT NULL REFERENCES cohorts(id) ON DELETE RESTRICT,
  class_id    BIGINT REFERENCES classes(id) ON DELETE SET NULL, -- NULL = course-wide
  purpose     TEXT NOT NULL DEFAULT 'general'
              CHECK (purpose IN ('general','homework','exam','exercise')),
  max_uses    INT NOT NULL DEFAULT 999,
  uses_count  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_by  UUID REFERENCES auth.users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE access_codes IS
  'Unified access codes for all courses and purposes. cohort_id is always set; class_id is set only for class-scoped codes (homework, exams).';

CREATE INDEX IF NOT EXISTS idx_access_codes_cohort   ON access_codes(cohort_id);
CREATE INDEX IF NOT EXISTS idx_access_codes_class     ON access_codes(class_id);
CREATE INDEX IF NOT EXISTS idx_access_codes_code_upper ON access_codes(UPPER(code));

-- ── 5. STUDENT SESSIONS ──────────────────────────────────────────────────────
--   Lightweight identity record created when a student first enters their
--   name + email + access code. No passwords; access code = cohort gate.
--
--   Enables: "show all submissions for this student" in O(1) query.
--   One row per (student_email, cohort_id) pair.
CREATE TABLE IF NOT EXISTS student_sessions (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_email  TEXT NOT NULL,
  student_name   TEXT NOT NULL,
  cohort_id      BIGINT NOT NULL REFERENCES cohorts(id) ON DELETE RESTRICT,
  access_code    TEXT,                     -- the code they used to join
  first_seen_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_seen_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (student_email, cohort_id)
);

COMMENT ON TABLE student_sessions IS
  'Lightweight student identity per cohort. Created on first access code validation. No passwords — access code is the gate.';

CREATE INDEX IF NOT EXISTS idx_student_sessions_email   ON student_sessions(student_email);
CREATE INDEX IF NOT EXISTS idx_student_sessions_cohort  ON student_sessions(cohort_id);

-- ── 6. EXERCISE DEFINITIONS ───────────────────────────────────────────────────
--   Registry of all exercises (Intro AI activities, AIJR visualizers, etc.).
--   Adding a new exercise = one INSERT here, zero schema changes elsewhere.
CREATE TABLE IF NOT EXISTS exercise_definitions (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  course_id      BIGINT NOT NULL REFERENCES courses(id) ON DELETE RESTRICT,
  exercise_slug  TEXT NOT NULL,            -- 'week01_scavenger_hunt'
  label          TEXT NOT NULL,            -- 'Week 1 — AI Scavenger Hunt'
  week_number    SMALLINT,                 -- 1
  sequence_order SMALLINT NOT NULL DEFAULT 1, -- ordering within the week
  is_active      BOOLEAN NOT NULL DEFAULT true,
  UNIQUE (course_id, exercise_slug)
);

COMMENT ON TABLE exercise_definitions IS
  'Master registry of all exercises per course. exercise_slug matches the HTML page filename convention.';

CREATE INDEX IF NOT EXISTS idx_exercise_def_course ON exercise_definitions(course_id);

-- ── 7. COHORT EXERCISE VISIBILITY ────────────────────────────────────────────
--   Per-cohort on/off toggles for which exercises are visible to students.
--   Replaces: introai_cohort_exercises.
CREATE TABLE IF NOT EXISTS cohort_exercise_visibility (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cohort_id    BIGINT NOT NULL REFERENCES cohorts(id) ON DELETE CASCADE,
  exercise_id  BIGINT NOT NULL REFERENCES exercise_definitions(id) ON DELETE CASCADE,
  is_active    BOOLEAN NOT NULL DEFAULT true,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (cohort_id, exercise_id)
);

COMMENT ON TABLE cohort_exercise_visibility IS
  'Controls which exercises are visible/active for each cohort. Default: all exercises active.';

-- ── 8. EXERCISE SUBMISSIONS ───────────────────────────────────────────────────
--   THE unified submissions table. Replaces all 35+ introai_week* tables.
--
--   exercise_id + student_email = UNIQUE (one submission per student per exercise).
--   cohort_id  is denormalized onto the row for fast server-side filtering —
--              no client-side resolution needed.
--   payload    stores exercise-specific answers as JSONB.
--   enjoyment_rating is extracted top-level for easy aggregation.
CREATE TABLE IF NOT EXISTS exercise_submissions (
  id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  exercise_id      BIGINT NOT NULL REFERENCES exercise_definitions(id) ON DELETE RESTRICT,
  cohort_id        BIGINT NOT NULL REFERENCES cohorts(id) ON DELETE RESTRICT,
  student_email    TEXT NOT NULL,
  student_name     TEXT NOT NULL,
  payload          JSONB NOT NULL DEFAULT '{}',
  enjoyment_rating SMALLINT CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (exercise_id, student_email)
);

COMMENT ON TABLE exercise_submissions IS
  'Unified submissions table. payload contains all exercise-specific answers as JSONB. cohort_id is denormalized for fast dashboard filtering without joins through access_codes.';

CREATE INDEX IF NOT EXISTS idx_ex_sub_exercise   ON exercise_submissions(exercise_id);
CREATE INDEX IF NOT EXISTS idx_ex_sub_cohort      ON exercise_submissions(cohort_id);
CREATE INDEX IF NOT EXISTS idx_ex_sub_email       ON exercise_submissions(student_email);
CREATE INDEX IF NOT EXISTS idx_ex_sub_cohort_ex   ON exercise_submissions(cohort_id, exercise_id);

-- ── ROW LEVEL SECURITY ────────────────────────────────────────────────────────

-- courses (anon can read; only auth can write)
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_select_courses" ON courses FOR SELECT TO anon USING (true);
CREATE POLICY "auth_all_courses"    ON courses FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- cohorts (anon can read; only auth can write)
ALTER TABLE cohorts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_select_cohorts" ON cohorts FOR SELECT TO anon USING (true);
CREATE POLICY "auth_all_cohorts"    ON cohorts FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- classes (anon can read; only auth can write)
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_select_classes" ON classes FOR SELECT TO anon USING (true);
CREATE POLICY "auth_all_classes"    ON classes FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- access_codes (anon can read/update uses_count; only auth can create/delete)
ALTER TABLE access_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_select_access_codes" ON access_codes FOR SELECT TO anon USING (true);
CREATE POLICY "anon_update_uses_count"   ON access_codes FOR UPDATE TO anon
  USING (true) WITH CHECK (true);
CREATE POLICY "auth_all_access_codes"    ON access_codes FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- student_sessions (anon can upsert own session; auth can read all)
ALTER TABLE student_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_insert_student_sessions" ON student_sessions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_select_student_sessions" ON student_sessions FOR SELECT TO anon USING (true);
CREATE POLICY "anon_update_student_sessions" ON student_sessions FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "auth_all_student_sessions"    ON student_sessions FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- exercise_definitions (anon can read; only auth can write)
ALTER TABLE exercise_definitions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_select_exercise_defs" ON exercise_definitions FOR SELECT TO anon USING (true);
CREATE POLICY "auth_all_exercise_defs"    ON exercise_definitions FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- cohort_exercise_visibility (anon can read; only auth can write)
ALTER TABLE cohort_exercise_visibility ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_select_cohort_vis" ON cohort_exercise_visibility FOR SELECT TO anon USING (true);
CREATE POLICY "auth_all_cohort_vis"    ON cohort_exercise_visibility FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- exercise_submissions (anon can insert + select; auth can do all)
ALTER TABLE exercise_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_insert_ex_submissions" ON exercise_submissions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_select_ex_submissions" ON exercise_submissions FOR SELECT TO anon USING (true);
CREATE POLICY "anon_update_ex_submissions" ON exercise_submissions FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "auth_all_ex_submissions"    ON exercise_submissions FOR ALL TO authenticated USING (true) WITH CHECK (true);
