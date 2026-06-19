---
name: idea-shaping
description: Turns a vague idea into a clear, evaluated problem statement before any spec or code. Use when a request is a one-liner, the problem is fuzzy, or you're not yet sure the idea is worth building.
---

# Idea Shaping

Before you specify *what* to build, make sure the idea is worth building and clearly understood. Most
weak features trace back to a fuzzy idea that nobody pressure-tested. Shape it first: sharpen the
problem, challenge the assumptions, and decide if it's worth a spec.

## When to Use

- The request is a single sentence or a hand-wave ("we should add gamification")
- The underlying problem is unclear or unstated
- You're choosing between several possible directions
- You suspect the idea may be solving the wrong problem

This precedes [[spec-first]]: shape the idea, then specify the chosen one.

## Process

1. **Find the real problem.** Ask what pain this addresses, for whom, and what they do today. Push past
   the proposed solution to the need underneath — people often hand you a solution and call it a problem.
2. **State it as one sharp problem statement:** *who* has *what* pain, *when*, and why current options
   fall short.
3. **Pressure-test the assumptions.** What has to be true for this to matter? Which of those are you
   guessing? Name the riskiest assumption and how you'd cheaply check it.
4. **Generate a couple of alternatives.** The first idea is rarely the best; sketch 2–3 ways to solve
   the problem, including the "do nothing / smallest thing" option.
5. **Evaluate against what matters** — user value, effort, risk, fit with the product. Be explicit
   about the trade-offs.
6. **Decide:** pursue, park, or drop — and write down why. A clear "not now, because…" is a real
   outcome.
7. **Hand the chosen idea to a spec** with the problem and constraints captured.

## Common Rationalizations

- "The idea is obviously good." — Obvious ideas still hide a wrong assumption or a better alternative.
- "Let's just build it and see." — Building is the most expensive way to test an idea; think first.
- "There's only one way to do it." — There's always more than one; you just haven't looked yet.
- "We can validate later." — The cheapest validation is a question now, not a shipped feature later.

## Red Flags

- Jumping straight from a one-line idea to implementation
- A "problem" that's actually a pre-chosen solution
- No one can say who has the pain or how big it is
- Only one option ever considered
- Unexamined assumptions the whole idea rests on

## Verification

- [ ] The real underlying problem is identified, not just the proposed solution
- [ ] A sharp problem statement exists (who/what/when/why)
- [ ] Key assumptions are named, with the riskiest flagged
- [ ] At least a couple of alternatives were weighed, including doing the minimum
- [ ] A pursue/park/drop decision is recorded with reasoning
- [ ] The chosen idea is ready to hand to spec-first
