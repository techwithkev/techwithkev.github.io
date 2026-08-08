# Site Architecture & Engineering Guide — techwithkev.github.io

> **Purpose:** Authoritative reference manual for maintaining, extending, and creating pages across the codebase without architectural drift, security regressions, or visual divergence.

---

## 1. System Overview & Page Categories

The codebase is divided into **three distinct page categories**, each with defined layout patterns and asset pipelines:

```
techwithkev.github.io/
├── index.md, courses.md, pricing.md      ── Category A: Jekyll Marketing Site
├── pages/introai/, pages/aijr/           ── Category B: Interactive Student Activity Pages
└── pages/teacher/                        ── Category C: Teacher Dashboards & Tools
```

| Property | Category A: Marketing Site | Category B: Student Activity Pages | Category C: Teacher Dashboards |
|---|---|---|---|
| **Location** | Root (`/*.md`, `/_layouts/`) | `pages/introai/*.html`, `pages/aijr/*.html` | `pages/teacher/*.html` |
| **Engine** | Jekyll (`_layouts/default.html`) | Standalone HTML5 Pages | Standalone HTML5 Pages |
| **CSS Source** | `assets/css/main.css` | `assets/css/activity.css` (Tailwind CLI) | `assets/css/activity.css` (Tailwind CLI) |
| **Primary Font** | Space Grotesk / Inter | Outfit / JetBrains Mono | DM Sans / DM Mono / Outfit |
| **State / DB** | Static / Formspree / ConvertKit | Supabase REST API (Anon Role) | Supabase REST API (Anon / Service Role) |
| **Back Link** | Navbar (`/`) | Header Back Link (`index.html` or `/`) | Nav Header |

---

## 2. Page Category Technical Guidelines

### Category A: Jekyll Marketing Pages
- **File Format:** Markdown (`.md`) or Liquid HTML (`.html`) in root.
- **Layout:** Standard front matter: `layout: default`.
- **CSS / JS:** Managed by Jekyll compilation from `assets/css/main.scss`. Do **not** link `activity.css` or Tailwind CDN directly in marketing pages.

### Category B: Student Activity Pages
- **File Format:** Standalone HTML files in `pages/introai/` or `pages/aijr/`.
- **Styling:** Compiled CSS (`../../assets/css/activity.css`). **NEVER load `https://cdn.tailwindcss.com`**.
- **Shared Utilities:** Standard import `../../assets/js/introai-shared.js`.
- **Navigation:** Header must include a back-link to the course hub (`index.html`) or home site.

---

## 3. Standardized Activity Page Boilerplate

All new student activity pages (`pages/introai/` or `pages/aijr/`) **MUST** use this exact `<head>` and script import structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Activity Title] — [Course Name] · Week [X]</title>
  <meta name="description" content="[1-2 sentence descriptive summary of exercise]">

  <!-- 1. Google Fonts Preconnect (MANDATORY for fast LCP) -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">

  <!-- 2. Compiled Activity CSS (NEVER CDN) -->
  <link rel="stylesheet" href="../../assets/css/activity.css">
</head>
<body class="bg-gray-50 text-gray-900 min-h-screen font-sans antialiased pb-20">

  <!-- Main Activity Layout -->
  ...

  <!-- 3. Shared Utilities (MUST be imported before page script) -->
  <script src="../../assets/js/introai-shared.js"></script>

  <!-- 4. Page-Specific Logic -->
  <script>
    const TABLE = 'introai_weekXX_[exercise_name]';
    ...
  </script>
</body>
</html>
```

---

## 4. State & Session Management (`introai-shared.js`)

To prevent students from having to re-type their name and email on every activity tab, pages **MUST** use the shared session storage keys provided in `introai-shared.js`.

### Session Storage Keys
- `INTROAI_NAME_KEY` (`'introai_student_name'`)
- `INTROAI_EMAIL_KEY` (`'introai_student_email'`)

### Standard Registration & Retrieval Pattern
```javascript
// Restoring session on page load
(function restoreSession() {
  const { name, email } = getStudentSession();
  if (name && email) {
    studentName = name;
    studentEmail = email;
    const overlay = document.getElementById('registration-overlay');
    if (overlay) overlay.remove();
  }
})();

// Saving session on registration submit
function handleRegistration(ev) {
  ev.preventDefault();
  const nameVal = document.getElementById('reg-name').value.trim();
  const emailVal = document.getElementById('reg-email').value.trim();
  
  if (!nameVal || !validateEmail(emailVal)) return;

  saveStudentSession(nameVal, emailVal);
  studentName = nameVal;
  studentEmail = emailVal;
  
  // Hide overlay
  ...
}
```

### Shared Supabase REST Functions
Never duplicate `fetch` boilerplates or API keys. Use `introai-shared.js` helpers:
- `supabaseInsert(table, payload)` — Simple INSERT.
- `supabaseUpsert(table, payload, conflictCol)` — UPSERT matching `on_conflict` column (defaults to `'student_email'`).
- `supabaseSelect(table, queryString)` — SELECT rows matching query.
- `supabasePatch(table, queryString, payload)` — PATCH rows matching query filter.

---

## 5. CSS Build Pipeline & Styling Rules

### CSS Build Command
All utility classes used in `pages/` are scanned and compiled into `assets/css/activity.css` via Tailwind CLI.

```bash
# Rebuild CSS minified (run after adding new Tailwind classes to HTML)
npm run build:css

# Watch for CSS changes during active development
npm run watch:css
```

### Tailwind Configuration Scopes (`tailwind.config.js`)
Ensure all page paths are included in `content`:
```javascript
module.exports = {
  content: [
    './pages/introai/**/*.html',
    './pages/aijr/**/*.html',
    './pages/teacher/**/*.html',
    './pages/*.html',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Outfit', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
    },
  },
};
```

### Styling Constraints
1. **No Inline Styles:** Use Tailwind classes or component classes defined in `assets/css/activity-src.css`.
2. **Card Containers:** `bg-white border border-gray-200 p-6 rounded-2xl shadow-sm`.
3. **Buttons:** `font-black rounded-xl shadow-lg transition-all active:scale-95`.
4. **Primary Color Palettes:**
   - Intro AI: Deep Rose / Pink (`from-rose-600 to-pink-700`) or Blue (`blue-600`).
   - AIJR: Indigo / Cyan (`from-indigo-600 to-cyan-700`).

---

## 6. Database & Database Migration Rules

All SQL definitions are organized in the `sql/` directory:

```
sql/
├── README.md                           # Database setup instructions
├── schema_introai_complete.sql         # Master schema file for fresh environments
├── exercises/                          # Standalone per-exercise table definitions
├── migrations/                         # Chronological alter & security patch scripts
└── seeds/                              # Test data & seed scripts
```

### Database Schema Standard for Activity Tables
Every table created in `sql/exercises/` and merged into `schema_introai_complete.sql` **MUST** follow this exact schema pattern:

```sql
-- ── Table: introai_weekXX_[exercise_name] ───────────────────────────
CREATE TABLE IF NOT EXISTS introai_weekXX_[exercise_name] (
  id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name     TEXT NOT NULL,
  student_email    TEXT NOT NULL,
  
  -- Exercise fields...
  [field_1]        TEXT NOT NULL,
  enjoyment_rating SMALLINT NOT NULL CHECK (enjoyment_rating BETWEEN 1 AND 5),

  submitted_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_wXX_[exercise_name]_email UNIQUE (student_email)
);

-- Enable RLS
ALTER TABLE introai_weekXX_[exercise_name] ENABLE ROW LEVEL SECURITY;

-- 1. Anonymous students can INSERT
CREATE POLICY "anon_insert_wXX_[exercise_name]"
  ON introai_weekXX_[exercise_name] FOR INSERT TO anon WITH CHECK (true);

-- 2. Anonymous students can SELECT own submissions
CREATE POLICY "anon_select_wXX_[exercise_name]"
  ON introai_weekXX_[exercise_name] FOR SELECT TO anon USING (true);

-- 3. Authenticated teachers can SELECT all
CREATE POLICY "auth_select_wXX_[exercise_name]"
  ON introai_weekXX_[exercise_name] FOR SELECT TO authenticated USING (true);
```

### 🔴 Security Rules:
- **NEVER** use `FOR ALL TO anon`. Always split into `FOR INSERT` and `FOR SELECT` policies.
- **ALWAYS** add `CONSTRAINT uq_[tablename]_email UNIQUE (student_email)` to prevent duplicate submission pollution.

---

## 7. Checklist for Creating New Pages

Before submitting or committing a new student exercise page:

- [ ] **Head Tags:** `<meta description>` included; Google Fonts `preconnect` and `gstatic` links present.
- [ ] **CSS Link:** Uses `<link rel="stylesheet" href="../../assets/css/activity.css">` (no CDN script).
- [ ] **Shared JS:** Includes `<script src="../../assets/js/introai-shared.js"></script>` before page script.
- [ ] **Session Keys:** Uses `INTROAI_NAME_KEY` and `INTROAI_EMAIL_KEY` for registration gate storage.
- [ ] **Supabase Functions:** Calls `supabaseUpsert()` or `supabaseInsert()` from `introai-shared.js` (no raw API key or URL constants).
- [ ] **Build CSS:** Ran `npm run build:css` after introducing any new Tailwind classes.
- [ ] **SQL Schema:** Added individual creation file to `sql/exercises/` and appended table definition to `sql/schema_introai_complete.sql`.
- [ ] **Course Hub Link:** Added card link on `pages/introai/index.html` or `pages/aijr/index.html`.
