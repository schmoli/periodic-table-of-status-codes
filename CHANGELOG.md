# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Design gallery landing page showcasing all 17 designs as a thumbnail grid
- 16 creative mockup designs exploring alternative presentations for HTTP status codes
  - Desktop: subway metro map, airport departure board, vinyl record crate, constellation star map, bookshelf library, vending machine, city skyline, treemap, radial sunburst
  - Mobile: swipe cards (Tinder-style), Instagram stories
  - Tablet/responsive: trading card collection, dense cheat sheet, honeycomb hex grid, iPad portrait accordion, compact color matrix
- Each mockup is a self-contained HTML file with a screenshot in `/mockups/`

### Changed

- Original periodic table moved from `index.html` to `periodic-table.html`
- Moved version badge from top bar to fixed bottom-right footer
- Added GitHub repo link with icon to footer

### Fixed

- Gallery cards now navigate in same tab so browser back button works
- Improved contrast for version badge, tile name labels, and RFC text in detail panel
- Increased font sizes across small text: tile names, RFC, footer, and nav hints
- Tile names now wrap to 2 lines instead of truncating to unreadable single line
- Nav hint arrows and label contrast fixed (were invisible at #30363d)

## [0.1.0] - 2026-02-14

### Added

- Periodic table layout of HTTP status codes (1xx–5xx)
- Category color coding and legend filtering
- Click-to-expand detail panel with RFC links
- Search by code number or description
- Keyboard navigation (arrow keys)
- Responsive dark theme with JetBrains Mono typography
- Auto-deploy to Vercel via GitHub integration
