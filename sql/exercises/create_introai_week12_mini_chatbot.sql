-- ── Table: introai_week12_mini_chatbot ────────────────────────────────
-- Week 12 Exercise: Build Your Own Mini-Chatbot (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week12_mini_chatbot (
  id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name             TEXT NOT NULL,
  student_email            TEXT NOT NULL,

  -- Chatbot Python Code & Config
  python_code              TEXT NOT NULL,
  bot_name                 TEXT NOT NULL,
  used_variables           BOOLEAN NOT NULL DEFAULT true,
  used_conditionals        BOOLEAN NOT NULL DEFAULT true,
  used_loops               BOOLEAN NOT NULL DEFAULT true,

  -- Reflections
  reflection_difference    TEXT NOT NULL,
  reflection_challenges    TEXT NOT NULL,
  enjoyment_rating         SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w12_mini_chatbot_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week12_mini_chatbot
  IS 'Week 12 Exercise: Build Your Own Mini-Chatbot';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week12_mini_chatbot ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w12_mini_chatbot" ON introai_week12_mini_chatbot;
DROP POLICY IF EXISTS "anon_select_w12_mini_chatbot" ON introai_week12_mini_chatbot;
DROP POLICY IF EXISTS "auth_select_w12_mini_chatbot" ON introai_week12_mini_chatbot;

-- Anonymous students can INSERT & SELECT (upsert & retrieval)
CREATE POLICY "anon_insert_w12_mini_chatbot"
  ON introai_week12_mini_chatbot FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w12_mini_chatbot"
  ON introai_week12_mini_chatbot FOR SELECT TO anon USING (true);

-- Authenticated teachers can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w12_mini_chatbot"
  ON introai_week12_mini_chatbot FOR SELECT TO authenticated USING (true);
