# SDLC Agents

Engineering delivery personas — all roles in `agents/sdlc/`.

**Guardrails:** every agent loads `skills/agent-guardrails/SKILL.md` first (via `prompts/agent-base.md` and session hook).

**Prompts:** [prompts/agents/sdlc/](../../prompts/agents/sdlc/) · **Org chart:** [docs/agent-org.md](../../docs/agent-org.md)

| Layer | Agents |
|-------|--------|
| Product & Business | product-manager, product-analyst, business-analyst, ux-designer, technical-writer |
| Architecture | solution-architect, technical-architect, security-architect |
| Eng Management | engineering-manager, team-lead, scrum-master, product-grooming |
| Development | senior-developer, frontend-developer, backend-developer, database-engineer |
| Quality | qa-engineer, sdet, code-reviewer, technical-qc, test-engineer |
| DevOps & Platform | devops-engineer, platform-engineer, site-reliability-engineer |
| Governance | dependency-analyzer, risk-assessment, compliance |
| Release | release-manager, incident-commander |

Reviewers: `code-reviewer`, `security-auditor`, `test-engineer` (also listed above).
