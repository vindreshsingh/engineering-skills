# Skill Anatomy

This describes the format every skill in this repo follows. Use it when writing a new skill or
revising an existing one. A skill is a **process an agent executes**, not a reference article —
optimize for that.

## File layout

```
skills/<skill-name>/
  SKILL.md          # required — the skill itself
  <supporting>.md   # optional — only when content genuinely exceeds ~100 lines
```

- `<skill-name>` is short, kebab-case, and describes the action (e.g. `test-first`, `hardening`).
- Keep everything in `SKILL.md` unless a section is large enough to warrant its own file. Prefer
  folding content in over scattering it.

## Frontmatter

```yaml
---
name: <skill-name>          # must equal the directory name
description: <what it does, then when to use it>
---
```

- **`name`** matches the folder exactly.
- **`description`** starts with what the skill does, in the third person ("Drives changes with
  tests…"), then the trigger conditions ("Use when…"). This is what an agent reads to decide whether
  to load the skill, so make the triggers concrete.

## Required sections

In order:

1. **Title + one-paragraph overview** — what the skill is and the core idea behind it.
2. **When to Use** — the situations that should trigger it, and (optionally) when to skip it.
3. **Process** — the actual step-by-step workflow. This is the heart of the skill. Number the steps;
   make each one an action.
4. **Common Rationalizations** — the excuses people use to skip the process, each with a short rebuttal.
   This is what makes a skill stick under pressure.
5. **Red Flags** — observable signs the skill is being violated.
6. **Verification** — a checkbox list of exit criteria. "Done" means these are true.

## Style

- Write imperatively and concretely. "Validate input at the boundary" beats "input should be handled
  carefully."
- Show short, illustrative examples where they clarify — not full implementations.
- Link related skills with `[[skill-name]]` so processes chain naturally.
- Be opinionated. A skill that hedges everything guides no one.
- Keep it tight — a skill people won't read is wasted.

## What a skill is not

- Not vague advice ("write clean code") — give a process with steps and checks.
- Not a duplicate of another skill — reference it instead.
- Not documentation of a specific codebase — skills are general and portable.
