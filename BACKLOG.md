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
- [ ] **[TASK-4.4] Batch 4 — Weeks 13–16 Intro AI Pages:**
  - `week13_will_ai_take_this_job.html`, `week13_ai_career_mapping.html`, `week16_final_submission.html`, etc.
  - Remove redundant raw `SUPABASE_URL` / `SUPABASE_ANON` constants.
- [ ] **[TASK-4.5] AIJR Student Pages:**
  - `pages/aijr/homework.html`
  - `pages/aijr/class16_FinalExam_Part1.html`
  - `pages/aijr/class08_part1.html`

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
