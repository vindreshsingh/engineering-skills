# Skill Tests

Behavioral tests for the skills in this repo. Each `tests/<skill-name>.test.md` is a **pressure
scenario** that proves the skill changes what an agent does — not just that the file is well-formed.

See [docs/testing-skills.md](../docs/testing-skills.md) for the method (RED → GREEN → REFACTOR) and the
required file structure. Run them with:

```bash
bash scripts/skill-test.sh
```

A skill without a passing test is a draft. The goal is one test per skill.
