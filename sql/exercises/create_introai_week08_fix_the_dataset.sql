-- ── Table: introai_week08_fix_the_dataset ─────────────────────────────────
-- Path: sql/create_introai_week08_fix_the_dataset.sql
-- Week 8 Exercise 3: Fix the Dataset
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_fix_the_dataset (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  partner_name            TEXT,

  -- Dataset modification tracking
  initial_dataset_summary TEXT NOT NULL,
  final_dataset_summary   TEXT NOT NULL,
  modified_dataset_json   TEXT,

  -- Reflections
  changes_explanation     TEXT NOT NULL,
  debrief_reflection      TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_fix_the_dataset_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_fix_the_dataset
  IS 'Week 8 Exercise 3: Fix the Dataset';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_fix_the_dataset ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_fix_the_dataset" ON introai_week08_fix_the_dataset;
DROP POLICY IF EXISTS "auth_select_w08_fix_the_dataset" ON introai_week08_fix_the_dataset;

-- Allow anonymous students to submit
CREATE POLICY "anon_insert_w08_fix_the_dataset"
  ON introai_week08_fix_the_dataset
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_fix_the_dataset"
  ON introai_week08_fix_the_dataset
  FOR SELECT TO authenticated
  USING (true);
