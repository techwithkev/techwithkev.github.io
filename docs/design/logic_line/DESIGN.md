```markdown
# Design System Strategy: The Digital Architect

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Architect."** In the competitive Singaporean edtech landscape, we must move beyond the "friendly cartoon" aesthetic of primary schools and the "stark clinical" look of traditional tuition centers. 

"The Digital Architect" represents a space where mathematical precision meets high-level engineering. The system breaks away from generic templates by utilizing **intentional asymmetry** (mimicking code structures), **high-contrast typographic scales**, and **layered depth**. We are not just building a website; we are building a high-performance environment where logic (Python) and structure (Math) are visualized through sophisticated, editorial layouts.

---

## 2. Colors & Surface Philosophy
This system uses a "Deep Logic" palette. We rely on the profound stability of `primary` (#003345) and the intellectual energy of `tertiary` (#283300/lime accents) to create a premium, expert atmosphere.

### The "No-Line" Rule
To achieve a high-end editorial feel, **1px solid borders are strictly prohibited for sectioning.** Boundaries must be defined solely through background color shifts or subtle tonal transitions.
*   *Example:* A content block using `surface-container-low` (#f3f3f6) should sit directly against a `surface` (#f9f9fc) background. The change in hex value is the "border."

### Surface Hierarchy & Nesting
Treat the UI as physical layers of frosted glass.
*   **Base:** `surface` (#f9f9fc) for the main canvas.
*   **Sectioning:** `surface-container-low` for large content groupings.
*   **Focus Areas:** `surface-container-highest` (#e2e2e5) for sidebars or highlighted data.
*   **The "Glass & Gradient" Rule:** Use Glassmorphism for floating navigation or modal overlays. Utilize `surface-container-lowest` (#ffffff) at 80% opacity with a 12px backdrop-blur.

### Signature Textures
Main CTAs and Hero backgrounds should utilize a subtle linear gradient:
*   **From:** `primary` (#003345)
*   **To:** `primary_container` (#004b63) at a 135-degree angle.
This adds "soul" and depth, preventing the flat, "cheap" feel of single-color blocks.

---

## 3. Typography
We use a high-contrast pairing to balance authority with technical precision.

*   **The Authority (Display & Headline):** **Space Grotesk.** This geometric sans-serif feels mathematical and engineered. 
    *   *Role:* Convey expertise. Use `display-lg` (3.5rem) for hero statements to command the page.
*   **The Engine (Body & Labels):** **Inter.** A workhorse for readability.
    *   *Role:* Instructional clarity. Use `body-md` (0.875rem) for Python code snippets or complex math explanations to ensure no eye strain.

**Hierarchy Tip:** Always pair a `display-md` headline with a `label-md` uppercase sub-header in `secondary` (#006a6a) to create a professional, "white-paper" editorial look.

---

## 4. Elevation & Depth
In this design system, shadows are a last resort, not a default. We prioritize **Tonal Layering.**

*   **The Layering Principle:** To lift a card, place a `surface-container-lowest` card on top of a `surface-container-low` section. The natural contrast creates a "soft lift."
*   **Ambient Shadows:** For floating elements (like a "Book Now" floating button), use:
    *   `box-shadow: 0 20px 40px rgba(0, 31, 43, 0.06);`
    *   *Note:* The shadow color is a tint of `on_primary_fixed`—never pure black.
*   **The "Ghost Border" Fallback:** If accessibility requires a stroke (e.g., in dark mode or high-glare situations), use `outline-variant` (#c0c7cd) at **15% opacity**. It should be felt, not seen.

---

## 5. Components

### Buttons (The Logic Gates)
*   **Primary:** Gradient of `primary` to `primary_container`. `md` (0.375rem) roundedness. Use `on_primary` (#ffffff) for text.
*   **Secondary:** Ghost style. No fill, `outline` token at 20% opacity. Text in `primary`.
*   **States:** On hover, primary buttons should shift +10% in brightness, never change size.

### Cards (The Knowledge Modules)
*   **Style:** No borders. Use `surface-container-lowest` (#ffffff) against a `surface-container` background.
*   **Padding:** Generous `xl` (2rem) internal padding to allow the "Expert" tone to breathe.
*   **Asymmetry:** Use a `0.25rem` accent bar of `tertiary_fixed` (#c8f323) on the left side of cards to represent "Logic/Python."

### Input Fields (The Data Entry)
*   **Style:** `surface-container-low` fill. No border.
*   **Focus:** A 2px bottom-border transition in `secondary` (#006a6a).
*   **Error State:** Use `error` (#ba1a1a) text but keep the background `error_container` (#ffdad6) at 30% opacity.

### Additional Signature Components
*   **Syntax Highlighters:** Custom containers for Python code using `primary` as a background with `tertiary_fixed` for keywords.
*   **Progress Steppers:** Use thick, 4px lines of `surface-variant` that fill with `secondary` as the student completes Math modules.

---

## 6. Do’s and Don’ts

### Do:
*   **Do** use extreme vertical whitespace (120px+) between major home page sections to convey a "Premium" feel.
*   **Do** use the `tertiary_fixed` (Lime) sparingly. It is a "laser pointer"—use it to draw the eye to a "Sign Up" button or a critical deadline.
*   **Do** utilize subtle grid-pattern overlays (2% opacity) in hero sections to reference mathematical graph paper.

### Don’t:
*   **Don't** use 100% black text. Always use `on_surface` (#1a1c1e) for better readability and a softer, high-end feel.
*   **Don't** use standard "drop shadows" on cards. Stick to tonal shifts between surface containers.
*   **Don't** use "rounded-full" (pills) for buttons. Use the `md` (0.375rem) scale to maintain a more "Architectural" and structured appearance.
*   **Don't** use dividers or lines to separate list items. Use 16px of vertical spacing and a `surface` hover state change.