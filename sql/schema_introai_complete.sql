-- ============================================================================
-- Intro to AI — Complete Unified Supabase Database Schema
-- ============================================================================
-- Overview: Creates all student activity tables, indexes, constraints,
--           and Row-Level Security (RLS) policies for Intro to AI.
-- Usage:    Paste and run in Supabase Dashboard → SQL Editor.
-- Generated: 2026-08-04
-- ============================================================================

-- ── create_introai_week01_chatbots.sql ───────────────────────────────────────────
-- =============================================================
-- Migration: Create table for Intro AI Week 01 Intro to Chatbots exercise
-- Context:   Students use an AI chatbot for 4 tasks and record results.
--            Tasks: define AI/ML, factual Q, summarise text, creative task.
-- Date:      2026-07-04
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week01_chatbots (
  id               BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name     TEXT NOT NULL,
  student_email    TEXT NOT NULL,

  -- Which chatbot was used
  chatbot_used     TEXT NOT NULL,
  -- 'ChatGPT' | 'Gemini' | 'Claude' | 'Copilot' | 'Perplexity' | 'Other'

  -- Task 1: Define AI or ML
  t1_chatbot_definition TEXT,   -- What the chatbot said
  t1_comparison         TEXT,   -- 'very_similar' | 'mostly_similar' | 'quite_different' | 'very_different'
  t1_notes              TEXT,   -- Optional observations

  -- Task 2: Factual Question
  t2_question           TEXT,   -- The question asked
  t2_chatbot_answer     TEXT,   -- The chatbot's answer
  t2_accuracy           TEXT,   -- 'accurate' | 'partially_accurate' | 'inaccurate'

  -- Task 3: Summarise Text
  t3_original_text      TEXT,   -- The paragraph provided
  t3_chatbot_summary    TEXT,   -- The chatbot's summary
  t3_summary_quality    TEXT,   -- 'excellent' | 'good' | 'okay' | 'poor'

  -- Task 4: Creative Task
  t4_creative_prompt    TEXT,   -- What they asked the chatbot to create
  t4_creative_response  TEXT,   -- The chatbot's creative output

  -- Overall reflection
  overall_impression    SMALLINT CHECK (overall_impression BETWEEN 1 AND 5),
  reflection            TEXT,   -- Open-ended "what surprised you"

  submitted_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_chatbots
  IS 'Week 1 Exercise 2: Students explore an AI chatbot across 4 structured tasks and record their findings.';

COMMENT ON COLUMN introai_week01_chatbots.chatbot_used
  IS 'The chatbot platform used: ChatGPT, Gemini, Claude, Copilot, Perplexity, or Other.';

COMMENT ON COLUMN introai_week01_chatbots.t1_comparison
  IS 'How the chatbot definition compared to the class definition: very_similar, mostly_similar, quite_different, very_different.';

COMMENT ON COLUMN introai_week01_chatbots.t2_accuracy
  IS 'Whether the chatbot answered the factual question accurately: accurate, partially_accurate, inaccurate.';

COMMENT ON COLUMN introai_week01_chatbots.t3_summary_quality
  IS 'Quality rating for the chatbot summary: excellent, good, okay, poor.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week01_chatbots ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_chatbots"
  ON introai_week01_chatbots
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_chatbots"
  ON introai_week01_chatbots
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week01_scavenger_hunt.sql ───────────────────────────────────────────
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


-- ── create_introai_week01_self_assessment.sql ───────────────────────────────────────────
-- =============================================================
-- Migration: Create table for Intro AI Week 01 Self-Assessment survey
-- Context:   Students rate their confidence (1–5) across 5 topic areas
--            at the start of the Intro to AI course (Week 1).
-- Date:      2026-07-04
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week01_self_assessment (
  id               BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name     TEXT        NOT NULL,
  student_email    TEXT        NOT NULL,

  -- Section A: What is AI?
  q1_explain_ai       SMALLINT NOT NULL CHECK (q1_explain_ai BETWEEN 1 AND 5),
  q2_rule_vs_ai       SMALLINT NOT NULL CHECK (q2_rule_vs_ai BETWEEN 1 AND 5),
  q3_real_world_apps  SMALLINT NOT NULL CHECK (q3_real_world_apps BETWEEN 1 AND 5),

  -- Section B: Machine Learning & Data
  q4_ml_understanding SMALLINT NOT NULL CHECK (q4_ml_understanding BETWEEN 1 AND 5),
  q5_training_data    SMALLINT NOT NULL CHECK (q5_training_data BETWEEN 1 AND 5),
  q6_ai_bias          SMALLINT NOT NULL CHECK (q6_ai_bias BETWEEN 1 AND 5),

  -- Section C: Responsible & Ethical AI Use
  q7_ethical_concerns SMALLINT NOT NULL CHECK (q7_ethical_concerns BETWEEN 1 AND 5),
  q8_responsible_use  SMALLINT NOT NULL CHECK (q8_responsible_use BETWEEN 1 AND 5),
  q9_fact_check_ai    SMALLINT NOT NULL CHECK (q9_fact_check_ai BETWEEN 1 AND 5),

  -- Section D: Working with AI Tools
  q10_chatbot_comfort   SMALLINT NOT NULL CHECK (q10_chatbot_comfort BETWEEN 1 AND 5),
  q11_prompt_writing    SMALLINT NOT NULL CHECK (q11_prompt_writing BETWEEN 1 AND 5),
  q12_ai_creation_tools SMALLINT NOT NULL CHECK (q12_ai_creation_tools BETWEEN 1 AND 5),

  -- Section E: AI & Society
  q13_industry_impact SMALLINT NOT NULL CHECK (q13_industry_impact BETWEEN 1 AND 5),
  q14_ai_opinion      SMALLINT NOT NULL CHECK (q14_ai_opinion BETWEEN 1 AND 5),
  q15_excitement      SMALLINT NOT NULL CHECK (q15_excitement BETWEEN 1 AND 5),

  -- Computed averages (stored for fast teacher dashboard queries)
  avg_section_a   NUMERIC(3,2),  -- What is AI?
  avg_section_b   NUMERIC(3,2),  -- ML & Data
  avg_section_c   NUMERIC(3,2),  -- Responsible AI
  avg_section_d   NUMERIC(3,2),  -- Working with Tools
  avg_section_e   NUMERIC(3,2),  -- AI & Society
  overall_avg     NUMERIC(3,2),  -- Mean of all 15 questions

  submitted_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_self_assessment
  IS 'Week 1 student confidence self-assessment for the Introduction to AI course. Students rate themselves 1–5 across 5 topic areas.';

COMMENT ON COLUMN introai_week01_self_assessment.overall_avg
  IS 'Mean of all 15 question ratings. Computed by the client and stored for quick sorting in the teacher dashboard.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week01_self_assessment ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT only (student page uses anon key)
CREATE POLICY "anon_insert_self_assessment"
  ON introai_week01_self_assessment
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_self_assessment"
  ON introai_week01_self_assessment
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week01_tables.sql ───────────────────────────────────────────
-- =============================================================
-- Migration: Create tables for Intro AI Week 01 "Is it AI?" activity
-- Context:   Students must register (name + email) before the activity,
--            and their final score is recorded on completion.
-- Date:      2026-07-04
-- =============================================================

-- ── Table 1: registrations ────────────────────────────────────
-- Records every student who starts the Week 01 activity.
CREATE TABLE IF NOT EXISTS introai_week01_registrations (
  id             BIGSERIAL PRIMARY KEY,
  student_name   TEXT        NOT NULL,
  student_email  TEXT        NOT NULL,
  registered_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_registrations
  IS 'Tracks students who registered for the Week 01 Is-it-AI sorting activity.';

COMMENT ON COLUMN introai_week01_registrations.student_name
  IS 'Full name entered by the student on the registration gate.';

COMMENT ON COLUMN introai_week01_registrations.student_email
  IS 'Email address entered by the student on the registration gate.';

-- ── Table 2: scores ──────────────────────────────────────────
-- Records the final score once a student completes all 10 cards.
CREATE TABLE IF NOT EXISTS introai_week01_scores (
  id             BIGSERIAL PRIMARY KEY,
  student_name   TEXT        NOT NULL,
  student_email  TEXT        NOT NULL,
  score          INT         NOT NULL CHECK (score >= 0),
  total          INT         NOT NULL CHECK (total > 0),
  rank           TEXT,                          -- 'AI Master', 'AI Specialist', etc.
  completed_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week01_scores
  IS 'Final scores for the Week 01 Is-it-AI sorting activity.';

COMMENT ON COLUMN introai_week01_scores.score
  IS 'Number of cards classified correctly (0–10).';

COMMENT ON COLUMN introai_week01_scores.total
  IS 'Total number of cards in the activity (currently 10).';

COMMENT ON COLUMN introai_week01_scores.rank
  IS 'Rank label derived from score: AI Master / Specialist / Apprentice / Novice.';

-- ── Row-Level Security ────────────────────────────────────────
-- Allow anonymous inserts (the page uses the anon key).
-- Reads are intentionally blocked for students; use the service role for teacher views.

ALTER TABLE introai_week01_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE introai_week01_scores        ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT only
CREATE POLICY "anon_insert_registrations"
  ON introai_week01_registrations
  FOR INSERT TO anon
  WITH CHECK (true);

CREATE POLICY "anon_insert_scores"
  ON introai_week01_scores
  FOR INSERT TO anon
  WITH CHECK (true);


-- ── create_introai_week02_co_writer_story.sql ───────────────────────────────────────────
-- =============================================================
-- Migration: Create table for Intro AI Week 02 Co-Writer Story
-- Context:   Students build a collaborative story by class number,
--            adding paragraphs co-written with AI.
-- Date:      2026-07-05
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week02_co_writer_story (
  id                  BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Class / cohort association
  class_number        TEXT NOT NULL,

  -- Story content
  prompt_used         TEXT,
  story_text          TEXT NOT NULL,

  -- Ordering sequence (1-indexed sequence of blocks)
  sequence_order      INTEGER NOT NULL,
  
  -- Flag to allow soft-deleting/filtering by teacher
  is_visible          BOOLEAN NOT NULL DEFAULT true,

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week02_co_writer_story
  IS 'Week 2 Activity 2: Collaborative class storytelling where students contribute blocks co-written with AI.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week02_co_writer_story ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT and SELECT
CREATE POLICY "anon_select_co_writer_story"
  ON introai_week02_co_writer_story
  FOR SELECT TO anon
  USING (is_visible = true);

CREATE POLICY "anon_insert_co_writer_story"
  ON introai_week02_co_writer_story
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated (teachers) can do anything (SELECT, INSERT, UPDATE, DELETE)
CREATE POLICY "auth_all_co_writer_story"
  ON introai_week02_co_writer_story
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);


-- ── create_introai_week02_creative_prompting.sql ───────────────────────────────────────────
-- =============================================================
-- Migration: Create table for Intro AI Week 02 Creative Prompting exercise
-- Context:   Students learn prompting by writing a prompt for a creative scenario
--            with specific constraints (Task, Tone, Persona, Format).
-- Date:      2026-07-05
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week02_creative_prompting (
  id                  BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Platform used
  chatbot_used        TEXT NOT NULL, -- 'ChatGPT', 'Gemini', 'Claude', etc.

  -- The prompt and chatbot response
  initial_prompt      TEXT NOT NULL,
  initial_response    TEXT NOT NULL,

  -- Constraint checklist evaluation
  followed_task       BOOLEAN NOT NULL, -- Wrote a poem?
  followed_tone       BOOLEAN NOT NULL, -- Funny tone?
  followed_persona    BOOLEAN NOT NULL, -- Frustrated robot persona?
  followed_format     BOOLEAN NOT NULL, -- 4-6 lines?
  actual_line_count   SMALLINT,         -- How many lines did the chatbot actually write?

  -- Refinement (optional second iteration)
  refined_prompt      TEXT,
  refined_response    TEXT,

  -- Overall takeaway / Reflection
  learning_takeaway   TEXT,

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week02_creative_prompting
  IS 'Week 2 Creative Prompting: Students prompt a chatbot to write a robot toast poem and evaluate its adherence to constraints.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week02_creative_prompting ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_creative_prompting"
  ON introai_week02_creative_prompting
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_creative_prompting"
  ON introai_week02_creative_prompting
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week02_persona_detective.sql ───────────────────────────────────────────
-- =============================================================
-- Migration: Create table for Intro AI Week 02 Persona Detective exercise
-- Context:   Students secretly draw a persona, write a prompt to adopt
--            the character, and have peers guess the persona from the response.
-- Date:      2026-07-05
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week02_persona_detective (
  id                  BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Assigned secret persona
  secret_persona      TEXT NOT NULL,

  -- Game question & prompt details
  teacher_question    TEXT NOT NULL,
  prompt_used         TEXT NOT NULL,
  chatbot_used        TEXT NOT NULL, -- 'ChatGPT', 'Gemini', 'Claude', etc.
  ai_response         TEXT NOT NULL,

  -- Game outcomes
  was_guessed         BOOLEAN NOT NULL,
  guess_time_seconds  SMALLINT, -- How fast it was guessed

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week02_persona_detective
  IS 'Week 2 Exercise 2: AI Persona Detective game results, testing adopting and maintaining chatbot personas.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week02_persona_detective ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_persona_detective"
  ON introai_week02_persona_detective
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_persona_detective"
  ON introai_week02_persona_detective
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week05_train_your_model.sql ───────────────────────────────────────────
-- =============================================================
-- Migration: Create table for Intro AI Week 05 Train Your Model exercise
-- Context:   Students train an Image, Audio, or Pose classifier using
--            Google Teachable Machine, export their link, test it live,
--            and reflect on the results.
-- Date:      2026-07-18
-- =============================================================

CREATE TABLE IF NOT EXISTS introai_week05_train_your_model (
  id                      BIGSERIAL PRIMARY KEY,

  -- Student identity
  student_name            TEXT NOT NULL,
  student_email           TEXT,

  -- Project details
  project_type            TEXT NOT NULL, -- 'Image', 'Audio', 'Pose'
  project_title           TEXT NOT NULL,
  classes_trained         TEXT NOT NULL,
  examples_per_class      TEXT NOT NULL,

  -- Teachable Machine details
  model_url               TEXT NOT NULL,

  -- Reflections & enjoyments
  accuracy_rating         TEXT NOT NULL,
  challenges_reflections  TEXT NOT NULL,
  improvement_ideas       TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL,

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE introai_week05_train_your_model
  IS 'Week 5 Exercise: Google Teachable Machine student trained models, metadata, and reflections.';

-- ── Row-Level Security ────────────────────────────────────────
ALTER TABLE introai_week05_train_your_model ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_train_your_model"
  ON introai_week05_train_your_model
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_train_your_model"
  ON introai_week05_train_your_model
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week06_analyze_your_feed.sql ───────────────────────────────────────────
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


-- ── create_introai_week06_be_the_algorithm.sql ───────────────────────────────────────────
-- ── Table: introai_week06_be_the_algorithm ─────────────────────────────────
-- Week 6 Exercise: Be the Algorithm! — Recommendation Systems
-- Students review student profiles with multiple parameters and decide
-- which movie to recommend, then reflect on their reasoning process.
-- ───────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week06_be_the_algorithm (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,

  -- Which profiles they were assigned
  profiles_used           TEXT NOT NULL,  -- e.g. 'A, B, C'

  -- Recommendations per profile (movie title chosen)
  profile_a_recommendation  TEXT,
  profile_b_recommendation  TEXT,
  profile_c_recommendation  TEXT,
  profile_d_recommendation  TEXT,
  profile_e_recommendation  TEXT,

  -- Key parameter(s) student focused on for each profile
  profile_a_key_param     TEXT,
  profile_b_key_param     TEXT,
  profile_c_key_param     TEXT,
  profile_d_key_param     TEXT,
  profile_e_key_param     TEXT,

  -- Reflections
  hardest_profile         TEXT NOT NULL,   -- Which profile was hardest to recommend for
  algorithm_strategy      TEXT NOT NULL,   -- What "rule" or strategy they used
  class_consensus         TEXT NOT NULL,   -- Did the class agree or disagree?
  real_world_connection   TEXT NOT NULL,   -- How does this connect to real recommendation systems?
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w06_algo_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week06_be_the_algorithm
  IS 'Week 6 Exercise: Be the Algorithm! — Students act as recommendation engines for fictional student profiles.';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week06_be_the_algorithm ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w06_algo"
  ON introai_week06_be_the_algorithm
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w06_algo"
  ON introai_week06_be_the_algorithm
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week06_design_a_recommender.sql ───────────────────────────────────────────
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


-- ── create_introai_week06_knowledge_check.sql ───────────────────────────────────────────
-- ── Table: introai_week06_knowledge_check ─────────────────────────────────
-- Week 6 Exercise: Week 6 Quiz — Recommendation Systems
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week06_knowledge_check (
  id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name                TEXT NOT NULL,
  student_email               TEXT,

  -- Multiple Choice Questions
  q1_content_filtering        TEXT NOT NULL,
  q2_collaborative_filtering  TEXT NOT NULL,
  q3_cold_start               TEXT NOT NULL,
  q4_filter_bubble            TEXT NOT NULL,
  q5_user_parameters          TEXT NOT NULL,
  q6_flowchart_shapes         TEXT NOT NULL,

  -- Quiz Score Results
  score                       SMALLINT NOT NULL,
  pct                         SMALLINT NOT NULL,

  -- Reflections
  reflection_surprising       TEXT NOT NULL,
  enjoyment_rating            SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w06_knowledge_check_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week06_knowledge_check
  IS 'Week 6 Quiz: Recommendation Systems Knowledge Check';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week06_knowledge_check ENABLE ROW LEVEL SECURITY;

-- Anon can INSERT (student page uses anon key)
CREATE POLICY "anon_insert_w06_knowledge_check"
  ON introai_week06_knowledge_check
  FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT
CREATE POLICY "auth_select_w06_knowledge_check"
  ON introai_week06_knowledge_check
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week07_build_dataset.sql ───────────────────────────────────────────
-- ── Table: introai_week07_build_dataset ─────────────────────────────────
-- Week 7 Exercise 3: Build Your Own Dataset
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week07_build_dataset (
  id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name                TEXT NOT NULL,
  student_email               TEXT,
  group_members               TEXT,

  -- Step 1: AI Goal
  ai_goal_option              TEXT NOT NULL,
  custom_ai_goal              TEXT,

  -- Step 2: Feature Names
  feature_1_name              TEXT NOT NULL,
  feature_2_name              TEXT NOT NULL,
  feature_3_name              TEXT NOT NULL,
  feature_4_name              TEXT NOT NULL,
  target_label_name           TEXT NOT NULL,

  -- Step 3: 5 Data Rows
  row_1_f1                    TEXT NOT NULL,
  row_1_f2                    TEXT NOT NULL,
  row_1_f3                    TEXT NOT NULL,
  row_1_f4                    TEXT NOT NULL,
  row_1_label                 TEXT NOT NULL,

  row_2_f1                    TEXT NOT NULL,
  row_2_f2                    TEXT NOT NULL,
  row_2_f3                    TEXT NOT NULL,
  row_2_f4                    TEXT NOT NULL,
  row_2_label                 TEXT NOT NULL,

  row_3_f1                    TEXT NOT NULL,
  row_3_f2                    TEXT NOT NULL,
  row_3_f3                    TEXT NOT NULL,
  row_3_f4                    TEXT NOT NULL,
  row_3_label                 TEXT NOT NULL,

  row_4_f1                    TEXT NOT NULL,
  row_4_f2                    TEXT NOT NULL,
  row_4_f3                    TEXT NOT NULL,
  row_4_f4                    TEXT NOT NULL,
  row_4_label                 TEXT NOT NULL,

  row_5_f1                    TEXT NOT NULL,
  row_5_f2                    TEXT NOT NULL,
  row_5_f3                    TEXT NOT NULL,
  row_5_f4                    TEXT NOT NULL,
  row_5_label                 TEXT NOT NULL,

  -- Step 4: Bias Reflections
  dataset_bias_reflection     TEXT NOT NULL,
  fairness_fix_reflection     TEXT NOT NULL,
  enjoyment_rating            SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w07_build_dataset_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week07_build_dataset
  IS 'Week 7 Exercise 3: Build Your Own Dataset';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week07_build_dataset ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w07_build_dataset" ON introai_week07_build_dataset;
DROP POLICY IF EXISTS "auth_select_w07_build_dataset" ON introai_week07_build_dataset;
DROP POLICY IF EXISTS "public_select_w07_build_dataset" ON introai_week07_build_dataset;

-- Anon & Public can INSERT (student page uses anon key to submit)
CREATE POLICY "anon_insert_w07_build_dataset"
  ON introai_week07_build_dataset
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- STRICT SECURITY: ONLY AUTHENTICATED USERS (TEACHERS) CAN SELECT / VIEW RESPONSES
CREATE POLICY "auth_select_w07_build_dataset"
  ON introai_week07_build_dataset
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week07_data_audit.sql ───────────────────────────────────────────
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


-- ── create_introai_week07_data_detective.sql ───────────────────────────────────────────
-- ── Table: introai_week07_data_detective ─────────────────────────────────────
-- Path: sql/create_introai_week07_data_detective.sql
-- Week 7 Exercise: Be a Data Detective!
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week07_data_detective (
  id                        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name              TEXT NOT NULL,
  student_email             TEXT,
  dataset_chosen            TEXT NOT NULL,
  data_types_identified     TEXT NOT NULL,
  data_types_explanation    TEXT NOT NULL,
  pattern_1_description     TEXT NOT NULL,
  pattern_2_description     TEXT NOT NULL,
  ai_prediction_usecase     TEXT NOT NULL,
  ai_pitfalls_reflections   TEXT NOT NULL,
  chart_visualization_idea  TEXT,
  enjoyment_rating          SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w07_data_detective_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week07_data_detective
  IS 'Week 7 Exercise: Be a Data Detective! Anonymized dataset exploration & pattern discovery.';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week07_data_detective ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w07_data_detective" ON introai_week07_data_detective;
DROP POLICY IF EXISTS "auth_select_w07_data_detective" ON introai_week07_data_detective;
DROP POLICY IF EXISTS "public_select_w07_data_detective" ON introai_week07_data_detective;

-- Anon & Public can INSERT (student page uses anon key to submit)
CREATE POLICY "anon_insert_w07_data_detective"
  ON introai_week07_data_detective
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- STRICT SECURITY: ONLY AUTHENTICATED USERS (TEACHERS) CAN SELECT / VIEW RESPONSES
CREATE POLICY "auth_select_w07_data_detective"
  ON introai_week07_data_detective
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week07_spot_the_bias.sql ───────────────────────────────────────────
-- ── Table: introai_week07_spot_the_bias ─────────────────────────────────
-- Week 7 Exercise: Spot the Bias!
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week07_spot_the_bias (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Scenario A: Music Recommendation AI
  scenario_a_left_out TEXT NOT NULL,
  scenario_a_harm     TEXT NOT NULL,
  scenario_a_fix      TEXT NOT NULL,

  -- Scenario B: Hiring AI
  scenario_b_left_out TEXT NOT NULL,
  scenario_b_harm     TEXT NOT NULL,
  scenario_b_fix      TEXT NOT NULL,

  -- Scenario C: Disease Detection AI
  scenario_c_left_out TEXT NOT NULL,
  scenario_c_harm     TEXT NOT NULL,
  scenario_c_fix      TEXT NOT NULL,

  -- Reflection
  final_reflection    TEXT NOT NULL,
  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w07_spot_the_bias_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week07_spot_the_bias
  IS 'Week 7 Exercise: Spot the Bias!';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week07_spot_the_bias ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w07_spot_the_bias" ON introai_week07_spot_the_bias;
DROP POLICY IF EXISTS "auth_select_w07_spot_the_bias" ON introai_week07_spot_the_bias;
DROP POLICY IF EXISTS "public_select_w07_spot_the_bias" ON introai_week07_spot_the_bias;

-- Anon & Public can INSERT (student page uses anon key to submit)
CREATE POLICY "anon_insert_w07_spot_the_bias"
  ON introai_week07_spot_the_bias
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- STRICT SECURITY: ONLY AUTHENTICATED USERS (TEACHERS) CAN SELECT / VIEW RESPONSES
CREATE POLICY "auth_select_w07_spot_the_bias"
  ON introai_week07_spot_the_bias
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week08_bias_card_twist.sql ───────────────────────────────────────────
-- ── Table: introai_week08_bias_card_twist ─────────────────────────────────
-- Path: sql/create_introai_week08_bias_card_twist.sql
-- Week 8 Exercise 1: The Bias Card Twist
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_bias_card_twist (
  id                    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name          TEXT NOT NULL,
  student_email         TEXT,
  group_members         TEXT,

  -- Step 1: Local Problem & Initial Solution
  local_problem         TEXT NOT NULL,
  initial_ai_solution   TEXT NOT NULL,

  -- Step 2: Twist Card
  twist_card            TEXT NOT NULL,

  -- Step 3: Impact Analysis
  what_breaks           TEXT NOT NULL,
  who_left_out          TEXT NOT NULL,

  -- Step 4: Debrief
  debrief_reflection    TEXT NOT NULL,
  enjoyment_rating      SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_bias_card_twist_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_bias_card_twist
  IS 'Week 8 Exercise 1: The Bias Card Twist';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_bias_card_twist ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_bias_card_twist" ON introai_week08_bias_card_twist;
DROP POLICY IF EXISTS "auth_select_w08_bias_card_twist" ON introai_week08_bias_card_twist;

-- Allow students to submit
CREATE POLICY "anon_insert_w08_bias_card_twist"
  ON introai_week08_bias_card_twist
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_bias_card_twist"
  ON introai_week08_bias_card_twist
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week08_bias_detective_stations.sql ───────────────────────────────────────────
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


-- ── create_introai_week08_fix_the_dataset.sql ───────────────────────────────────────────
-- ── Table: introai_week08_fix_the_dataset ─────────────────────────────────
-- Path: sql/create_introai_week08_fix_the_dataset.sql
-- Week 8 Exercise 3: Fix the Dataset
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_fix_the_dataset (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  partner_name            TEXT,

  -- Dataset modification tracking
  initial_dataset_summary TEXT NOT NULL,
  final_dataset_summary   TEXT NOT NULL,
  modified_dataset_json   TEXT,

  -- Reflections
  changes_explanation     TEXT NOT NULL,
  debrief_reflection      TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_fix_the_dataset_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_fix_the_dataset
  IS 'Week 8 Exercise 3: Fix the Dataset';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_fix_the_dataset ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_fix_the_dataset" ON introai_week08_fix_the_dataset;
DROP POLICY IF EXISTS "auth_select_w08_fix_the_dataset" ON introai_week08_fix_the_dataset;

-- Allow anonymous students to submit
CREATE POLICY "anon_insert_w08_fix_the_dataset"
  ON introai_week08_fix_the_dataset
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_fix_the_dataset"
  ON introai_week08_fix_the_dataset
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week08_mini_ethics_trial.sql ───────────────────────────────────────────
-- ── Table: introai_week08_mini_ethics_trial ──────────────────────────────
-- Path: sql/create_introai_week08_mini_ethics_trial.sql
-- Week 8 Exercise 5: Mini Ethics Trial
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_mini_ethics_trial (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Trial Role & Argument
  role_selected       TEXT NOT NULL,
  case_argument       TEXT NOT NULL,
  followup_qa         TEXT NOT NULL,
  verdict_ruling      TEXT NOT NULL,

  -- Debrief
  debrief_reflection  TEXT NOT NULL,
  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Allow multiple runs per student
ALTER TABLE introai_week08_mini_ethics_trial DROP CONSTRAINT IF EXISTS uq_w08_mini_ethics_trial_email;

COMMENT ON TABLE introai_week08_mini_ethics_trial
  IS 'Week 8 Exercise 5: Mini Ethics Trial';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_mini_ethics_trial ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_mini_ethics_trial" ON introai_week08_mini_ethics_trial;
DROP POLICY IF EXISTS "auth_select_w08_mini_ethics_trial" ON introai_week08_mini_ethics_trial;

-- Allow anonymous students to submit
CREATE POLICY "anon_insert_w08_mini_ethics_trial"
  ON introai_week08_mini_ethics_trial
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_mini_ethics_trial"
  ON introai_week08_mini_ethics_trial
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week08_promise_vs_problem.sql ───────────────────────────────────────────
-- ── Table: introai_week08_promise_vs_problem ─────────────────────────────
-- Path: sql/create_introai_week08_promise_vs_problem.sql
-- Week 8 Exercise 4: Promise vs. Problem Placemat
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week08_promise_vs_problem (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  partner_name            TEXT,

  -- AlphaFold
  alphafold_promise       TEXT NOT NULL,
  alphafold_problem       TEXT NOT NULL,

  -- Woebot
  woebot_promise          TEXT NOT NULL,
  woebot_problem          TEXT NOT NULL,

  -- BeMyEyes
  bemyeyes_promise        TEXT NOT NULL,
  bemyeyes_problem        TEXT NOT NULL,

  -- Ocean Cleanup
  ocean_cleanup_promise   TEXT NOT NULL,
  ocean_cleanup_problem   TEXT NOT NULL,

  -- Debrief
  debrief_reflection      TEXT NOT NULL,
  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w08_promise_vs_problem_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week08_promise_vs_problem
  IS 'Week 8 Exercise 4: Promise vs. Problem Placemat';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week08_promise_vs_problem ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w08_promise_vs_problem" ON introai_week08_promise_vs_problem;
DROP POLICY IF EXISTS "auth_select_w08_promise_vs_problem" ON introai_week08_promise_vs_problem;

-- Allow anonymous students to submit
CREATE POLICY "anon_insert_w08_promise_vs_problem"
  ON introai_week08_promise_vs_problem
  FOR INSERT TO anon, public
  WITH CHECK (true);

-- Allow authenticated teachers to view responses
CREATE POLICY "auth_select_w08_promise_vs_problem"
  ON introai_week08_promise_vs_problem
  FOR SELECT TO authenticated
  USING (true);


-- ── create_introai_week09_ai_feature_pitch.sql ───────────────────────────────────────────
-- ── Table: introai_week09_ai_feature_pitch ─────────────────────────────
-- Week 9 Exercise 2: AI Feature: The Prompt (Generative AI game feature pitch)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week09_ai_feature_pitch (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- Feature Pitch Details
  game_title          TEXT NOT NULL,
  ai_tech_type        TEXT NOT NULL,
  sentence_1          TEXT NOT NULL,
  sentence_2          TEXT NOT NULL,
  sentence_3          TEXT NOT NULL,
  full_pitch          TEXT NOT NULL,

  -- Analysis & Trade-offs
  gameplay_pillar     TEXT NOT NULL,
  technical_hurdle    TEXT NOT NULL,
  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w09_ai_feature_pitch_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week09_ai_feature_pitch
  IS 'Week 9 Exercise 2: AI Feature: The Prompt';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week09_ai_feature_pitch ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch;
DROP POLICY IF EXISTS "anon_select_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch;
DROP POLICY IF EXISTS "anon_update_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch;
DROP POLICY IF EXISTS "anon_all_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch;
DROP POLICY IF EXISTS "auth_select_w09_ai_feature_pitch" ON introai_week09_ai_feature_pitch;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w09_ai_feature_pitch"
  ON introai_week09_ai_feature_pitch
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w09_ai_feature_pitch"
  ON introai_week09_ai_feature_pitch
  FOR SELECT
  TO authenticated
  USING (true);


-- ── create_introai_week09_npc_logic.sql ───────────────────────────────────────────
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

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w09_npc_logic" ON introai_week09_npc_logic;
DROP POLICY IF EXISTS "anon_select_w09_npc_logic" ON introai_week09_npc_logic;
DROP POLICY IF EXISTS "anon_update_w09_npc_logic" ON introai_week09_npc_logic;
DROP POLICY IF EXISTS "anon_all_w09_npc_logic" ON introai_week09_npc_logic;
DROP POLICY IF EXISTS "auth_select_w09_npc_logic" ON introai_week09_npc_logic;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w09_npc_logic"
  ON introai_week09_npc_logic
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w09_npc_logic"
  ON introai_week09_npc_logic
  FOR SELECT
  TO authenticated
  USING (true);


-- ── create_introai_week09_poc_brainstormer.sql ───────────────────────────────────────────
-- ── Table: introai_week09_poc_brainstormer ──────────────────────────────
-- Week 9 Exercise: Final Project POC Brainstormer & Tracker
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week09_poc_brainstormer (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name        TEXT NOT NULL,
  student_email       TEXT,

  -- AI Modality Ratings & Preference Profile (JSON)
  modality_ratings    TEXT NOT NULL,
  primary_modality    TEXT NOT NULL,
  secondary_modality  TEXT NOT NULL,
  target_domain       TEXT NOT NULL,

  -- Proof of Concept (POC) Pitch Details
  poc_title           TEXT NOT NULL,
  poc_description     TEXT NOT NULL,
  mvp_scope           TEXT NOT NULL,

  enjoyment_rating    SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w09_poc_brainstormer_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week09_poc_brainstormer
  IS 'Week 9 Exercise: Final Project POC Brainstormer & Tracker';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week09_poc_brainstormer ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "anon_select_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "anon_update_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "anon_all_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;
DROP POLICY IF EXISTS "auth_select_w09_poc_brainstormer" ON introai_week09_poc_brainstormer;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w09_poc_brainstormer"
  ON introai_week09_poc_brainstormer
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w09_poc_brainstormer"
  ON introai_week09_poc_brainstormer
  FOR SELECT
  TO authenticated
  USING (true);


-- ── create_introai_week09_project_brief.sql ───────────────────────────────────────────
-- ── Table: introai_week09_project_brief ─────────────────────────────────
-- Week 9 Kickoff Task: Your Project Brief (Final AI project planning)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week09_project_brief (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT,
  group_members           TEXT NOT NULL,

  -- Project Brief Items
  project_goal            TEXT NOT NULL,
  intended_audience       TEXT NOT NULL,
  ai_tools_methods        TEXT NOT NULL,
  division_of_labor       TEXT NOT NULL,
  ethical_considerations  TEXT NOT NULL,
  definition_of_done      TEXT NOT NULL,

  enjoyment_rating        SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),
  submitted_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w09_project_brief_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week09_project_brief
  IS 'Week 9 Kickoff Task: Your Project Brief';

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week09_project_brief ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w09_project_brief" ON introai_week09_project_brief;
DROP POLICY IF EXISTS "anon_select_w09_project_brief" ON introai_week09_project_brief;
DROP POLICY IF EXISTS "anon_update_w09_project_brief" ON introai_week09_project_brief;
DROP POLICY IF EXISTS "anon_all_w09_project_brief" ON introai_week09_project_brief;
DROP POLICY IF EXISTS "auth_select_w09_project_brief" ON introai_week09_project_brief;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w09_project_brief"
  ON introai_week09_project_brief
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w09_project_brief"
  ON introai_week09_project_brief
  FOR SELECT
  TO authenticated
  USING (true);


-- ── create_introai_week10_ai_design_sprint.sql ───────────────────────────────────────────
-- ── Table: introai_week10_ai_design_sprint ─────────────────────────────────
-- Week 10 Exercise 1: AI Design Tool Sprint (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week10_ai_design_sprint (
  id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name             TEXT NOT NULL,
  student_email            TEXT,

  -- Step 1: Brief
  product_brief            TEXT NOT NULL,

  -- Step 2: Visual Prompts
  visual_prompt_1          TEXT NOT NULL,
  visual_prompt_2          TEXT NOT NULL,
  visual_prompt_3          TEXT NOT NULL,

  -- Step 3: Screen UI Layout & Mockup Slide Link
  focal_component          TEXT NOT NULL,
  screen_layout_desc       TEXT NOT NULL,
  slides_link              TEXT NOT NULL,

  -- Step 4: Justification & Reflection
  key_choice_justification TEXT NOT NULL,
  ux_risk_reflection       TEXT NOT NULL,

  -- Rating
  enjoyment_rating         SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w10_ai_design_sprint_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week10_ai_design_sprint
  IS 'Week 10 Exercise 1: AI Design Tool Sprint';

-- ── Safe Schema Migration (if table already exists) ──────────────────────────
ALTER TABLE introai_week10_ai_design_sprint ADD COLUMN IF NOT EXISTS slides_link TEXT;

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week10_ai_design_sprint ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "anon_select_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "anon_update_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "anon_all_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;
DROP POLICY IF EXISTS "auth_select_w10_ai_design_sprint" ON introai_week10_ai_design_sprint;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w10_ai_design_sprint"
  ON introai_week10_ai_design_sprint
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w10_ai_design_sprint"
  ON introai_week10_ai_design_sprint
  FOR SELECT
  TO authenticated
  USING (true);


-- ── create_introai_week10_mockup_critique.sql ───────────────────────────────────────────
-- ── Table: introai_week10_mockup_critique ─────────────────────────────────
-- Week 10 Exercise 2: Mockup Critique & Ethical UI Redesign (Individual exercise)
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_week10_mockup_critique (
  id                       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name             TEXT NOT NULL,
  student_email            TEXT,

  -- Step 1: Selected Interface Screenshot Pattern
  selected_pattern         TEXT NOT NULL,
  pattern_name_id          TEXT NOT NULL,

  -- Step 2: Benefit vs Harm Critique
  who_benefits             TEXT NOT NULL,
  who_is_harmed            TEXT NOT NULL,

  -- Step 3: Honest UI Redesign & Google Slides Link
  honest_rewrite_summary   TEXT NOT NULL,
  slides_link              TEXT NOT NULL,

  -- Step 4: Class Share Takeaway
  class_share_takeaway     TEXT NOT NULL,

  -- Rating
  enjoyment_rating         SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at             TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w10_mockup_critique_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_week10_mockup_critique
  IS 'Week 10 Exercise 2: Mockup Critique & Ethical UI Redesign';

-- ── Safe Schema Migration (if table already exists) ──────────────────────────
ALTER TABLE introai_week10_mockup_critique ADD COLUMN IF NOT EXISTS slides_link TEXT;

-- ── Row-Level Security ────────────────────────────────────────────────────────
ALTER TABLE introai_week10_mockup_critique ENABLE ROW LEVEL SECURITY;

-- Clean up any legacy policies
DROP POLICY IF EXISTS "anon_insert_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "anon_select_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "anon_update_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "anon_all_w10_mockup_critique" ON introai_week10_mockup_critique;
DROP POLICY IF EXISTS "auth_select_w10_mockup_critique" ON introai_week10_mockup_critique;

-- Allow anonymous students to SELECT, INSERT, and UPDATE (for upsert & retrieval)
CREATE POLICY "anon_all_w10_mockup_critique"
  ON introai_week10_mockup_critique
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- Authenticated users (teachers) can SELECT for dashboard & CSV export
CREATE POLICY "auth_select_w10_mockup_critique"
  ON introai_week10_mockup_critique
  FOR SELECT
  TO authenticated
  USING (true);


-- ── create_introai_week10_project_tracker.sql ───────────────────────────────────────────
-- ── Table 1: introai_project_tracker ─────────────────────────────────────
-- Main project registry per student/team
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_project_tracker (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name            TEXT NOT NULL,
  student_email           TEXT NOT NULL,
  team_members            TEXT,

  -- Project Overview
  project_name            TEXT NOT NULL,
  project_goal            TEXT NOT NULL,
  project_url             TEXT,
  overall_progress_pct    SMALLINT NOT NULL DEFAULT 10 CHECK (overall_progress_pct BETWEEN 0 AND 100),
  current_status          TEXT NOT NULL DEFAULT 'Planning & Ideation',

  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_w10_proj_tracker_email UNIQUE (student_email)
);

COMMENT ON TABLE introai_project_tracker
  IS 'Main final AI project registry for students';

-- ── Table 2: introai_project_progress_logs ──────────────────────────────
-- Class-by-class progress update logs for Build Check-Ins 1 through 5+
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS introai_project_progress_logs (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_email           TEXT NOT NULL,
  class_label             TEXT NOT NULL, -- e.g. "Class 10 - Build Check-In 1", "Class 11 - Build Check-In 2"
  checkin_type            TEXT DEFAULT 'general', -- 'checkin_1', 'checkin_2', 'checkin_3', 'checkin_4', 'build_goals', 'ready_class15'

  -- Core Log Details
  milestone_completed     TEXT NOT NULL,
  progress_pct            SMALLINT NOT NULL CHECK (progress_pct BETWEEN 0 AND 100),
  next_goal               TEXT NOT NULL,

  -- Build Check-In 1 (Class 10)
  tool_access_status      TEXT,          -- Tool access confirmation status
  mockup_sketch_url       TEXT,          -- Google Slides or feature sketch link

  -- Shared Across Check-Ins 1, 2 & Class 15
  ethics_review_update    TEXT,          -- Ethical pre-review updates & Class 15 finished review
  blockers_faced          TEXT,          -- Flagged blockers to teacher (Check-Ins 1-4)

  -- Build Check-In 2 (Class 11)
  blocker_solution_plan   TEXT,          -- How group will solve blocker before leaving today

  -- Build Check-In 3 (Class 12)
  behind_reason_and_fix   TEXT,          -- Single biggest reason if behind & way to fix it
  goal_drift_check        TEXT,          -- Does project match original brief goal or has it drifted?

  -- Build Check-In 4 (Class 13)
  current_state_honesty   TEXT,          -- Current project state & what's not working yet
  top_priorities_left     TEXT,          -- 2-3 most important things left to finish
  non_essentials_cut      TEXT,          -- What non-essential features were cut

  -- Build Goals (Class 14)
  priorities_confirmation TEXT,          -- Confirmation of Class 13 priorities (still right or changed?)
  team_member_tasks       TEXT,          -- Task assignments: who is doing what for next stretch
  user_testing_notes      TEXT,          -- Stranger user testing feedback if finished early

  -- Ready for Class 15 & Presentation (Class 15/16)
  working_version_url     TEXT,          -- Working demo / prototype URL
  presentation_rough_idea TEXT,          -- Rough idea of what student will say at Class 16 presentation
  unsure_questions        TEXT,          -- One thing still unsure about to ask in Class 15

  -- Catch-all for extra check-in metadata
  checkin_data            JSONB DEFAULT '{}'::jsonb,

  logged_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Safely add columns if table already exists in Supabase
DO $$
BEGIN
  -- Build Check-In 1 & General
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='checkin_type') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN checkin_type TEXT DEFAULT 'general';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='tool_access_status') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN tool_access_status TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='mockup_sketch_url') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN mockup_sketch_url TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='ethics_review_update') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN ethics_review_update TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='blockers_faced') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN blockers_faced TEXT;
  END IF;

  -- Build Check-In 2
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='blocker_solution_plan') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN blocker_solution_plan TEXT;
  END IF;

  -- Build Check-In 3
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='behind_reason_and_fix') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN behind_reason_and_fix TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='goal_drift_check') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN goal_drift_check TEXT;
  END IF;

  -- Build Check-In 4
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='current_state_honesty') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN current_state_honesty TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='top_priorities_left') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN top_priorities_left TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='non_essentials_cut') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN non_essentials_cut TEXT;
  END IF;

  -- Build Goals (Class 14)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='priorities_confirmation') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN priorities_confirmation TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='team_member_tasks') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN team_member_tasks TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='user_testing_notes') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN user_testing_notes TEXT;
  END IF;

  -- Class 15 & Demo Day
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='working_version_url') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN working_version_url TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='presentation_rough_idea') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN presentation_rough_idea TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='unsure_questions') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN unsure_questions TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='introai_project_progress_logs' AND column_name='checkin_data') THEN
    ALTER TABLE introai_project_progress_logs ADD COLUMN checkin_data JSONB DEFAULT '{}'::jsonb;
  END IF;
END $$;

COMMENT ON TABLE introai_project_progress_logs
  IS 'Class-by-class progress update logs for final AI projects across all Build Check-Ins';

-- ── Row-Level Security: introai_project_tracker ───────────────────────────────
ALTER TABLE introai_project_tracker ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all_w10_proj_tracker" ON introai_project_tracker;
DROP POLICY IF EXISTS "auth_select_w10_proj_tracker" ON introai_project_tracker;

CREATE POLICY "anon_all_w10_proj_tracker"
  ON introai_project_tracker
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

CREATE POLICY "auth_select_w10_proj_tracker"
  ON introai_project_tracker
  FOR SELECT
  TO authenticated
  USING (true);

-- ── Row-Level Security: introai_project_progress_logs ─────────────────────────
ALTER TABLE introai_project_progress_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all_w10_proj_logs" ON introai_project_progress_logs;
DROP POLICY IF EXISTS "auth_select_w10_proj_logs" ON introai_project_progress_logs;

CREATE POLICY "anon_all_w10_proj_logs"
  ON introai_project_progress_logs
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

CREATE POLICY "auth_select_w10_proj_logs"
  ON introai_project_progress_logs
  FOR SELECT
  TO authenticated
  USING (true);

-- ── create_introai_week11_synthetic_media.sql ──────────────────────────────────
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

ALTER TABLE introai_week11_synthetic_media ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w11_synthetic_media" ON introai_week11_synthetic_media;
DROP POLICY IF EXISTS "anon_select_w11_synthetic_media" ON introai_week11_synthetic_media;
DROP POLICY IF EXISTS "auth_select_w11_synthetic_media" ON introai_week11_synthetic_media;

CREATE POLICY "anon_insert_w11_synthetic_media"
  ON introai_week11_synthetic_media FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w11_synthetic_media"
  ON introai_week11_synthetic_media FOR SELECT TO anon USING (true);

CREATE POLICY "auth_select_w11_synthetic_media"
  ON introai_week11_synthetic_media FOR SELECT TO authenticated USING (true);

-- ── create_introai_week11_what_would_you_do.sql ────────────────────────────────
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

ALTER TABLE introai_week11_what_would_you_do ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w11_wwyd" ON introai_week11_what_would_you_do;
DROP POLICY IF EXISTS "anon_select_w11_wwyd" ON introai_week11_what_would_you_do;
DROP POLICY IF EXISTS "auth_select_w11_wwyd" ON introai_week11_what_would_you_do;

CREATE POLICY "anon_insert_w11_wwyd"
  ON introai_week11_what_would_you_do FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w11_wwyd"
  ON introai_week11_what_would_you_do FOR SELECT TO anon USING (true);

CREATE POLICY "auth_select_w11_wwyd"
  ON introai_week11_what_would_you_do FOR SELECT TO authenticated USING (true);

-- ── create_introai_week12_mini_chatbot.sql ─────────────────────────────────────
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

ALTER TABLE introai_week12_mini_chatbot ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w12_mini_chatbot" ON introai_week12_mini_chatbot;
DROP POLICY IF EXISTS "anon_select_w12_mini_chatbot" ON introai_week12_mini_chatbot;
DROP POLICY IF EXISTS "auth_select_w12_mini_chatbot" ON introai_week12_mini_chatbot;

CREATE POLICY "anon_insert_w12_mini_chatbot"
  ON introai_week12_mini_chatbot FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w12_mini_chatbot"
  ON introai_week12_mini_chatbot FOR SELECT TO anon USING (true);

CREATE POLICY "auth_select_w12_mini_chatbot"
  ON introai_week12_mini_chatbot FOR SELECT TO authenticated USING (true);

-- ── create_introai_week12_bot_vs_llm.sql ─────────────────────────────────────
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

ALTER TABLE introai_week12_bot_vs_llm ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_insert_w12_bot_vs_llm" ON introai_week12_bot_vs_llm;
DROP POLICY IF EXISTS "anon_select_w12_bot_vs_llm" ON introai_week12_bot_vs_llm;
DROP POLICY IF EXISTS "auth_select_w12_bot_vs_llm" ON introai_week12_bot_vs_llm;

CREATE POLICY "anon_insert_w12_bot_vs_llm"
  ON introai_week12_bot_vs_llm FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "anon_select_w12_bot_vs_llm"
  ON introai_week12_bot_vs_llm FOR SELECT TO anon USING (true);

CREATE POLICY "auth_select_w12_bot_vs_llm"
  ON introai_week12_bot_vs_llm FOR SELECT TO authenticated USING (true);


-- ── create_introai_cohort_exercises.sql ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS introai_cohort_exercises (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cohort       TEXT NOT NULL DEFAULT 'aijr',       -- e.g. 'aijr', 'fall2024', 'sat_10am'
  exercise_id  TEXT NOT NULL,                      -- e.g. 'week01_is_it_ai', 'week11_synthetic_media'
  is_active    BOOLEAN NOT NULL DEFAULT true,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_cohort_exercise UNIQUE (cohort, exercise_id)
);

COMMENT ON TABLE introai_cohort_exercises
  IS 'Stores active/inactive visibility toggles for Intro to AI exercises per cohort';

ALTER TABLE introai_cohort_exercises ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_cohort_exercises" ON introai_cohort_exercises;
DROP POLICY IF EXISTS "anon_all_cohort_exercises" ON introai_cohort_exercises;
DROP POLICY IF EXISTS "auth_all_cohort_exercises" ON introai_cohort_exercises;

CREATE POLICY "anon_select_cohort_exercises"
  ON introai_cohort_exercises FOR SELECT TO anon USING (true);

CREATE POLICY "anon_all_cohort_exercises"
  ON introai_cohort_exercises FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "auth_all_cohort_exercises"
  ON introai_cohort_exercises FOR ALL TO authenticated USING (true) WITH CHECK (true);

