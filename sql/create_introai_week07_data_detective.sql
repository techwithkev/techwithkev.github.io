-- Create table for Week 7 Activity: Data Detective
-- Path: sql/create_introai_week07_data_detective.sql

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

-- Enable Row Level Security (RLS)
ALTER TABLE introai_week07_data_detective ENABLE ROW LEVEL SECURITY;

-- Allow anonymous users to submit exercise responses
CREATE POLICY "anon_insert_w07_data_detective"
  ON introai_week07_data_detective FOR INSERT TO anon WITH CHECK (true);

-- Allow authenticated users (teachers) to view responses
CREATE POLICY "auth_select_w07_data_detective"
  ON introai_week07_data_detective FOR SELECT TO authenticated USING (true);
