/** @type {import('tailwindcss').Config} */
module.exports = {
  // Scan all standalone activity HTML pages for class names.
  // The Jekyll marketing pages (index.md, courses.md, etc.) use the
  // default layout which loads Tailwind CDN separately — they are excluded here.
  content: [
    './pages/introai/**/*.html',
    './pages/aijr/**/*.html',
    './pages/teacher/**/*.html',
    './pages/*.html',
  ],
  theme: {
    extend: {
      fontFamily: {
        // Activity pages use Outfit as the default sans-serif
        sans: ['Outfit', 'sans-serif'],
        // Inline code / mono elements
        mono: ['JetBrains Mono', 'monospace'],
      },
    },
  },
  plugins: [],
};
