-- ── Table: introai_week07_data_audit ─────────────────────────────────────
-- Week 7 Exercise 2: Your Personal Data Audit
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week07_data_audit (
  id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name                TEXT NOT NULL,
  student_email               TEXT,

  -- App Audit 1
  app_1_name                  TEXT NOT NULL,
  app_1_data_collected        TEXT NOT NULL,
  app_1_how_used              TEXT NOT NULL,
  app_1_worth_tradeoff        TEXT NOT NULL,

  -- App Audit 2
  app_2_name                  TEXT NOT NULL,
  app_2_data_collected        TEXT NOT NULL,
  app_2_how_used              TEXT NOT NULL,
  app_2_worth_tradeoff        TEXT NOT NULL,

  -- App Audit 3
  app_3_name                  TEXT NOT NULL,
  app_3_data_collected        TEXT NOT NULL,
  app_3_how_used              TEXT NOT NULL,
  app_3_worth_tradeoff        TEXT NOT NULL,

  -- App Audit 4
  app_4_name                  TEXT NOT NULL,
  app_4_data_collected        TEXT NOT NULL,
  app_4_how_used              TEXT NOT NULL,
  app_4_worth_tradeoff        TEXT NOT NULL,

  -- Reflections
  surprising_app_reflection   TEXT NOT NULL,
  opinion_changed_reflection  TEXT NOT NULL,
  behavior_change_reflection  TEXT NOT NULL,
  privacy_challenge           TEXT NOT NULL,
  enjoyment_rating            SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w07_data_audit_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week07_data_audit
  IS 'Week 7 Exercise 2: Your Personal Data Audit';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week07_data_audit ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w07_data_audit" ON introai_week07_data_audit;
DROP POLICY IF EXISTS "auth_select_w07_data_audit" ON introai_week07_data_audit;
DROP POLICY IF EXISTS "public_select_w07_data_audit" ON introai_week07_data_audit;

-- Anon & Public can INSERT (student page uses anon key to submit)
CREATE POLICY "anon_insert_w07_data_audit"
  ON introai_week07_data_audit
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- STRICT SECURITY: ONLY AUTHENTICATED USERS (TEACHERS) CAN SELECT / VIEW RESPONSES
CREATE POLICY "auth_select_w07_data_audit"
  ON introai_week07_data_audit
  FOR SELECT TO authenticated
  USING (true);
