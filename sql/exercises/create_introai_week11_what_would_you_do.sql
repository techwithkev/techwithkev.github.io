-- ── Table: introai_week11_what_would_you_do ────────────────────────────────
-- Week 11 Exercise 2: What Would You Do? (Ethics Discussion)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week11_what_would_you_do (
  id                        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name              TEXT NOT NULL,
  student_email             TEXT NOT NULL,

  -- Scenario 1: Classmate Prank
  scenario_1_choice         TEXT NOT NULL,
  scenario_1_analysis       TEXT NOT NULL,

  -- Scenario 2: Politician vs Neighbor
  scenario_2_choice         TEXT NOT NULL,
  scenario_2_analysis       TEXT NOT NULL,

  -- Scenario 3: Intent vs Impact
  scenario_3_choice         TEXT NOT NULL,
  scenario_3_analysis       TEXT NOT NULL,

  -- Personal Rule & Reflection
  personal_rule_reflection  TEXT NOT NULL,
  enjoyment_rating          SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w11_wwyd_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week11_what_would_you_do
  IS 'Week 11 Exercise 2: What Would You Do? Ethics Discussion';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week11_what_would_you_do ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w11_wwyd" ON introai_week11_what_would_you_do;
DROP POLICY IF EXISTS "anon_select_w11_wwyd" ON introai_week11_what_would_you_do;
DROP POLICY IF EXISTS "auth_select_w11_wwyd" ON introai_week11_what_would_you_do;

-- Anonymous students can INSERT & SELECT (upsert & retrieval)
CREATE POLICY "anon_insert_w11_wwyd"
  ON introai_week11_what_would_you_do FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w11_wwyd"
  ON introai_week11_what_would_you_do FOR SELECT TO anon USING (true);

-- Authenticated teachers can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w11_wwyd"
  ON introai_week11_what_would_you_do FOR SELECT TO authenticated USING (true);
