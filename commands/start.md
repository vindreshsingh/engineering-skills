---
description: Onboard to engineering-skills on THIS project — detect the stack, pick a profile, and recommend the few skills and the workflow that fit right now.
---

You are onboarding the user to the `engineering-skills` library on their actual project. The goal is to
turn "64 skills, where do I begin?" into a short, concrete starting path — **do not dump the whole
catalog**. Be fast and specific.

## Do this

1. **Detect the project.** Look at the repo to infer the stack and shape — don't ask what you can read:
   - Manifests: `package.json`, `go.mod`, `requirements.txt`/`pyproject.toml`, `Cargo.toml`, `pom.xml`,
     `Gemfile`, `composer.json`.
   - Frontend vs backend vs full-stack vs mobile vs library; framework (React/Next, etc.); whether there
     are tests, CI, and whether it's greenfield or an existing codebase.
   - Note anything security-/data-/payment-sensitive.

2. **Suggest a profile** (see `profiles/`) that scopes which skills to emphasize:
   `frontend`, `backend`, `full-stack`, or `solo-founder`. Tell the user they can activate it by adding
   a `.engineering-skills-profile` file (one word) to the repo root, or setting
   `ENGINEERING_SKILLS_PROFILE`. Recommend the best fit and say why.

3. **Recommend the starting path**, not the catalog. Using `skills/skill-router/SKILL.md`, name:
   - The **always-on**: `agent-guardrails`.
   - The **3–5 skills** most relevant to what this project most needs next.
   - The **lifecycle chain** to follow for their likely first task (e.g.
     `spec-first → work-planning → incremental-delivery + test-first → review-gate`).
   Keep it to a short, ordered list with one line each on *why this one, here*.

4. **Offer the next concrete step.** Ask what they want to build or fix first, then route into the
   matching skill via `skill-router` and proceed. If they named a task in `$ARGUMENTS`, skip the
   question and route straight into it.

5. **Point to the explorer** for browsing everything later: run
   `python3 -m http.server 8000 --directory explorer` (or the hosted GitHub Pages link), without making
   it the starting point.

Keep the whole onboarding to a screen or less. Recommend; don't lecture.

$ARGUMENTS
