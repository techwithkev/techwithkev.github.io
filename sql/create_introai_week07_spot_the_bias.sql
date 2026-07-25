-- ── Table: introai_week07_spot_the_bias ─────────────────────────────────
-- Week 7 Exercise: Spot the Bias!
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week07_spot_the_bias (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Scenario A: Music Recommendation AI
  scenario_a_left_out TEXT NOT NULL,
  scenario_a_harm     TEXT NOT NULL,
  scenario_a_fix      TEXT NOT NULL,

  -- Scenario B: Hiring AI
  scenario_b_left_out TEXT NOT NULL,
  scenario_b_harm     TEXT NOT NULL,
  scenario_b_fix      TEXT NOT NULL,

  -- Scenario C: Disease Detection AI
  scenario_c_left_out TEXT NOT NULL,
  scenario_c_harm     TEXT NOT NULL,
  scenario_c_fix      TEXT NOT NULL,

  -- Reflection
  final_reflection    TEXT NOT NULL,
  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w07_spot_the_bias_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week07_spot_the_bias
  IS 'Week 7 Exercise: Spot the Bias!';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week07_spot_the_bias ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w07_spot_the_bias" ON introai_week07_spot_the_bias;
DROP POLICY IF EXISTS "auth_select_w07_spot_the_bias" ON introai_week07_spot_the_bias;
DROP POLICY IF EXISTS "public_select_w07_spot_the_bias" ON introai_week07_spot_the_bias;

-- Anon & Public can INSERT (student page uses anon key to submit)
CREATE POLICY "anon_insert_w07_spot_the_bias"
  ON introai_week07_spot_the_bias
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- STRICT SECURITY: ONLY AUTHENTICATED USERS (TEACHERS) CAN SELECT / VIEW RESPONSES
CREATE POLICY "auth_select_w07_spot_the_bias"
  ON introai_week07_spot_the_bias
  FOR SELECT TO authenticated
  USING (true);
