-- ============================================================================
-- techwithkev.github.io — Schema v2: Dashboard Convenience Views
-- ============================================================================
-- Run AFTER schema_v2.sql and seeds.
--
-- Views:
--   v_submission_summary — per-student, per-exercise submission counts
--                          used by the teacher dashboard roster page.
--   v_cohort_roster      — one row per student per cohort with submission counts.
-- ============================================================================

-- ── 1. SUBMISSION SUMMARY ────────────────────────────────────────────────────
--   Joins exercise_submissions with exercise_definitions + cohorts for easy
--   teacher dashboard queries without multi-table joins in JS.
CREATE OR REPLACE VIEW v_submission_summary AS
SELECT
  es.id,
  es.submitted_at,
  es.student_email,
  es.student_name,
  es.enjoyment_rating,
  es.cohort_id,
  c.name   AS cohort_name,
  c.term   AS cohort_term,
  co.slug  AS course_slug,
  co.name  AS course_name,
  ed.id    AS exercise_id,
  ed.exercise_slug,
  ed.label AS exercise_label,
  ed.week_number
FROM exercise_submissions es
JOIN exercise_definitions ed ON ed.id = es.exercise_id
JOIN cohorts c               ON c.id  = es.cohort_id
JOIN courses co              ON co.id = ed.course_id;

COMMENT ON VIEW v_submission_summary IS
  'Flattened exercise submission view for teacher dashboard. Includes cohort, course, and exercise metadata.';

-- ── 2. COHORT ROSTER ─────────────────────────────────────────────────────────
--   One row per student per cohort. Shows total submissions + last activity.
--   Used by the roster.html teacher page.
CREATE OR REPLACE VIEW v_cohort_roster AS
SELECT
  ss.cohort_id,
  co.name              AS cohort_name,
  co.term              AS cohort_term,
  cur.slug             AS course_slug,
  cur.name             AS course_name,
  ss.student_email,
  ss.student_name,
  ss.first_seen_at,
  ss.last_seen_at,
  COUNT(es.id)         AS total_submissions,
  MAX(es.submitted_at) AS last_submission_at
FROM student_sessions ss
JOIN cohorts co   ON co.id  = ss.cohort_id
JOIN courses cur  ON cur.id = co.course_id
LEFT JOIN exercise_submissions es
  ON es.student_email = ss.student_email
  AND es.cohort_id    = ss.cohort_id
GROUP BY
  ss.cohort_id, co.name, co.term, cur.slug, cur.name,
  ss.student_email, ss.student_name,
  ss.first_seen_at, ss.last_seen_at;

COMMENT ON VIEW v_cohort_roster IS
  'One row per student per cohort. Shows submission counts and last activity. Used by teacher roster page.';

-- ── 3. COHORT EXERCISE COMPLETION ────────────────────────────────────────────
--   Grid of: which students have submitted which exercises, per cohort.
--   Useful for dashboard "completion heatmap" feature.
CREATE OR REPLACE VIEW v_cohort_exercise_completion AS
SELECT
  es.cohort_id,
  c.name     AS cohort_name,
  ed.exercise_slug,
  ed.label   AS exercise_label,
  ed.week_number,
  COUNT(es.id)                          AS submission_count,
  ROUND(AVG(es.enjoyment_rating), 2)    AS avg_enjoyment
FROM exercise_submissions es
JOIN exercise_definitions ed ON ed.id = es.exercise_id
JOIN cohorts c               ON c.id  = es.cohort_id
GROUP BY es.cohort_id, c.name, ed.exercise_slug, ed.label, ed.week_number
ORDER BY es.cohort_id, ed.week_number, ed.exercise_slug;

COMMENT ON VIEW v_cohort_exercise_completion IS
  'Per-cohort exercise completion counts and average enjoyment. Used for dashboard completion grid.';
