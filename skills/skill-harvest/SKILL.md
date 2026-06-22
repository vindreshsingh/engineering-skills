---
name: skill-harvest
description: Captures a hard-won lesson from the current session back into the skill library before it evaporates. Use at the end of non-trivial work — after a tricky debug, a repeated mistake, a workflow that finally worked, or a skill that misfired or was ignored. Closes the self-improving loop by triaging the lesson and handing the keeper to skill-creator.
---

# Skill Harvest

A library of skills only compounds if what you learn *gets back into it*. The default failure is
silent: you solve something non-obvious, the session ends, and the lesson dies with the context
window. The next agent — maybe you tomorrow — re-learns it from scratch. **This skill is the reflex
that closes the loop:** notice the lesson, decide whether it's worth keeping, and route the keepers
into the library through [[skill-creator]].

Harvest is the *trigger and triage* layer. It does not author skills — [[skill-creator]] does that.
Harvest decides **whether**, **what**, and **where**; skill-creator handles **how**.

## When to Use

Run a harvest pass when the session produced a **reusable lesson**, especially:

- A debug that took real effort and the root cause was **non-obvious** ([[fault-recovery]] just ran)
- You (or the agent) **made the same class of mistake** you've made before — a pattern worth a guardrail
- A **workflow or sequence that finally worked** after false starts, that you'd want to repeat
- A skill **failed to fire** when it should have, **fired wrongly**, or was **ignored under pressure**
- A skill's steps were **incomplete or out of date** versus what actually worked
- A recurring task type has **no skill** and you improvised the same process twice ([[skill-router]] §7)
- A review, incident, or migration surfaced a rule that **isn't written down anywhere**

**Skip** when:
- The work was routine and an existing skill already covered it well — nothing new was learned
- The lesson is a **one-off fact** about *this* codebase (that's a repo doc / [[decision-docs]], not a skill)
- You're mid-task — harvest at a natural boundary, not as a distraction from finishing

**Not a substitute for** [[skill-creator]] (the authoring craft) or [[decision-docs]] (project-specific
records). Harvest points to those; it doesn't replace them.

## Process

### 1. Scan the session for harvest candidates

Before ending the work, ask explicitly: *what did I learn here that a future agent would want?*
Look for the signals above. Write each candidate as one sentence — the **lesson**, not the incident.

```text
Weak:   "We fixed the login bug."
Strong: "OAuth state cookies silently drop when SameSite=Lax and the IdP posts back cross-site —
         the fix is SameSite=None; Secure. Worth a guardrail in hardening."
```

If nothing clears the bar, say so and stop — a forced harvest produces noise that dilutes routing.

### 2. Triage each candidate — what *kind* of thing is it?

| The lesson is… | Destination |
|----------------|-------------|
| A repeatable **process** people predictably cut corners on | New skill → [[skill-creator]] |
| A **gap or error in an existing skill** (missing step, wrong trigger, stale advice) | Improve that skill → [[skill-creator]] |
| A **mistake to prevent** before destructive/risky actions | Extend [[agent-guardrails]] |
| A routing miss (right skill existed, wasn't picked) | Fix the [[skill-router]] table / description |
| A **project-specific** fact or decision | [[decision-docs]] / repo docs — **not** a skill |
| A one-off fact, no repeatability | Drop it — not worth capturing |

Most weak harvests come from skipping this step and writing a "skill" for something that's really a doc
or a one-off. Triage honestly: **a skill encodes a repeatable workflow where corners get cut.**

### 3. Check it doesn't already exist

Search the library before creating anything (`grep -ri "<keyword>" skills/ agents/`). Overlap dilutes
routing worse than a missing skill. If a skill nearly covers it, **improve or link** that one rather
than spawning a near-duplicate.

### 4. Decide new-skill vs improve-existing — bias toward improving

- **Improve existing** when the lesson sharpens, corrects, or extends a skill that already fires for
  this work. Cheaper, keeps the library tight. Most harvests land here.
- **New skill** only when the work is a distinct, recurring job no existing skill owns, and you can
  name the trigger conditions an agent would see.

### 5. Hand off to skill-creator

Pass the triaged, deduped lesson to [[skill-creator]] with the destination decided. Skill-creator owns
the anatomy — trigger-rich `description`, executable Process, Common Rationalizations, Red Flags,
checkbox Verification — and the validation/catalog steps. Don't reinvent that here.

For a guardrail or router fix, make the edit directly in [[agent-guardrails]] / [[skill-router]] and
still run validation.

### 6. Validate and catalog

Run `scripts/validate.sh` and `scripts/generate-catalog.sh` (and `scripts/skill-test.sh` if you added
a behavioral test). A harvest that breaks structure or skips the catalog isn't done ([[pipeline-ops]]
enforces this in CI).

### 7. Confirm the loop closed

State what was harvested and where it went — or that nothing met the bar. A harvest with no decision
and no diff is a harvest that didn't happen.

## Common Rationalizations

- "I'll remember this." — You won't, and the next agent never had it. The context window is not the library.
- "It's not worth writing up." — If it cost you real time to learn, it'll cost the next person the same; the bar is *reusable*, not *novel*.
- "Just make it a new skill." — Most lessons sharpen an existing skill; a near-duplicate dilutes routing more than a gap does. Triage first (step 2).
- "Harvest = write a skill." — Harvest is triage; the lesson might be a guardrail, a router fix, a doc, or nothing. Deciding *that* is the work.
- "I'll harvest everything to be safe." — Forced harvests produce noise; an unfocused library is worse than a smaller sharp one.
- "I'm out of context, skip it." — The moment you have the lesson is the only moment it's cheap to capture; later it's gone.

## Red Flags

- A non-trivial debug or repeated mistake ends with **no harvest pass** at all
- A "new skill" that's really a one-off fact about this repo (belongs in [[decision-docs]])
- A harvested skill that overlaps an existing one instead of improving/linking it
- Triage skipped — every lesson defaulted to "new skill"
- Lesson written as the *incident* ("we fixed X") rather than the *transferable rule*
- Handed to [[skill-creator]] without checking for an existing skill first
- Validation / catalog not run after the change
- "I'll harvest later" on a lesson you only hold in the current context

## Verification

- [ ] Session scanned for candidates; each written as a transferable lesson, not an incident
- [ ] Each candidate triaged to a destination (new / improve / guardrail / router / doc / drop)
- [ ] Searched the library; no near-duplicate created — existing skill improved or linked when one fit
- [ ] New-vs-improve decided with bias toward improving an existing skill
- [ ] Keepers handed to [[skill-creator]] (or guardrail/router edited directly), not authored ad hoc here
- [ ] `validate.sh` + `generate-catalog.sh` run (and `skill-test.sh` if a test was added)
- [ ] Outcome stated: what was harvested and where, or an explicit "nothing met the bar"
