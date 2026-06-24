# Before / After — what the skills actually change

These are concrete, code-level examples of the same task done **without** a skill and **with** it. The
point isn't that an agent *can't* write the "before" — it's that under time pressure it usually does,
and the skill is what reliably produces the "after."

| Example | Skill | The lift |
|---------|-------|----------|
| [Add a discount calculator](test-first.md) | [`test-first`](../../skills/test-first/SKILL.md) | Edge cases caught before shipping, not after |
| [Validate an upload endpoint](hardening.md) | [`hardening`](../../skills/hardening/SKILL.md) | An auth/injection hole closed before merge |
| [Tidy a settings loader](simplify.md) | [`simplify`](../../skills/simplify/SKILL.md) | Accidental complexity deleted, behavior unchanged |

Each shows the task, the rushed version and what's wrong with it, the skill-driven version, and why
it's better. See [docs/sdlc-walkthrough.md](../sdlc-walkthrough.md) for a full multi-phase run.
