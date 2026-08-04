-- ── Table: introai_week06_analyze_your_feed ──────────────────────────────────
-- Week 6 Activity 2: Analyze Your Feed!
-- Students reflect on their real platform recommendations (YouTube, TikTok,
-- Spotify, Netflix) and explore personalisation, bad recommendations,
-- and the filter bubble concept.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week06_analyze_your_feed (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,

  -- Step 1: Platform and example recommendation
  platforms_used          TEXT NOT NULL,  -- comma-separated: 'YouTube, TikTok, Spotify'
  fav_recommendation      TEXT NOT NULL,  -- specific example recommendation they describe

  -- Step 2: Personalisation
  personalization_rating  TEXT NOT NULL,  -- 'Not at all', 'A little', 'Mostly', 'Exactly'
  how_it_knows            TEXT NOT NULL,  -- student's hypothesis about the data used

  -- Step 3: Weird/wrong recommendations
  got_weird_rec           TEXT NOT NULL,  -- 'Yes — definitely' | 'Not that I remember'
  weird_example           TEXT NOT NULL,  -- description of the weird recommendation

  -- Step 4: Filter bubble
  filter_bubble_status    TEXT NOT NULL,  -- 'Yes — same content', 'Maybe', 'No — lots of variety'
  bubble_reflection       TEXT NOT NULL,  -- is seeing only familiar content good or bad?
  break_bubble_idea       TEXT,           -- optional: how they'd break out of their bubble

  -- Final reflection
  ai_ethics_thought       TEXT NOT NULL,  -- should AI shape what we see and think?

  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w06_feed_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week06_analyze_your_feed
  IS 'Week 6 Activity 2: Students analyse their own platform feeds and reflect on personalisation, bad recommendations, and the filter bubble.';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week06_analyze_your_feed ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w06_feed"
  ON introai_week06_analyze_your_feed
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w06_feed"
  ON introai_week06_analyze_your_feed
  FOR SELECT TO authenticated
  USING (true);
