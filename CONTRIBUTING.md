# Contributing

Thanks for improving engineering-skills. The bar here is specific: a skill is a **process an agent
executes**, not general advice. Contributions that don't meet that bar will be sent back.

## Adding or changing a skill

1. **Read [docs/skill-anatomy.md](docs/skill-anatomy.md).** It defines the required format.
2. **Create `skills/<name>/SKILL.md`** where `<name>` is short, kebab-case, and action-oriented
   (`data-modeling`, not `database-stuff`). The directory name must equal the frontmatter `name`.
3. **Include the frontmatter** (`name`, `description`) and all required sections: overview,
   `## When to Use`, `## Process`, `## Common Rationalizations`, `## Red Flags`, `## Verification`.
4. **Write a strong `description`.** It starts with what the skill does, then concrete triggers
   ("Use when…"). This is what makes an agent load the skill at the right moment — vague descriptions
   never fire.
5. **Make the Process executable** — numbered steps with a decision at each. If it can't be followed
   step-by-step, it's an article, not a skill.
6. **Keep `Common Rationalizations` and `Red Flags`.** These are what make a skill resist being
   shortcut under pressure; they're the point.
7. **Link, don't duplicate.** Reference related skills with `[[name]]` instead of repeating content.
8. **Regenerate the catalog and validate** (below) before opening a PR.

## What gets rejected

- Vague advice ("write clean code") instead of a process.
- Content that duplicates an existing skill — extend or link it instead.
- Skills tied to one specific codebase. Keep them general and portable.
- Missing sections, or a `name` that doesn't match the directory.

## Before you open a PR

```bash
bash scripts/validate.sh          # structure, frontmatter, manifests
bash scripts/generate-catalog.sh  # refresh SKILLS.md
```

CI runs the same checks. A PR that fails validation or has a stale `SKILLS.md` won't pass.

## Commands, agents, and references

- **Commands** (`commands/`) are thin wrappers that load a skill — keep them minimal.
- **Agents** (`agents/`) are reviewer personas; same frontmatter rules (`name`, `description`).
- **References** (`references/`) are supplementary checklists used *alongside* a skill, not standalone
  processes.
