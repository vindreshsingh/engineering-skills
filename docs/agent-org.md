# Agent Org — the SDLC team

A library of role-based agent personas covering the full software delivery lifecycle, organized into 8
layers. Each persona has clear responsibilities and outputs and **drives the repo's skills** rather
than redefining them — load a persona when you want that role's perspective, and it will reach for the
relevant `SKILL.md`.

Personas live in [`agents/sdlc/`](../agents/sdlc) (engineering) and [`agents/marketing/`](../agents/marketing) (growth). Shared skill-loading instructions live in
[`prompts/agent-base.md`](../prompts/agent-base.md). The three general reviewer personas
(`code-reviewer`, `security-auditor`, `test-engineer`) complement the org roles below.

## Layers

### 1 — Product & Business
| # | Agent | Key outputs |
|---|-------|-------------|
| 1 | `product-manager` | Epic, user stories, acceptance criteria, PRD |
| 2 | `product-analyst` | Product insights, KPIs, A/B test reports |
| 3 | `business-analyst` | BRD, requirement docs, gap analysis |
| 4 | `ux-designer` | User flows, IA, interaction specs, wireframe handoff |
| 5 | `technical-writer` | README, API docs, runbooks, changelogs |

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
| 10 | `product-grooming` | Groomed backlog, Definition of Ready, session notes |

### 4 — Development
| # | Agent | Key outputs |
|---|-------|-------------|
| 11 | `senior-developer` | Production-grade code (complex parts) |
| 12 | `frontend-developer` | Components, pages, state |
| 13 | `backend-developer` | Services, controllers, repositories |
| 14 | `database-engineer` | ERD, SQL scripts, migrations |

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

## Marketing team (separate group)

Marketing is a **separate team** from the SDLC layers — grouped for clarity:

| Location | Contents |
|----------|----------|
| [`marketing/`](../marketing/) | Team guide, router ([SKILL.md](../marketing/SKILL.md)), references |
| [`skills/marketing/`](../skills/marketing/) | 5 marketing skills |
| [`agents/marketing/`](../agents/marketing/) | 5 marketing agents |
| [`prompts/agents/marketing/`](../prompts/agents/marketing/) | Copy-paste prompts |

See [marketing/README.md](../marketing/README.md) for roster and typical flow.

### Marketing agents

| Agent | Key outputs |
|-------|-------------|
| `growth-lead` | GTM plan, positioning, campaign calendar, channel briefs |
| `content-marketer` | Blog posts, tutorials, newsletters, landing copy |
| `social-media-manager` | Social post packs, launch threads, UTM links |
| `seo-strategist` | Keyword map, on-page SEO, content clusters |
| `community-manager` | Welcome flows, engagement calendar, seed content |

## Layer 9 — Growth & Marketing

Same agents as the marketing team above (also listed here for lifecycle numbering):

| # | Agent | Key outputs |
|---|-------|-------------|
| 26 | `growth-lead` | GTM plan, positioning, campaign calendar, channel briefs |
| 27 | `content-marketer` | Blog posts, tutorials, newsletters, landing copy |
| 28 | `social-media-manager` | Social post packs, launch threads, UTM links |
| 29 | `seo-strategist` | Keyword map, on-page SEO, content clusters |
| 30 | `community-manager` | Welcome flows, engagement calendar, seed content |

## How work flows

A feature moves down the layers, with each layer's output feeding the next:

```
Business/Product (1–3)  →  PRD + requirements
        ↓
Architecture (4–6)      →  HLD/LLD + security design
        ↓
Eng Management (7–10)    →  grooming + task breakdown + sprint plan
        ↓
Development (11–14)     →  implemented code
        ↓
Quality (14–17)         →  tested + reviewed + audited
        ↓
DevOps & Platform (18–20) → deployed + observable
        ↓
Release (24–25)         →  shipped, with rollback + incident cover
   (Governance 21–23 runs across all layers)
        ↓
Growth (26–30)          →  traffic, engagement, sign-ups, retention
   (runs after launch or in parallel with Ship for GTM prep)
```

## Example — "Add Product Reviews"

1. **product-manager** writes the epic + stories (review form, list, rating) with acceptance criteria.
2. **solution-architect / technical-architect** define the review service boundary, API, and schema
   approach; **security-architect** adds authz + abuse checks.
3. **product-grooming** refines the epic into sprint-ready stories with AC, estimates, and Definition
   of Ready; **team-lead** breaks Ready items into tasks:
   - Frontend: review form, review list, rating widget
   - Backend: review API, database schema
   - QA: test cases
   - DevOps: deployment changes
4. **frontend-developer / backend-developer / database-engineer** implement their slices.
5. **qa-engineer / sdet / code-reviewer / technical-qc** test, automate, review, and audit.
6. **devops-engineer / sre** deploy with monitoring; **release-manager** ships with a rollback plan;
   **incident-commander** is on standby.
7. **growth-lead** plans GTM; **community-manager** seeds the community; **seo-strategist** optimizes
   landing pages; **content-marketer** publishes launch content; **social-media-manager** runs the
   launch sequence.

## Example — "Market a developer-connection product"

1. **growth-lead** defines ICP (e.g. bootcamp grads seeking mentors), positioning, channel mix, and
   30-day calendar with briefs for each channel agent.
2. **community-manager** sets up welcome flows, rules, and 10+ seed posts **before** traffic arrives.
3. **seo-strategist** audits the landing page, maps keywords ("developer networking", "find coding
   mentor"), and plans a content cluster.
4. **content-marketer** writes launch blog + "first connection in 5 minutes" tutorial.
5. **social-media-manager** runs 7-day post pack + launch thread on X/LinkedIn + Show HN post.
6. **growth-lead** runs weekly review — cut failing channels, double down on what converts.

## Using a persona

In Claude Code, ask for the role and point at the agent definition — e.g. *"Act as the
`solution-architect` agent (`agents/sdlc/solution-architect.md`) and produce an HLD for this feature."*

Each persona:

1. Loads [prompts/agent-base.md](../prompts/agent-base.md) for how to use skills.
2. Reads its **primary skill** (`skills/<name>/SKILL.md` or `skills/marketing/<name>/SKILL.md`) and follows that Process.
3. Loads secondary skills only when the work requires them.
4. Delivers the persona's **Outputs** after the skill's Verification checklist passes.

**End users:** copy-paste prompts for every agent live in
[`prompts/agents/`](../prompts/agents/) — see [how-to-use-prompts.md](../prompts/how-to-use-prompts.md).
