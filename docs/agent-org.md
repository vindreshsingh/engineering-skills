# Agent Org — the SDLC team

A library of role-based agent personas covering the full software delivery lifecycle, organized into 8
layers. Each persona has clear responsibilities and outputs and **drives the repo's skills** rather
than redefining them — load a persona when you want that role's perspective, and it will reach for the
relevant `SKILL.md`.

Personas live in [`agents/`](../agents). The three general reviewer personas (`code-reviewer`,
`security-auditor`, `test-engineer`) complement the org roles below.

## Layers

### 1 — Product & Business
| # | Agent | Key outputs |
|---|-------|-------------|
| 1 | `product-manager` | Epic, user stories, acceptance criteria, PRD |
| 2 | `product-analyst` | Product insights, KPIs, A/B test reports |
| 3 | `business-analyst` | BRD, requirement docs, gap analysis |

### 2 — Architecture
| # | Agent | Key outputs |
|---|-------|-------------|
| 4 | `solution-architect` | Architecture diagrams, HLD |
| 5 | `technical-architect` | Technical design doc, LLD |
| 6 | `security-architect` | Security checklist, threat model |

### 3 — Engineering Management
| # | Agent | Key outputs |
|---|-------|-------------|
| 7 | `engineering-manager` | Sprint capacity, resource allocation |
| 8 | `team-lead` | Task breakdown, dependency mapping |
| 9 | `scrum-master` | Sprint board, burndown reports |

### 4 — Development
| # | Agent | Key outputs |
|---|-------|-------------|
| 10 | `senior-developer` | Production-grade code (complex parts) |
| 11 | `frontend-developer` | Components, pages, state |
| 12 | `backend-developer` | Services, controllers, repositories |
| 13 | `database-engineer` | ERD, SQL scripts, migrations |

### 5 — Quality
| # | Agent | Key outputs |
|---|-------|-------------|
| 14 | `qa-engineer` | Test plans, test cases |
| 15 | `sdet` | Automated test suites |
| 16 | `code-reviewer` | Review comments, approval/rejection |
| 17 | `technical-qc` | Technical audit report |

### 6 — DevOps & Platform
| # | Agent | Key outputs |
|---|-------|-------------|
| 18 | `devops-engineer` | Deployment pipelines |
| 19 | `platform-engineer` | Shared platform services, DX tooling |
| 20 | `site-reliability-engineer` | Alerts, dashboards, runbooks |

### 7 — Governance
| # | Agent | Key outputs |
|---|-------|-------------|
| 21 | `dependency-analyzer` | Dependency graph, impact analysis |
| 22 | `risk-assessment` | Risk register |
| 23 | `compliance` | Compliance report |

### 8 — Release
| # | Agent | Key outputs |
|---|-------|-------------|
| 24 | `release-manager` | Release notes, rollback plan |
| 25 | `incident-commander` | RCA reports |

## How work flows

A feature moves down the layers, with each layer's output feeding the next:

```
Business/Product (1–3)  →  PRD + requirements
        ↓
Architecture (4–6)      →  HLD/LLD + security design
        ↓
Eng Management (7–9)    →  task breakdown + sprint plan
        ↓
Development (10–13)     →  implemented code
        ↓
Quality (14–17)         →  tested + reviewed + audited
        ↓
DevOps & Platform (18–20) → deployed + observable
        ↓
Release (24–25)         →  shipped, with rollback + incident cover
   (Governance 21–23 runs across all layers)
```

## Example — "Add Product Reviews"

1. **product-manager** writes the epic + stories (review form, list, rating) with acceptance criteria.
2. **solution-architect / technical-architect** define the review service boundary, API, and schema
   approach; **security-architect** adds authz + abuse checks.
3. **team-lead** breaks it into tasks:
   - Frontend: review form, review list, rating widget
   - Backend: review API, database schema
   - QA: test cases
   - DevOps: deployment changes
4. **frontend-developer / backend-developer / database-engineer** implement their slices.
5. **qa-engineer / sdet / code-reviewer / technical-qc** test, automate, review, and audit.
6. **devops-engineer / sre** deploy with monitoring; **release-manager** ships with a rollback plan;
   **incident-commander** is on standby.

## Using a persona

In Claude Code, ask for the role and point at the agent definition — e.g. *"Act as the
`solution-architect` agent and produce an HLD for this feature."* Each persona will pull in the skills
listed in its file as it works.
