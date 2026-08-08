-- ── Table: introai_week11_synthetic_media ─────────────────────────────────
-- Week 11 Exercise: Deepfakes & Synthetic Media (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week11_synthetic_media (
  id                             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name                   TEXT NOT NULL,
  student_email                  TEXT NOT NULL,

  -- Case 1: Cat Diving Olympics
  cat_diving_choice              TEXT NOT NULL,
  cat_diving_analysis            TEXT NOT NULL,

  -- Case 2: Nicolas Cage Deepfake
  cage_deepfake_choice           TEXT NOT NULL,
  cage_deepfake_analysis         TEXT NOT NULL,

  -- Case 3: AI Drake Song
  drake_ai_choice                TEXT NOT NULL,
  drake_ai_analysis              TEXT NOT NULL,

  -- Case 4: Tom Cruise Deepfake
  tom_cruise_realism_rating      SMALLINT NOT NULL CHECK (tom_cruise_realism_rating BETWEEN 1 AND 5),
  tom_cruise_analysis            TEXT NOT NULL,

  -- Reflections
  ethical_risk_reflection        TEXT NOT NULL,
  detection_strategy_reflection  TEXT NOT NULL,
  enjoyment_rating               SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at                   TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w11_synthetic_media_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week11_synthetic_media
  IS 'Week 11 Exercise: Deepfakes & Synthetic Media Audit';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week11_synthetic_media ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w11_synthetic_media" ON introai_week11_synthetic_media;
DROP POLICY IF EXISTS "anon_select_w11_synthetic_media" ON introai_week11_synthetic_media;
DROP POLICY IF EXISTS "auth_select_w11_synthetic_media" ON introai_week11_synthetic_media;

-- Anonymous students can INSERT & SELECT (upsert & retrieval)
CREATE POLICY "anon_insert_w11_synthetic_media"
  ON introai_week11_synthetic_media FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w11_synthetic_media"
  ON introai_week11_synthetic_media FOR SELECT TO anon USING (true);

-- Authenticated teachers can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w11_synthetic_media"
  ON introai_week11_synthetic_media FOR SELECT TO authenticated USING (true);
