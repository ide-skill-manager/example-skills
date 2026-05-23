---
description: Produce a reviewer checklist for the current PR diff.
---

Generate a reviewer checklist for the diff between `main` and `HEAD`.

For each meaningful change, emit one checkbox line:

```
- [ ] <reviewer action> — <file or area>
```

Group by area when there are more than five items. Skip trivial whitespace or rename-only changes. The checklist should fit on one screen.
