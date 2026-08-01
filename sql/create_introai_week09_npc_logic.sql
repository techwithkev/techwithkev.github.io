-- ── Table: introai_week09_npc_logic ─────────────────────────────────
-- Week 9 Exercise 1: NPC Logic: Map Out Guard Logic (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week09_npc_logic (
  id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name          TEXT NOT NULL,
  student_email         TEXT,

  -- Situation 1: Noise response
  noise_action          TEXT NOT NULL,
  noise_yes_branch      TEXT NOT NULL,
  noise_no_branch       TEXT NOT NULL,

  -- Situation 2: Direct sight response
  sight_action          TEXT NOT NULL,
  sight_yes_branch      TEXT NOT NULL,
  sight_no_branch       TEXT NOT NULL,

  -- Situation 3: Lost sight response
  lost_action           TEXT NOT NULL,
  lost_yes_branch       TEXT NOT NULL,
  lost_no_branch        TEXT NOT NULL,
  search_time_limit     TEXT NOT NULL,

  -- Reflections
  debrief_reflection    TEXT NOT NULL,
  real_world_connection TEXT NOT NULL,
  enjoyment_rating      SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w09_npc_logic_email UNIQUE (student_email)
);


COMMENT ON TABLE introai_week09_npc_logic
  IS 'Week 9 Exercise: NPC Logic: Map Out Guard Logic';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week09_npc_logic ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT, SELECT, and UPDATE (student page uses anon key with upserts)
CREATE POLICY "anon_insert_w09_npc_logic"
  ON introai_week09_npc_logic
  FOR INSERT TO anon
  WITH CHECK (true);

CREATE POLICY "anon_select_w09_npc_logic"
  ON introai_week09_npc_logic
  FOR SELECT TO anon
  USING (true);

CREATE POLICY "anon_update_w09_npc_logic"
  ON introai_week09_npc_logic
  FOR UPDATE TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w09_npc_logic"
  ON introai_week09_npc_logic
  FOR SELECT TO authenticated
  USING (true);

