-- ── Table: introai_week06_knowledge_check ─────────────────────────────────
-- Week 6 Exercise: Week 6 Quiz — Recommendation Systems
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week06_knowledge_check (
  id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name                TEXT NOT NULL,
  student_email               TEXT,

  -- Multiple Choice Questions
  q1_content_filtering        TEXT NOT NULL,
  q2_collaborative_filtering  TEXT NOT NULL,
  q3_cold_start               TEXT NOT NULL,
  q4_filter_bubble            TEXT NOT NULL,
  q5_user_parameters          TEXT NOT NULL,
  q6_flowchart_shapes         TEXT NOT NULL,

  -- Quiz Score Results
  score                       SMALLINT NOT NULL,
  pct                         SMALLINT NOT NULL,

  -- Reflections
  reflection_surprising       TEXT NOT NULL,
  enjoyment_rating            SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w06_knowledge_check_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week06_knowledge_check
  IS 'Week 6 Quiz: Recommendation Systems Knowledge Check';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week06_knowledge_check ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w06_knowledge_check"
  ON introai_week06_knowledge_check
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w06_knowledge_check"
  ON introai_week06_knowledge_check
  FOR SELECT TO authenticated
  USING (true);
