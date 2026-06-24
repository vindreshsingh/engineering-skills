# Profiles

64 skills is the full toolbox. A **profile** scopes the emphasis to the skills a given kind of work
actually uses — so a new user isn't routed through marketing skills on a backend service, or ops
skills on a static site. Profiles change *what's emphasized*, never *what's allowed*: every skill is
still reachable via [`skill-router`](../skills/skill-router/SKILL.md), and `agent-guardrails` is always
on regardless of profile.

## Activate a profile

Pick one of `frontend`, `backend`, `full-stack`, `solo-founder` and either:

- add a one-word file `.engineering-skills-profile` to your project root:
  ```bash
  echo full-stack > .engineering-skills-profile
  ```
- **or** set an environment variable: `export ENGINEERING_SKILLS_PROFILE=full-stack`

On the next session the start-up hook reads it and tells the agent which skills to prioritize for this
repo. No profile set = the full library (current behavior). Run `/start` to have the agent detect your
stack and recommend a profile.

## Available profiles

| Profile | For | Emphasizes |
|---------|-----|-----------|
| [`frontend`](frontend.md) | UI / web app work | Build-UI, Verify, Review, design + a11y |
| [`backend`](backend.md) | services / APIs / data | Interfaces, data, resilience, security, ops |
| [`full-stack`](full-stack.md) | end-to-end product work | The core lifecycle across both |
| [`solo-founder`](solo-founder.md) | one person, idea → launch | Discovery, lean build, ship, and growth |
