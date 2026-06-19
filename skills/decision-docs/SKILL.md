---
name: decision-docs
description: Captures architectural decisions and the reasoning behind them (ADRs) and keeps docs useful. Use when making a significant technical choice or when documentation is missing, stale, or misleading.
---

# Decision Docs

Record the decisions that are expensive to reverse and the *why* behind them. Code shows what you did;
it can't show what you considered and rejected, or what constraint forced your hand. That context is
what saves the next person from relitigating settled questions — or repeating a mistake.

## When to Use

- Choosing an architecture, framework, datastore, protocol, or major pattern
- Making a trade-off that future maintainers will question ("why not X?")
- A decision that's costly to undo or affects many parts of the system
- Documentation is absent, outdated, or actively wrong

## Process

1. **Write the decision down when you make it**, while the alternatives and reasoning are fresh. An
   ADR is short: context, the decision, the options considered, the consequences.
2. **Lead with the why.** State the problem and constraints, then the choice. The rejected options and
   *why* they lost are the most valuable part.
3. **Be honest about trade-offs.** Every real decision costs something; name what you're giving up so
   nobody assumes it was free.
4. **Keep it close to the code** and version-controlled, so it travels with what it describes.
5. **Treat ADRs as immutable history.** Don't edit a past decision — supersede it with a new one that
   references the old, so the evolution is visible.
6. **Document what isn't obvious from the code**: setup gotchas, why a workaround exists, the
   non-obvious "here be dragons." Skip narrating what the code already says.
7. **Prune and fix stale docs** as you touch areas — wrong docs are worse than none.

## Common Rationalizations

- "The code is self-documenting." — Code documents *what*, never the *why* or the roads not taken.
- "I'll remember why." — You won't, and the next person never knew.
- "Docs always go stale." — Decision records are dated history that stays valid; living docs get updated.
- "It's obvious." — Obvious to you today, with all the context you're about to forget.

## Red Flags

- A major architectural choice with no record of why
- Recurring debates that rehash a question already decided
- Docs that describe a version of the system that no longer exists
- Editing past decisions instead of superseding them
- Comments/docs that restate the code instead of explaining intent

## Verification

- [ ] Significant, hard-to-reverse decisions are recorded as ADRs
- [ ] Each captures context, options considered, decision, and consequences
- [ ] Trade-offs and rejected alternatives are explicit
- [ ] Records live with the code and are dated; superseded, not edited
- [ ] Docs explain the non-obvious why, and stale docs were fixed
