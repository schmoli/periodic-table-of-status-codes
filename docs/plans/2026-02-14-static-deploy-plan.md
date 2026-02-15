# Static HTML Deploy to Vercel — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Get the periodic table HTML file live on the internet via GitHub + Vercel with auto-deploy.

**Architecture:** Single static HTML file served by Vercel. No framework, no build step. GitHub repo with Vercel integration for CI/CD.

**Tech Stack:** Static HTML/CSS/JS, GitHub, Vercel (static hosting)

---

### Task 1: Add HTML file and design doc to repo

**Files:**
- Create: `index.html` (copy from `/Users/toli/claude/periodic-table-of-status-codes/periodic-table-of-status-codes.html`)
- Existing: `docs/plans/2026-02-14-static-deploy-design.md` (already created, unstaged)

**Step 1: Copy the HTML file into the repo root as index.html**

Run: `cp /Users/toli/claude/periodic-table-of-status-codes/periodic-table-of-status-codes.html /Users/toli/repos/schmoli/periodic-table-of-status-codes/index.html`

**Step 2: Verify the file is in place**

Run: `head -5 /Users/toli/repos/schmoli/periodic-table-of-status-codes/index.html`
Expected: `<!DOCTYPE html>` and the opening tags

**Step 3: Commit both files**

```
git add index.html docs/plans/2026-02-14-static-deploy-design.md
git commit -m "feat: add periodic table HTML for static deploy"
```

---

### Task 2: Create GitHub repo and push

**Step 1: Create the GitHub repo**

Run: `cd /Users/toli/repos/schmoli/periodic-table-of-status-codes && gh repo create schmoli/periodic-table-of-status-codes --public --source=. --push`

This creates the repo, sets `origin`, and pushes `main` in one command.

**Step 2: Verify the repo exists and code is pushed**

Run: `gh repo view schmoli/periodic-table-of-status-codes --json url,defaultBranchRef`
Expected: URL and `main` branch confirmed

---

### Task 3: Deploy to Vercel

**Step 1: Deploy using the Vercel MCP tool**

Use tool: `mcp__claude_ai_Vercel__deploy_to_vercel`

This links the local project to Vercel and triggers a deploy. Vercel will auto-detect static files (no framework, no build command needed).

**Step 2: Verify the deployment**

Use tool: `mcp__claude_ai_Vercel__list_projects` with teamId `team_ssq8foPizOHprE0ESowNh5m0` to find the project, then check the deployment URL.

**Step 3: Fetch the deployed site to verify it loads**

Use the deployment URL to confirm the page renders correctly.

---

## Done Criteria

- `index.html` committed and pushed to `schmoli/periodic-table-of-status-codes` on GitHub
- Vercel deployment live at a public URL
- Page loads and displays the periodic table of HTTP status codes
