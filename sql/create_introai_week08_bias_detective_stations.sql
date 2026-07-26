-- ── Table: introai_week08_bias_detective_stations ───────────────────────
-- Path: sql/create_introai_week08_bias_detective_stations.sql
-- Week 8 Exercise 2: Bias Detective Stations
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_bias_detective_stations (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  group_members           TEXT,

  -- Station 1: Resume Screening Tool
  st1_bias_source         TEXT NOT NULL,
  st1_who_gets_hurt       TEXT NOT NULL,

  -- Station 2: Voice Assistant Accents
  st2_bias_source         TEXT NOT NULL,
  st2_who_gets_hurt       TEXT NOT NULL,

  -- Station 3: Heart Disease Predictor
  st3_bias_source         TEXT NOT NULL,
  st3_who_gets_hurt       TEXT NOT NULL,

  -- Station 4: Photo-Tagging Skin Tones
  st4_bias_source         TEXT NOT NULL,
  st4_who_gets_hurt       TEXT NOT NULL,

  -- Wrap-Up Share
  favorite_station_share  TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_bias_detective_stations_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_bias_detective_stations
  IS 'Week 8 Exercise 2: Bias Detective Stations';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_bias_detective_stations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_bias_detective_stations" ON introai_week08_bias_detective_stations;
DROP POLICY IF EXISTS "auth_select_w08_bias_detective_stations" ON introai_week08_bias_detective_stations;

-- Allow anonymous students to submit
CREATE POLICY "anon_insert_w08_bias_detective_stations"
  ON introai_week08_bias_detective_stations
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_bias_detective_stations"
  ON introai_week08_bias_detective_stations
  FOR SELECT TO authenticated
  USING (true);
