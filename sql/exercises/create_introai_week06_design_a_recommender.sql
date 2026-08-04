-- ── Table: introai_week06_design_a_recommender ───────────────────────────────
-- Week 6 Activity 3: Design a Simple Recommender!
-- Students design a board game recommender algorithm using an interactive
-- in-page Drawflow flowchart builder. The full flowchart is stored as JSON.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week06_design_a_recommender (
  id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name          TEXT NOT NULL,
  student_email         TEXT,

  -- Step 1: Inputs
  input_questions       TEXT NOT NULL,    -- student's list of input questions
  num_decision_steps    TEXT NOT NULL,    -- '1' | '2' | '3' | '4+'

  -- Step 2: Flowchart (Drawflow serialised)
  flowchart_json        TEXT NOT NULL,    -- full Drawflow JSON export
  flowchart_summary     TEXT,            -- human-readable node list (auto-generated)

  -- Step 3: Outputs
  output_games          TEXT NOT NULL,    -- list of board game suggestions and which path leads there

  -- Step 4: Reflections
  hardest_part          TEXT NOT NULL,    -- what was hardest about designing the recommender?
  rule_limitations      TEXT NOT NULL,    -- what could the recommender get wrong / what data is missing?
  real_vs_simple        TEXT,            -- optional: how is this different from Netflix/Spotify?

  enjoyment_rating      SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w06_rec_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week06_design_a_recommender
  IS 'Week 6 Activity 3: Students design a board game recommender using an interactive flowchart (Drawflow). Flowchart JSON stored for teacher review.';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week06_design_a_recommender ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w06_rec"
  ON introai_week06_design_a_recommender
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w06_rec"
  ON introai_week06_design_a_recommender
  FOR SELECT TO authenticated
  USING (true);
