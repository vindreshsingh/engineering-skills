---
name: simplify
description: Removes accidental complexity — dead code, duplication, needless indirection, and over-engineering. Use when refactoring, after a feature lands, when code is harder to read than the problem warrants, or before extending a messy area.
---

# Simplify

The goal is the **simplest code that correctly solves the actual problem** — not the most flexible,
most abstract, or most clever. Most complexity is accidental: abstractions built for futures that never
arrived, duplication from copy-paste, and indirection that hides intent. **Delete it, don't decorate it.**

Essential complexity stays — the problem really is hard. Accidental complexity is optional and your job
is to remove it without changing behavior.

Pair with [[test-first]] for the safety net, [[incremental-delivery]] for small refactor PRs,
[[review-gate]] when the cleanup is ready to merge, [[interface-design]] when simplifying public APIs,
[[dependency-hygiene]] when deciding to own code vs import a package, and [[perf-budget]] before
"optimizing" structure on hot paths — simpler isn't always faster; measure if latency matters.

## When to Use

- Cleaning up after a feature lands or a spike becomes production code
- Code that takes more effort to read than the problem deserves
- A reviewer or you keep getting lost following the flow
- Before extending a messy area — simplify first, then add
- After [[review-gate]] flags unnecessary indirection or duplication
- Choosing between a new dependency and a small amount of owned code ([[dependency-hygiene]])

**Skip** as the primary skill when:
- The area is under active feature development — finish the behavior, simplify in a follow-up PR
- You don't understand the code yet and have no tests — understand and cover first ([[test-first]])
- The change would alter public contracts without a migration ([[interface-design]], [[migration-path]])

**Not a substitute for** [[fault-recovery]] — if something is broken, fix the bug first; don't refactor
around it blindly.

## Process

Work in order. Safety and understanding before deletion.

### 1. Define scope and the safety net

- **Bound the refactor** — one module, one flow, one PR. "Simplify the whole app" never finishes.
- **Behavior must stay the same** unless the task explicitly includes a behavior change — simplification
  is not a stealth feature.
- **Tests green before you start** ([[test-first]]). No tests? Add characterization tests for critical
  paths first — even coarse ones beat refactoring blind.
- **Small commits** — delete dead code in one commit, extract duplication in the next; easy to bisect
  if something breaks ([[git-flow]]).
- For public APIs, note **callers** — simplifying internals is free; changing exports needs care
  ([[interface-design]]).

```text
Good scope: "Simplify checkout total calculation — one module, tests in checkout.test.ts"
Bad scope:  "Clean up the codebase while I'm here"
```

### 2. Understand it fully before changing anything

- Read the code **end-to-end** — inputs, outputs, side effects, error paths.
- Trace **one real scenario** through the maze — if you can't, neither can the next reader.
- Identify **essential vs accidental** complexity:
  - Essential — required by the domain (tax rules, auth rules, protocol spec)
  - Accidental — wrappers, unused options, duplicate paths, "just in case" layers
- Ask: **what is the smallest description of what this does?** If the code is 10× longer than that
  description, most of the gap is accidental.

Don't simplify what you don't understand — you'll delete load-bearing code.

### 3. Delete what isn't used (highest ROI, lowest risk)

Start here. Deletion is the purest simplification.

Remove:

- **Dead code** — unreachable branches, unused functions, orphaned files
- **Unused parameters and variables** — including "reserved for later" args
- **Commented-out blocks** — git history remembers; comments rot
- **Feature flags and config options** nothing sets anymore
- **Imports and dependencies** pulled in but unused ([[dependency-hygiene]])
- **Speculative types/interfaces** with no implementations or callers

Run the test suite and linter after each deletion batch. If nothing breaks, it wasn't load-bearing.

```text
Red flag: export function handleLegacyV1() { ... }  // zero callers in repo
Action:   delete (or confirm external consumer first)
```

### 4. Remove real duplication — not coincidental similarity

**Duplication is two places that change for the same reason.** Similar-looking code that evolves
independently should stay separate ([[interface-design]] — don't force false coupling).

When duplication is real:

- **Rule of Three** — first occurrence, second duplicate, **third** time extract a shared helper.
  Premature extraction creates the wrong abstraction.
- Extract the **idea**, not the lines — name the helper for what it means (`computeLineTax`), not
  `doStuffFromCartAndCheckout`.
- Prefer **one obvious home** for shared logic — utils module, domain service, not a new `helpers2`.

When **not** to extract:

- Two snippets look alike but have different failure modes or change triggers
- Extraction would require boolean flags (`if (forCheckout)`) — worse than two clear functions

### 5. Collapse needless indirection

Every layer must **earn its keep** — hide a seam, swap implementations, or isolate a trust boundary.

| Smell | Action |
|-------|--------|
| Wrapper with one caller, no interface | Inline it |
| Service that only delegates to one repo | Call the repo directly or merge |
| Abstract base with one subclass | Delete the hierarchy |
| Factory that returns one type | Construct directly |
| "Manager/Handler/Processor" pass-through | Collapse to the layer that decides |
| Generic framework for one use case | Replace with plain code |

**Indirection that's worth keeping:**

- Multiple real implementations behind one interface
- Clear module boundary between teams or deploy units
- Test seam (inject dependency) with more than one production path

If removing a layer makes testing harder, keep a **thin** seam — not a cathedral.

### 6. Simplify control flow and state

- **Replace deep nesting** with early returns (guard clauses) — fewer variables in scope at once.
- **Collapse boolean explosion** — five params × three flags → config object or explicit types/states.
- **Replace state machines drawn with flags** — `isLoading && !isError && hasData` → enum/status field
  with valid transitions only.
- **Fewer mutable variables** — prefer deriving values during render/calculation over sync effects
  ([[react-patterns]]).
- **Remove special cases** by making the general case handle them — often the data model is wrong
  ([[data-modeling]]).

```text
Before: if (x) { if (y) { if (!z) { doThing(); } } }
After:  if (!x || !y || z) return; doThing();
```

### 7. Replace clever with clear

Clever code is read many times and understood once.

- Prefer **obvious constructs** over terse tricks — readable loop over chained one-liner.
- **Name for intent** — `retryCount` not `n`, `expiredToken` not `t`.
- Replace **magic numbers/strings** with named constants when meaning isn't obvious.
- Delete comments that **restate the code**; keep comments that explain *why* a non-obvious rule exists.
- If you need a comment to explain *what* a line does, rewrite the line.

Clarity is not "more lines" — often the clear version is shorter.

### 8. Simplify data and API surfaces

- **Fewer parameters** — if a function takes 8 args, group related ones or pass a typed object with
  a small surface ([[interface-design]]).
- **Flatten deep JSON** only when callers need it flat — don't map-unmap-map for sport.
- **Remove optional fields** nobody passes — YAGNI on API shape.
- **Prefer plain data** over objects with behavior when behavior is one function away.
- **Delete unused exports** — public surface is a promise; shrink it when callers allow
  ([[migration-path]] if breaking).

### 9. Prefer owning small code over heavy dependencies

Before adding or keeping a package for a trivial job ([[dependency-hygiene]]):

```text
Ask: Would ~20 lines of boring code be simpler than this dependency + its upgrade path?
```

Simplify by **removing** dependencies when:

- You use one function from a large library
- The dependency pulls transitive weight for a one-liner
- The API is harder to learn than the problem

Keep the dependency when security, correctness, or maintenance cost clearly favors it (crypto, parsing
complex formats). Document the choice in [[decision-docs]] if non-obvious.

### 10. Refactor in small, behavior-preserving steps

The sequence that works:

1. **Green tests**
2. **One simplification** (delete, inline, extract, rename)
3. **Green tests again**
4. **Commit**
5. Repeat

Never combine **behavior change + structural refactor** in one commit — reviewers and bisect can't tell
what broke. If simplification reveals a bug, fix in a separate commit with a regression test
([[fault-recovery]]).

For large messes, **strangler approach** ([[incremental-delivery]]): simplify the path you're about to
touch; leave unrelated tangles for later scoped PRs.

### 11. Know when to stop

Stop simplifying when:

- **Further change needs a behavior decision** — that's product/spec, not cleanup
- **You're adding abstraction** to make it "more flexible" — YAGNI
- **Perf-critical path** — measure before restructuring ([[perf-budget]]); clearer code that doubles
  allocations on the hot path may need a different trade-off
- **The result is smaller but harder to read** — wrong extract; revert and try again
- **Diminishing returns** — two readable functions beat one "elegant" meta-function

Ship the PR when behavior is unchanged, tests green, and a stranger could follow the flow faster.

## Common Rationalizations

- "We might need it later." — Add it later when "later" is real; YAGNI beats speculative flexibility.
- "It's clever, leave it." — Clever code is cursed on every read; clear wins.
- "Touching it is risky." — With tests, the bigger risk is leaving the maze for the next hurried edit.
- "It works, don't refactor." — Working but unreadable code is a future bug factory.
- "One more abstraction will make it clean." — Abstractions accumulate; deletion and inlining clean better.
- "I'll simplify while adding the feature." — Mixed PRs are hard to review; separate cleanup when possible.
- "Duplication is DRY violation — extract now." — Wrong abstraction is worse than two clear copies.
- "Removing the dependency is too much work." — Transitive deps are permanent work; weigh honestly.

## Red Flags

- Abstractions with exactly one implementation or caller
- Same logic copy-pasted in several places with no extract plan
- Layers that only pass calls through unchanged
- Functions you re-read three times to follow
- Flags and config options nothing sets
- "Flexible" frameworks built for requirements that don't exist
- Refactor PR with no tests and wide diff
- Public API changed without caller updates or migration note
- New helper file created for one 3-line function used once
- `utils`, `helpers`, `common` folders growing without domain meaning
- Simplification that adds more lines than it removes

## Verification

- [ ] Scope bounded; behavior unchanged unless explicitly in scope
- [ ] Tests green before and after; characterization tests added if none existed
- [ ] Dead code, unused params, orphaned flags, and unused deps removed
- [ ] Real duplication extracted (Rule of Three); coincidental similarity left alone
- [ ] Single-use indirection inlined; remaining layers earn their keep
- [ ] Control flow and state reduced — early returns, fewer flags, clearer status
- [ ] Clever constructs replaced with clear names and obvious logic
- [ ] Public API surface not accidentally shrunk or expanded without [[interface-design]] / [[migration-path]]
- [ ] Refactor in small commits; no behavior change mixed with structural cleanup
- [ ] Result is smaller or same size, strictly easier to read — not a new abstraction maze
