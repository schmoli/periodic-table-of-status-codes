#!/usr/bin/env bash
# PreToolUse hook: reminds Claude to update CHANGELOG.md before committing.
# Reads the tool input JSON from stdin and checks if it's a git commit command.

set -euo pipefail

INPUT=$(cat)

# Extract the Bash command from the tool input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only care about git commit commands
if ! echo "$COMMAND" | grep -qE '(^|\s|&&|\|)git\s+commit\b'; then
  exit 0
fi

# Check if CHANGELOG.md is already staged
if git diff --cached --name-only | grep -q '^CHANGELOG.md$'; then
  exit 0
fi

# Block the commit — CHANGELOG.md isn't staged
cat <<'EOF'
{"decision": "block", "reason": "CHANGELOG.md is not staged. Please update CHANGELOG.md with a summary of your changes, then stage it with `git add CHANGELOG.md` before committing."}
EOF
