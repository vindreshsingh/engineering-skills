---
name: context-curation
description: Manages what information an AI agent works from so context stays relevant, grounded, and small. Use when a task spans many files, when responses drift or hallucinate, when writing project rules or agent instructions, when a long session degrades, or when designing prompts and agent tools that carry context.
---

# Context Curation

An agent is only as good as what's in its context window. Too little and it guesses; too much and the
signal drowns in noise. Models also **lose focus in the middle** of long contexts — burying the
important bit under thousands of tokens of "related" material doesn't make work safer, it makes it worse.

Curate deliberately: load what the **current step** needs, ground it in **authoritative sources**, and
**prune** what no longer matters. Context curation is not a one-time setup — it's ongoing hygiene for
every step of a task.

Pairs with [[source-first]] for what to load, [[work-planning]] for step boundaries,
[[incremental-delivery]] for slice-sized working sets, and [[decision-docs]] for durable "why" that
shouldn't live in chat.

## When to Use

- A task touches a large codebase and you must choose what to show the agent
- Responses drift, repeat, hedge, or invent files/APIs that don't exist
- You're writing or reorganizing project rules, `CLAUDE.md`, `AGENTS.md`, or Cursor rules
- A long session is degrading — slower, vaguer, or contradicting earlier decisions
- Designing LLM prompts, system instructions, RAG retrieval, or agent tool payloads ([[llm-feature-engineering]])
- Handing work to another person or a fresh session and need a clean starting point
- Multiple skills or large reference docs are tempting you to "load everything just in case"

Skip as the primary skill for a trivial one-file edit with no drift — but still apply the working-set
habit. Never skip when setting up standing instructions; bad project memory poisons every future task.

## Process

Work in order. Later steps assume you've classified what kind of context you're managing.

### 1. Classify what you're holding

Context isn't one blob. Separate it mentally (and in project files) into layers:

| Layer | What it is | Where it lives | Load when |
|-------|------------|----------------|-----------|
| **Standing rules** | Conventions, architecture constraints, routing | `CLAUDE.md`, rules, `AGENTS.md` | Every session — keep small |
| **Task brief** | Goal, scope, acceptance criteria for this work | Spec, ticket, plan item | Start of task — restate often |
| **Working set** | Code, types, contracts, tests for *this step* | Files you read this turn | Each step — narrowest slice |
| **Durable why** | Decisions, trade-offs, dragons | ADRs, decision docs | When choice affects the step |
| **Conversation** | Prior reasoning, attempts, conclusions | Chat history | Summarize down — don't replay |

**Rule:** standing rules are tiny and stable; working set is large only for the moment you need it,
then collapses to a conclusion.

### 2. Define the working set for this step

Before reading or pasting anything, write (in chat or a scratch note) a one-line **step goal** and the
**minimum** material required to achieve it. Pair with [[work-planning]] when the task has multiple steps.

Include only:

- The **function, type, or module** you're changing — not every file in the directory
- **Contracts** the change must honor: API schema, interface, public types, event shape
- **One example** of correct usage or test — not every test in the suite
- **The error or symptom** — stack trace, log line, failing test name — for debugging
- **Explicit out-of-scope** — "do not touch billing," "ignore legacy `v1` endpoints"

Resist:

- "Everything in `src/features/`"
- Whole files when one exported function matters
- Duplicating code already in the repo as a pasted paraphrase
- Loading five skills because the task is "big"

```text
Step goal: Fix null handling in OrderSummary when cart is empty.

Working set:
  - components/OrderSummary.tsx (render + props)
  - types/cart.ts (CartSummary shape)
  - OrderSummary.test.tsx (empty-cart case)

Out of scope: checkout flow, payment APIs, other cart components
```

### 3. Load precisely — search wide, read narrow

Retrieval strategy:

1. **Search** (grep, semantic search, symbol lookup) to *find* candidates.
2. **Read** only the matched region — function, type block, config key — not the whole file.
3. **Trace** one call path for behavior questions; don't load every importer ([[source-first]]).
4. **Prefer pointers** — file path + line range — over pasting full source into chat.
5. **One skill at a time** — load the skill for the *current phase* ([[skill-router]]), not the whole catalog.

When a file is huge:

- Read the export/signature first, then the implementation you touch.
- Skip generated code, lockfiles, and vendor bundles unless the bug is there.
- For configs, load the key you need — not every environment block.

### 4. Ground in authoritative sources

Paraphrase is a lossy compression that invents details. Load the real artifact:

- **Code and types** over your memory of the API
- **Installed version** over docs for a different release
- **Schema/OpenAPI** over a Slack description of the endpoint
- **Failing test output** over a guess at what failed

If you must summarize for another session, summarize **conclusions** ("`CartSummary.items` is optional
when empty") — not a hand-wavy recreation of the code. See [[source-first]].

### 5. Front-load rules, lazy-load detail

**Standing instructions** should be:

- **Short** — if rules exceed a few screens, agents skim and miss the critical line
- **Specific** — "validate at API boundary" beats "handle errors properly"
- **Non-contradictory** — pick one convention; delete the stale rule
- **Stable** — task-specific detail belongs in the ticket, not `CLAUDE.md`

**Task detail** loads on demand when that task is active. Don't put "how to run the e2e suite for
feature X" in global rules if only feature X work needs it.

When writing rules, link to deeper docs instead of duplicating them:

```markdown
<!-- Good -->
API errors: use `ApiError` shape in `lib/errors.ts`. See ADR-012 for why we don't throw raw strings.

<!-- Bad -->
API errors: sometimes we use ApiError, but legacy routes return { error: string } except on Tuesdays...
```

### 6. Prune and summarize as you go

Context fills with transcripts. Treat finished work as **outcomes**, not **play-by-play**.

After each sub-task or slice ([[incremental-delivery]]):

- **Collapse** exploration: "Tried A and B; B works because cache key includes tenant."
- **Drop** superseded code snippets from chat — the repo has the truth.
- **Remove** failed hypotheses unless they prevent repeat mistakes.
- **Keep** decisions and constraints: "We must not add a DB round-trip here — perf budget."

Signs you need to prune now:

- The same file was pasted three times
- A 20-message debugging thread with no stated conclusion
- Instructions repeated because "the agent forgot"

### 7. Re-anchor on long tasks

On multi-step or multi-session work, periodically restate a **state block** (every few steps or when
quality dips):

```text
Goal: Add guest checkout (spec §3.2).
Done: cart merge, guest session cookie, OrderSummary empty state.
Current: payment redirect — investigating 422 on POST /api/orders.
Constraints: no new DB tables; must work with existing Stripe webhook.
Next: trace validateOrderPayload → fix schema mismatch.
Not doing: account creation upsell (out of scope).
```

Re-anchor beats silent drift. If re-anchoring doesn't help — context is polluted beyond recovery —
**start a fresh session** with a tight brief and the state block, not the full old transcript.

### 8. Maintain durable project memory

When you discover something every future agent should know:

- **Convention** → short rule in `CLAUDE.md` or project rules
- **Significant choice** → ADR or decision doc ([[decision-docs]])
- **Repeatable process** → skill in this repo ([[skill-creator]])

Audit standing memory when:

- Agents keep making the same wrong assumption
- Two rules contradict each other
- A rule describes code that no longer exists
- New hires (or agents) ask the same "why" question

Delete or supersede stale rules. Wrong memory is worse than none.

### 9. Scenario playbooks

**Large feature across many files**

- Plan steps first ([[work-planning]]); one working set per step.
- Each slice: load only what that slice touches; summarize before the next slice.
- Don't load the whole spec every turn — load the current section.

**Debugging**

- Working set: error message, stack, inputs, one reproduction path.
- Trace until the mismatch is found; don't load unrelated modules.
- State the root cause in one sentence before fixing.

**Code review**

- Diff + files that define contracts the diff relies on.
- Don't load the entire codebase to "understand context."
- If review needs architecture why, load the ADR — not five adjacent services.

**Session handoff**

- Write a state block (goal, done, current, constraints, next).
- Link paths, not pasted code.
- Fresh session starts from the block + narrow working set.

**Subagents and parallel exploration**

- Isolate heavy search in a subagent; parent keeps **summary + pointers**.
- Parent context should not absorb every file the subagent read.

**LLM prompts and tools**

- Same rules: minimal grounded context per call.
- Retrieve facts; don't stuff the whole knowledge base.
- Validate tool payloads — don't pass unbounded user text ([[llm-feature-engineering]], [[hardening]]).

### 10. Resolve contradictions before loading

Conflicting instructions produce hedging, wasted tokens, and wrong compromises.

Before adding or loading rules:

- Search for an existing rule on the same topic.
- **Pick one** convention; remove or supersede the other.
- If both are valid in different layers, **scope** them: "In `legacy/` use X; in `api/v2/` use Y."

Never load two skills whose processes conflict for the same step without choosing which governs.

## Common Rationalizations

- "More context is safer." — Past a point, extra context lowers accuracy and hides the relevant bits.
- "I'll paste the whole file." — Show the function that matters; the rest is noise the model must wade through.
- "It remembers what we discussed." — Detail decays as the window fills; re-anchor or restart with a state block.
- "One big rules file covers it." — Rules that contradict or over-specify confuse more than they help.
- "I'll load all the skills so nothing is missed." — Agents follow none of them fully; load one for the current phase.
- "Paraphrasing the API is faster than reading it." — Paraphrase invents parameters; read the signature.
- "The transcript is fine — I need the history." — History without summary is a pile of noise; collapse to outcomes.
- "We'll clean up CLAUDE.md later." — Every session pays the cost of stale or conflicting rules until you do.

## Red Flags

- Dumping entire directories or monorepo packages into context "for completeness"
- The agent references files, functions, or APIs that don't exist
- Quality dropping as the session grows — vaguer answers, repeated mistakes
- Standing instructions that contradict each other or describe deleted code
- The same code or explanation pasted repeatedly instead of summarized once
- Five skills loaded for one task; none followed completely
- Debugging with no stated reproduction path or error text in context
- `CLAUDE.md` or rules files longer than a few screens with no clear hierarchy
- Handoff is "read the whole chat" instead of a state block and pointers
- Prompt or tool design that passes unbounded context every call

## Verification

- [ ] Context layers identified — standing rules vs task brief vs step working set
- [ ] Step goal and minimum working set written before bulk loading
- [ ] Out-of-scope explicitly stated for the current step
- [ ] Search wide, read narrow — functions/regions, not whole directories
- [ ] Authoritative sources loaded ([[source-first]]); no invented APIs from paraphrase
- [ ] Only the skill(s) for the current phase loaded ([[skill-router]])
- [ ] Finished sub-tasks collapsed to conclusions; duplicate snippets removed
- [ ] Long task re-anchored with goal, done, current, constraints, next — or fresh session with state block
- [ ] Standing rules are short, specific, non-contradictory, and stale rules removed or superseded
- [ ] Handoffs use state block + paths, not full transcript replay
