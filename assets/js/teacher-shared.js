/* =============================================================
 * Teacher Shared — Supabase Config & Utilities
 * ─────────────────────────────────────────────
 * Single source of truth for the teacher dashboard pages.
 *
 * Import this FIRST in every pages/teacher/*.html file:
 *   <script src="../../assets/js/teacher-shared.js"></script>
 *   (or "../_shared/teacher-config.js" from pages/teacher/_shared/)
 *
 * PROVIDES
 *  • TEACHER_SUPABASE_URL / TEACHER_SUPABASE_KEY  – credentials
 *  • createTeacherClient()  – Supabase JS v2 client (cached singleton)
 *  • getTeacherSession()    – returns current auth session or null
 *  • requireTeacherAuth()   – redirects to login if not authenticated
 *  • TeacherAuth.login/logout – auth helpers
 *  • buildCohortCascade()   – populates course → cohort → class dropdowns
 *  • teacherFetch()         – authenticated REST fetch wrapper
 *
 * CREDENTIAL NOTES
 *   TEACHER_SUPABASE_KEY is the anon JWT — intentionally public.
 *   Teacher authentication is enforced by Supabase Auth (email/password).
 *   All sensitive teacher operations use Row Level Security on authenticated role.
 * ============================================================= */

/* ── Credentials ───────────────────────────────────────────── */
var TEACHER_SUPABASE_URL = 'https://zhbcjvwkxhkbcmfiplfr.supabase.co';
var TEACHER_SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpoYmNqdndreGhrYmNtZmlwbGZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNjgxNDAsImV4cCI6MjA4OTk0NDE0MH0.aszEBypZLI0ZQbF3g9NdXsbWqRVcXhlZRz4kNiqW-68';

/* ── Supabase Client (cached singleton) ────────────────────── */
var _teacherClient = null;

/**
 * Returns the shared Supabase JS v2 client.
 * Requires the Supabase CDN script to be loaded before this file.
 */
function createTeacherClient() {
  if (_teacherClient) return _teacherClient;
  if (typeof supabase === 'undefined' || typeof supabase.createClient !== 'function') {
    throw new Error('[teacher-shared] Supabase JS not loaded. Add the CDN script before teacher-shared.js.');
  }
  _teacherClient = supabase.createClient(TEACHER_SUPABASE_URL, TEACHER_SUPABASE_KEY, {
    auth: { persistSession: true }
  });
  return _teacherClient;
}

/* ── Auth Helpers ──────────────────────────────────────────── */

/**
 * Returns the current Supabase auth session, or null if not signed in.
 * @returns {Promise<import('@supabase/supabase-js').Session|null>}
 */
async function getTeacherSession() {
  var sb = createTeacherClient();
  var { data } = await sb.auth.getSession();
  return data.session || null;
}

/**
 * Checks auth; if not signed in, shows the loginEl and hides the contentEl.
 * Returns true if authenticated, false otherwise.
 * @param {HTMLElement} loginEl   - The login gate element to show/hide.
 * @param {HTMLElement} contentEl - The main content to show when authed.
 */
async function requireTeacherAuth(loginEl, contentEl) {
  var session = await getTeacherSession();
  if (session) {
    if (loginEl)   loginEl.classList.add('hidden');
    if (contentEl) contentEl.classList.remove('hidden');
    return true;
  } else {
    if (loginEl)   loginEl.classList.remove('hidden');
    if (contentEl) contentEl.classList.add('hidden');
    return false;
  }
}

/**
 * Teacher auth namespace — login + logout convenience.
 */
var TeacherAuth = {
  /**
   * Signs in with email + password.
   * @param {string} email
   * @param {string} password
   * @returns {Promise<{ user: object|null, error: string|null }>}
   */
  async login(email, password) {
    var sb = createTeacherClient();
    var { data, error } = await sb.auth.signInWithPassword({ email, password });
    if (error) return { user: null, error: error.message };
    return { user: data.user, error: null };
  },

  /**
   * Signs out the current teacher.
   */
  async logout() {
    var sb = createTeacherClient();
    await sb.auth.signOut();
  }
};

/* ── Cohort Cascade Selector ───────────────────────────────── */

/**
 * Populates a three-level cascade of <select> dropdowns:
 *   course → cohort → class (optional)
 *
 * Usage:
 *   await buildCohortCascade({
 *     courseSelect:  document.getElementById('course-select'),
 *     cohortSelect:  document.getElementById('cohort-select'),
 *     classSelect:   document.getElementById('class-select'),   // optional
 *     onCohortChange: (cohortId) => loadData(cohortId),
 *     onClassChange:  (classId)  => loadClassData(classId),
 *   });
 *
 * @param {Object} opts
 */
async function buildCohortCascade(opts) {
  var sb = createTeacherClient();
  var { courseSelect, cohortSelect, classSelect, onCohortChange, onClassChange } = opts;

  // Load courses
  var { data: courses } = await sb
    .from('courses')
    .select('id, slug, name')
    .eq('is_active', true)
    .order('name');

  if (!courses || !courses.length) {
    if (courseSelect) courseSelect.innerHTML = '<option value="">No courses found</option>';
    return;
  }

  // Populate course dropdown
  if (courseSelect) {
    courseSelect.innerHTML = courses.map(c =>
      `<option value="${c.id}" data-slug="${c.slug}">${c.name}</option>`
    ).join('');
  }

  /**
   * Load cohorts for a given course_id.
   */
  async function loadCohorts(courseId) {
    var { data: cohorts } = await sb
      .from('cohorts')
      .select('id, slug, name, term')
      .eq('course_id', courseId)
      .eq('is_active', true)
      .order('term', { ascending: false });

    if (!cohorts || !cohorts.length) {
      if (cohortSelect) cohortSelect.innerHTML = '<option value="">No cohorts found</option>';
      return;
    }

    if (cohortSelect) {
      cohortSelect.innerHTML = cohorts.map(c =>
        `<option value="${c.id}">${c.name}${c.term ? ' (' + c.term + ')' : ''}</option>`
      ).join('');
    }

    // Trigger initial cohort load
    var firstCohortId = cohorts[0].id;
    if (onCohortChange) onCohortChange(firstCohortId);
    if (classSelect) await loadClasses(firstCohortId);
  }

  /**
   * Load classes for a given cohort_id.
   */
  async function loadClasses(cohortId) {
    if (!classSelect) return;
    var { data: classes } = await sb
      .from('classes')
      .select('id, label, sequence_order')
      .eq('cohort_id', cohortId)
      .eq('is_active', true)
      .order('sequence_order');

    if (!classes || !classes.length) {
      classSelect.innerHTML = '<option value="">All classes</option>';
      return;
    }

    classSelect.innerHTML = '<option value="">All classes</option>' +
      classes.map(cl => `<option value="${cl.id}">${cl.label}</option>`).join('');
  }

  // Wire up event listeners
  if (courseSelect) {
    courseSelect.addEventListener('change', () => loadCohorts(courseSelect.value));
  }

  if (cohortSelect) {
    cohortSelect.addEventListener('change', () => {
      var cohortId = cohortSelect.value;
      if (onCohortChange) onCohortChange(cohortId);
      if (classSelect) loadClasses(cohortId);
    });
  }

  if (classSelect) {
    classSelect.addEventListener('change', () => {
      if (onClassChange) onClassChange(classSelect.value || null);
    });
  }

  // Initial load
  if (courseSelect && courseSelect.value) {
    await loadCohorts(courseSelect.value);
  } else if (courses.length) {
    await loadCohorts(courses[0].id);
  }
}

/* ── Authenticated REST Fetch ──────────────────────────────── */

/**
 * Builds Supabase REST headers for the authenticated teacher session.
 * Falls back to anon key if not signed in (for read-only operations).
 * @param {Object} [extra] - Additional headers.
 * @returns {Promise<Object>}
 */
async function teacherHeaders(extra) {
  var sb = createTeacherClient();
  var session = await getTeacherSession();
  var token = session ? session.access_token : TEACHER_SUPABASE_KEY;
  return Object.assign({
    'Content-Type': 'application/json',
    'apikey':        TEACHER_SUPABASE_KEY,
    'Authorization': 'Bearer ' + token
  }, extra || {});
}

/**
 * Authenticated Supabase REST fetch wrapper.
 * @param {string} path - REST path, e.g. "/rest/v1/cohorts"
 * @param {RequestInit} options
 * @returns {Promise<Response>}
 */
async function teacherFetch(path, options) {
  options = options || {};
  options.headers = await teacherHeaders(options.headers);
  return fetch(TEACHER_SUPABASE_URL + path, options);
}
