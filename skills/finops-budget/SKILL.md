---
name: finops-budget
description: Controls cloud and SaaS spend — cost visibility, budgets, alerts, and right-sizing. Use when bills spike, planning infra for a feature, or setting cost guardrails before scale.
---

# FinOps Budget

Performance without cost awareness burns runway. This skill makes spend **visible**, **budgeted**, and
**actionable** before a surprise invoice — not after.

Pairs with [[observability]] for metrics, [[perf-budget]] for efficiency, [[launch-readiness]] before
scale events, and [[data-modeling]] when storage drives cost.

## When to Use

- Monthly cloud bill review or spike investigation
- New feature with infra impact (compute, storage, egress, LLM tokens)
- Setting budgets/alerts for prod
- Right-sizing over-provisioned resources
- Choosing between managed services by cost

Skip for local-only development with no cloud spend.

## Process

### 1. Baseline — know current spend

- Top 5 cost drivers (service/SKU)
- Cost per environment (prod vs staging)
- Trend: last 3 months MoM
- Untagged or "unknown" spend percentage

No baseline = no improvement.

### 2. Attribute cost to product

| Tag / dimension | Use |
|-----------------|-----|
| `service` / `team` | Ownership |
| `environment` | prod vs non-prod |
| `feature` | New launch tracking |

Target: >90% tagged spend.

### 3. Set budgets and alerts

- Monthly budget per env with 50/80/100% alert thresholds
- Anomaly detection on daily spend
- LLM/API: cost per 1k requests if applicable

Document who gets paged at 100%.

### 4. Optimize — measure before cutting

Priority order:

1. **Waste** — idle resources, orphaned disks, oversized dev clusters
2. **Right-size** — CPU/memory after 2 weeks of metrics
3. **Storage** — lifecycle policies, compression, archive cold data
4. **Egress** — CDN, regional placement, cache ([[caching-strategy]])
5. **Commitments** — reserved/savings plans only after stable baseline

### 5. Feature cost estimate (before build)

For new features document:

- Compute delta (requests × duration × price)
- Storage delta (GB × retention)
- Egress delta
- Third-party API (LLM tokens, maps, etc.)
- **Monthly estimate** at 1x, 10x, 100x users

Hand to product-manager if estimate breaks business model.

### 6. Review cadence

- Weekly: anomaly check
- Monthly: budget vs actual, top deltas
- Quarterly: architecture cost review

## Common Rationalizations

- **"We're too small for FinOps"** — Small teams feel bill spikes hardest.
- **"Staging can mirror prod size"** — Staging at 25% spec saves 75% there.
- **"Reserved instances now"** — Wait for 30-day stable usage pattern.

## Red Flags

- No billing alerts configured
- Prod and staging indistinguishable in cost reports
- LLM features without token/cost logging
- >20% untagged spend
- Cost discussed only at fundraise time

## Verification

- [ ] Top cost drivers documented
- [ ] Budgets and alerts configured
- [ ] Tagging coverage >90% or gap plan owned
- [ ] Feature cost template used for significant infra changes
- [ ] Monthly review cadence scheduled
