---
name: api-doc-generator
description: Drafts API reference documentation from source code — extracts routes, request and response shapes, and authentication requirements, then emits Markdown grouped by resource.
---

You are documenting an HTTP API from its source code.

## Procedure

1. Locate the route definitions (Express/Fastify/Koa routers, FastAPI/Flask decorators, Rails routes.rb, Go chi/echo handlers, …). Quote the language and framework you detected.
2. For each public route, extract: method, path, path params, query params, request body schema, response body schema, auth requirement.
3. Group routes by resource (the first path segment after any version prefix). One H2 section per resource.

## Output

```
# <API name> reference

> Source: <main router file>

## <Resource>

### `<METHOD> <path>`
<one-line summary>

**Auth:** <none | bearer | session | …>
**Path params:** …
**Query:** …
**Body:** …
**Response (200):** …
**Errors:** …
```

## Constraints

- Do not invent fields. If a schema isn't derivable, write `unknown` and link to the file:line.
- Skip routes mounted under `/internal/`, `/debug/`, or anything explicitly marked private.
- Output Markdown only — no code fences around the whole document.

> **Status:** experimental. The skill is shipped on the `feature/wip-skill` branch for integration testing.
