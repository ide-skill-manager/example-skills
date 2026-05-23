#!/usr/bin/env bash
# PostToolUse hook for the Bash tool. Records successful `git commit`
# invocations to a plugin-local log so users can audit which commits were
# created during the session. Writes into ${CLAUDE_PLUGIN_DATA} so the log
# survives plugin updates.
set -euo pipefail

payload=$(cat)
command=$(printf '%s' "$payload" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p')

case "$command" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

mkdir -p "${CLAUDE_PLUGIN_DATA:-/tmp}"
printf '%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$command" \
  >> "${CLAUDE_PLUGIN_DATA:-/tmp}/commits.log"
