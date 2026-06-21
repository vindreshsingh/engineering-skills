# SDLC Walkthrough — End-to-End Example

One feature traced through **every phase** — agents, skills, and handoffs. Use this as a template
for real work in any repo that loads engineering-skills.

**Example feature:** *Developer Connection — "Send connection request with optional message"*  
**Goal:** User can request to connect with another developer; recipient can accept or decline.

---

## Phase map

```text
Define → Plan → Build → Verify → Review → Ship → Grow
```

| Phase | Agent(s) | Skill(s) | Output |
|-------|----------|----------|--------|
| Define | product-manager | product-brief, spec-first | PRD + spec |
| Plan | product-grooming, team-lead | product-grooming, work-planning | Groomed backlog + tasks |
| Build | backend, frontend, database | incremental-delivery, test-first, interface-design | Code + unit tests |
| Verify | qa-engineer, sdet | e2e-testing, browser-checks | E2E + browser pass |
| Review | code-reviewer, security-auditor | review-gate, hardening | Approved PR |
| Ship | release-manager, devops, sre | launch-readiness, pipeline-ops, observability | Production deploy |
| Grow | growth-lead → marketing team | growth-strategy → channel skills | Traffic + sign-ups |

---

## 1 — Define

### product-manager

**Prompt:** [`prompts/agents/sdlc/product-manager.md`](../prompts/agents/sdlc/product-manager.md)  
**Skill:** `spec-first` → `product-brief`

**Deliver:**
- Epic: Connection requests with message
- Stories: send request, view pending, accept/decline, notification
- AC: Given logged-in user A, when A sends request to B with message, then B sees pending request with message

**Hand off →** solution-architect (HLD) if complex; else product-grooming

---

## 2 — Plan

### product-grooming

**Prompt:** [`prompts/agents/sdlc/product-grooming.md`](../prompts/agents/sdlc/product-grooming.md)  
**Skill:** `product-grooming`

**Ceremony:** Walk team voices; split "notifications" if too large; Ready/Not ready gate.

**Deliver:**
- Story 1: POST /connections (Ready, 3 days)
- Story 2: Pending list UI (Ready, 2 days)
- Story 3: Accept/decline API + UI (Ready, 3 days)
- Open question: email or in-app only? → Owner: PM, due before sprint

### team-lead

**Skill:** `work-planning`

**Deliver task breakdown:**
1. DB migration: connection_requests table
2. Backend: API endpoints + authz
3. Frontend: request modal, pending list
4. QA: test cases from AC

---

## 3 — Build

Run **incremental-delivery** + **test-first** per slice. Load **interface-design** before API work.

### database-engineer

**Skill:** `data-modeling`  
**Deliver:** ERD, migration for `connection_requests(status, message, from_user, to_user)`

### backend-developer

**Skills:** `incremental-delivery`, `test-first`, `interface-design`, `hardening`  
**Slice order:** migration → POST endpoint (test) → GET pending → PATCH accept/decline

### frontend-developer

**Skills:** `ui-craft`, `incremental-delivery`, `test-first`  
**Deliver:** Request modal, pending list, empty/error states

---

## 4 — Verify

### qa-engineer + sdet

**Skill:** `test-first` — test plan from AC

### sdet (E2E)

**Skill:** `e2e-testing`  
**P0 flow:** User A sends request → User B accepts → both see connection

```text
Playwright: login(A) → open profile(B) → send request → login(B) → accept → assert connected
```

### frontend-developer

**Skill:** `browser-checks` — console clean, network 2xx, mobile width

---

## 5 — Review

### code-reviewer

**Skill:** `review-gate` — correctness, architecture, security, perf

### security-auditor

**Skill:** `hardening` — authz: can A only send as self? rate limit? message XSS?

**Exit:** PR approved; CI green

---

## 6 — Ship

### devops-engineer

**Skill:** `pipeline-ops` — migration job before app deploy

### release-manager

**Skill:** `launch-readiness`  
**Checklist:** staging verified, rollback = revert migration + deploy, feature flag optional, release notes

### site-reliability-engineer

**Skill:** `observability` — metric `connection_request_sent`, alert on 5xx spike

### technical-writing (same PR or follow-up)

**Skill:** `technical-writing`  
**Deliver:** API doc for new endpoints; changelog entry

**Command:** `/ship` loads launch-readiness

---

## 7 — Grow (post-launch)

Product is live — marketing team drives adoption.

### growth-lead

**Skill:** `growth-strategy`  
**Deliver:** ICP = bootcamp grads seeking mentors; channels = SEO + LinkedIn + referral

### Parallel week 1

| Agent | Skill | Deliver |
|-------|-------|---------|
| community-manager | community-engagement | Seed #introductions; welcome flow |
| seo-strategist | seo-growth | Landing page for "developer networking" |
| content-marketer | content-marketing | "First connection in 5 minutes" tutorial |

### Week 2 launch

| Agent | Skill | Deliver |
|-------|-------|---------|
| social-media-manager | social-distribution | Launch thread + Reddit value post |
| email-marketer | email-nurture | Welcome Day 0–7 sequence |
| referral-manager | referral-loop | Invite after first connection accepted |

### Week 3+ scale

| Agent | Skill | Deliver |
|-------|-------|---------|
| paid-media-manager | paid-ads | LinkedIn test $500/mo, target CAC |
| growth-lead | growth-strategy | Weekly review — cut losers, double winners |

**Command:** `/grow` loads marketing router

---

## Commands used in this walkthrough

| Step | Command |
|------|---------|
| Spec | `/spec` |
| Groom backlog | `/groom` |
| Plan tasks | `/plan` |
| Implement | `/build` |
| Unit tests | `/test` |
| Debug failure | `/debug` |
| E2E | Load `e2e-testing` skill |
| Review PR | `/review` |
| Security | `/secure` |
| Ship | `/ship` |
| Market | `/grow` |
| Incident (if needed) | `/incident` |

---

## Minimal path (small team)

If you can't run every agent, minimum chain:

```text
spec-first → product-grooming → incremental-delivery + test-first
→ e2e-testing → review-gate → launch-readiness → growth-strategy
```

Three skills if nothing else: **spec-first**, **test-first**, **review-gate**.

---

## Related docs

- [agent-org.md](agent-org.md) — full org chart
- [getting-started.md](getting-started.md) — setup
- [marketing/README.md](../marketing/README.md) — growth team
- [plugin-discovery.md](plugin-discovery.md) — Claude Code nested paths
