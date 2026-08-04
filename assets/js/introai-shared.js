/* =============================================================
 * Intro to AI — Shared Configuration & Utilities
 * ─────────────────────────────────────────────
 * Loaded by every student activity page in pages/introai/.
 *
 * WHY THIS FILE EXISTS
 * Previously every page duplicated ~6 lines of Supabase config
 * and helper functions. Centralising them here means:
 *   • Credential rotation = edit ONE file, not 40+
 *   • Session storage = student enters name/email ONCE per session
 *   • Common helpers = DRY code, consistent behaviour
 *
 * CREDENTIAL NOTES
 * SUPABASE_KEY is the *anon* JWT — intentionally public.
 * All access control is enforced by Row Level Security
 * policies in Supabase (INSERT + SELECT only for anon).
 * ============================================================= */

/* ── Supabase connection ───────────────────────────────────── */
var SUPABASE_URL = 'https://zhbcjvwkxhkbcmfiplfr.supabase.co';
var SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpoYmNqdndreGhrYmNtZmlwbGZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNjgxNDAsImV4cCI6MjA4OTk0NDE0MH0.aszEBypZLI0ZQbF3g9NdXsbWqRVcXhlZRz4kNiqW-68';

/* ── Shared session keys ───────────────────────────────────── */
// Pages MUST use these keys so students type their details
// only once per browser session (across all activity pages).
var INTROAI_NAME_KEY  = 'introai_student_name';
var INTROAI_EMAIL_KEY = 'introai_student_email';

/* ── Helpers ──────────────────────────────────────────────── */

/**
 * Basic email format check.
 * @param {string} email
 * @returns {boolean}
 */
function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

/**
 * Build the standard Supabase REST headers for the anon role.
 * @param {Object} [extra] - Additional headers to merge in.
 * @returns {Object}
 */
function supabaseHeaders(extra) {
  return Object.assign(
    {
      'Content-Type': 'application/json',
      'apikey': SUPABASE_KEY,
      'Authorization': 'Bearer ' + SUPABASE_KEY
    },
    extra || {}
  );
}

/**
 * Generic Supabase REST fetch wrapper.
 * @param {string} path - Path relative to SUPABASE_URL (e.g. "/rest/v1/my_table")
 * @param {RequestInit} options
 * @returns {Promise<Response>}
 */
function supabaseFetch(path, options) {
  options = options || {};
  options.headers = supabaseHeaders(options.headers);
  return fetch(SUPABASE_URL + path, options);
}

/**
 * INSERT a row (plain insert, no upsert).
 * Throws on HTTP error.
 * @param {string} table
 * @param {Object} payload
 */
async function supabaseInsert(table, payload) {
  var resp = await supabaseFetch('/rest/v1/' + table, {
    method: 'POST',
    headers: { 'Prefer': 'return=minimal' },
    body: JSON.stringify(payload)
  });
  if (!resp.ok) {
    var text = await resp.text();
    throw new Error('HTTP ' + resp.status + ': ' + text);
  }
}

/**
 * UPSERT a row (POST with on_conflict merge).
 * Throws on HTTP error.
 * @param {string} table
 * @param {Object} payload
 * @param {string} [conflictCol='student_email'] - Unique column to conflict on.
 */
async function supabaseUpsert(table, payload, conflictCol) {
  conflictCol = conflictCol || 'student_email';
  var resp = await supabaseFetch(
    '/rest/v1/' + table + '?on_conflict=' + conflictCol,
    {
      method: 'POST',
      headers: { 'Prefer': 'resolution=merge-duplicates,return=minimal' },
      body: JSON.stringify(payload)
    }
  );
  if (!resp.ok) {
    var text = await resp.text();
    throw new Error('HTTP ' + resp.status + ': ' + text);
  }
}

/**
 * SELECT rows from a table.
 * @param {string} table
 * @param {string} queryString - e.g. "student_email=eq.foo%40bar.com"
 * @returns {Promise<Array>}
 */
async function supabaseSelect(table, queryString) {
  var resp = await supabaseFetch('/rest/v1/' + table + '?' + (queryString || ''), {
    method: 'GET'
  });
  if (!resp.ok) {
    var text = await resp.text();
    throw new Error('HTTP ' + resp.status + ': ' + text);
  }
  return resp.json();
}

/**
 * PATCH (partial update) rows matching a query.
 * @param {string} table
 * @param {string} queryString - Row filter, e.g. "student_email=eq.foo%40bar.com"
 * @param {Object} payload
 */
async function supabasePatch(table, queryString, payload) {
  var resp = await supabaseFetch('/rest/v1/' + table + '?' + queryString, {
    method: 'PATCH',
    headers: { 'Prefer': 'return=minimal' },
    body: JSON.stringify(payload)
  });
  if (!resp.ok) {
    var text = await resp.text();
    throw new Error('HTTP ' + resp.status + ': ' + text);
  }
}

/**
 * Read the shared student name/email from sessionStorage.
 * @returns {{ name: string, email: string }}
 */
function getStudentSession() {
  return {
    name:  sessionStorage.getItem(INTROAI_NAME_KEY)  || '',
    email: sessionStorage.getItem(INTROAI_EMAIL_KEY) || ''
  };
}

/**
 * Persist the student name/email to the shared session keys.
 * @param {string} name
 * @param {string} email
 */
function saveStudentSession(name, email) {
  sessionStorage.setItem(INTROAI_NAME_KEY,  name);
  sessionStorage.setItem(INTROAI_EMAIL_KEY, email);
}
