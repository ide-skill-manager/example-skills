#!/usr/bin/env bash
# PreToolUse hook for the Bash tool. Reads the tool payload from stdin and
# blocks `git commit -m "..."` invocations whose subject line does not match
# the conventional-commits format that this plugin's skill produces.
set -euo pipefail

payload=$(cat)
command=$(printf '%s' "$payload" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p')

# Only inspect git commit -m "..." invocations; let everything else through.
if ! printf '%s' "$command" | grep -qE '^[[:space:]]*git[[:space:]]+commit[[:space:]]+(-[a-zA-Z]*m[a-zA-Z]*)[[:space:]]+'; then
  exit 0
fi

subject=$(printf '%s' "$command" | sed -E 's/.*-m[[:space:]]+"([^"]*)".*/\1/' | head -n 1)
pattern='^(feat|fix|refactor|perf|test|docs|chore|build|ci)(\([^)]+\))?:[[:space:]]+.+'

if ! printf '%s' "$subject" | grep -qE "$pattern"; then
  printf 'commit-message-writer: subject "%s" is not conventional-commit format.\n' "$subject" >&2
  exit 2
fi
