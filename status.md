# Project Refactor Status & State of the Codebase

> **Last Updated:** September 6, 2026 (Phase 1–3 Complete; Ready for SQL Migration & Phase 3b/4)  
> **Repository:** `techwithkev.github.io`  
> **Target Audience:** Next Coding Agent / Lead Engineer  

---

## 📌 Executive Summary

This repository is being refactored from a fragmented, per-exercise Supabase table structure (50+ individual tables and an 11,936-line monolithic teacher dashboard) into a **scalable, multi-tenant course platform (Schema v2)**.

### The 4 Major Subsystems
1. **Marketing / Landing:** Root `index.md`, `courses.md`, `pricing.md`, `assessments.md` (Jekyll / GitHub Pages).
2. **Intro to AI (`pages/introai/`):** 35+ interactive student exercise pages across 16 weeks.
3. **AI Olympiad Junior (`pages/aijr/`):** Class pages, homework submissions, and final exams.
4. **Teacher Portal (`pages/teacher/`):** Dashboard for managing cohorts, classes, student access codes, exercise submissions, homework, exams, and analytics.

---

## 🏗 Architecture v2 Overview

### 1. Database Schema (`sql/`)
Instead of `CREATE TABLE introai_weekX_exercise_name` for every new activity:
- **Core Entities:** `courses` (e.g. `introai`, `aijr`) $\rightarrow$ `cohorts` $\rightarrow$ `classes` (individual class meeting times/sessions).
- **Access Control:** `access_codes` (scoped to course, cohort, class, or purpose `general | homework | exam | exercise`).
- **Student Identity:** `student_sessions` (created upon access code entry; maps `student_email` $\leftrightarrow$ `cohort_id`).
- **Unified Exercise Engine:** `exercise_definitions` (metadata catalog for all 47+ exercises) and `exercise_submissions` (`exercise_id`, `cohort_id`, `student_email`, `student_name`, `payload JSONB`).
- **AIJR Specialized Tables:** `exam_submissions` (consolidates `caio_final_exam_results` + `test_submissions`) and `homework_submissions` (with new `cohort_id` foreign key).
- **Database Views:** `v_submission_summary`, `v_cohort_roster`, `v_cohort_exercise_completion`.

### 2. Client Architecture (`assets/js/`)
- **Teacher Portal:** `assets/js/teacher-shared.js` — Centralized Supabase client (`createTeacherClient()`), `TeacherAuth` session management, dynamic cohort cascade dropdown builder, and authenticated fetch helpers.
- **Student Portal:** `assets/js/introai-shared.js` — Added `validateAccessCode()`, `registerStudentSession()`, `submitExercise(slug, payload)`, and `mountAccessCodeGate()`. Fully backward-compatible with legacy `supabaseInsert()`.

### 3. Modular Teacher Portal (`pages/teacher/`)
Replaced the monolithic `teacher_dashboard.html` (11,936 lines) with focused, modern dark-themed pages:
- `index.html`: Portal dashboard hub with password gate and navigation cards.
- `cohorts.html`: Course $\rightarrow$ Cohort $\rightarrow$ Class management.
- `access-codes.html`: Unified access code generator with purpose tabs and usage meters.
- `submissions.html`: Unified exercise browser with course/cohort/exercise cascade, submission detail drawer, enjoyment distribution charts, and CSV export. Replaces 44 individual dashboard tabs.
- `roster.html`: Live student roster powered by `v_cohort_roster` with submission counts, search, and CSV export.
- `teacher_dashboard.legacy.html`: Archived original monolith for historical fallback reference.

---

## ✅ Completed Progress (Phases 1–3)

### Phase 1: Database Schema & Migration SQL
- [x] **`sql/schema_v2_premigration.sql`**: Pre-migration script that safely renames legacy tables (`cohorts` $\rightarrow$ `cohorts_legacy`, `access_codes` $\rightarrow$ `access_codes_legacy`) to prevent `42703 column "cohort_id" does not exist` collisions.
- [x] **`sql/schema_v2.sql`**: Core 8-table schema with indexes and RLS policies.
- [x] **`sql/schema_v2_aijr.sql`**: AIJR `exam_submissions` table + `homework_submissions` cohort migration.
- [x] **`sql/seeds/v2_seed_courses.sql`**: Seed data for `courses` (Intro AI, AI Olympiads Junior) and 47 `exercise_definitions`.
- [x] **`sql/views/v_submission_summary.sql`**: Consolidated views for teacher analytics.

### Phase 2: Shared JS Modules & Credential Centralization
- [x] **`assets/js/teacher-shared.js`**: Built shared teacher authentication and Supabase client layer.
- [x] **`assets/js/introai-shared.js`**: Extended with v2 unified submission and access code gate API.
- [x] **`pages/teacher/manage_cohorts.html`**: Migrated off hardcoded credentials.
- [x] **`pages/teacher/ai_progress_view.html`**: Migrated off hardcoded credentials.

### Phase 3: Teacher Portal Decomposition
- [x] Built `pages/teacher/index.html` (Hub)
- [x] Built `pages/teacher/cohorts.html`
- [x] Built `pages/teacher/access-codes.html`
- [x] Built `pages/teacher/submissions.html`
- [x] Built `pages/teacher/roster.html`
- [x] Archived `pages/teacher/teacher_dashboard.html` $\rightarrow$ `pages/teacher/teacher_dashboard.legacy.html`

---

## ⚡ Next Immediate Step: Smoke Test

All 5 schema v2 SQL files have been deployed to Supabase (premigration, schema_v2, schema_v2_aijr, seed, views). Next: smoke test by creating a test cohort in `pages/teacher/cohorts.html` and generating an access code in `pages/teacher/access-codes.html`.

---

## 📋 Comprehensive Backlog & Roadmap

For task breakdown, dependencies, and execution plan, refer to [BACKLOG.md](file:///Users/kevinng/Kevin/kevin/techwithkev.github.io/BACKLOG.md).
