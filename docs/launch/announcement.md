# Announcement post

_Drafted as the `content-marketer` persona using the `content-marketing` skill. Publish on dev.to, a
personal blog, or Medium. Adjust the voice to yours before posting._

---

## Title options

- **"I gave my coding agent a whole engineering org"**
- "engineering-skills: 64 tested skills + a 38-role team for your AI coding agent"
- "Your coding agent can write code. Can it ship like a team?"

## Post

Coding agents are great at writing code and bad at *engineering*. They skip the spec, don't test the
edge cases, forget the rollout plan, and have no concept of the work that surrounds the code — product,
review, release, even growth.

I built **engineering-skills** to fix that: a library of **64 step-by-step skills** that turn a coding
agent into something closer to a disciplined engineering team.

**What makes it different from other skill libraries:**

- **It covers the whole lifecycle, not just the dev loop.** Define → plan → build → verify → review →
  ship → operate — plus a **38-role org** of personas (product manager, architect, DBA, QA, SRE,
  release manager… and a marketing team).
- **The skills are behaviorally tested.** Most skill files are just good advice. Here, over half the
  skills have a *pressure-scenario test* that proves the skill changes what the agent does — watch it
  cut the corner without the skill, then hold the line with it. CI enforces it.
- **There's an orchestrated build loop.** `orchestrated-delivery` conducts a feature through every
  phase, loading the right skill and persona at each step, gating on sign-off, and dispatching
  independent work to parallel subagents.
- **It runs anywhere.** Claude Code, Cursor, Gemini CLI, GitHub Copilot, Codex/OpenCode — each gets the
  entry file it reads.

**It's new.** I'm not going to pretend it has a huge community yet. What it has is *scope* and *rigor*:
every skill is a real process with verification, and the whole thing is CI-validated.

If you want your agent to behave less like an eager intern and more like a senior team:

```text
/plugin marketplace add vindreshsingh/engineering-skills
/plugin install engineering-skills@engineering-skills
```

(Other tools: see the platforms guide in the repo.)

Repo: https://github.com/vindreshsingh/engineering-skills — feedback and PRs very welcome.

---

### CTA variations
- "What's the one skill your agent always skips? I'll add a tested skill for it."
- "Star it if useful; open an issue if it's missing your stack."
