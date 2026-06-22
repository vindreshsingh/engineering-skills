---
name: skill-router
description: Meta-skill that routes a task to the right engineering skill. Load this at the start of a session or when unsure which skill applies — it maps intent to the process that should govern the work.
---

# Skill Router

This repo's skills are **step-by-step processes**, not reference docs. The hard part is loading the
right one at the right moment — then following it fully. This skill is the map: identify what you're
doing, pick the matching skill(s), work in lifecycle order, and chain to the next phase when done.

## The Rule (mandatory)

**If there is even a ~1% chance a skill applies, invoke it before acting** — before clarifying
questions, before writing code, before "just doing it." Check the routing table below first. If a
loaded skill turns out not to fit, set it aside; but you do not get to skip the check, and **partial
application counts as skipping**. Confidence without the process is exactly the failure these skills
exist to prevent.

**Precedence:** the user always wins. If the user — or `CLAUDE.md`/`AGENTS.md` — says not to use a
skill, follow the user. Skills override your *default* behavior, never an explicit instruction.

**Before routing:** confirm [[agent-guardrails]] is active — destructive data ops, secret access, and
security bypasses require explicit user approval regardless of which skill you pick next.

Wrong skill or partial application is worse than no skill — you get confidence without the process.
When several skills apply, pick a **primary** skill for the current step and pull in **secondary**
skills only when the diff or task touches their domain ([[context-curation]] keeps the load lean).

## When to Use

- Start of a session — before improvising a workflow that already exists here
- User request could match multiple skills — need disambiguation
- Unsure whether to spec, plan, or jump to code
- Task spans phases — need the lifecycle order
- Recurring work type might need a new skill ([[skill-creator]])

**Skip** re-reading the full map when you're mid-phase and the next skill is obvious (e.g. finished
[[spec-first]], now load [[work-planning]]). **Not a substitute for** any domain skill — routing
points you to the process; the process does the work.

## Process

### 1. Classify the request — what kind of work is this?

Read the user's ask for **intent**, not keywords alone:

| Signal | Likely phase | First skill to load |
|--------|--------------|---------------------|
| One-line idea → full buildable, measurable plan | Define | [[product-discovery]] |
| Vague idea, "should we build…?" | Define | [[idea-shaping]] |
| Need PRD, RFC, stakeholder alignment | Define | [[product-brief]] |
| Know what to build, need spec before code | Define | [[spec-first]] |
| Groom backlog before sprint planning | Plan | [[product-grooming]] |
| Spec exists, need tasks/order/estimate | Plan | [[work-planning]] |
| Implement, add feature, change behavior | Build | [[incremental-delivery]] + [[test-first]] |
| Something broke / unexpected behavior (dev) | Verify | [[fault-recovery]] |
| Something broke in **production** / alert firing | Operate | [[incident-response]] |
| Review PR or own diff before merge | Review | [[review-gate]] |
| Deploy / release / go live | Ship | [[launch-readiness]] |
| Launch a shipped feature — full go-to-market | Grow | [[launch-campaign]] |
| Market product / grow traffic / SEO / social | Grow | [[growth-strategy]] — see `marketing/SKILL.md` and `skills/marketing/` |
| Not sure | Meta | Stay here; use maps below |

If the request mixes phases ("build and ship today"), **still sequence** — define/plan may be a 5-minute
pass, not skipped silently when risk is high.

### 2. Match intent to a skill

Use the **primary intent** — the thing the user most needs done *right now*.

#### Define — clarify before building

| You're about to… | Load |
|------------------|------|
| Run a raw idea through full discovery (problem → PRD → metrics → tasks) | [[product-discovery]] |
| Shape a raw idea into something concrete | [[idea-shaping]] |
| Write a PRD / product brief / RFC | [[product-brief]] |
| Define what to build before coding | [[spec-first]] |

#### Plan — order the work

| You're about to… | Load |
|------------------|------|
| Break work into ordered, verifiable tasks | [[work-planning]] |

#### Build — implement correctly

| You're about to… | Load |
|------------------|------|
| Implement a feature or change in slices | [[incremental-delivery]] |
| Write logic/tests (with or after spec) | [[test-first]] |
| Shrink or focus what the agent reads | [[context-curation]] |
| Verify API/library/code behavior before relying on it | [[source-first]] |
| Build or change user-facing UI | [[ui-craft]] |
| Add click feedback or view/route transitions | [[micro-interactions]] |
| Make UI usable by everyone (a11y) | [[accessibility]] |
| Turn a design/mockup into code | [[design-handoff]] |
| Write/review React or Next.js (perf, RSC, data) | [[react-patterns]] |
| Design an API, module, or schema boundary | [[interface-design]] |
| Design DB schema, indexes, or fix queries | [[data-modeling]] |
| Add AI/LLM product behavior (prompts, tools, evals) | [[llm-feature-engineering]] |
| Harden failure paths (timeouts, retries, idempotency) | [[resilience]] |
| Add caching to an expensive read | [[caching-strategy]] |

#### Verify — prove it works

| You're about to… | Load |
|------------------|------|
| Confirm a web change in a real browser | [[browser-checks]] |
| Automate critical user journeys (E2E) | [[e2e-testing]] |
| Debug a failure, failing test, or surprise behavior | [[fault-recovery]] |

#### Review — check before merge

| You're about to… | Load |
|------------------|------|
| Review a PR or self-review a diff | [[review-gate]] |
| Remove accidental complexity / refactor for clarity | [[simplify]] |
| Security pass (auth, input, secrets) | [[hardening]] |
| Something is slow — measure and fix the bottleneck | [[perf-budget]] |
| Add, upgrade, or audit dependencies | [[dependency-hygiene]] |
| Upgrade a package — research release notes and fix breaking changes | [[version-upgrade]] |

#### Ship — get it out safely

| You're about to… | Load |
|------------------|------|
| Commit, branch, merge, recover git mistakes | [[git-flow]] |
| Set up or fix CI/CD, builds, deploy automation | [[pipeline-ops]] |
| Change schema/API/deps others depend on | [[migration-path]] |
| Record a technical decision or fix docs | [[decision-docs]] |
| Design UX flows before UI | [[ux-design]] |
| Mobile app feature (RN/Flutter) | [[mobile-patterns]] |
| Add languages / locales | [[i18n-l10n]] |
| Cloud cost spike or budget | [[finops-budget]] |
| Write README, API docs, runbooks | [[technical-writing]] |
| Verify ready for production (rollout, rollback, monitoring) | [[launch-readiness]] |

#### Operate — run and learn in prod

| You're about to… | Load |
|------------------|------|
| Add logging, metrics, tracing, alerts | [[observability]] |
| Handle production incident or write postmortem | [[incident-response]] |

#### Grow — traffic, engagement, retention

| You're about to… | Load |
|------------------|------|
| Run a full go-to-market launch for a shipped feature | [[launch-campaign]] |
| Plan go-to-market, positioning, campaign calendar | [[growth-strategy]] |
| Write blog, tutorial, newsletter, landing copy | [[content-marketing]] |
| Post on social, launch threads, distribute content | [[social-distribution]] |
| Improve SEO, keywords, page rankings | [[seo-growth]] |
| Build community, welcome flows, engagement | [[community-engagement]] |
| Run paid ads with CAC tracking | [[paid-ads]] |
| Email welcome / nurture sequences | [[email-nurture]] |
| Referral / invite viral loops | [[referral-loop]] |

#### Meta — this repo's skills

| You're about to… | Load |
|------------------|------|
| Route or pick the right skill (you are here) | [[skill-router]] |
| Drive a whole feature end-to-end (define → ship) | [[orchestrated-delivery]] |
| Dispatch independent tasks to parallel subagents | [[parallel-subagents]] |
| Write or improve a skill in this repo | [[skill-creator]] |
| Capture a lesson from this session back into the library | [[skill-harvest]] |

### 3. Disambiguate when several skills seem to fit

| Tension | Choose |
|---------|--------|
| [[product-discovery]] vs [[idea-shaping]] vs [[product-brief]] | Whole front-of-funnel (problem → PRD → metrics → task plan) → product-discovery; sharpen one fuzzy idea only → idea-shaping; one PRD for an already-validated problem → product-brief |
| [[product-discovery]] vs [[orchestrated-delivery]] | Idea → validated, scoped, planned (stops before build) → product-discovery; carry the feature all the way to ship → orchestrated-delivery |
| [[idea-shaping]] vs [[spec-first]] | Idea fuzzy → shape first; problem clear → spec |
| [[product-brief]] vs [[spec-first]] | Stakeholders/PRD/RFC → brief; eng implementation spec → spec-first |
| [[fault-recovery]] vs [[incident-response]] | Dev/local/staging debug → fault-recovery; **prod outage/alert** → incident-response |
| [[perf-budget]] vs [[react-patterns]] vs [[caching-strategy]] | Measure first ([[perf-budget]]); frontend/React → react-patterns; repeated expensive read → caching-strategy |
| [[ui-craft]] vs [[accessibility]] vs [[design-handoff]] vs [[micro-interactions]] | General UI → ui-craft; a11y compliance → accessibility; mockup → design-handoff; click/route motion → micro-interactions |
| [[simplify]] vs [[review-gate]] | Dedicated cleanup/refactor → simplify; PR review gate → review-gate (may *suggest* simplify) |
| [[hardening]] vs [[review-gate]] | Deep security work or audit → hardening; general pre-merge review → review-gate (includes light security) |
| [[source-first]] vs [[context-curation]] | Verify behavior/API → source-first; manage total files in agent context → context-curation |
| [[dependency-hygiene]] vs [[version-upgrade]] vs [[migration-path]] | Vet/add/audit deps → dependency-hygiene; bump vendor version with research → version-upgrade; your API/schema breaks consumers → migration-path |
| [[migration-path]] vs [[interface-design]] | Designing the contract → interface-design; rolling out breaking change → migration-path |
| [[launch-readiness]] vs [[pipeline-ops]] | "Are we ready to ship this change?" → launch-readiness; "Fix the CI pipeline" → pipeline-ops |
| [[launch-campaign]] vs [[launch-readiness]] vs [[growth-strategy]] | Market a shipped feature end-to-end (the GTM conductor) → launch-campaign; *engineering* release gate (rollout/rollback/monitoring) → launch-readiness; one GTM plan/calendar without running the whole launch → growth-strategy |
| [[growth-strategy]] vs [[content-marketing]] vs [[social-distribution]] | Plan/calendar/positioning → growth-strategy; long-form article → content-marketing; short posts/threads → social-distribution |
| [[seo-growth]] vs [[content-marketing]] | Keyword map + on-page fixes → seo-growth; write the article → content-marketing |
| [[resilience]] vs [[caching-strategy]] | Failure/retry/idempotency → resilience; speed repeated reads with staleness rules → caching-strategy |
| [[skill-harvest]] vs [[skill-creator]] | Deciding *whether/what/where* to capture a lesson → skill-harvest; authoring/fixing the skill itself → skill-creator (harvest hands off to it) |

When still unsure, prefer the skill **earlier in the lifecycle** — spec beats code, measure beats optimize.

### 4. Use common recipes — multi-skill chains

These are typical sequences; run **one primary skill at a time**, chain when the phase completes.

**Idea → buildable plan (discovery)**

```text
[[product-discovery]]  (runs idea-shaping → product-brief → success metrics
→ RFC handoff → work-planning, gating on sign-off) → hand off to Build
```

**New feature (full lifecycle)**

```text
[[product-discovery]] (or [[idea-shaping]]? → [[spec-first]]) → [[work-planning]]
→ [[incremental-delivery]] + [[test-first]]
→ [[browser-checks]] (if UI) → [[review-gate]]
→ [[launch-readiness]]
```

**Bug fix**

```text
[[fault-recovery]] → [[test-first]] (regression test) → [[review-gate]]
→ [[skill-harvest]] (if the root cause was non-obvious)
```

**Production incident**

```text
[[incident-response]] → (after) [[fault-recovery]] or [[decision-docs]] for follow-ups
```

**New HTTP API**

```text
[[interface-design]] → [[test-first]] + [[incremental-delivery]]
→ [[hardening]] → [[review-gate]] → [[launch-readiness]]
```

**Breaking API/schema change**

```text
[[interface-design]] → [[migration-path]] → [[test-first]] → [[review-gate]] → [[launch-readiness]]
```

**Slow checkout / page**

```text
[[perf-budget]] → [[react-patterns]] and/or [[data-modeling]] and/or [[caching-strategy]]
```

**Implement Figma screen**

```text
[[design-handoff]] → [[ui-craft]] → [[accessibility]] → [[browser-checks]] → [[review-gate]]
```

**Add npm package**

```text
[[dependency-hygiene]] → [[review-gate]]; justify vs own ([[simplify]])
```

**LLM feature**

```text
[[spec-first]] → [[llm-feature-engineering]] → [[hardening]] → [[observability]] → [[review-gate]]
```

**Product launch / go-to-market**

```text
[[launch-readiness]] (ship safely) → [[launch-campaign]]  (Grow conductor: runs
growth-strategy → community-engagement [seed before traffic] → seo-growth
→ content-marketing → social-distribution → email-nurture + referral-loop
→ growth-strategy weekly review, gating on the ordering rule)
```

### 5. Apply lifecycle order across phases

When a task spans phases, move **top-down** — don't jump to code if requirements are ambiguous.

**Define → Plan → Build → Verify → Review → Ship → Operate → Grow**

| Phase | Skills |
|-------|--------|
| **Define** | product-discovery, idea-shaping, product-brief, spec-first |
| **Plan** | work-planning, product-grooming |
| **Build** | incremental-delivery, test-first, context-curation, source-first, ui-craft, micro-interactions, ux-design, accessibility, react-patterns, mobile-patterns, i18n-l10n, interface-design, design-handoff, resilience, data-modeling, caching-strategy, llm-feature-engineering |
| **Verify** | browser-checks, e2e-testing, fault-recovery |
| **Review** | review-gate, simplify, hardening, perf-budget, dependency-hygiene, version-upgrade |
| **Ship** | git-flow, pipeline-ops, migration-path, decision-docs, technical-writing, launch-readiness |
| **Operate** | observability, incident-response, finops-budget |
| **Grow** | launch-campaign (Grow conductor), growth-strategy, content-marketing, social-distribution, seo-growth, community-engagement, paid-ads, email-nurture, referral-loop (`skills/marketing/`) |
| **Orchestrate** | orchestrated-delivery (conductor across all phases), parallel-subagents |
| **Meta** | skill-router, skill-creator, skill-harvest |

Finishing one phase **points to the next** — e.g. after Build + Verify, load [[review-gate]] before merge.

### 6. Load and follow — rules of use

1. **If a skill matches, load and follow it** — don't improvise a weaker version under time pressure.
2. **Follow it fully** — especially Verification checklists and anti-rationalization sections; partial
   application loses most value.
3. **One primary skill at a time** — secondary skills when the task touches their domain (see
   [[review-gate]] routing table pattern).
4. **Read the skill's `description`** — it's the trigger; if your task matches, trust it.
5. **Chain, don't stack** — finish [[spec-first]] before deep [[incremental-delivery]]; don't load all
   Build skills for a planning question.
6. **Agents complement skills** — code-reviewer with [[review-gate]], security-auditor with
   [[hardening]], test-engineer with [[test-first]]; the skill is still the process.

### 7. When no skill fits

If the task genuinely doesn't match anything:

- Proceed with sound engineering judgment
- Note the gap — recurring work without a skill → [[skill-harvest]] (triage) → [[skill-creator]] (author)
- After non-trivial work (tricky debug, repeated mistake, a skill that misfired), run [[skill-harvest]]
  to capture the lesson before context is lost
- Don't force-fit the wrong skill (e.g. [[simplify]] on an production incident)

## Common Rationalizations

- "I know the process, I don't need the skill." — These skills encode steps people skip under pressure.
- "I'll load the skill after I start." — Wrong skill from minute one wastes the first hour.
- "Load everything so nothing is missed." — Context bloat; one primary skill per step ([[context-curation]]).
- "This is urgent, skip spec/plan." — Urgent bugs use [[fault-recovery]] / [[incident-response]]; urgent
  features still need a minimal spec when risk is non-trivial.
- "Review-gate covers it." — Review-gate routes to specialists; load [[hardening]] when the diff is
  auth-heavy, not only review-gate.
- "Any refactor skill will do." — [[simplify]] is behavior-preserving cleanup; [[migration-path]] is
  breaking change rollout — different jobs.

## Red Flags

- Jumping to code on a vague one-liner with no [[spec-first]] or [[idea-shaping]] when scope is unclear
- Using [[fault-recovery]] for a production outage instead of [[incident-response]]
- Loading five skills and following none of them completely
- [[perf-budget]] skipped — optimizing by intuition
- UI change marked done without [[browser-checks]]
- Breaking API change without [[migration-path]]
- "I'll read the skill later" on a security or launch task
- Inventing a new review checklist instead of using [[review-gate]]

## Verification

- [ ] Request classified by phase and primary intent
- [ ] Primary skill identified from the intent map (or disambiguation table)
- [ ] Lifecycle order respected — earlier phases not skipped when risk warrants them
- [ ] At most one primary skill loaded for the current step; secondaries only when domain requires
- [ ] Selected skill read and Process + Verification will be followed fully
- [ ] Next skill in the chain noted (e.g. after build → verify → review-gate)
- [ ] If nothing fits, gap noted for possible [[skill-creator]]
