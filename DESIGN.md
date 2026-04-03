# Design System — Tech With Kev

## Product Context
- **What this is:** A tutoring site for secondary school students (math + Python), run by one educator (Kevin Ng). Marketing site + lead generation via interactive assessments.
- **Who it's for:** Secondary/high school students falling behind, and their parents. Singapore context. Deadline-driven — exam season, course prerequisites, grade cutoffs.
- **Space/industry:** Private tutoring, edtech. Peers: Brilliant, Khan Academy, Wyzant. Deliberate positioning against them: solo expert vs. platform/marketplace.
- **Project type:** Marketing site + lead gen assessments (Jekyll, GitHub Pages, static)

## Aesthetic Direction
- **Direction:** Warm Academic — cream paper, strong type, terminal precision for code sections.
- **Decoration level:** Intentional — typography does the heavy lifting; texture comes from the cream background and the contrast between serif headlines and mono code labels.
- **Mood:** Like someone's actual lecture notes, not a startup's marketing site. The kind of tutor you'd trust because they've clearly thought about this more than you have.
- **Key insight:** Every competitor is designed to signal *scale* (millions of students, hundreds of tutors). Kevin is the opposite — one expert, direct relationship, personal access. The design reflects that. No stock photos. No testimonial carousels. Specificity over volume.
- **Reference sites:** Brilliant.org (dark sophistication, "learn by doing"), Stripe early-era (single expert voice, no corporate dilution)

## Typography
- **Display/Hero:** Fraunces (variable, opsz 9–144, wght 300–900) — A variable serif with optical size support. At 72px it has authority; at 24px, personality. The italic at 300 weight paired with upright at 800 is the core typographic move. Signals "individual expert" vs. "corporate platform."
- **Body:** Instrument Sans — clean grotesque with slightly more warmth than Inter. Reads well at 16–17px for long quiz content and body copy.
- **UI/Labels:** DM Mono — quiz answer labels (A/B/C), score counters, section markers, small metadata. Mono = "precise, measurable thing."
- **Code:** JetBrains Mono — all Python snippets, code blocks. Already in use on assessment pages. Non-negotiable for code legibility.
- **Loading:** Google Fonts CDN
  ```
  https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300..900;1,9..144,300..900&family=Instrument+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=DM+Mono:wght@400;500&display=swap
  ```
- **Scale:**
  | Level | Size | Font | Weight |
  |-------|------|------|--------|
  | Hero | clamp(2.4rem, 5vw, 3.75rem) | Fraunces | 800 |
  | Hero italic | clamp(2rem, 4vw, 3rem) | Fraunces italic | 300 |
  | H2 | 1.875rem | Fraunces | 700 |
  | H3 | 1.375rem | Fraunces | 700 |
  | Body | 1.0625rem | Instrument Sans | 400 |
  | UI/Strong | 0.9375rem | Instrument Sans | 600 |
  | Mono/Label | 0.78rem | DM Mono | 500 |
  | Code | 0.9rem | JetBrains Mono | 400 |

## Color
- **Approach:** Restrained — 1 accent (Ember) carries urgency; Cobalt is for links and code only; color is meaningful, not decorative.

| Name | Hex | Role |
|------|-----|------|
| **Chalk** | `#F5F0E8` | Page background — warm cream, not white. Removes sterile screen glare. |
| **Slate** | `#1A1A2E` | Primary text, nav, dark surfaces (assessment pages). Deep navy-black, not pure black. |
| **Ember** | `#E05C20` | Primary CTA, hover states. Warm orange — urgent without being garish. Used sparingly. |
| **Cobalt** | `#2A52CC` | Links, Python syntax highlighting, secondary interactive elements. |
| **Grid** | `#C4BAA8` | Borders, dividers, input outlines. The color of a slightly aged notebook. |
| **Confirm** | `#16A34A` | Correct answers, success states. Reserved — never decorative. |
| **Surface** | `#EDE8DF` | Cards, raised elements, score cards. Slightly darker than Chalk. |
| **Muted** | `#7A7060` | Secondary text, metadata, helper copy. |

- **Dark mode (assessment pages):** Background `#12121F`, surface `#1E1E30`, text `#E8E3D8`, muted `#8888A8`, border `#2E2E44`. Same Ember/Cobalt/Confirm accents — reduce saturation ~10%.

## Spacing
- **Base unit:** 8px
- **Density:** Comfortable — not airy like a marketing-only site, not cramped like a textbook.
- **Scale:** 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96px
- **Section padding:** 4–5rem vertical on desktop, 2.5rem on mobile.

## Layout
- **Approach:** Grid-disciplined. Left-aligned text — not centered-everything.
- **First viewport as a poster:** Big Fraunces headline, one-line subtext, one CTA button. No hero image.
- **Max content width:** 960px (main), 680px (prose/hero copy), 560px (forms/booking)
- **Grid:** 12 columns at 960px+, single column below 640px
- **Border radius:** 4px (badges, inputs) / 6px (buttons) / 8px (small cards) / 10–12px (large cards, mockups)

## Two-Mode Visual Language (deliberate)
The main marketing site uses the cream/warm palette. The assessment pages use a dark surface (`#12121F`). This is intentional — the shift signals "you've entered the practice environment." Same brand colors, different surface.

Implementation: the assessment pages already use dark backgrounds. The back-link (`← techwithkev.github.io`) makes the transition feel deliberate, not broken.

When assessment CTAs link to `book.html` or back to the main site, the cream palette returns.

## Motion
- **Approach:** Minimal-functional — only transitions that aid comprehension.
- **Easing:** enter: `ease-out` / exit: `ease-in` / move: `ease-in-out`
- **Duration:** micro: 100ms / short: 200ms / medium: 300ms
- **Use:** Quiz answer selection flash, score bar fill on results, page-load fade-in for results section. No decorative motion.

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-04-03 | Fraunces as display font | Variable serif signals individual authority vs. grotesque = corporate platform |
| 2026-04-03 | Cream `#F5F0E8` background | Every competitor uses white. Cream reads as deliberate — premium stationery energy. |
| 2026-04-03 | Ember `#E05C20` as primary CTA | Warm orange avoids the generic blue-CTA pattern; creates urgency without aggression |
| 2026-04-03 | Two-mode design (cream main + dark assessments) | Assessment pages already dark — lean into it as a deliberate "practice mode" signal |
| 2026-04-03 | No hero stock photo | Lead with a real score number/proof of activity, not a smiling student |
| 2026-04-03 | Initial design system created | Created by /design-consultation. Research: Brilliant, Wyzant screenshots + competitive analysis. Outside voice: Claude subagent proposed same core direction independently (DM Serif Display → swapped to Fraunces; identical palette rationale). |
