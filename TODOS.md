# TODOs

## Owner actions required (blocked on external accounts)

These are placeholder values in the code that need real IDs before the funnel is fully live.

| # | File | Line | Find | Replace with |
|---|------|------|------|-------------|
| 1 | `pages/book.html` | 95 | `YOUR_CALENDLY_URL` | Your Calendly event link (e.g. `https://calendly.com/techwithkev/60min`) |
| 2 | `pages/book.html` | 117 | `YOUR_STRIPE_PAYMENT_LINK` | Your Stripe payment link URL |
| 3 | `pages/python/python_functions.html` | 2171 | `YOUR_FORM_UID/YOUR_EMBED_ID.js` | ConvertKit embed script URL (from ConvertKit → Forms → Embed → HTML/JS tab) |
| 4 | `pages/g9_math_prerequisite_assessment.html` | 1770 | `YOUR_FORM_UID/YOUR_EMBED_ID.js` | ConvertKit embed script URL (same form as above) |
| 5 | `contact.md` | 10 | `YOUR_FORM_ID` | Formspree form ID (from formspree.io dashboard) |

## Setup checklist

- [ ] Create Calendly account → set up "60-min Tutoring Session" event → copy event link
- [ ] Create Stripe payment link for a 1-on-1 session → copy URL
- [ ] Sign up for ConvertKit → create a form → go to Embed → copy the JS script `src` URL
- [ ] Sign up for Formspree → create a form → copy the form ID from the action URL

## Deferred (not blocking launch)

- Fix G9 Math answer key: `q13` explanation contradicts the `correct` field (says A but walks through to C)
- Brand identity: assessment pages use a different visual language from the main site (dark theme vs white)

## From /plan-eng-review — pages/ architecture audit (2026-08-15)

- [ ] **Split `pages/teacher/teacher_dashboard.html` (11,618 lines, 164 functions) into per-tab modules, and convert its 987 inline `style="..."` attributes to Tailwind classes as part of each extraction.**
  What: Break the monolithic dashboard into separate files/modules per view (roster, cohorts, submissions, AI analyzer, access codes), e.g. `<script type="module">` per tab or separate pages behind the existing nav. Convert each extracted piece's inline styles to Tailwind classes at the same time — don't do a standalone 987-instance style sweep first, since that touches the same lines twice.
  Why: The file is 5x the size of the next-largest page in `pages/` (2,275 lines) and violates ARCHITECTURE.md §5's "No Inline Styles" rule at the largest magnitude found anywhere in the review. Every change requires reasoning about an 11k-line file; git diffs are hard to scope; browser parse cost grows for every visitor regardless of which tab they use.
  Pros: Smaller, independently reviewable diffs going forward; doc-compliant styling; lower parse/compile cost per tab.
  Cons: Multi-day effort if done as one project; touches a file with zero test coverage (see test-framework TODO below) — do incrementally, one tab at a time, not as a big-bang rewrite.
  Context: File has gained ~5 features in the last 15 commits (roster, cohort filtering, AI analyzer, access codes). Do the split the next time a new tab/feature touches this file, not as a standalone effort.
  Depends on: ideally do after the test-framework TODO below exists, so extractions have some regression coverage.

- [ ] **Create a shared Supabase config module for `pages/teacher/*.html` (Category C).**
  What: Add `pages/teacher/teacher-shared.js` (or extend `assets/js/introai-shared.js`) with `SUPABASE_URL`/`SUPABASE_ANON` + a shared `createClient()` helper. Migrate `teacher_dashboard.html`, `manage_cohorts.html`, `Generate_Access_Codes_with_login.html`, `ai_progress_view.html` to import it instead of each hardcoding the same literals.
  Why: ARCHITECTURE.md §4 documents exactly this principle for Category B ("credential rotation = edit ONE file, not 40+") but it was never extended to Category C. Rotating the anon key today means hand-editing 4 files.
  Pros: One-file credential rotation for teacher pages, matches the pattern the rest of the repo already follows.
  Cons: Touches 4 live files; anon key is public by design so this is a maintainability fix, not a security fix — low urgency.
  Context: Found during the pages/ architecture review, alongside the same drift already fixed once for Category B via `introai-shared.js`.

- [ ] **Migrate 7 introai/aijr/python pages off raw `SUPABASE_URL`/`SUPABASE_ANON` constants onto a shared config module.**
  What: `pages/introai/week13_will_ai_take_this_job.html`, `pages/introai/week13_ai_career_mapping.html`, `pages/aijr/class16_FinalExam_Part1.html`, `pages/aijr/class08_part1.html`, `pages/aijr/homework.html` each duplicate raw Supabase constants instead of importing `../../assets/js/introai-shared.js` like the other 46/51 introai/aijr pages. Migrate each to use the shared helpers (`supabaseInsert`/`supabaseUpsert`/`supabaseSelect`), verifying each file's existing inline fetch logic maps cleanly to the shared helper signatures first. `pages/python/python_functions.html` and `pages/python/python_conditionals_loops.html` have the same raw-constant duplication but aren't covered by ARCHITECTURE.md's category system at all (pages/python/ isn't listed under Category A/B/C) — fold them into this same migration since it's the same fix, and note the doc gap separately (see ARCHITECTURE.md category-coverage TODO below).
  Why: ARCHITECTURE.md's page-creation checklist explicitly requires "no raw API key or URL constants" — these are drift from an established pattern the rest of the folder follows correctly, not a missing pattern.
  Pros: Matches the folder's own convention; one-file credential rotation extends to (nearly) all of Category B plus the undocumented python pages.
  Cons: 7 files with live student-facing forms and zero test coverage — needs individual verification per file, not a blind find-replace.
  Context: Found during the pages/ architecture review (introai/aijr) and its outside-voice cross-check (python/). `week13_ai_career_mapping.html` and `week13_will_ai_take_this_job.html` were also fixed for the separate Tailwind-CDN violation in this same pass (see commit history) — worth doing this migration in the same follow-up session since both are the same two "newest, least-conformant" pages.

- [ ] **Add cohort-scoped server-side filtering to `teacher_dashboard.html`'s `loadAll()`.**
  What: `loadAll()` fires 44 parallel Supabase queries (`teacher_dashboard.html:4974-5018`), each `.select('*')...limit(10000)` with no server-side filter — the entire database loads into the browser on every page load/refresh, then gets filtered to the selected cohort client-side in JS. Add `.eq()`/`.in()` filters scoped to the selected cohort at the query level.
  Why: Not urgent at current scale (properly parallelized via `Promise.all`, not sequential N+1) but doesn't scale — every added cohort/table grows every future load, and there's no caching between manual refreshes.
  Pros: Query time and payload size scale with the cohort viewed, not the whole database; server-side scoping instead of a client-side-only boundary.
  Cons: Not currently causing a felt slowdown — pure prevention, no urgent user-facing symptom today.
  Context: Found during the pages/ architecture Performance Review. Recent commit history (4702044, 100e0fe) shows this query list actively growing as new exercise tables are added — worth doing before it compounds further. Could be bundled with the `teacher_dashboard.html` split TODO above since it touches the same file.
