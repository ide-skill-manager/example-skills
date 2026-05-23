---
description: Generate a PR title and Markdown body from the current diff.
argument-hint: "[base-branch]"
---

Write a pull-request title and body from the diff between `$1` (default: `main`) and `HEAD`.

Run `git diff $1...HEAD` if you need the diff. Output in this exact format:

```
TITLE: <short imperative, under 70 chars, no trailing period>

## Summary
- <1-3 bullets describing what changed>

## Test plan
- [ ] <one line per test step the reviewer should take>

## Risks
- <bullets only if non-trivial risks exist; omit section otherwise>
```

Stay terse. Describe *intent*, not file-by-file changes.
