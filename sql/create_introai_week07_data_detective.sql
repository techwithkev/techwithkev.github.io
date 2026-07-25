-- ── Table: introai_week07_data_detective ─────────────────────────────────────
-- Path: sql/create_introai_week07_data_detective.sql
-- Week 7 Exercise: Be a Data Detective!
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week07_data_detective (
  id                        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name              TEXT NOT NULL,
  student_email             TEXT,
  dataset_chosen            TEXT NOT NULL,
  data_types_identified     TEXT NOT NULL,
  data_types_explanation    TEXT NOT NULL,
  pattern_1_description     TEXT NOT NULL,
  pattern_2_description     TEXT NOT NULL,
  ai_prediction_usecase     TEXT NOT NULL,
  ai_pitfalls_reflections   TEXT NOT NULL,
  chart_visualization_idea  TEXT,
  enjoyment_rating          SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w07_data_detective_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week07_data_detective
  IS 'Week 7 Exercise: Be a Data Detective! Anonymized dataset exploration & pattern discovery.';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week07_data_detective ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w07_data_detective" ON introai_week07_data_detective;
DROP POLICY IF EXISTS "auth_select_w07_data_detective" ON introai_week07_data_detective;
DROP POLICY IF EXISTS "public_select_w07_data_detective" ON introai_week07_data_detective;

-- Anon & Public can INSERT (student page uses anon key to submit)
CREATE POLICY "anon_insert_w07_data_detective"
  ON introai_week07_data_detective
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- STRICT SECURITY: ONLY AUTHENTICATED USERS (TEACHERS) CAN SELECT / VIEW RESPONSES
CREATE POLICY "auth_select_w07_data_detective"
  ON introai_week07_data_detective
  FOR SELECT TO authenticated
  USING (true);
