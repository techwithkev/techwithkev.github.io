# TODOs

## Owner actions required (blocked on external accounts)

These are placeholder values in the code that need real IDs before the funnel is fully live.

| # | File | Line | Find | Replace with |
|---|------|------|------|-------------|
| 1 | `pages/book.html` | 95 | `YOUR_CALENDLY_URL` | Your Calendly event link (e.g. `https://calendly.com/techwithkev/60min`) |
| 2 | `pages/book.html` | 117 | `YOUR_STRIPE_PAYMENT_LINK` | Your Stripe payment link URL |
| 3 | `pages/python_functions.html` | 2174 | `YOUR_FORM_UID/YOUR_EMBED_ID.js` | ConvertKit embed script URL (from ConvertKit → Forms → Embed → HTML/JS tab) |
| 4 | `pages/g9_math_prerequisite_assessment.html` | 1769 | `YOUR_FORM_UID/YOUR_EMBED_ID.js` | ConvertKit embed script URL (same form as above) |
| 5 | `contact.md` | 10 | `YOUR_FORM_ID` | Formspree form ID (from formspree.io dashboard) |

## Setup checklist

- [ ] Create Calendly account → set up "60-min Tutoring Session" event → copy event link
- [ ] Create Stripe payment link for a 1-on-1 session → copy URL
- [ ] Sign up for ConvertKit → create a form → go to Embed → copy the JS script `src` URL
- [ ] Sign up for Formspree → create a form → copy the form ID from the action URL

## Deferred (not blocking launch)

- Fix G9 Math answer key: `q13` explanation contradicts the `correct` field (says A but walks through to C)
- Brand identity: assessment pages use a different visual language from the main site (dark theme vs white)
