---
name: review-gate
description: Reviews a change across correctness, design, readability, security, and performance before it merges. Use when reviewing a PR, self-reviewing your own diff, or sanity-checking an AI-generated change prior to shipping.
---

# Review Gate

A review is the last cheap chance to catch a problem before it reaches users. Read the change with
intent across fixed dimensions, and judge it against what it's supposed to do — not just whether it
looks plausible.

Good review is **systematic, prioritized, and constructive**. Block on correctness and safety; suggest
on style and polish. Approve when the change is correct and safe — not when it's perfect.

Pair with the **code-reviewer** agent for a structured pass, **security-auditor** for trust-boundary
changes, and **test-engineer** for test gaps. Route deep dives to [[hardening]], [[perf-budget]],
[[interface-design]], [[dependency-hygiene]], [[browser-checks]], [[accessibility]], and
[[migration-path]] when the diff touches those areas. Authors should self-review via [[git-flow]] before
opening a PR.

## When to Use

- Reviewing a pull request (human or AI-authored)
- Self-reviewing your own diff before opening or merging it
- Sanity-checking an AI-generated change before accepting it
- Pre-merge gate on a release branch ([[launch-readiness]])
- Reviewing a dependency bump or lockfile-only change ([[dependency-hygiene]])

**Skip** as a full gate when the change is truly trivial (typo in comment, version bump with no code
path change) — still scan for accidental file inclusions. **Not a substitute for** running the app
([[browser-checks]]) or live security pen-testing — review catches what static reading can; verify
runtime behavior separately when the change is UI or interaction-heavy.

## Process

Work in order. Understanding intent comes before line comments.

### 1. Understand intent before reading code

- Read the **PR description, ticket, or spec** — what problem does this solve? What is explicitly out
  of scope?
- Note the **acceptance criteria** and verify the diff addresses them — not an adjacent refactor.
- Check **how to test** — did the author describe steps? For UI, are there screenshots or recordings?
- Identify **risk class**: user-facing, auth/payments, schema migration, infra, dependency-only.
- If intent is unclear, **ask first** — reviewing code without knowing the goal produces noise.

```text
Bad:  start at line 1 of the diff and comment on naming
Good: "This adds idempotent checkout retries — I'll verify idempotency and error paths"
```

### 2. Read the whole change — not just the headline file

- Read **tests, config, migrations, lockfiles, and deleted code** — bugs hide in "boring" files.
- Scan the **full diff stat** — a 2,000-line PR needs a different pass than a 50-line fix
  ([[incremental-delivery]]). If too large to review safely, request a split before deep review.
- For self-review: read the diff as if someone else wrote it — `git diff main...HEAD`, not just the
  last commit.
- For AI-generated changes: assume **plausible but wrong** — verify imports exist, APIs match the
  codebase, and "helpful" refactors weren't bundled in silently.

### 3. Correctness — does it do what it claims?

Walk the **happy path and the failure paths**:

| Check | Questions |
|-------|-----------|
| **Logic** | Does the algorithm match the spec? Off-by-one, wrong operator, inverted condition? |
| **Edge cases** | Empty, null, zero, max length, duplicate, concurrent, first/last item |
| **Error handling** | Failures surfaced or swallowed? Partial failure state consistent? |
| **Concurrency** | Race between read and write? Double-submit? Stale cache after write? |
| **Data integrity** | Migrations reversible or forward-safe? Orphans possible? |
| **Config/env** | New vars documented? Defaults safe in prod? Feature flag default correct? |

- Trace one **concrete scenario** end-to-end through the diff — input → transform → output → side
  effects.
- If behavior changed, confirm it's **intentional** and callers/tests were updated.
- Flag **missing tests** for new behavior or fixed bugs — a fix without a regression test will regress
  ([[test-first]]).

### 4. Design — does it fit the system?

- **Right layer** — business logic not in handlers/templates; UI not fetching what the server should
  ([[react-patterns]]).
- **Right boundary** — public API stable; internals not leaked ([[interface-design]]).
- **No parallel patterns** — doesn't introduce a second way to do what the codebase already does
  ([[simplify]]).
- **Coupling** — change isolated or does everything import the new god-module?
- **Duplication** — copy-pasted logic that should share an existing helper?
- **Scope creep** — drive-by refactors mixed with the feature; ask to split if reviewability suffers.

Approve pragmatic fixes that aren't architecturally perfect if they're **correct, tested, and better
than what they replace** — but flag debt worth a follow-up ticket.

### 5. Readability — will someone understand this in six months?

- **Names** reflect domain intent, not implementation (`retryPayment`, not `handleStuff`).
- **Functions** do one thing at a reasonable size — nested ternaries and 200-line handlers are review
  findings when they obscure behavior.
- **Comments** explain *why*, not *what* — delete comments that lie after the code changed.
- **Control flow** is followable without holding five variables in head — early returns beat deep nesting.
- **Diff noise** — formatting-only churn makes real bugs hard to spot; ask to separate cosmetic commits.

Readability nits are usually **non-blocking** unless confusion hides a bug. Don't rewrite in your
preferred style ([[simplify]] is for dedicated refactors, not blocking every PR).

### 6. Security — trust nothing that crosses a boundary

Every PR gets a **light security pass**. Deep or auth-heavy changes get [[hardening]] or the
**security-auditor** agent.

| Signal in diff | Check |
|----------------|-------|
| HTTP handler, form, webhook | Input validated; auth **and** authz on this action/resource |
| Query, shell, template, redirect | Parameterized / escaped — no concatenation |
| File upload/path | Safe names; outside web root; size limits |
| Secrets, tokens, PII | Not in code, logs, or client responses |
| New dependency | Supply-chain risk ([[dependency-hygiene]]) |
| LLM / tool call | Prompt injection, tool scope ([[llm-feature-engineering]]) |

- **Client-side checks alone** are not security — flag if server doesn't re-verify.
- **Default-deny** on new endpoints — public by accident is a common bug.

### 7. Performance — flag real traps, not style preferences

Apply [[perf-budget]] thinking at review time — look for **obvious traps**, don't demand micro-opts:

- N+1 queries or loops that call remote services per item
- Unbounded queries, lists, or fan-out (missing pagination/limits)
- Serial awaits where work is independent ([[react-patterns]], [[resilience]])
- Blocking work on the hot path (sync I/O in request handler)
- Large payloads across Server/Client boundaries
- Missing indexes on new query patterns ([[data-modeling]])

Performance comments should name **expected impact** ("this loops orders × line items = N+1") and
suggest direction — not "make it faster" without substance.

### 8. Tests and verification evidence

- **New behavior has tests** that assert outcomes, not implementation details (test-engineer agent).
- **Bug fixes include a regression test** that fails without the fix.
- **Tests are deterministic** — no time/network flakiness without explicit control.
- **Deleted tests** — understand why; don't accept removed coverage without replacement.
- **CI green** is necessary, not sufficient — green can mean weak assertions ([[pipeline-ops]]).
- For UI changes: evidence of **manual or browser verification** ([[browser-checks]]) when behavior
  is visual or interaction-heavy.

### 9. Route to specialist skills when the diff demands it

Don't re-derive every specialty in review — load the skill when the diff touches it:

| Diff touches | Also apply |
|--------------|------------|
| Public API, schema, event shape | [[interface-design]] |
| DB schema, queries | [[data-modeling]] |
| Cache layer | [[caching-strategy]] |
| Retries, queues, webhooks | [[resilience]] |
| Breaking change, dual-write | [[migration-path]] |
| UI components, forms | [[ui-craft]], [[accessibility]] |
| React/Next pages | [[react-patterns]] |
| New/ upgraded packages | [[dependency-hygiene]] |
| Observability, alerts | [[observability]] |
| Launch, feature flags, rollback | [[launch-readiness]] |

One sentence in the review is enough: "Auth change — ran hardening lens; IDOR on line 42."

### 10. Prioritize findings and write actionable feedback

Structure every review comment:

1. **Severity** — blocking / suggestion / question
2. **Location** — file and line (or function)
3. **Problem** — what's wrong and **consequence** if shipped
4. **Direction** — proposed fix or alternative — not just "this is bad"

```text
Blocking — payments/handler.ts:88
Retry on POST /charge without idempotency key can double-charge on timeout.
→ Accept Idempotency-Key header and return cached result on duplicate (see [[resilience]]).

Suggestion — cart/utils.ts:12
`computeTotal` name is clear; optional: extract tax line for reuse with checkout summary.

Question — Is empty cart supposed to 400 or return []? Spec wasn't explicit.
```

**Order output:** blocking issues first, then questions, then non-blocking suggestions.

| Verdict | When |
|---------|------|
| **Approve** | Correct, safe, tested adequately; nits are optional |
| **Approve with nits** | Ship-ready; minor suggestions documented |
| **Request changes** | Blocking correctness, security, design, or missing tests on risky paths |
| **Comment only** | Early feedback; author still iterating |

Be **specific and kind** — review the code, not the person. "LGTM" with no evidence you read the diff
is not a review.

### 11. Know when to stop

- Don't block on **pure style** when a linter/formatter should enforce it ([[pipeline-ops]]).
- Don't demand **premature abstraction** or perf work on cold paths ([[perf-budget]]).
- Don't re-review **unchanged lines** after the author fixed blocking issues — verify the fix, not
  re-litigate nits you already waived.
- Escalate **fundamental design disagreement** to a sync or [[decision-docs]] — async comment threads
  on architecture rarely resolve cleanly.

## Common Rationalizations

- "It looks fine." — Looking fine isn't walking edge cases, security boundaries, and error paths.
- "The author knows best." — Review exists to catch what the author can't see.
- "Tests pass, so ship it." — Tests check what they check; review checks what tests miss.
- "I'll nitpick everything." — Drowning blocking issues in style nits helps no one; separate the two.
- "It's a small change." — Small diffs cause big outages; security and correctness scale with impact,
  not line count.
- "AI wrote it and tests pass." — AI code is confidently wrong; verify against real APIs and conventions.
- "I'll approve and fix it myself later." — Later doesn't happen; block or open a ticket with owner.
- "Security is a separate audit." — Light pass every PR; deep audit for high-risk, not zero pass elsewhere.

## Red Flags

- Approving a large diff in seconds
- Comments only about formatting, none about behavior or design
- No check of error paths, edge cases, or untrusted input
- "LGTM" / "ship it" with no evidence the change was read or run
- Blocking and trivial feedback mixed with no severity labels
- New public endpoint with no authz check visible in diff
- Deleted or weakened tests without explanation
- PR description empty or unrelated to the diff
- Lockfile-only PR approved without scanning transitive changes
- AI-generated boilerplate (wrong imports, hallucinated APIs) accepted unchecked
- Reviewer rewrites the entire approach in comments instead of blocking on concrete issues

## Verification

- [ ] Intent and acceptance criteria understood before line-level review
- [ ] Full diff read — tests, config, migrations, lockfiles included
- [ ] Correctness: happy path, edge cases, errors, concurrency traced for risky changes
- [ ] Design: right layer/boundary; no unjustified parallel patterns or scope creep
- [ ] Readability: intent clear; blocking confusion distinguished from style nits
- [ ] Security: light pass minimum; [[hardening]] depth for auth/input/trust-boundary changes
- [ ] Performance: obvious traps flagged ([[perf-budget]]); no premature micro-opt demands
- [ ] Tests: new behavior and bug fixes covered; CI green is not the only bar
- [ ] Specialist skills applied where diff touches their domain
- [ ] Findings prioritized (blocking / question / suggestion); feedback is specific with proposed direction
- [ ] Verdict matches findings — approve when correct and safe, not when perfect
