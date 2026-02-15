# Periodic Table of HTTP Status Codes — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Port the HTML mockup into an Astro 5 static site deployed to Vercel, preserving all visual and interactive behavior.

**Architecture:** Astro static site with vanilla JS interactivity. Grid tiles are server-rendered at build time with data attributes. Client JS reads data attributes for search, filtering, detail panel, and keyboard navigation — no duplicate data in JS. All styles use `<style is:global>` since this is a single-page app.

**Tech Stack:** Astro 5, TypeScript, Vanilla JS, Vercel (static deployment)

**Source mockup:** `/Users/toli/claude/periodic-table-of-status-codes/periodic-table-of-status-codes.html`

---

### Task 1: Initialize Astro Project

**Files:**
- Create: `package.json`
- Create: `astro.config.mjs`
- Create: `tsconfig.json`
- Create: `src/pages/index.astro` (placeholder)

**Step 1: Create package.json**

```json
{
  "name": "periodic-table-of-status-codes",
  "type": "module",
  "version": "0.0.1",
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview"
  }
}
```

**Step 2: Install Astro**

Run: `npm install astro`

**Step 3: Create astro.config.mjs**

```js
import { defineConfig } from 'astro/config';

export default defineConfig({});
```

**Step 4: Create tsconfig.json**

```json
{
  "extends": "astro/tsconfigs/strict"
}
```

**Step 5: Create placeholder page**

Create `src/pages/index.astro`:
```astro
---
---
<html lang="en">
<head><title>HTTP Status Codes</title></head>
<body><h1>Coming soon</h1></body>
</html>
```

**Step 6: Verify dev server starts**

Run: `npm run dev`
Expected: Astro dev server starts, page loads at localhost:4321

**Step 7: Commit**

```
feat: initialize Astro project
```

---

### Task 2: Create Status Codes Data Module

**Files:**
- Create: `src/data/status-codes.ts`

This file exports all the data the grid needs: status codes, category metadata, icon SVGs, and a helper to get the icon HTML for a given code.

**Step 1: Create `src/data/status-codes.ts`**

Copy all data from the source mockup (`<script>` section, lines 504-658) and wrap in TypeScript:

```ts
export interface StatusCode {
  code: number;
  name: string;
  symbol: string;
  cat: string;
  desc: string;
  rfc: string;
}

// Copy the STATUS_CODES array from the mockup (lines 504-566), typed as StatusCode[]
export const STATUS_CODES: StatusCode[] = [
  { code: 100, name: "Continue", symbol: "Cn", cat: "1xx", desc: "The server has received the request headers and the client should proceed to send the request body.", rfc: "RFC 9110" },
  // ... all 63 status codes from the mockup ...
  { code: 511, name: "Network Auth Req'd", symbol: "Nr", cat: "5xx", desc: "The client needs to authenticate to gain network access. Think captive portals at airports or hotels.", rfc: "RFC 6585" },
];

export const CAT_COLORS: Record<string, string> = {
  '1xx': '#58a6ff', '2xx': '#3fb950', '3xx': '#d29922', '4xx': '#ff7b72', '5xx': '#bc8cff',
};

export const CAT_LABELS: Record<string, string> = {
  '1xx': 'Informational', '2xx': 'Success', '3xx': 'Redirection', '4xx': 'Client Error', '5xx': 'Server Error',
};

// Copy the svg helper, ICONS map, CAT_ICON_MAP, CODE_ICON_MAP from mockup (lines 577-653)
const svg = (d: string) => `<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="${d}"/></svg>`;

const ICONS: Record<string, string> = {
  // ... all icon entries from the mockup ...
};

const CAT_ICON_MAP: Record<string, string> = {
  '1xx': 'info', '2xx': 'check', '3xx': 'redirect', '4xx': 'warning', '5xx': 'server',
};

const CODE_ICON_MAP: Record<number, string> = {
  // ... all per-code icon overrides from the mockup ...
};

export function getIcon(code: number, cat: string): string {
  const key = CODE_ICON_MAP[code] || CAT_ICON_MAP[cat] || 'info';
  return ICONS[key] || ICONS.info;
}

export const COLS = 16;

export interface GridRow {
  cat: string;
  first: boolean;
  codes: StatusCode[];
  pad: number;
}

export function buildRows(): GridRow[] {
  const groups = (['1xx', '2xx', '3xx', '4xx', '5xx'] as const).map(cat => ({
    cat,
    codes: STATUS_CODES.filter(s => s.cat === cat),
  }));
  const rows: GridRow[] = [];
  const perRow = COLS - 1;
  groups.forEach(g => {
    for (let i = 0; i < g.codes.length; i += perRow) {
      const chunk = g.codes.slice(i, i + perRow);
      rows.push({ cat: g.cat, first: i === 0, codes: chunk, pad: perRow - chunk.length });
    }
  });
  return rows;
}
```

**Step 2: Verify TypeScript compiles**

Run: `npx astro check`
Expected: No errors

**Step 3: Commit**

```
feat: add status codes data module
```

---

### Task 3: Create Layout and Index Page

**Files:**
- Create: `src/layouts/Layout.astro`
- Replace: `src/pages/index.astro`

**Step 1: Create `src/layouts/Layout.astro`**

```astro
---
interface Props {
  title: string;
}
const { title } = Astro.props;
---
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <slot />
</body>
</html>
```

**Step 2: Create `src/pages/index.astro`**

This is the main page. It imports the data, renders the grid at build time, includes all CSS, and has a client-side `<script>` for interactivity.

**Key architectural decision:** Each tile stores ALL its data in `data-*` attributes (`data-code`, `data-name`, `data-symbol`, `data-cat`, `data-desc`, `data-rfc`, `data-icon`). The client JS reads these attributes for search, filtering, and the detail panel. No duplicate data array in client JS. Single source of truth.

The template has three sections:

**A) Astro frontmatter + HTML template:**
- Import data from `status-codes.ts`
- Call `buildRows()` at build time
- Render the top bar (title, search box, legend)
- Render the grid using `rows.map()` — each row gets a group header + tile elements + gap padding
- Render the detail panel shell (empty state + content placeholders)

**B) `<style is:global>` block:**
- Copy ALL CSS from the mockup (lines 7-446) verbatim
- Must use `is:global` because client JS injects SVG via innerHTML into the detail icon, and those dynamic SVG elements won't have Astro's scoping attribute

**C) `<script>` block for client-side interactivity:**

The client JS is rewritten from the mockup to work with pre-rendered DOM:

```ts
// Small lookup tables (only data client JS needs that isn't in DOM)
const CAT_COLORS = { '1xx': '#58a6ff', '2xx': '#3fb950', '3xx': '#d29922', '4xx': '#ff7b72', '5xx': '#bc8cff' };
const CAT_LABELS = { '1xx': 'Informational', '2xx': 'Success', '3xx': 'Redirection', '4xx': 'Client Error', '5xx': 'Server Error' };

let activeFilter = 'all';
let searchQuery = '';
let activeTileEl: HTMLElement | null = null;

// Grab all tiles ONCE at load time
const allTiles = Array.from(document.querySelectorAll<HTMLElement>('.tile[data-code]'));

// tileMatches() — reads data attributes from tile element
function tileMatches(tile: HTMLElement): boolean { /* filter + search logic using tile.dataset */ }

// updateVisibility() — toggles 'dimmed' class on tiles (replaces mockup's renderGrid)
function updateVisibility() { allTiles.forEach(t => t.classList.toggle('dimmed', !tileMatches(t))); }

// showDetail(tile) — reads all data-* attrs from tile, populates detail panel
// clearDetail() — resets panel
// toggleFilter(cat) — toggles activeFilter, syncs legend + headers, updates visibility
// Keyboard nav — filters visible tiles (non-dimmed), arrow keys cycle through them
// Event listeners: tile mouseenter/click, legend click, group header click/hover, search input
```

The key difference from the mockup: instead of `renderGrid()` rebuilding the entire DOM on every filter/search change, we call `updateVisibility()` which just toggles CSS classes on existing elements. Much more efficient.

**Step 3: Run dev server and verify**

Run: `npm run dev`
Verify all behaviors match the mockup:
- Grid layout (5 category rows, proper column count)
- Category colors (blue, green, yellow, red, purple)
- Hover shows detail panel on the right
- Search filters tiles
- Legend buttons filter by category
- Group header click toggles category filter
- Group header hover highlights row
- Keyboard arrow keys navigate between tiles

**Step 4: Build and verify static output**

Run: `npm run build && npm run preview`
Expected: Static build succeeds, preview server shows same result

**Step 5: Commit**

```
feat: implement periodic table page with full interactivity
```

---

### Task 4: Deploy to Vercel

**Step 1: Create `.gitignore`**

```
node_modules/
dist/
.astro/
```

**Step 2: Commit**

```
chore: add gitignore
```

**Step 3: Deploy to Vercel**

Use the Vercel MCP tool `deploy_to_vercel`, or manually:

Run: `npx vercel --yes`
Expected: Deployment URL returned

No Vercel adapter needed — pure static output. Astro builds to `dist/` and Vercel serves it as-is.

**Step 4: Verify deployed site**

Open the deployment URL and verify all behaviors match the mockup.

---

## Architecture Decisions Summary

1. **Data attributes on tiles**: Each tile has `data-code`, `data-name`, `data-symbol`, `data-cat`, `data-desc`, `data-rfc`, `data-icon`. Client JS reads these directly — single source of truth, no parallel data array.

2. **Build-time grid rendering**: Grid HTML is generated at build time via Astro templating. Client JS only toggles classes (`dimmed`, `active-tile`, `row-highlight`, `active-header`) — never creates/destroys DOM elements.

3. **`<style is:global>`**: Single-page app + client JS injects SVG via innerHTML into detail panel icon. Scoped styles would miss those elements.

4. **No Vercel adapter**: Pure static output — no SSR needed.

5. **Class toggling vs DOM rebuild**: Mockup's `renderGrid()` rebuilds entire DOM on filter/search. Our approach toggles `dimmed` class on pre-rendered elements — more efficient, same visual result.
