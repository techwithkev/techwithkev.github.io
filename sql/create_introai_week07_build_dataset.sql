-- ── Table: introai_week07_build_dataset ─────────────────────────────────
-- Week 7 Exercise 3: Build Your Own Dataset
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week07_build_dataset (
  id                        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name              TEXT NOT NULL,
  student_email             TEXT,
  group_members             TEXT,

  -- Step 1: AI Goal
  ai_goal_option            TEXT NOT NULL,
  custom_ai_goal            TEXT,

  -- Step 2: Feature & Label Names
  feature_1_name            TEXT NOT NULL,
  feature_2_name            TEXT NOT NULL,
  feature_3_name            TEXT NOT NULL,
  feature_4_name            TEXT NOT NULL,
  target_label_name         TEXT NOT NULL,

  -- Step 3: Dataset Row 1
  row_1_f1                  TEXT NOT NULL,
  row_1_f2                  TEXT NOT NULL,
  row_1_f3                  TEXT NOT NULL,
  row_1_f4                  TEXT NOT NULL,
  row_1_label               TEXT NOT NULL,

  -- Dataset Row 2
  row_2_f1                  TEXT NOT NULL,
  row_2_f2                  TEXT NOT NULL,
  row_2_f3                  TEXT NOT NULL,
  row_2_f4                  TEXT NOT NULL,
  row_2_label               TEXT NOT NULL,

  -- Dataset Row 3
  row_3_f1                  TEXT NOT NULL,
  row_3_f2                  TEXT NOT NULL,
  row_3_f3                  TEXT NOT NULL,
  row_3_f4                  TEXT NOT NULL,
  row_3_label               TEXT NOT NULL,

  -- Dataset Row 4
  row_4_f1                  TEXT NOT NULL,
  row_4_f2                  TEXT NOT NULL,
  row_4_f3                  TEXT NOT NULL,
  row_4_f4                  TEXT NOT NULL,
  row_4_label               TEXT NOT NULL,

  -- Dataset Row 5
  row_5_f1                  TEXT NOT NULL,
  row_5_f2                  TEXT NOT NULL,
  row_5_f3                  TEXT NOT NULL,
  row_5_f4                  TEXT NOT NULL,
  row_5_label               TEXT NOT NULL,

  -- Step 4: Bias Reflections
  dataset_bias_reflection   TEXT NOT NULL,
  fairness_fix_reflection   TEXT NOT NULL,

  enjoyment_rating          SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w07_build_dataset_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week07_build_dataset
  IS 'Week 7 Exercise 3: Build Your Own Dataset';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week07_build_dataset ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w07_build_dataset"
  ON introai_week07_build_dataset
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w07_build_dataset"
  ON introai_week07_build_dataset
  FOR SELECT TO authenticated
  USING (true);
