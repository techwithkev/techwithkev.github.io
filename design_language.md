# Design Language System

## 1. Design Philosophy
The design language is modern, clean, and data-focused. It relies heavily on ample whitespace, soft rounded corners, subtle borders, and semantic color cues. It is designed to make complex interactive visualizers and data dashboards feel approachable, game-like, and easy to read.

## 2. Color Palette

### Neutrals (Backgrounds & Borders)
- **App Background:** `bg-gray-50` (#F9FAFB) - Used for the main body background to provide a soft contrast against white cards.
- **Card/Component Background:** `bg-white` (#FFFFFF) - Used for content containers.
- **Subtle Backgrounds:** `bg-gray-100` (#F3F4F6), `bg-gray-200` (#E5E7EB) - Used for secondary buttons, slider tracks, inactive components, and borders.
- **Borders:** `border-gray-200` (#E5E7EB) - Applied universally to cards, inputs, and container edges to define boundaries softly.

### Typography Colors
- **Primary Text:** `text-gray-900` (#111827) - Main headings and standard text.
- **Secondary Text:** `text-gray-500` (#6B7280) - Subtitles, descriptions, and less important labels.
- **Tertiary/Micro Text:** `text-gray-400` (#9CA3AF) - Uppercase tiny labels and structural indicators.

### Semantic & Accent Colors
- **Primary Accent (Blue):** `text-blue-600`, `bg-blue-600`, `border-blue-500` - Used for primary actions, current values, main data visualization bars, and emphasis.
- **Success/Reward (Green):** `text-green-600`, `bg-green-50`, `border-green-200` - Represents positive outcomes, rewards, and exploiting behavior.
- **Error/Regret (Red):** `text-red-500`, `bg-red-500`, `text-red-600` - Represents losses, regret, and negative outcomes.
- **Warning/Exploration (Amber):** `bg-amber-50`, `text-amber-800` - Used to indicate exploration or non-standard transient states.

## 3. Typography

The system uses standard sans-serif fonts (`font-sans`) paired with monospaced fonts (`font-mono`) for data elements, creating a clear distinction between structural text and analytical values.

### Headings
- **Page Titles:** `text-4xl font-black tracking-tight text-gray-900`. Heavily weighted and tightly tracked for high impact.
- **Subtitles:** `text-gray-500 font-medium italic`. Softer contrast to the bold titles.

### Data & Numbers
- **Large Metrics:** `text-4xl font-mono font-black`. Monospace ensures numbers align beautifully and feel analytical.
- **Small Metrics:** `text-2xl font-mono font-bold`.

### Labels & Microcopy
- **Overhead Labels:** `text-xs font-bold text-gray-400 uppercase mb-1`. Used above data points.
- **Tiny Indicators:** `text-[10px] font-black uppercase tracking-widest text-gray-500`. Often used for specific IDs or badges.
- **Tracking:** Heavy use of `tracking-widest` for pill badges and `tracking-tighter` for compact visualizer labels.

## 4. Layout, Spacing & Shapes

### Spacing & Grid
- **Page Container:** `max-w-5xl mx-auto p-4 md:p-8`. Constrains line lengths and centers the application, ensuring it does not stretch excessively on large monitors.
- **Component Gaps:** Extensive use of CSS Grid (`grid-cols-1 md:grid-cols-3`, `gap-6`) to create responsive masonry and aligned column layouts.
- **Vertical Rhythm:** `mb-8` for separating major vertical sections (Header, Stats, Controls, Visualizer).

### Border Radius (Soft UI)
- **Cards & Major Containers:** `rounded-2xl` (1rem). Creates a friendly, modern "app-like" feel.
- **Buttons & Small Containers:** `rounded-xl` (0.75rem).
- **Badges:** `rounded-full`.

### Shadows & Depth
- **Standard Depth:** `shadow-sm`. Kept very subtle to avoid a cluttered look. Almost flat, relying more on `border-gray-200` for definition.
- **Action Depth:** `shadow-md` on primary buttons to make them pop out slightly.

## 5. UI Components

### Cards
- **Structure:** `bg-white border border-gray-200 p-6 rounded-2xl shadow-sm`.
- **Usage:** Contains stats, controls, or individual dashboard sections.

### Buttons
- **Primary Button:** `bg-blue-600 hover:bg-blue-700 text-white font-black px-8 py-4 rounded-xl shadow-md`. Includes `transition-all active:scale-95` for tactile feedback.
- **Secondary Button:** `bg-gray-100 hover:bg-gray-200 text-gray-600 font-bold px-6 py-4 rounded-xl`.

### Badges & Tags
- **Structure:** `px-6 py-2 rounded-full font-black text-sm uppercase tracking-widest border shadow-sm`.
- **States:** Colors change based on semantic meaning (e.g., Green for Exploiting, Amber for Exploring, White/Gray for Waiting).

### Data Visualization Elements (Bars)
- **Container:** `rounded-2xl border-2 border-gray-200 overflow-hidden flex items-end`.
- **Fill Bars:** `bg-blue-500/20 border-t-4 border-blue-500`. Semi-transparent fill with a solid top border.
- **Background Data (Truth):** Repeating linear gradients used to represent background or "true" data (`repeating-linear-gradient(45deg, #e2e8f0, #e2e8f0 5px, #cbd5e1 5px, #cbd5e1 10px)`).

## 6. Animations & Interactions

- **Tactile Feedback:** `active:scale-95` on buttons gives an immediate physical press sensation.
- **Smooth Transitions:** `transition-all duration-300` on structural changes (badges changing color), and `transition: height 0.3s cubic-bezier(0.4, 0, 0.2, 1)` for fluid bar chart movements.
- **Pulse Effects (Event Feedback):** Custom `@keyframes` used to create expanding ring animations (`box-shadow`) for immediate user feedback on discrete events.
  - `win-flash`: Rapid green pulse (`rgba(34, 197, 94, 0.4)` expanding to transparent).
  - `loss-flash`: Rapid red pulse (`rgba(239, 68, 68, 0.4)` expanding to transparent).
