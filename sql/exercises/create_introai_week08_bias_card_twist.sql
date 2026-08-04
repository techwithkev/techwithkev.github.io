-- ── Table: introai_week08_bias_card_twist ─────────────────────────────────
-- Path: sql/create_introai_week08_bias_card_twist.sql
-- Week 8 Exercise 1: The Bias Card Twist
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_bias_card_twist (
  id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name          TEXT NOT NULL,
  student_email         TEXT,
  group_members         TEXT,

  -- Step 1: Local Problem & Initial Solution
  local_problem         TEXT NOT NULL,
  initial_ai_solution   TEXT NOT NULL,

  -- Step 2: Twist Card
  twist_card            TEXT NOT NULL,

  -- Step 3: Impact Analysis
  what_breaks           TEXT NOT NULL,
  who_left_out          TEXT NOT NULL,

  -- Step 4: Debrief
  debrief_reflection    TEXT NOT NULL,
  enjoyment_rating      SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_bias_card_twist_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_bias_card_twist
  IS 'Week 8 Exercise 1: The Bias Card Twist';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_bias_card_twist ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_bias_card_twist" ON introai_week08_bias_card_twist;
DROP POLICY IF EXISTS "auth_select_w08_bias_card_twist" ON introai_week08_bias_card_twist;

-- Allow students to submit
CREATE POLICY "anon_insert_w08_bias_card_twist"
  ON introai_week08_bias_card_twist
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_bias_card_twist"
  ON introai_week08_bias_card_twist
  FOR SELECT TO authenticated
  USING (true);
