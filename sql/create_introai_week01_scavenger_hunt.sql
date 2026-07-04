-- =============================================================
-- Migration: Create table for Intro AI Week 01 AI Scavenger Hunt
-- Context:   Students pick a tool they use and identify 3-5 places
--            where they think AI is working behind the scenes.
--            Includes a surprise rating and open-ended reflection.
-- Date:      2026-07-04
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week01_scavenger_hunt (
  id               BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name     TEXT        NOT NULL,
  student_email    TEXT        NOT NULL,

  -- Tool / website selected
  tool_name        TEXT        NOT NULL,
  tool_category    TEXT,   -- 'social_media','streaming','search','navigation','shopping',
                           --   'messaging','gaming','productivity','health_fitness','other'
  tool_description TEXT,   -- Optional: what they use it for

  -- AI instances identified (3 required, up to 5)
  ai_instance_1    TEXT,   -- Required
  ai_instance_2    TEXT,   -- Required
  ai_instance_3    TEXT,   -- Required
  ai_instance_4    TEXT,   -- Optional
  ai_instance_5    TEXT,   -- Optional
  instance_count   SMALLINT NOT NULL DEFAULT 3 CHECK (instance_count BETWEEN 1 AND 5),

  -- Reflection
  surprised        TEXT,   -- 'yes' | 'somewhat' | 'no'
  reflection       TEXT,   -- Open-ended takeaway

  submitted_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_scavenger_hunt
  IS 'Week 1 Exercise 1: Students identify a regularly-used tool and spot where AI works behind the scenes.';

COMMENT ON COLUMN introai_week01_scavenger_hunt.tool_category
  IS 'Category of the tool: social_media, streaming, search, navigation, shopping, messaging, gaming, productivity, health_fitness, other.';

COMMENT ON COLUMN introai_week01_scavenger_hunt.instance_count
  IS 'Number of AI instances the student identified (min 3, max 5).';

COMMENT ON COLUMN introai_week01_scavenger_hunt.surprised
  IS 'Whether the student was surprised by how much AI was in the tool: yes | somewhat | no.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week01_scavenger_hunt ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_scavenger_hunt"
  ON introai_week01_scavenger_hunt
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_scavenger_hunt"
  ON introai_week01_scavenger_hunt
  FOR SELECT TO authenticated
  USING (true);
