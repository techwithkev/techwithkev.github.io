// Regression test for the auth-bypass bug fixed in supabase/functions/ai-dashboard/index.ts
// (commit 4702044 removed the client-side sign-in gate; the edge function itself never
// rejected on auth failure, just console.warn'd, so anyone could call the paid Groq-backed
// endpoint with no session — see TODOS.md "From /plan-eng-review" for full context).
//
// This hits the live deployed edge function directly (no staging environment exists for
// this project), matching how every other credential in this repo is used against prod.

const { test, expect } = require('@playwright/test');

const SUPABASE_URL = 'https://zhbcjvwkxhkbcmfiplfr.supabase.co';
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpoYmNqdndreGhrYmNtZmlwbGZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNjgxNDAsImV4cCI6MjA4OTk0NDE0MH0.aszEBypZLI0ZQbF3g9NdXsbWqRVcXhlZRz4kNiqW-68';
const EDGE_FUNCTION_URL = `${SUPABASE_URL}/functions/v1/ai-dashboard`;

test.describe('ai-dashboard edge function auth', () => {
  test('rejects a request with no Authorization header', async ({ request }) => {
    const res = await request.post(EDGE_FUNCTION_URL, {
      headers: { 'Content-Type': 'application/json', apikey: SUPABASE_ANON },
      data: { action: 'student_analyzer', payload: {} },
    });

    // Supabase's own gateway intercepts a fully-missing Authorization header before
    // it reaches the function code, so this checks platform-level rejection rather
    // than the function's own auth check (covered by the test below).
    expect(res.status()).toBe(401);
    const body = await res.json();
    expect(body.code || body.message || body.error).toMatch(/unauthoriz|missing/i);
  });

  test('rejects the public anon key used as a bearer token (no real user session)', async ({ request }) => {
    const res = await request.post(EDGE_FUNCTION_URL, {
      headers: {
        'Content-Type': 'application/json',
        apikey: SUPABASE_ANON,
        Authorization: `Bearer ${SUPABASE_ANON}`,
      },
      data: { action: 'student_analyzer', payload: {} },
    });

    expect(res.status()).toBe(401);
    const body = await res.json();
    expect(body.error).toMatch(/unauthorized|sign in/i);
  });
});
