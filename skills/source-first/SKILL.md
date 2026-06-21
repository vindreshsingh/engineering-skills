---
name: source-first
description: Grounds work in the actual source — code, types, docs, and data — before reasoning or writing. Use whenever you're about to rely on how something behaves, an API's shape, a library's contract, or existing code paths.
---

# Source First

Check the source before you trust your memory of it. APIs change, training-data recollection is fuzzy,
and a library's real behavior lives in its code and types — not in what you assume it does. **Unverified
assumptions are the main cause of plausible-but-wrong AI output.**

Source-first means: identify what you're claiming, find the authoritative evidence, read it, then write
or change code. If the source contradicts your plan, **the source wins**.

Pair with [[context-curation]] to load verified source into the working set (not paraphrase), [[fault-recovery]]
when debugging against a wrong mental model, [[interface-design]] when confirming public contracts,
[[test-first]] to lock verified behavior, and [[llm-feature-engineering]] when grounding model answers
in retrieval — model memory is not a source.

## When to Use

- Calling an API, library, or internal module you're not 100% certain about
- Reasoning about how existing code behaves before changing it
- Installed version may differ from what you remember or from online docs
- Debugging behavior that "should" work according to your mental model
- Reviewing or accepting AI-generated code that references symbols, paths, or APIs
- Writing a spec, ADR, or doc that claims how the system works ([[decision-docs]])
- Before adding a dependency — verify the API you need actually exists in that version ([[dependency-hygiene]])

**Skip** for pure greenfield logic with no external contracts — still apply when you touch existing
code or libraries. **Not a substitute for** running the app ([[browser-checks]]) or tests ([[test-first]]) —
source tells you what *should* happen; execution proves it.

## Process

Work in order. Know what you're verifying before you open files.

### 1. Name the claim that needs grounding

Before searching, write the **specific assertion** you're relying on:

```text
Bad:  "I'll use the auth helper"
Good: "authMiddleware() runs before route handlers and sets req.user from the JWT"
```

If you can't state the claim, you're not ready to implement — explore first, don't guess.

Claims that always need a source:

- Function signature, return type, and thrown errors
- Default parameter values and optional fields
- Middleware/hook order and side effects
- Config keys, env var names, and their defaults
- Which file/module owns a behavior
- Database column types, constraints, and indexes
- External API request/response shape for the **installed** version

### 2. Pick the authoritative source — hierarchy matters

Use the **highest-authority** source available for the claim:

| Priority | Source | Use for |
|----------|--------|---------|
| **1** | **Your codebase** — definition, callers, tests | Internal modules, app behavior, conventions |
| **2** | **Types/schemas** — TypeScript, OpenAPI, Protobuf, DB migration | Contracts, required fields, enums |
| **3** | **Tests** — unit/integration asserting behavior | Expected edge cases, regression truth |
| **4** | **Installed package** — `node_modules`, lockfile version, vendor code | Third-party API for *your* version |
| **5** | **Version-pinned docs** — docs for the exact release in lockfile | When code isn't readable |
| **6** | **Runtime sample** — one real query, log line, API response | Data shape, null patterns, env quirks |
| **7** | **Web search / training memory** | Last resort — confirm against 1–6 before trusting |

```text
Wrong: blog post from 2021 → implement
Right: lockfile says v4.2 → read types in node_modules → cross-check v4.2 docs if needed
```

**Docs lag code** on active repos; **code lags docs** on stable public APIs — when they disagree on
*your* repo, your code wins. For third-party libs, installed source + pinned docs beat generic web results.

### 3. Find the source efficiently

Don't read the whole repo — locate the definition:

- **Jump to definition** / LSP / `grep` for symbol name, export, route path
- **Follow imports** from the entry you know to the implementation
- **Read the test file** named like the module — tests document intended behavior
- **Check lockfile / package manifest** for exact version before reading vendor code or docs
- **Schema/migration files** for DB truth — not the ORM model alone if migrations diverged
- **Generated clients** (OpenAPI, GraphQL codegen) — authoritative for external API shape *as configured*

For AI agents: **verify paths and symbols exist** before editing — invented file paths and imports are
a common failure mode.

### 4. Read the relevant slice — not a snippet from search results

Read enough to answer: **what goes in, what comes out, what can fail, what else it touches.**

Checklist for the slice:

- **Signature** — params, generics, overloads, async vs sync
- **Defaults** — optional args, feature flags, config fallbacks
- **Errors** — thrown exceptions, error codes, retryability ([[resilience]])
- **Side effects** — I/O, mutation, cache, global state, logging
- **Pre/post conditions** — auth required? null allowed? empty array meaning?
- **Deprecation** — comments, `@deprecated`, migration notes ([[migration-path]])

```text
Assumed:  getUser(id) → User
Read:     getUser(id) → User | null; throws NetworkError on timeout; caches 60s
```

Stop when the claim is verified — don't read adjacent modules "while you're here" ([[context-curation]]).

### 5. Confirm version and environment

Behavior without version context is incomplete.

- **Lockfile / manifest** — `package-lock.json`, `pnpm-lock.yaml`, `Cargo.lock`, `go.sum`
- **Runtime version** — Node, Python, Java, DB engine — APIs differ across majors
- **Feature flags / env** — same code path, different behavior per environment
- **Fork/vendored patches** — internal fork may differ from upstream docs

If the user's environment is unknown, **ask or detect** before assuming latest docs apply.

### 6. Trace the real execution path — don't guess the flow

For "how does X work today?" follow **one concrete path**:

1. Entry point — route, handler, job trigger, UI event
2. Each call — who calls whom, with what arguments
3. Branch points — conditionals that change behavior
4. Exit — response, write, side effect

```text
Assumed:  DELETE /users/:id removes row immediately
Traced:   handler → softDeleteUser() → sets deleted_at; row stays 90 days
```

Tracing beats reading one function in isolation when the bug is **order**, **wiring**, or **middleware**.

Tools: debugger, structured logs, temporary trace log, or manual step-through in tests.

### 7. Sample real data when behavior is data-dependent

Some truths aren't in code alone:

- **Null/empty patterns** — does production data match schema assumptions?
- **Id formats** — UUID vs int vs slug in live rows
- **Encoding, timezone, locale** — dates and strings surprise at boundaries
- **Scale** — "small in dev" hides full-table scan ([[data-modeling]], [[perf-budget]])

Use **sanitized** samples — never paste secrets or PII into chat ([[hardening]]). Prefer schema +
one anonymized row, or `LIMIT 1` read in dev/staging.

### 8. Record what you verified — then write

Before implementing or advising:

- State **what you read** (file, symbol, version) — not "I checked the docs"
- Implement against **verified** signatures — not memory
- If advising the user, cite the source location when the claim is non-obvious

When pairing with [[context-curation]], load **actual source excerpts** into the working set — a
hand-wavy paraphrase of a module reintroduces hallucination.

### 9. When source contradicts the plan — source wins

If evidence disproves the assumption:

1. **Stop** — don't patch forward on a false premise
2. **Update the plan**, spec, or mental model
3. **Re-check downstream** — callers, tests, docs that assumed the old behavior
4. If the surprise reveals a **bug**, switch to [[fault-recovery]] with a verified baseline

```text
Planned:  add field to existing POST body
Found:    OpenAPI marks field read-only; server rejects unknown fields
Action:   new endpoint or version bump ([[interface-design]], [[migration-path]])
```

### 10. Know special cases

| Situation | Source-first rule |
|-----------|-------------------|
| **AI-generated code** | Every import, path, method name verified in repo or package |
| **Stack Overflow / gist** | Treat as untrusted — rewrite against your version's source |
| **LLM "facts" about your product** | Ground in retrieval or code — never model memory alone ([[llm-feature-engineering]]) |
| **Deprecated API** | Read migration guide + grep repo for remaining callers |
| **Config from env** | Read `.env.example`, deploy config, or schema — not "usual" var names |
| **Monorepo shared package** | Trace into the package source — don't assume npm doc matches internal fork |

## Common Rationalizations

- "I know this API." — You know a version of it; confirm the one installed.
- "The docs are probably right." — Docs lag code; for behavior that matters, read the code.
- "I'll assume the default." — Defaults change and surprise; verify the one in play.
- "Tracing the flow takes too long." — Less long than debugging a fix built on a wrong assumption.
- "The types are wrong, I'll ignore them." — Types may be the only contract; fix types or verify runtime.
- "Search gave me an answer." — Search snippets lack version and context; read the full definition.
- "It compiled so the imports are fine." — Compilation may not run yet; verify symbols exist in *this* repo.
- "We did it this way before." — Before ≠ still; trace current code.

## Red Flags

- Writing against an API from memory without checking the signature
- "It should work like X" with no source consulted
- Ignoring which version is installed
- Bug fix based on assumed code path rather than traced path
- Copy-pasting a snippet whose behavior isn't verified for your version
- AI output referencing files that don't exist or APIs not in the lockfile
- Doc/ADR claiming behavior nobody verified in code ([[decision-docs]])
- Changing a public function without reading all callers ([[interface-design]])
- Trusting generic web docs for a heavily configured internal wrapper

## Verification

- [ ] Claims to rely on are named explicitly before implementation
- [ ] Authoritative source identified (code > types > tests > installed package > pinned docs)
- [ ] Relevant slice read — signature, defaults, errors, side effects — not a search snippet
- [ ] Installed/runtime version confirmed where behavior depends on it
- [ ] Existing behavior traced on the real path when changing or debugging flow
- [ ] Data-dependent assumptions validated with sample or schema when needed
- [ ] Implementation matches verified source; no invented paths, imports, or APIs
- [ ] Where source contradicted assumptions, plan updated before proceeding
