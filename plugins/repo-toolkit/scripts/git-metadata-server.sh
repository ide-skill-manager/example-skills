#!/usr/bin/env bash
# Placeholder MCP server entry point. A real implementation would speak the
# Model Context Protocol over stdio and expose tools like `list_branches`,
# `recent_commits`, or `file_history` backed by `git` commands. This stub
# just demonstrates how a plugin-bundled binary is wired up via .mcp.json.
set -euo pipefail
exec >&2
printf 'git-metadata MCP server stub — replace with a real MCP implementation.\n'
printf 'Args: %s\n' "$*"
printf 'CLAUDE_PLUGIN_ROOT=%s\n' "${CLAUDE_PLUGIN_ROOT:-unset}"
printf 'CLAUDE_PROJECT_DIR=%s\n' "${CLAUDE_PROJECT_DIR:-unset}"
exit 1
