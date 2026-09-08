# Project Backlog & Future Actions

> **Handoff Document for Coding Agents & Contributors**  
> **Status Reference:** [status.md](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/status.md)  
> **Architecture Reference:** [ARCHITECTURE.md](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/ARCHITECTURE.md)  

---

## 🎯 High-Priority / Immediate Next Steps

### 1. Database Schema Deployment (Manual Action by User / Admin)
- [x] **Run Pre-migration:** Execute `sql/schema_v2_premigration.sql` in Supabase SQL editor.
- [x] **Run Schema v2:** Execute `sql/schema_v2.sql`.
- [x] **Run AIJR Schema:** Execute `sql/schema_v2_aijr.sql`.
- [x] **Seed Courses & Exercises:** Execute `sql/seeds/v2_seed_courses.sql`.
- [x] **Create Reporting Views:** Execute `sql/views/v_submission_summary.sql`.
- [ ] **Smoke Test:** Create a test cohort in `pages/teacher/cohorts.html` and generate an access code in `pages/teacher/access-codes.html`.

---

## 🚀 Phase 3b: AIJR & Specialized Teacher Portal Modules

Extract the remaining functional tabs from `pages/teacher/teacher_dashboard.legacy.html` into dedicated, modern standalone modules matching the dark design system (`teacher-shared.js` + Tailwind CSS).

### [TASK-3B.1] AIJR Homework Viewer (`pages/teacher/homework.html`)
- **Description:** Standalone teacher page to review AIJR homework submissions.
- **Data Source:** `homework_submissions` table (with `cohort_id` join to `cohorts`).
- **Features:**
  - Course $\rightarrow$ Cohort selector (`buildCohortCascade()`).
  - Class session / Homework assignment filter.
  - Student code preview modal with syntax highlighting.
  - Grading / Feedback status toggle and notes save.
  - CSV export of submissions by cohort.

### [TASK-3B.2] AIJR Exam Results (`pages/teacher/exams.html`)
- **Description:** Standalone exam grading and analytics dashboard.
- **Data Source:** `exam_submissions` table.
- **Features:**
  - Exam selector (Final Exam Part 1, Part 2, Midterm, etc.).
  - Class / Cohort grade distribution histogram & average score stat cards.
  - Question-by-question error rate analysis.
  - Detailed student score breakdown table with CSV export.

### [TASK-3B.3] AI Progress & Analysis Portal (`pages/teacher/ai-analyzer.html`)
- **Description:** Deep-dive student exercise response analyzer.
- **Data Source:** `exercise_submissions` and `v_cohort_roster`.
- **Features:**
  - Cohort-level enjoyment ratings breakdown.
  - AI student sentiment summary / reflection text viewer.
  - Flagged student alert list (students falling behind on submissions).

---

## 🎓 Phase 4: Student Portal Migration to Schema v2

Gradually update student exercise pages in `pages/introai/` and `pages/aijr/` to utilize `introai-shared.js`'s unified access gate and `submitExercise()` handler.

### Architecture Pattern for Student Pages:
```html
<!-- Include Shared Header and JS -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="../../assets/js/introai-shared.js"></script>

<script>
  // On Page Load:
  IntroAI.mountAccessCodeGate({
    courseSlug: 'introai',
    exerciseSlug: 'week01_sentiment_analysis',
    onAuthenticated: (session) => {
      console.log('Student validated:', session);
    }
  });

  // On Form Submit:
  async function handleSubmit(formData) {
    const { data, error } = await IntroAI.submitExercise('week01_sentiment_analysis', formData);
    if (error) alert('Error submitting: ' + error.message);
    else showSuccessScreen();
  }
</script>
```

### Subtasks:
- [ ] **[TASK-4.1] Batch 1 — Week 01 Intro AI Pages:**
  - `pages/introai/week01_quick_draw.html`
  - `pages/introai/week01_ai_drawing_prompting.html`
  - `pages/introai/week01_ai_vs_human_drawing.html`
  - `pages/introai/week01_sentiment_analysis.html`
- [ ] **[TASK-4.2] Batch 2 — Weeks 02–06 Intro AI Pages:**
  - Weeks 02 to 06 exercises (Vision, Sound, Teachable Machine, Chatbots).
- [ ] **[TASK-4.3] Batch 3 — Weeks 07–12 Intro AI Pages:**
  - Weeks 07 to 12 exercises (Ethics, Generation, Embeddings, Prompt Engineering).
- [ ] **[TASK-4.4] Batch 4 — Weeks 13–16 Intro AI Pages (New & Emerging Topics):**
  - Week 13: `week13_will_ai_take_this_job.html`, `week13_ai_career_mapping.html`, `week13_checkin.html`
  - Week 14: AI in Science & Research (`week14_science_research.html` - to author)
  - Week 15: AI for Business & Entrepreneurship (`week15_business_entrepreneurship.html` - to author)
  - Week 16: Robotics & Physical AI (`week16_robotics_physical_ai.html` - to author)
- [ ] **[TASK-4.5] Batch 5 — Weeks 17–19 Intro AI Pages (Build Sprint & Showcase):**
  - Week 17: `week17_checkin.html`, `week17_progress_notes.html` (Project Build Session)
  - Week 18: `week18_checkin.html` (Project Build Session & Rehearsal)
  - Week 19: `week19_final_submission.html` (Showcase, Debate & What's Next)
- [x] **[TASK-4.6] AIJR Student Pages & File Renames (19-Class Expansion):**
  - `pages/aijr/index.html` (Visualizers Hub with 19-class filter dropdown and remapped tiles)
  - `pages/aijr/homework.html` (Homework Hub for Classes 1–19)
  - `pages/aijr/class10_midterm_exam.html` (Class 10 Midterm Assessment — Classes 1–9)
  - `pages/aijr/class10_cheatsheet.html` (Class 10 Midterm Cheatsheet — Classes 1–9)
  - `pages/aijr/class19_final_exam.html` (Class 19 Final Exam — Classes 1–18)
  - Renamed visualizer files to match 19-class sequence (`class07_entropy_splitter.html`, `class09_kernel_trick.html`, `class12_constraint_propagation.html`, `class13_k_means_clustering.html`, `class13_principal_component_analysis.html`, `class13_t_sne_process_visualizer.html`, `class15_mae_rmse.html`, `class15_r2_coefficient_of_determination.html`, `class15_roc_auc.html`, `class15_visualization.html`, `class15_learning_curves.html`, `class16_agent_environment_loop.html`, `class16_mdp.html`, `class16_bellman_gridworld.html`, `class16_epsilon_visualizer.html`, `class16_qlearning.html`, `class17_cosine_similarity.html`, `class18_self_attention.html`, `class18_latent_space.html`)
  - Optional concept visualizers / modules for Class 7 (Ensembles), Class 8 (Naive Bayes), Class 12 (Minimax & Adversarial Search), Class 14 (Extended Clustering DBSCAN/GMM).

---

## 🌐 Phase 5: Public Marketing & Funnel Overhaul

- [ ] **[TASK-5.1] Homepage Rebuild (`index.md` / `index.html`):**
  - Personal brand landing page for Kevin Ng (Educator, AI Engineer, Competitive Programming Coach).
  - Feature courses: *Introduction to AI* and *AI Olympiads Junior*.
  - Testimonial carousel and student achievements.
- [ ] **[TASK-5.2] Course Catalog & Pricing Pages (`courses.md`, `pricing.md`):**
  - Sync curriculum descriptions with latest 16-week syllabus.
  - Clear enrollment call-to-actions linking to booking/payment.
- [ ] **[TASK-5.3] Replace Integration Placeholders (see `TODOS.md`):**
  - Calendly link in `pages/book.html`.
  - Stripe payment links.
  - ConvertKit lead capture form IDs in `pages/python/` and `pages/g9_math_prerequisite_assessment.html`.
  - Formspree ID in `contact.md`.

---

## 📦 Phase 6: Extended Roadmap & Infrastructure

- [ ] **[TASK-6.1] Historical Data Migration Script:**
  - Write Node.js or SQL migration script to ETL old data from `introai_week*` (50+ tables) into `exercise_submissions`.
- [ ] **[TASK-6.2] Integrate Python & Competitive Programming Hubs:**
  - Integrate `pages/python/` and `pages/comp/` into the unified `courses` hierarchy.
- [ ] **[TASK-6.3] Supabase Edge Functions & Enhanced RLS:**
  - Deploy server-side Edge Functions for student submission validation to completely prevent direct table tampering without a valid access code token.
