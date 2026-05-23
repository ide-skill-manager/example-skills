# example-skills

A public test marketplace for the [Agentry](https://github.com/ide-skill-manager/jetbrains) plugin. The repo follows the **Microsoft agent-plugins / Claude Code marketplace** spec ([VS Code docs](https://code.visualstudio.com/docs/copilot/customization/agent-plugins), [Chris Ayers's cross-tool overview](https://chris-ayers.com/posts/agent-skills-plugins-marketplace/)).

The repo dual-publishes its manifests so the same source works for **Copilot CLI**, **VS Code Copilot**, **Claude Code**, and (via Agentry) **JetBrains IDEs**:

- `.github/plugin/marketplace.json` and `plugins/<plugin>/.github/plugin.json` — Microsoft/Copilot dialect.
- `.claude-plugin/marketplace.json` and `plugins/<plugin>/.claude-plugin/plugin.json` — Claude Code dialect.

The component directories under each plugin (`skills/`, `commands/`, `agents/`, `hooks/`, `.mcp.json`) are shared by both dialects.

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
| [`repo-toolkit`](plugins/repo-toolkit/) | **Subagent** + bundled **MCP server** | `agents/repo-explorer.agent.md`, `.mcp.json` |

## Repository layout

```
.github/plugin/marketplace.json                   # marketplace catalog (Copilot CLI + VS Code Copilot)
.claude-plugin/marketplace.json                   # marketplace catalog (Claude Code)
plugins/
  code-reviewer/
    .github/plugin.json                           # plugin manifest (Copilot)
    .claude-plugin/plugin.json                    # plugin manifest (Claude Code)
    skills/code-reviewer/SKILL.md                 # skill with YAML frontmatter
  pr-summarizer/
    .github/plugin.json
    .claude-plugin/plugin.json
    commands/pr-summarize.md                      # slash command (frontmatter + body)
    commands/pr-checklist.md
  commit-message-writer/
    .github/plugin.json                           # declares skills: ["./"] + hooks: hooks/hooks.json
    .claude-plugin/plugin.json                    # same
    SKILL.md                                      # single-skill-at-root pattern
    hooks/hooks.json                              # PreToolUse + PostToolUse hooks
    scripts/validate-commit-message.sh
    scripts/log-commit.sh
  repo-toolkit/
    .github/plugin.json
    .claude-plugin/plugin.json
    agents/repo-explorer.agent.md                 # subagent (.agent.md extension)
    .mcp.json                                     # bundled MCP server config
    scripts/git-metadata-server.sh                # stub MCP server entry point
```

## How each component type is wired

### Skills (`code-reviewer`, `commit-message-writer`)

Skills live in `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`). The `skills/` directory is auto-discovered — no manifest field needed. A `SKILL.md` placed directly at the plugin root (as in `commit-message-writer`) is loaded as a single-skill plugin; the explicit `"skills": ["./"]` in its manifest makes this discovery deterministic.

### Commands (`pr-summarizer`)

Command files are flat markdown in `commands/`. The frontmatter supports `description` and `argument-hint`; the file body is the prompt template, with `$1`, `$2`, … bound to positional arguments. Each file becomes a `/<plugin-name>:<command-name>` slash command.

### Agents (`repo-toolkit`)

Subagent files live in `agents/<name>.agent.md`. The frontmatter supports `name`, `description`, `model`, `effort`, `maxTurns`, `tools`, `disallowedTools`, and a few others. Plugin-shipped agents cannot declare their own `hooks`, `mcpServers`, or `permissionMode`.

### Hooks (`commit-message-writer`)

Hooks are declared in `hooks/hooks.json` (or inline in the plugin manifest). The spec supports `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `PreCompact`, `SubagentStart`, `SubagentStop`, and `Stop`. The example here uses `${CLAUDE_PLUGIN_ROOT}` to invoke bundled scripts and `${CLAUDE_PLUGIN_DATA}` for persistent log state across plugin updates.

### MCP servers (`repo-toolkit`)

MCP servers are declared in `.mcp.json` at the plugin root. The example registers a stub `git-metadata` server invoked via a bundled shell script; a real implementation would speak the Model Context Protocol over stdio. `${CLAUDE_PLUGIN_ROOT}` and `${CLAUDE_PROJECT_DIR}` are expanded inside `command`, `args`, `env`, and `cwd`.

## Branches

- `main` — stable versions of all four plugins, dual-published in both manifest dialects.
- `feature/wip-skill` — adds an in-progress fifth plugin (`api-doc-generator`) and bumps `pr-summarizer` to `0.2.0`. Use this branch to test that Agentry picks up new commits on Refresh.

## License

MIT — see [LICENSE](LICENSE).
