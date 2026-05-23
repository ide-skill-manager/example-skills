# example-skills

A public test marketplace for the [Agentry](https://github.com/ide-skill-manager/jetbrains) plugin, conforming to the [VS Code agent-plugins manifest spec](https://code.visualstudio.com/docs/copilot/customization/agent-plugins).

The repo root is a marketplace (`.claude-plugin/marketplace.json`). Each entry under `plugins/` is its own plugin with a `.claude-plugin/plugin.json` manifest. Together the four plugins cover every component type the spec defines: **skills**, **commands**, **agents**, **hooks**, and **MCP servers**.

## Use it

In Agentry's **Settings → Tools → Agentry**, add this marketplace:

| Field | Value |
|---|---|
| URL | `https://github.com/ide-skill-manager/example-skills.git` |
| Ref | `main` (or `feature/wip-skill` to exercise the branch-based WIP flow) |

Then click **Refresh** — the four plugins listed below should appear as installable entries.

## Plugins

| Plugin | Demonstrates | Layout |
|---|---|---|
| [`code-reviewer`](plugins/code-reviewer/) | **Skill** in a `skills/<name>/SKILL.md` subdirectory | `skills/code-reviewer/SKILL.md` |
| [`pr-summarizer`](plugins/pr-summarizer/) | **Slash commands** (`/pr-summarize`, `/pr-checklist`) | `commands/*.md` with frontmatter |
| [`commit-message-writer`](plugins/commit-message-writer/) | **Single-skill-at-root** layout + **hooks** (`PreToolUse` / `PostToolUse`) | `SKILL.md` at root, `hooks/hooks.json`, `scripts/*.sh` |
| [`repo-toolkit`](plugins/repo-toolkit/) | **Subagent** + bundled **MCP server** | `agents/repo-explorer.md`, `.mcp.json` |

## Repository layout

```
.claude-plugin/
  marketplace.json                              # marketplace catalog (this file lists the four plugins)
plugins/
  code-reviewer/
    .claude-plugin/plugin.json                  # plugin manifest
    skills/code-reviewer/SKILL.md               # skill with YAML frontmatter
  pr-summarizer/
    .claude-plugin/plugin.json
    commands/pr-summarize.md                    # slash command (frontmatter + body)
    commands/pr-checklist.md
  commit-message-writer/
    .claude-plugin/plugin.json                  # declares `skills: ["./"]` + `hooks: hooks/hooks.json`
    SKILL.md                                    # single-skill-at-root pattern
    hooks/hooks.json                            # PreToolUse + PostToolUse hooks
    scripts/validate-commit-message.sh
    scripts/log-commit.sh
  repo-toolkit/
    .claude-plugin/plugin.json
    agents/repo-explorer.md                     # subagent with model/effort/tool restrictions
    .mcp.json                                   # bundled MCP server config
    scripts/git-metadata-server.sh              # stub MCP server entry point
```

## How each component type is wired

### Skills (`code-reviewer`, `commit-message-writer`)

Skills live in `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`). The `skills/` directory is auto-discovered — no `plugin.json` field needed. A `SKILL.md` placed directly at the plugin root (as in `commit-message-writer`) is loaded as a single-skill plugin; the explicit `"skills": ["./"]` in its manifest makes this discovery deterministic.

### Commands (`pr-summarizer`)

Command files are flat markdown in `commands/`. The frontmatter supports `description` and `argument-hint`; the file body is the prompt template, with `$1`, `$2`, … bound to positional arguments. Each file becomes a `/<plugin-name>:<command-name>` slash command.

### Agents (`repo-toolkit`)

Subagent files live in `agents/<name>.md`. The frontmatter supports `name`, `description`, `model`, `effort`, `maxTurns`, `tools`, `disallowedTools`, and a few others. Plugin-shipped agents cannot declare their own `hooks`, `mcpServers`, or `permissionMode`.

### Hooks (`commit-message-writer`)

Hooks are declared in `hooks/hooks.json` (or inline in `plugin.json`). The spec supports `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `PreCompact`, `SubagentStart`, `SubagentStop`, and `Stop`. The example here uses `${CLAUDE_PLUGIN_ROOT}` to invoke bundled scripts and `${CLAUDE_PLUGIN_DATA}` for persistent log state across plugin updates.

### MCP servers (`repo-toolkit`)

MCP servers are declared in `.mcp.json` at the plugin root. The example registers a stub `git-metadata` server invoked via a bundled shell script; a real implementation would speak the Model Context Protocol over stdio. `${CLAUDE_PLUGIN_ROOT}` and `${CLAUDE_PROJECT_DIR}` are expanded inside `command`, `args`, `env`, and `cwd`.

## Branches

- `main` — stable versions of all four plugins.
- `feature/wip-skill` — adds an in-progress fifth plugin (`api-doc-generator`) and bumps `pr-summarizer` to `0.2.0`. Use this branch to test that Agentry picks up new commits on Refresh.

## License

MIT — see [LICENSE](LICENSE).
