-- ── Table: introai_week09_ai_feature_pitch ─────────────────────────────
-- Week 9 Exercise 2: AI Feature: The Prompt (Generative AI game feature pitch)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week09_ai_feature_pitch (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Feature Pitch Details
  game_title          TEXT NOT NULL,
  ai_tech_type        TEXT NOT NULL,
  sentence_1          TEXT NOT NULL,
  sentence_2          TEXT NOT NULL,
  sentence_3          TEXT NOT NULL,
  full_pitch          TEXT NOT NULL,

  -- Analysis & Trade-offs
  gameplay_pillar     TEXT NOT NULL,
  technical_hurdle    TEXT NOT NULL,
  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w09_ai_feature_pitch_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week09_ai_feature_pitch
  IS 'Week 9 Exercise 2: AI Feature: The Prompt';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week09_ai_feature_pitch ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT, SELECT, and UPDATE (student page uses anon key with upserts)
CREATE POLICY "anon_insert_w09_ai_feature_pitch"
  ON introai_week09_ai_feature_pitch
  FOR INSERT TO anon
  WITH CHECK (true);

CREATE POLICY "anon_select_w09_ai_feature_pitch"
  ON introai_week09_ai_feature_pitch
  FOR SELECT TO anon
  USING (true);

CREATE POLICY "anon_update_w09_ai_feature_pitch"
  ON introai_week09_ai_feature_pitch
  FOR UPDATE TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w09_ai_feature_pitch"
  ON introai_week09_ai_feature_pitch
  FOR SELECT TO authenticated
  USING (true);

