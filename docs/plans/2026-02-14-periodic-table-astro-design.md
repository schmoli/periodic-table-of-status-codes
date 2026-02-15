# Periodic Table of HTTP Status Codes — Astro Static Site

**Date:** 2026-02-14
**Status:** Approved

## Goal

Port the existing HTML mockup of a "Periodic Table of HTTP Status Codes" into an Astro static site deployed to Vercel. Faithful visual and functional port — no new features in this milestone.

## Source Mockup

`/Users/toli/claude/periodic-table-of-status-codes/periodic-table-of-status-codes.html`

Single-file HTML (830 lines) with inline CSS and JS. Features:
- Dark theme with GitHub-inspired color palette
- Grid layout resembling a periodic table, color-coded by category (1xx–5xx)
- Search box filtering by code, name, description, symbol
- Category filtering via legend buttons and clickable row headers
- Detail panel (right side) showing full info on hover/click
- Keyboard navigation (arrow keys)
- SVG icons per status code
- Row highlighting on group header hover

## Architecture

Astro static site, vanilla JS for interactivity, deployed to Vercel.

### Project Structure

```
periodic-table-of-status-codes/
├── astro.config.mjs
├── package.json
├── tsconfig.json
├── public/
│   └── favicon.svg
└── src/
    ├── data/
    │   └── status-codes.ts
    ├── layouts/
    │   └── Layout.astro
    └── pages/
        └── index.astro
```

### Key Decisions

1. **Data extraction**: Status codes, category colors/labels, and icon SVG paths extracted to `src/data/status-codes.ts`. Reusable for future milestones.

2. **Build-time grid rendering**: Grid tiles rendered at build time via Astro templating. Client JS handles only interactions (hover, search, filter, keyboard nav).

3. **Vanilla JS interactivity**: No framework islands needed. The mockup's vanilla JS handles all interactions cleanly.

4. **Scoped CSS**: Styles scoped via Astro's `<style>` instead of global inline styles.

5. **Fonts**: Google Fonts (JetBrains Mono + Inter) loaded via `<link>` in the layout.

### What Changes from Mockup

- Grid tiles are server-rendered (Astro template) instead of client-side `createElement`
- Data lives in a separate TypeScript module
- CSS is Astro-scoped

### What Stays the Same

- All visual styling, colors, gradients, hover effects
- Search, category filtering, detail panel, keyboard navigation
- SVG icons per status code
- Row highlighting on group header hover

## Deployment

Astro static output deployed to Vercel. No server-side rendering needed.

## Future Milestones (Out of Scope)

- Mobile/tablet responsive layout
- SEO + Open Graph meta tags
- Deep-linkable URLs per status code (`/418`)
- Accessibility improvements
