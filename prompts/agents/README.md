# Agent Prompts — Index

Copy-paste prompts for every SDLC agent. Open a file, fill `[BRACKETS]`, copy the block, paste into
your AI agent.

**How to use:** [how-to-use-prompts.md](../how-to-use-prompts.md) · **Structure:** [prompt-structure.md](../prompt-structure.md)

## Layer 1 — Product & Business

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Product Manager | [product-manager.md](sdlc/product-manager.md) | `product-brief` |
| Product Analyst | [product-analyst.md](sdlc/product-analyst.md) | `observability` |
| Business Analyst | [business-analyst.md](sdlc/business-analyst.md) | `idea-shaping` |
| UX Designer | [ux-designer.md](sdlc/ux-designer.md) | `ux-design` |
| Technical Writer | [technical-writer.md](sdlc/technical-writer.md) | `technical-writing` |

## Layer 2 — Architecture

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Solution Architect | [solution-architect.md](sdlc/solution-architect.md) | `interface-design` |
| Technical Architect | [technical-architect.md](sdlc/technical-architect.md) | `interface-design` |
| Security Architect | [security-architect.md](sdlc/security-architect.md) | `hardening` |

## Layer 3 — Engineering Management

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Engineering Manager | [engineering-manager.md](sdlc/engineering-manager.md) | `work-planning` |
| Team Lead | [team-lead.md](sdlc/team-lead.md) | `work-planning` |
| Scrum Master | [scrum-master.md](sdlc/scrum-master.md) | `work-planning` |
| Product Grooming | [product-grooming.md](sdlc/product-grooming.md) | `product-grooming` |

## Layer 4 — Development

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Senior Developer | [senior-developer.md](sdlc/senior-developer.md) | `incremental-delivery` |
| Frontend Developer | [frontend-developer.md](sdlc/frontend-developer.md) | `ui-craft` |
| Backend Developer | [backend-developer.md](sdlc/backend-developer.md) | `incremental-delivery` |
| Database Engineer | [database-engineer.md](sdlc/database-engineer.md) | `data-modeling` |

## Layer 5 — Quality

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| QA Engineer | [qa-engineer.md](sdlc/qa-engineer.md) | `test-first` |
| SDET | [sdet.md](sdlc/sdet.md) | `test-first` |
| Code Reviewer | [code-reviewer.md](sdlc/code-reviewer.md) | `review-gate` |
| Technical QC | [technical-qc.md](sdlc/technical-qc.md) | `review-gate` |

## Layer 6 — DevOps & Platform

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| DevOps Engineer | [devops-engineer.md](sdlc/devops-engineer.md) | `pipeline-ops` |
| Platform Engineer | [platform-engineer.md](sdlc/platform-engineer.md) | `pipeline-ops` |
| Site Reliability Engineer | [site-reliability-engineer.md](sdlc/site-reliability-engineer.md) | `observability` |

## Layer 7 — Governance

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Dependency Analyzer | [dependency-analyzer.md](sdlc/dependency-analyzer.md) | `migration-path` |
| Risk Assessment | [risk-assessment.md](sdlc/risk-assessment.md) | `work-planning` |
| Compliance | [compliance.md](sdlc/compliance.md) | `hardening` |

## Layer 8 — Release

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Release Manager | [release-manager.md](sdlc/release-manager.md) | `launch-readiness` |
| Incident Commander | [incident-commander.md](sdlc/incident-commander.md) | `incident-response` |

## Reviewers (cross-cutting)

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Security Auditor | [security-auditor.md](sdlc/security-auditor.md) | `hardening` |
| Test Engineer | [test-engineer.md](sdlc/test-engineer.md) | `test-first` |

## Marketing team — [`marketing/`](marketing/)

Separate from SDLC layers. Skills in `skills/marketing/`, agents in `agents/marketing/`.

| Agent | Prompt | Primary skill |
|-------|--------|---------------|
| Growth Lead | [growth-lead.md](marketing/growth-lead.md) | `growth-strategy` |
| Content Marketer | [content-marketer.md](marketing/content-marketer.md) | `content-marketing` |
| Social Media Manager | [social-media-manager.md](marketing/social-media-manager.md) | `social-distribution` |
| SEO Strategist | [seo-strategist.md](marketing/seo-strategist.md) | `seo-growth` |
| Community Manager | [community-manager.md](marketing/community-manager.md) | `community-engagement` |
| Paid Media Manager | [paid-media-manager.md](marketing/paid-media-manager.md) | `paid-ads` |
| Email Marketer | [email-marketer.md](marketing/email-marketer.md) | `email-nurture` |
| Referral Manager | [referral-manager.md](marketing/referral-manager.md) | `referral-loop` |

Team guide: [marketing/README.md](../../marketing/README.md)

## Typical flow for one feature

```
business-analyst → product-manager → solution-architect → security-architect
→ product-grooming → team-lead → [developers] → qa-engineer → sdet → code-reviewer
→ technical-qc → devops-engineer → site-reliability-engineer → release-manager
```

Governance agents (`dependency-analyzer`, `risk-assessment`, `compliance`) run across layers as needed.

## Typical flow for marketing a live product

```
growth-lead → community-manager (seed first) + seo-strategist (landing page)
→ content-marketer → social-media-manager (launch) → growth-lead (weekly review)
```
