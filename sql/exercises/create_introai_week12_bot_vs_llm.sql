-- ── Table: introai_week12_bot_vs_llm ─────────────────────────────────────────
-- Week 12 Discussion Exercise: Rule-Based Bot vs. LLM Chatbot
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week12_bot_vs_llm (
  id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name             TEXT NOT NULL,
  student_email            TEXT NOT NULL,

  -- Scenario 1: Vending Machine
  scenario_1_choice        TEXT NOT NULL,
  scenario_1_analysis      TEXT NOT NULL,

  -- Scenario 2: Customer Support Bot
  scenario_2_choice        TEXT NOT NULL,
  scenario_2_analysis      TEXT NOT NULL,

  -- Scenario 3: Hybrid Systems
  scenario_3_choice        TEXT NOT NULL,
  scenario_3_analysis      TEXT NOT NULL,

  -- System Architect Reflection
  architect_reflection     TEXT NOT NULL,
  enjoyment_rating         SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w12_bot_vs_llm_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week12_bot_vs_llm
  IS 'Week 12 Discussion: Rule-Based Bot vs. LLM Chatbot';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week12_bot_vs_llm ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w12_bot_vs_llm" ON introai_week12_bot_vs_llm;
DROP POLICY IF EXISTS "anon_select_w12_bot_vs_llm" ON introai_week12_bot_vs_llm;
DROP POLICY IF EXISTS "auth_select_w12_bot_vs_llm" ON introai_week12_bot_vs_llm;

-- Anonymous students can INSERT & SELECT (upsert & retrieval)
CREATE POLICY "anon_insert_w12_bot_vs_llm"
  ON introai_week12_bot_vs_llm FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w12_bot_vs_llm"
  ON introai_week12_bot_vs_llm FOR SELECT TO anon USING (true);

-- Authenticated teachers can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w12_bot_vs_llm"
  ON introai_week12_bot_vs_llm FOR SELECT TO authenticated USING (true);
