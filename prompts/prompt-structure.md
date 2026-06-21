# Prompt Structure — Anatomy of an agent prompt

Every agent prompt in `prompts/agents/` follows the same structure so end users get predictable,
high-quality results.

## Sections in every agent prompt file

| Section | Purpose |
|---------|---------|
| **When to use** | Decides if this is the right agent for the task |
| **What to provide** | Checklist of inputs to gather before copying the prompt |
| **Copy-paste prompt** | Ready-to-use block — fill placeholders, paste into your AI agent |
| **Expected outputs** | What "done" looks like for this role |
| **Hand off to** | Which agent or skill to run next in the SDLC chain |
| **Tips** | Common mistakes and how to get better results |

## Placeholders in the copy-paste block

Replace every `[BRACKET]` value before pasting. Do not leave placeholders empty.

| Placeholder | What to put |
|-------------|-------------|
| `[TASK]` | One sentence — what you want this agent to do right now |
| `[FEATURE]` | Feature, epic, or system name |
| `[GOAL]` | The outcome you need (not the implementation) |
| `[CONSTRAINTS]` | Deadlines, tech stack, compliance, out-of-scope |
| `[INPUTS]` | Paste PRD, diff, schema, logs, designs, tickets — whatever this agent needs |
| `[OUTPUT_FORMAT]` | Optional — how you want results formatted (table, markdown doc, checklist) |

## The 4 files every agent loads

Every copy-paste prompt tells the AI to load:

0. `skills/agent-guardrails/SKILL.md` — always-on safety (data deletion, secrets, security)
1. `agents/<name>.md` — role, responsibilities, outputs, primary/secondary skills
2. `prompts/agent-base.md` — how to load skills and verify before done
3. `skills/<primary-skill>/SKILL.md` — the step-by-step process for this task

## Rules block (always included)

- Follow **agent-guardrails** before destructive ops, secret access, or security bypasses
- Follow the primary skill **Process** step by step
- Complete the skill **Verification** checklist before declaring done
- Load secondary skills only when the task requires them
- Ask clarifying questions if inputs are missing — do not guess

## One feature, many agents

Run agents in SDLC order. Each agent's output becomes the next agent's `[INPUTS]`:

```
business-analyst → product-manager → solution-architect → team-lead
→ developers → qa-engineer / sdet → code-reviewer → release-manager
```

See [agents/README.md](agents/README.md) for the full index by layer.
