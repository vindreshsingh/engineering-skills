---
name: skill-creator
description: Authors a new engineering skill (or fixes an existing one) so it fires at the right time and gets followed. Use when adding a skill to this repo, splitting an overloaded one, or improving a skill that isn't being triggered.
---

# Skill Creator

A skill is only valuable if an agent loads it at the right moment and then actually follows it. Most
weak skills fail on one of those two: a vague `description` that never triggers, or "advice" with no
executable process. This skill is the process for writing skills that don't fail that way — it
dogfoods this repo's own anatomy.

## When to Use

- Adding a new skill to this repository
- A skill exists but rarely fires, or the agent ignores its steps
- One skill is trying to cover several jobs and should be split
- Reviewing a contributed skill before merge

## Process

1. **Confirm it's process-worthy.** A skill encodes a repeatable workflow where people predictably cut
   corners. If it's a one-off fact or generic advice, it's a doc or a reference — not a skill.
2. **Check it doesn't already exist.** Search existing skills; extend or link rather than duplicate.
   Overlap dilutes routing.
3. **Name it** short, kebab-case, action-oriented; the directory name must equal the frontmatter `name`.
4. **Write the `description` last and carefully — it's the trigger.** Start with what the skill does
   (third person), then concrete conditions ("Use when…"). Name the situations and keywords an agent
   would see. This single line decides whether the skill ever loads.
5. **Write an executable Process.** Numbered steps, a decision or action in each, ordered by what
   matters most. If it can't be followed step-by-step, rewrite it until it can. Add short illustrative
   examples only where they clarify.
6. **Write the anti-shortcut sections.** `Common Rationalizations` (the excuse → the rebuttal) and
   `Red Flags` (observable signs it's being violated). These are what make the skill stick under
   pressure — don't skip them.
7. **Make `Verification` a checkbox list** of observable, testable exit conditions.
8. **Link, don't duplicate** related skills with `[[name]]`. Keep it tight — one screen of signal.
9. **Validate and catalog.** Run `scripts/validate.sh` and `scripts/generate-catalog.sh`; fix anything
   that fails ([[pipeline-ops]] enforces this in CI).
10. **Test the trigger and the value.** Does an agent load it for the intended task? Does following it
    produce a better result than not? Iterate the description and steps from real runs.

## Common Rationalizations

- "The description is fine, the content is what matters." — A skill that never triggers is never read; the description is the product.
- "It's mostly advice but useful." — Advice doesn't change behavior under pressure; give a process or don't ship it.
- "Rationalizations and red flags are filler." — They're exactly what stops the steps from being skipped.
- "I'll test it later." — An untriggered or unfollowed skill is dead weight; verify it works.

## Red Flags

- A `description` with no concrete trigger conditions
- A "Process" that's a list of principles, not actions
- Missing `Common Rationalizations`, `Red Flags`, or a testable `Verification`
- A skill overlapping an existing one instead of linking it
- `name` not matching the directory; validation not run
- Never tested against a real task

## Verification

- [ ] The topic is a repeatable process people cut corners on (not advice/one-off fact)
- [ ] No existing skill already covers it; related skills are linked
- [ ] `description` leads with what it does, then specific triggers
- [ ] Process is numbered, executable, and prioritized
- [ ] Common Rationalizations, Red Flags, and a checkbox Verification are present
- [ ] `scripts/validate.sh` passes and the catalog is regenerated
- [ ] Triggering and usefulness checked on a real task
