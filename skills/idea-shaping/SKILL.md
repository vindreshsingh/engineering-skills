---
name: idea-shaping
description: Turns a vague idea into a clear, evaluated problem statement before any spec or code. Use when a request is a one-liner, the problem is fuzzy, you're choosing between directions, or you're not yet sure the idea is worth building.
---

# Idea Shaping

Before you specify *what* to build, decide whether the idea is **worth building** and **clearly
understood**. Most weak features trace back to a fuzzy idea nobody pressure-tested — a solution handed
as a problem, an unexamined assumption, or the first option never compared to doing less.

Shaping is cheap. Building is expensive. A sharp **pursue / park / drop** with reasoning is a valid
outcome; a vague "yes let's try" is not.

This skill precedes [[spec-first]] for engineering specs and [[product-brief]] when stakeholders need
alignment on a PRD or RFC. For recording a significant chosen direction, see [[decision-docs]].

## When to Use

- The request is a single sentence or hand-wave ("add gamification", "we need AI here")
- The underlying problem is unclear, unstated, or disputed
- You're choosing between several possible directions
- You suspect the idea solves the wrong problem or is a vanity feature
- A stakeholder, exec, or customer proposed a solution — need to find the need underneath
- You're about to estimate or staff work and can't explain the problem in one sharp sentence

Skip when the problem is already shaped, evidenced, and agreed — go straight to [[spec-first]] or
[[product-brief]]. Skip for pure execution on a locked spec.

**Not this skill alone:** cross-team sign-off on a large initiative → shape first, then [[product-brief]].

## Process

Work in order. Don't write requirements until the problem statement survives pressure.

### 1. Capture the raw input — don't adopt the solution as the problem

Write what was said verbatim, then separate layers:

```text
Raw request: "Add a leaderboard to increase engagement"

Solution proposed: leaderboard
Problem (unknown): ??? engagement with what, for whom, why now
```

People hand you **solutions** and call them problems. Your job is to dig to the **need**.

**Clarifying questions** (ask until answers are concrete):

- Who specifically has pain or opportunity? (role, segment, not "users")
- What do they do **today** without this feature?
- What goes wrong or what's missing — in their words, not yours?
- How often does it happen? How painful is it (time, money, risk, frustration)?
- Why now? What changed — market, data, regulation, strategy?
- What would success look like **for them**, not for the dashboard?

If answers are vague ("engagement is low"), push for **observable behavior** ("users abandon onboarding
at step 3").

### 2. Write one sharp problem statement

A good problem statement has **who, pain, context, and why alternatives fail** — no solution baked in.

**Template:**

```text
[Who] experiences [pain] when [context/situation],
because [cause or constraint].
Today they [current behavior/workaround], which [cost of workaround].
```

**Examples:**

```text
Good: New sellers abandon listing creation after uploading photos because they don't
      know if pricing is competitive; they guess or leave and never publish.

Bad:  We need a pricing recommendation feature.
```

**Solution disguised as problem** — rewrite:

| Disguised | Reframed |
|-----------|----------|
| "We need push notifications" | Buyers miss time-sensitive deals because they don't check email within the offer window |
| "Build a mobile app" | Field technicians can't complete jobs when offline; they paper notes and re-enter later |
| "Add AI chat" | Support can't scale; wait time is 48h and CSAT dropped — unclear if chat is the fix |

If you can't write the statement without naming your favorite solution, you haven't finished shaping.

### 3. Map assumptions — name what must be true

List what the idea **assumes** without evidence:

| Assumption | Evidence we have | Confidence |
|------------|------------------|------------|
| Sellers quit because of pricing, not photos/UX | One support ticket | Low |
| Recommendations will increase publish rate | None | Guess |
| Sellers will trust algorithmic prices | Competitor survey | Medium |

**Circle the riskiest assumption** — if it's wrong, the whole idea fails. That's what you validate
first, cheapest.

Common hidden assumptions:

- Users want this (desire)
- Users will change behavior (adoption)
- We can build it within constraints (feasibility)
- It won't hurt another metric (strategic)
- Legal/compliance allows it (constraint)
- Data exists to power it (data)

### 4. Validate cheaply before building

Building is the most expensive experiment. Prefer **fast learning** on the riskiest assumption:

| Method | Cost | Good for |
|--------|------|----------|
| **5–8 user interviews** | Hours | Pain real? workaround? language? |
| **Data analysis** | Hours–days | Drop-off funnel, cohort, support tags |
| **Concierge / manual** | Days | Deliver outcome by hand before automating |
| **Fake door / prototype** | Days | Click interest without full build |
| **Survey** | Days | Breadth — weak on depth; triangulate |
| **Spike / technical prototype** | Days | Feasibility, latency, cost — not user value alone |

Record what you learned and **update assumptions**. "We talked to 6 sellers; 4 cited pricing anxiety,
2 cited photo quality" beats "users want this."

If validation fails the riskiest assumption → **drop or pivot** before [[spec-first]].

### 5. Generate alternatives — including less

The first idea is rarely the best. Sketch **at least three** approaches:

1. **Proposed solution** — what was handed to you
2. **Different approach** — same problem, different mechanism
3. **Minimum viable** — smallest change that might move the needle
4. **Do nothing** — cost of inaction; sometimes correct choice

```text
Problem: sellers abandon listing due to pricing uncertainty

A) ML price recommendation at upload
B) Show market range from public data (read-only, no ML)
C) Human pricing review for first 10 listings (concierge)
D) Improve copy explaining how to price (education only)
E) Do nothing — focus on photo upload UX instead (if data shows that's the drop)
```

Alternatives force trade-offs into the open. Skipping this step is how teams build expensive A when B
would have worked.

### 6. Evaluate with explicit criteria

Score or rank options against what **matters for this decision** — not every criterion every time.

Typical criteria:

| Criterion | Questions |
|-----------|-----------|
| **User value** | How much pain removed? For how many? |
| **Evidence** | What validates the riskiest assumption? |
| **Effort** | Build time, ongoing maintenance, ops burden |
| **Risk** | Technical, legal, reputational, metric cannibalization |
| **Strategic fit** | Aligns with company focus, moat, roadmap |
| **Time** | Urgency — deadline, season, competitive window |

Be honest about **trade-offs**:

```text
Option B is faster but may not be enough for power sellers;
Option A is high upside but 3-month build and needs pricing data we don't have yet.
```

Avoid false precision — "score 7.2" without reasoning helps no one. Narrative trade-offs help.

### 7. Decide — pursue, park, or drop

Record a clear decision with **why**:

| Decision | When | Record |
|----------|------|--------|
| **Pursue** | Problem sharp, riskiest assumption validated or acceptable, best option chosen | Chosen approach + why not others |
| **Park** | Maybe later — missing data, dependency, strategy timing | What must change to revisit; review date |
| **Drop** | Wrong problem, failed validation, better alternative elsewhere | Why not — prevents relitigation |

```text
Decision: PURSUE option B (market range display) for v1.
Why: interviews + funnel data support pricing anxiety; B ships in 2 weeks vs 3 months for ML.
Park A for Q3 if B moves publish rate +10%.
Drop C — ops cost not scalable.
```

"No" with reasoning is success. "Let's just try it" without criteria is not.

### 8. Hand off to the next artifact

| Next step | When |
|-----------|------|
| [[spec-first]] | Engineering team ready to build; problem shaped for one team |
| [[product-brief]] | Stakeholders, sign-off, cross-team initiative, PRD/RFC needed |
| [[decision-docs]] | Significant strategic choice others will question later |
| Spike ticket only | Technical feasibility unknown — time-boxed, not a feature commit |

**Handoff packet** (paste into spec or brief):

```text
Problem statement:
Assumptions (validated / still open):
Chosen direction:
Alternatives rejected and why:
Success signal (how we'll know it worked):
Out of scope for this round:
Open questions for spec:
```

### 9. Scenario playbooks

**Exec one-liner in Slack**

Capture verbatim → problem excavation in 30 min → one-page shape → pursue/park/drop before anyone
estimates.

**Engineer proposed solution**

"Let's use Kafka" → what problem? at what scale? what fails today? → maybe a queue isn't the issue.

**Competitive parity ("Competitor has X")**

What user job does X serve for *our* users? Is parity strategic or anxiety? Often a smaller local
win beats feature cloning.

**Internal tool / automation**

Who does manual work today? How many hours? What's the error rate? Internal ROI can be clear without
user interviews — still shape the problem.

**"We should add AI / LLM"**

What task, what input, what output, what failure cost? ([[llm-feature-engineering]]) — AI is an
implementation option, rarely the problem statement.

**Customer feature request**

Thank → understand job → check if request is representative → shape for segment size, not one loud
customer.

**Two good ideas, one team**

Shape both lightly → compare criteria → pick one → park the other with review trigger (metric, date).

## Common Rationalizations

- "The idea is obviously good." — Obvious ideas still hide wrong assumptions or better alternatives.
- "Let's just build it and see." — Building is the most expensive test; validate cheaper first.
- "There's only one way to do it." — There's always do-less and do-different; look harder.
- "We can validate after launch." — Launch without learning plan wastes the cheapest validation window.
- "The CEO asked for it." — Shape anyway; execs often want outcomes, not the first solution named.
- "We don't have time to think." — You'll spend more time rebuilding the wrong thing.
- "Data will tell us after we ship." — Define the metric before ship; else you can't interpret noise.
- "Park is the same as pursue slowly." — Park needs explicit triggers; otherwise it becomes zombie roadmap.

## Red Flags

- Jumping from one-line idea to implementation or spec with no problem statement
- "Problem" statement contains the solution name ("we need a leaderboard")
- No one can name who has pain or how they'd behave differently after
- Zero alternatives considered — only the handed solution
- Riskiest assumption never named or tested
- Success metric undefined — "engagement", "better", "modern" without observable behavior
- Pursue decision with no rejected alternatives documented
- Shaping skipped because "we already built the prototype"
- Park without review date or success criteria for revisit
- Shape doc is 20 pages — nobody reads it; one page plus handoff packet is enough

## Verification

- [ ] Raw request captured; solution separated from underlying problem
- [ ] Sharp problem statement — who, pain, context, workaround cost (no solution baked in)
- [ ] Assumptions listed; riskiest assumption identified
- [ ] Cheap validation done or explicitly deferred with owner and method ([[spec-first]] blocker if wrong)
- [ ] At least three alternatives weighed, including minimum and do-nothing
- [ ] Trade-offs explicit across value, effort, risk, fit — not just gut feel
- [ ] Clear pursue / park / drop decision with reasoning and rejected options recorded
- [ ] Handoff packet ready for [[spec-first]] or [[product-brief]]
- [ ] Success signal defined — how we'll know the chosen direction worked or failed
