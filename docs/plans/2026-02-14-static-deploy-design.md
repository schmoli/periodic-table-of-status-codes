# Static HTML Deploy to Vercel

**Date:** 2026-02-14
**Status:** Proposed

## Goal

Get the existing single-file HTML periodic table live on the internet. No framework, no build step — just static hosting.

## Source

`/Users/toli/claude/periodic-table-of-status-codes/periodic-table-of-status-codes.html` (830 lines, inline CSS + JS)

## Plan

1. Copy HTML file into repo as `index.html`
2. Create GitHub repo `schmoli/periodic-table-of-status-codes` (public)
3. Push to GitHub
4. Deploy to Vercel (GitHub integration for auto-deploy on push)

## What We Don't Need

- No `package.json`, no build command
- No framework (Astro plans are deferred)
- No `vercel.json` (Vercel serves static files by default)

## Supersedes

This supersedes the Astro port plans (`2026-02-14-periodic-table-astro-design.md` and `2026-02-14-implementation-plan.md`). The web app conversion is a future milestone — this design focuses on getting the existing work live first.
