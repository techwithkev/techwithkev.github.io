/* =============================================================
 * Intro to AI — Shared Configuration & Utilities  (v2)
 * ─────────────────────────────────────────────
 * Loaded by every student activity page in pages/introai/ and pages/aijr/.
 *
 * WHY THIS FILE EXISTS
 *   • Credential rotation = edit ONE file, not 40+
 *   • Session storage = student enters name/email + access code ONCE per session
 *   • Common helpers = DRY code, consistent behaviour
 *   • submitExercise() = unified write path to exercise_submissions (v2 schema)
 *
 * CREDENTIAL NOTES
 *   SUPABASE_KEY is the *anon* JWT — intentionally public.
 *   All access control is enforced by Row Level Security in Supabase.
 *
 * v2 CHANGES (backward compatible)
 *   • New session keys: INTROAI_ACCESS_CODE_KEY, INTROAI_COHORT_ID_KEY
 *   • New: validateAccessCode(code)    — validates code, returns cohort_id
 *   • New: registerStudentSession()    — upserts into student_sessions
 *   • New: submitExercise(slug, data)  — writes to exercise_submissions
 *   • Kept: supabaseInsert/Upsert/Select/Patch for legacy page compat
 * ============================================================= */

/* ── Supabase connection ───────────────────────────────────── */
var SUPABASE_URL = 'https://zhbcjvwkxhkbcmfiplfr.supabase.co';
var SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpoYmNqdndreGhrYmNtZmlwbGZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNjgxNDAsImV4cCI6MjA4OTk0NDE0MH0.aszEBypZLI0ZQbF3g9NdXsbWqRVcXhlZRz4kNiqW-68';

/* ── Session Storage Keys ──────────────────────────────────── */
// v1 keys — kept for backward compatibility
var INTROAI_NAME_KEY         = 'introai_student_name';
var INTROAI_EMAIL_KEY        = 'introai_student_email';
// v2 keys — added for access code + cohort identity
var INTROAI_ACCESS_CODE_KEY  = 'introai_access_code';
var INTROAI_COHORT_ID_KEY    = 'introai_cohort_id';
var INTROAI_COURSE_SLUG_KEY  = 'introai_course_slug';

/* ── Exercise definition cache ─────────────────────────────── */
// exercise_slug → exercise_id lookup, populated on first call to submitExercise()
var _exerciseDefCache = null;

/* ════════════════════════════════════════════════════════════
 * CORE SESSION HELPERS
 * ════════════════════════════════════════════════════════════ */

/**
 * Basic email format check.
 * @param {string} email
 * @returns {boolean}
 */
function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

/**
 * Read the shared student session from sessionStorage.
 * @returns {{ name: string, email: string, accessCode: string, cohortId: string|null, courseSlug: string }}
 */
function getStudentSession() {
  return {
    name:       sessionStorage.getItem(INTROAI_NAME_KEY)        || '',
    email:      sessionStorage.getItem(INTROAI_EMAIL_KEY)       || '',
    accessCode: sessionStorage.getItem(INTROAI_ACCESS_CODE_KEY) || '',
    cohortId:   sessionStorage.getItem(INTROAI_COHORT_ID_KEY)   || null,
    courseSlug: sessionStorage.getItem(INTROAI_COURSE_SLUG_KEY) || ''
  };
}

/**
 * Persist the student session to shared session keys.
 * @param {string} name
 * @param {string} email
 * @param {string} [accessCode]
 * @param {string|number} [cohortId]
 * @param {string} [courseSlug]
 */
function saveStudentSession(name, email, accessCode, cohortId, courseSlug) {
  sessionStorage.setItem(INTROAI_NAME_KEY,  name);
  sessionStorage.setItem(INTROAI_EMAIL_KEY, email);
  if (accessCode !== undefined) sessionStorage.setItem(INTROAI_ACCESS_CODE_KEY, accessCode);
  if (cohortId   !== undefined) sessionStorage.setItem(INTROAI_COHORT_ID_KEY,   String(cohortId));
  if (courseSlug !== undefined) sessionStorage.setItem(INTROAI_COURSE_SLUG_KEY, courseSlug);
}

/* ════════════════════════════════════════════════════════════
 * SUPABASE REST HELPERS  (v1 — kept for legacy page compatibility)
 * ════════════════════════════════════════════════════════════ */

/**
 * Build standard Supabase REST headers.
 * @param {Object} [extra]
 * @returns {Object}
 */
function supabaseHeaders(extra) {
  return Object.assign({
    'Content-Type': 'application/json',
    'apikey':        SUPABASE_KEY,
    'Authorization': 'Bearer ' + SUPABASE_KEY
  }, extra || {});
}

/**
 * Generic Supabase REST fetch.
 * @param {string} path
 * @param {RequestInit} options
 * @returns {Promise<Response>}
 */
function supabaseFetch(path, options) {
  options = options || {};
  options.headers = supabaseHeaders(options.headers);
  return fetch(SUPABASE_URL + path, options);
}

/**
 * INSERT a row into a legacy per-exercise table.
 * @deprecated Use submitExercise() for new exercises.
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
 * UPSERT a row into a legacy table.
 * @deprecated Use submitExercise() for new exercises.
 * @param {string} conflictCol - Defaults to 'student_email'.
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
 * @param {string} queryString - Row filter, e.g. "student_email=eq.foo%40bar.com"
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

/* ════════════════════════════════════════════════════════════
 * v2 ACCESS CODE + SUBMISSION HELPERS
 * ════════════════════════════════════════════════════════════ */

/**
 * Validates an access code against the new `access_codes` table.
 * If valid, returns the cohort info; if invalid, returns null.
 *
 * Side effects:
 *   • Increments uses_count on the access_codes row.
 *   • Does NOT save session — call saveStudentSession() separately.
 *
 * @param {string} code - The raw code the student typed.
 * @returns {Promise<{cohortId: number, cohortName: string, courseSlug: string}|null>}
 */
async function validateAccessCode(code) {
  if (!code || !code.trim()) return null;
  var upper = code.trim().toUpperCase();

  // Fetch the code row + cohort info
  var resp = await supabaseFetch(
    '/rest/v1/access_codes' +
    '?code=eq.' + encodeURIComponent(upper) +
    '&is_active=eq.true' +
    '&select=id,cohort_id,uses_count,max_uses,cohorts(id,name,term,courses(slug,name))',
    { method: 'GET' }
  );
  if (!resp.ok) return null;

  var rows = await resp.json();
  if (!rows || !rows.length) return null;

  var row = rows[0];
  if (row.uses_count >= row.max_uses) return null; // code exhausted

  var cohort = row.cohorts;
  if (!cohort) return null;

  // Increment uses_count (best-effort, non-blocking)
  supabaseFetch('/rest/v1/access_codes?id=eq.' + row.id, {
    method: 'PATCH',
    headers: { 'Prefer': 'return=minimal' },
    body: JSON.stringify({ uses_count: row.uses_count + 1 })
  }).catch(() => {}); // ignore error — usage tracking is non-critical

  return {
    cohortId:   cohort.id,
    cohortName: cohort.name,
    courseSlug: cohort.courses ? cohort.courses.slug : ''
  };
}

/**
 * Upserts a row in `student_sessions` for the current student.
 * Should be called after validateAccessCode() and saveStudentSession().
 *
 * @param {string} studentEmail
 * @param {string} studentName
 * @param {number} cohortId
 * @param {string} accessCode
 * @returns {Promise<void>}
 */
async function registerStudentSession(studentEmail, studentName, cohortId, accessCode) {
  var now = new Date().toISOString();
  await supabaseFetch(
    '/rest/v1/student_sessions?on_conflict=student_email,cohort_id',
    {
      method: 'POST',
      headers: { 'Prefer': 'resolution=merge-duplicates,return=minimal' },
      body: JSON.stringify({
        student_email:  studentEmail,
        student_name:   studentName,
        cohort_id:      cohortId,
        access_code:    accessCode,
        last_seen_at:   now
      })
    }
  );
}

/**
 * Loads and caches the exercise_definitions for the given course slug.
 * Returns a Map: exercise_slug → exercise_id.
 *
 * @param {string} courseSlug - e.g. 'introai' | 'aijr'
 * @returns {Promise<Map<string, number>>}
 */
async function _loadExerciseDefs(courseSlug) {
  if (_exerciseDefCache && _exerciseDefCache._courseSlug === courseSlug) {
    return _exerciseDefCache;
  }

  var resp = await supabaseFetch(
    '/rest/v1/exercise_definitions' +
    '?select=id,exercise_slug&courses(slug)=eq.' + encodeURIComponent(courseSlug),
    { method: 'GET' }
  );

  // Fallback: fetch via join
  if (!resp.ok) {
    resp = await supabaseFetch(
      '/rest/v1/exercise_definitions' +
      '?select=id,exercise_slug,course_id,courses!inner(slug)' +
      '&courses.slug=eq.' + encodeURIComponent(courseSlug),
      { method: 'GET' }
    );
  }

  var defs = resp.ok ? await resp.json() : [];
  var map = new Map();
  (defs || []).forEach(d => map.set(d.exercise_slug, d.id));
  map._courseSlug = courseSlug;
  _exerciseDefCache = map;
  return map;
}

/**
 * Submits an exercise response to the unified `exercise_submissions` table.
 *
 * This is the PRIMARY submission function for all v2 student pages.
 * It resolves the exercise_slug → exercise_id automatically.
 *
 * @param {string} exerciseSlug - e.g. 'week07_spot_the_bias'
 * @param {Object} exercisePayload - All exercise-specific fields as a plain object.
 * @param {Object} [opts]
 * @param {number} [opts.enjoymentRating] - Optional 1–5 enjoyment score.
 * @param {string} [opts.overrideEmail]   - Override student email (default: from session).
 * @param {string} [opts.overrideName]    - Override student name (default: from session).
 * @returns {Promise<void>}
 * @throws {Error} If session is missing, code is invalid, or exercise not found.
 */
async function submitExercise(exerciseSlug, exercisePayload, opts) {
  opts = opts || {};

  // 1. Get current session
  var session = getStudentSession();
  var studentEmail = opts.overrideEmail || session.email;
  var studentName  = opts.overrideName  || session.name;
  var cohortId     = session.cohortId   ? Number(session.cohortId) : null;
  var courseSlug   = session.courseSlug || 'introai';

  if (!studentEmail || !studentName) {
    throw new Error('No student session. Complete registration before submitting.');
  }
  if (!cohortId) {
    throw new Error('No cohort assigned. Please enter a valid access code first.');
  }

  // 2. Resolve exercise_slug → exercise_id
  var defs = await _loadExerciseDefs(courseSlug);

  // PostgREST join syntax: try direct fetch if cache failed
  if (!defs.has(exerciseSlug)) {
    var fallback = await supabaseFetch(
      '/rest/v1/exercise_definitions?exercise_slug=eq.' + encodeURIComponent(exerciseSlug) +
      '&select=id,exercise_slug',
      { method: 'GET' }
    );
    if (fallback.ok) {
      var rows = await fallback.json();
      if (rows && rows.length) defs.set(rows[0].exercise_slug, rows[0].id);
    }
  }

  var exerciseId = defs.get(exerciseSlug);
  if (!exerciseId) {
    throw new Error('Exercise "' + exerciseSlug + '" not found in exercise_definitions. Add it to the seed SQL.');
  }

  // 3. Build submission row
  var row = {
    exercise_id:      exerciseId,
    cohort_id:        cohortId,
    student_email:    studentEmail,
    student_name:     studentName,
    payload:          exercisePayload,
    submitted_at:     new Date().toISOString()
  };
  if (opts.enjoymentRating) row.enjoyment_rating = opts.enjoymentRating;

  // 4. Upsert into exercise_submissions (conflict = exercise_id + student_email)
  var resp = await supabaseFetch(
    '/rest/v1/exercise_submissions?on_conflict=exercise_id,student_email',
    {
      method: 'POST',
      headers: { 'Prefer': 'resolution=merge-duplicates,return=minimal' },
      body: JSON.stringify(row)
    }
  );

  if (!resp.ok) {
    var text = await resp.text();
    throw new Error('Submission failed (HTTP ' + resp.status + '): ' + text);
  }
}

/**
 * Retrieves a student's own submission for a given exercise.
 *
 * @param {string} exerciseSlug
 * @returns {Promise<Object|null>} The submission row, or null if not found.
 */
async function getMySubmission(exerciseSlug) {
  var session = getStudentSession();
  if (!session.email) return null;

  var defs = await _loadExerciseDefs(session.courseSlug || 'introai');
  var exerciseId = defs.get(exerciseSlug);
  if (!exerciseId) return null;

  var rows = await supabaseSelect(
    'exercise_submissions',
    'exercise_id=eq.' + exerciseId +
    '&student_email=eq.' + encodeURIComponent(session.email) +
    '&limit=1'
  );
  return rows && rows.length ? rows[0] : null;
}

/* ════════════════════════════════════════════════════════════
 * STANDARD ACCESS CODE REGISTRATION GATE
 *
 * Call mountAccessCodeGate() to inject and manage the standard
 * three-field registration overlay (name + email + access code).
 * Used by all v2 student pages in place of the old name/email gate.
 * ════════════════════════════════════════════════════════════ */

/**
 * Mounts the standard registration gate overlay.
 *
 * If the student already has a valid session (name + email + cohortId),
 * the gate is skipped and onSuccess is called immediately.
 *
 * @param {Object} opts
 * @param {string}   opts.courseSlug      - 'introai' | 'aijr'
 * @param {Function} opts.onSuccess       - Called with {name, email, cohortId} on completion.
 * @param {string}  [opts.overlayId]      - ID of overlay element (default: 'registration-overlay')
 * @param {string}  [opts.title]          - Overlay title text.
 * @param {string}  [opts.subtitle]       - Overlay subtitle text.
 */
function mountAccessCodeGate(opts) {
  opts = opts || {};
  var courseSlug = opts.courseSlug || 'introai';
  var overlayId  = opts.overlayId  || 'registration-overlay';

  // Check for existing valid session
  var session = getStudentSession();
  if (session.name && session.email && session.cohortId) {
    if (opts.onSuccess) opts.onSuccess(session);
    return;
  }

  // Render overlay
  var overlay = document.getElementById(overlayId);
  if (!overlay) {
    overlay = document.createElement('div');
    overlay.id = overlayId;
    document.body.appendChild(overlay);
  }

  var title    = opts.title    || 'Welcome! Let\'s get started.';
  var subtitle = opts.subtitle || 'Enter your details and class access code to begin.';

  overlay.innerHTML = `
    <div style="
      position:fixed;inset:0;z-index:9999;
      display:flex;align-items:center;justify-content:center;
      background:rgba(10,12,20,0.88);backdrop-filter:blur(6px);
      font-family:Outfit,system-ui,sans-serif;
    ">
      <div style="
        background:#fff;border-radius:20px;padding:40px 36px;
        width:100%;max-width:440px;box-shadow:0 32px 80px rgba(0,0,0,0.3);
        margin:16px;
      ">
        <h2 style="margin:0 0 6px;font-size:1.4rem;font-weight:800;color:#1a1a2e;">${title}</h2>
        <p style="margin:0 0 24px;font-size:0.875rem;color:#6b7280;">${subtitle}</p>
        <div id="reg-error" style="display:none;margin-bottom:12px;padding:10px 14px;background:#fef2f2;border:1px solid #fecaca;border-radius:10px;font-size:0.8rem;color:#dc2626;"></div>
        <div style="display:flex;flex-direction:column;gap:12px;">
          <input id="reg-name"  type="text"     placeholder="Your full name"       maxlength="80"
            style="padding:12px 14px;border:1.5px solid #e5e7eb;border-radius:10px;font-size:0.9rem;font-family:inherit;outline:none;" />
          <input id="reg-email" type="email"    placeholder="Your email address"   maxlength="120"
            style="padding:12px 14px;border:1.5px solid #e5e7eb;border-radius:10px;font-size:0.9rem;font-family:inherit;outline:none;" />
          <input id="reg-code"  type="text"     placeholder="Class access code (e.g. AIJR26)" maxlength="20"
            style="padding:12px 14px;border:1.5px solid #e5e7eb;border-radius:10px;font-size:0.9rem;font-family:inherit;outline:none;text-transform:uppercase;letter-spacing:0.08em;" />
          <button id="reg-submit" onclick="_handleRegistration('${courseSlug}')"
            style="
              padding:13px;background:linear-gradient(135deg,#6366f1,#8b5cf6);
              color:#fff;font-size:0.95rem;font-weight:700;border:none;
              border-radius:12px;cursor:pointer;font-family:inherit;
              transition:opacity 0.15s;
            "
            onmouseover="this.style.opacity='0.88'"
            onmouseout="this.style.opacity='1'"
          >Start Activity →</button>
        </div>
        <p style="margin:16px 0 0;font-size:0.75rem;color:#9ca3af;text-align:center;">
          Your name and email are only used to save your work and share it with your teacher.
        </p>
      </div>
    </div>
  `;

  // Store the callback for the inline handler to call
  window._registrationCallback = opts.onSuccess;

  // Allow Enter key on code input
  var codeInput = document.getElementById('reg-code');
  if (codeInput) {
    codeInput.addEventListener('keydown', function(e) {
      if (e.key === 'Enter') _handleRegistration(courseSlug);
    });
  }
}

/**
 * Internal handler for the registration gate form submission.
 * Called by the inline onclick on the gate button.
 * @param {string} courseSlug
 */
async function _handleRegistration(courseSlug) {
  var nameInput  = document.getElementById('reg-name');
  var emailInput = document.getElementById('reg-email');
  var codeInput  = document.getElementById('reg-code');
  var errorDiv   = document.getElementById('reg-error');
  var submitBtn  = document.getElementById('reg-submit');

  var name  = nameInput  ? nameInput.value.trim()  : '';
  var email = emailInput ? emailInput.value.trim()  : '';
  var code  = codeInput  ? codeInput.value.trim().toUpperCase() : '';

  function showError(msg) {
    if (errorDiv) { errorDiv.textContent = msg; errorDiv.style.display = 'block'; }
  }
  function clearError() {
    if (errorDiv) errorDiv.style.display = 'none';
  }

  clearError();

  if (!name)              return showError('Please enter your full name.');
  if (!validateEmail(email)) return showError('Please enter a valid email address.');
  if (!code)              return showError('Please enter the class access code given by your teacher.');

  if (submitBtn) { submitBtn.disabled = true; submitBtn.textContent = 'Checking code…'; }

  try {
    var result = await validateAccessCode(code);

    if (!result) {
      showError('Access code "' + code + '" is not valid or has expired. Check with your teacher.');
      if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = 'Start Activity →'; }
      return;
    }

    // Save session
    saveStudentSession(name, email, code, result.cohortId, courseSlug);

    // Register in student_sessions (best-effort)
    registerStudentSession(email, name, result.cohortId, code).catch(() => {});

    // Remove overlay
    var overlay = document.getElementById('registration-overlay');
    if (overlay) overlay.remove();

    // Invoke caller's success callback
    if (window._registrationCallback) {
      window._registrationCallback({ name, email, cohortId: result.cohortId, courseSlug });
      window._registrationCallback = null;
    }

  } catch (err) {
    showError('Something went wrong. Please try again. (' + (err.message || 'network error') + ')');
    if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = 'Start Activity →'; }
  }
}
