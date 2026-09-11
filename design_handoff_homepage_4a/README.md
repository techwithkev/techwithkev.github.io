# Handoff: Tech With Kev Homepage — Option 4a (Approachable Builder, Blue)

## Overview
Redesigned homepage for techwithkev.com, repositioning the site from 1:1 tutoring to two built courses (Introduction to AI, AI Olympiads Junior) plus Kevin Ng's dual identity as an enterprise AI engineer and 18-year programming educator. This is option "4a": a blue-accented riff of the warm "Approachable Builder" direction — playful, confident, built around the interactive classroom tools as the visual centerpiece.

## About the Design Files
The file in this bundle (`homepage-4a.html`) is a **design reference created in HTML** — a static prototype showing intended look, layout, and copy. It is not production code to copy directly. The task is to **recreate this design in the target codebase's existing environment** (the site is a static Jekyll site — implement as Jekyll layout/includes with plain CSS, matching current build tooling) using established site patterns. If no reusable layout exists yet for this homepage, build new partials following Jekyll conventions.

## Fidelity
**High-fidelity.** Colors, typography, spacing, and copy are final for this option. Recreate pixel-close using the values below; class names and DOM structure can be adapted to fit Jekyll templating.

## Screens / Views
Single page: **Homepage**. Sections top to bottom:

1. **Nav** — wordmark "Tech With Kev" (italic-free, bold Sora) + right-aligned links: Courses, About, Contact. Padding `22px 48px`, background `#F3F5FB`.
2. **Hero** — two-column grid (`1.1fr .9fr`, gap `48px`, padding `96px 48px 64px`).
   - Left: pill badge "AI ENGINEER · TEACHER OF 18 YEARS" (background `#1E4FD9`, white text, `border-radius:100px`, `padding:7px 14px`).
   - H1 (40px/1.24, weight 700, color `#131722`): "Don't just teach your child how to use AI. Teach them how to think with it."
   - Two paragraphs (17px/1.6, color `#57607A`, max-width 520px): "I teach students how AI works, how to use it effectively, and how to build with it." / "I've spent 18 years teaching programming and math, and today I help enterprises put AI and data technology to work. I bring that real-world experience into every lesson."
   - Two CTAs: "See the courses" (dark pill, background `#131722`, text `#F3F5FB`, links to courses section) and "Register interest" (background `#1E4FD9`, white text) — both `border-radius:100px`, `padding:15px 28px`.
   - Right: dark card (`#131722`, `border-radius:20px`, `aspect-ratio:4/3`) labeled "LIVE TOOL PREVIEW" with a circular gradient placeholder (`radial-gradient(circle at 30% 30%,#1E4FD9,#7a3220)`) and caption "Self-attention, visualized". This placeholder should be swapped for a real screenshot/embed of the self-attention tool.
3. **Credibility strip** — full-width dark bar (`#131722`), padding `20px 48px`, flex row: SingleStore, Mirantis, HCL, CA Technologies (left, `rgba(243,245,251,.75)`), and Gemini Certified Educator / CKA / Claude Academy (right, color `#7FA0F5`).
4. **Courses** — padding `80px 48px`. H2: "Two courses. Equal attention." Subhead: "Neither course is running as a live cohort yet. Register your interest and we'll let you know when the next cohort opens." Two-column grid (`1fr 1fr`, gap `24px`), each a white card (`border-radius:20px`, `padding:32px`, `box-shadow:0 8px 24px rgba(19,23,34,.06)`):
   - **Introduction to AI** — "Machine learning and modern AI, from first principles to how large language models work."
   - **AI Olympiads Junior** — "Competitive-programming problem solving for students prepping for CAIO."
   Each card ends with a dark "Register interest" pill button.
5. **Tools** — padding `80px 48px`, white background. H2 "Poke at the tools." Subhead "Three real, already-built activities from the classroom." Three-column grid (gap `20px`), each a rounded card (`border-radius:18px`) with a gradient header block and title/description, wrapped in a link:
   - Self-Attention Visualizer → `https://techwithkev.github.io/pages/aijr/class18_self_attention.html`
   - K-Means Clustering → `https://techwithkev.github.io/pages/aijr/class13_k_means_clustering.html`
   - Movie Recommender — no live link yet; card rendered at `opacity:.65`, copy: "Netflix-style recommendations. Link coming soon."
6. **Quiz banner** — full-width blue bar (`#1E4FD9`), padding `56px 48px`, flex row: heading "How ready are you for AI & logic?" + subcopy, and a dark "Take the quiz →" pill button (link is a placeholder — needs the real quiz URL).
7. **YouTube placeholder** — padding `80px 48px`. H2 "New on YouTube — coming soon." Three dashed-border placeholder tiles (`aspect-ratio:16/9`, `border:2px dashed #c7cede`) labeled "COMING SOON" — intentionally a placeholder section, no video embed required yet.
8. **Testimonial** — dark full-width block (`#131722`), padding `70px 48px`, italic quote placeholder: "Testimonial to come." — swap in a real parent/student quote when available.
9. **Footer** — padding `56px 48px`, flex row: wordmark + final "Register interest" CTA (blue pill).

## Interactions & Behavior
- "See the courses" scrolls to the courses section (in-page anchor).
- "Register interest" (appears 3×: hero, footer, and once per course card) should link to whatever interest-capture mechanism is chosen (simple email form, external form, or mailto — not yet decided; currently a placeholder `#` link).
- Visualizer cards link out to the two existing live tools; the Movie Recommender card has no href yet — leave unclickable (or visually disabled) until a URL exists.
- "Take the quiz →" links to the AI & logic readiness quiz — placeholder URL, needs to be filled in.
- No JS interactivity required on this page itself; it's a static marketing page linking out to existing interactive tools hosted elsewhere on the site.

## State Management
None — fully static content, no client-side state.

## Design Tokens
**Colors**
- Background: `#F3F5FB` (cool off-white)
- Ink / dark panels: `#131722`
- Body text: `#57607A`
- Primary accent (blue): `#1E4FD9`
- Light accent tint: `#7FA0F5`
- White card background: `#fff`
- Placeholder neutrals: `#c7cede`, `#e8ecf7`, `#8b93ac`

**Typography**
- Font family: `'Sora', sans-serif` (Google Fonts, weights 400/500/600/700/800) — the whole page uses one family, weight does the differentiating.
- H1: 40px/1.24, weight 700
- H2 (section headers): 32px/1.2, weight 700
- Body copy: 15–17px/1.6, weight 400
- Buttons/labels: 12–14px, weight 600–700

**Spacing / shape**
- Section horizontal padding: `48px` (nav/hero/sections), `64px` unused here
- Section vertical padding: `56–96px`
- Pill buttons: `border-radius:100px`, `padding:13–16px 24–30px`
- Cards: `border-radius:18–20px`

## Assets
- No custom images used — the "LIVE TOOL PREVIEW" hero panel and the three tool-teaser card headers are CSS gradient placeholders standing in for real screenshots/embeds of the three tools. Replace with actual tool screenshots or thumbnails when available.
- Kevin's portrait was not provided and is not used in this option.

## Files
- `homepage-4a.html` — the full static prototype for this option (open directly in a browser).
