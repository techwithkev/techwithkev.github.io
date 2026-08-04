# Intro to AI — Supabase Database Architecture & SQL Directory

This folder contains the database schema, migrations, and seed scripts for the **Intro to AI** student course platform hosted on Supabase.

---

## 📁 Directory Structure

```
sql/
├── README.md                           # This documentation guide
├── schema_introai_complete.sql         # ⭐️ Master schema (all 30+ activity tables in one file)
├── exercises/                          # Standalone table creation scripts by exercise
│   ├── create_introai_week01_tables.sql
│   ├── create_introai_week01_chatbots.sql
│   └── ...
├── migrations/                         # Date-stamped alter scripts & security hotfixes
│   ├── 20260718_prevent_multiple_submissions.sql
│   ├── 20260802_add_slide_link_to_project_progress_notes.sql
│   ├── 20260803_allow_anon_select_cohorts.sql
│   └── 20260804_fix_rls_week09_week10.sql
├── seeds/                              # Test & mock data scripts
│   ├── classes1to7_test_setup.sql
│   └── insert_co_writer_story_class.sql
└── legacy/                             # Archived database dumps & historical reference
    └── full_audit.sql
```

---

## 🚀 Quickstart

### Option A: Fresh Database Setup (Recommended)
To initialize a fresh Supabase database with all student exercise tables, RLS policies, and unique constraints:
1. Open **Supabase Dashboard → SQL Editor**.
2. Copy and paste the contents of `schema_introai_complete.sql`.
3. Click **Run**.

---

### Option B: Running Individual Exercise Setup
If you are developing a single new exercise page:
1. Check `exercises/create_introai_weekXX_<exercise_name>.sql`.
2. Run that specific script in the Supabase SQL Editor.

---

## 🔒 Security & Row-Level Security (RLS) Standard

All student exercise tables follow a strict, standardized RLS security policy:
- **`anon_insert_<tablename>`** — Allows anonymous students to submit their completed exercises via the frontend app.
- **`anon_select_<tablename>`** — Allows anonymous students to view/retrieve their submitted progress when matching unique email constraints.
- **`auth_select_<tablename>`** — Allows authenticated teachers (signed into the Teacher Dashboard) to read all submissions and export CSV reports.
