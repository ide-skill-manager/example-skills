# example-skills

A public test registry for the [Agentry](https://github.com/ide-skill-manager/jetbrains) plugin.

Three sample skills live in this repo, one per top-level directory. Each has a `skill.json` manifest in the VS Code Marketplace shape that Agentry's `ManifestParser` understands.

## Use it

In Agentry's **Settings → Tools → Agentry**, add this registry:

| Field | Value |
|---|---|
| URL | `https://github.com/ide-skill-manager/example-skills.git` |
| Ref | `main` (or `feature/wip-skill` to exercise the branch-based WIP flow) |

Then click **Refresh** in the Agentry tool window — `code-reviewer`, `pr-summarizer`, and `commit-message-writer` should appear.

## What's here

| Skill | Description |
|---|---|
| [`code-reviewer/`](code-reviewer/) | Reviews a diff for bugs, security issues, and style |
| [`pr-summarizer/`](pr-summarizer/) | Generates a concise PR title and description from a diff |
| [`commit-message-writer/`](commit-message-writer/) | Writes a conventional-commit-style message for staged changes |

## Branches

- `main` — stable versions of all three skills.
- `feature/wip-skill` — adds an in-progress fourth skill (`api-doc-generator`) and bumps `pr-summarizer` to `0.2.0`. Use this branch to test that Agentry picks up new commits on Refresh.

## License

MIT — see [LICENSE](LICENSE).
