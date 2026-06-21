---
name: paid-ads
description: Plans and runs paid acquisition campaigns for developer products — Google, LinkedIn, Meta, and dev-focused ad platforms. Use when organic growth needs a paid boost, launching to a cold audience, or scaling sign-ups with measurable CAC.
---

# Paid Ads

Organic takes months; paid buys **targeted reach now** — if you measure it. Developer products fail at
paid when they run generic B2C ads instead of intent-driven campaigns with landing pages that match
the ad promise.

Chains from [[growth-strategy]] (ICP, budget, CAC targets) and feeds [[seo-growth]] (landing page
quality). Coordinate with [[social-distribution]] for creative reuse.

Use [paid-ads checklist](../../../marketing/references/paid-ads-checklist.md) alongside this process.

## When to Use

- Launching to cold audience with budget allocated
- Organic channels plateaued — need scalable sign-ups
- Retargeting site visitors who didn't convert
- Testing messaging before heavy content investment

Skip when: no landing page, no conversion tracking, or budget < minimum viable test ($500–1000/mo).

## Process

### 1. Define campaign economics

| Field | Example |
|-------|---------|
| **Goal** | Sign-up, demo request, waitlist |
| **Monthly budget** | $1,000 test / $5,000 scale |
| **Target CAC** | $15 sign-up |
| **Landing page** | UTM-tagged, matches ad copy |
| **Tracking** | Pixel + conversion event verified |

No tracking = no campaign.

### 2. Pick platforms by ICP

| Platform | Best for dev products |
|----------|----------------------|
| **Google Search** | High intent ("developer networking app") |
| **LinkedIn** | B2B, career-stage targeting, mentors |
| **Meta/Instagram** | Broad, cheaper tests — lower intent |
| **Reddit Ads** | Subreddit targeting (r/programming, r/cscareerquestions) |
| **Dev newsletters** | Sponsorships — treat as paid, measure clicks |

Start **one platform** for 2 weeks before splitting budget.

### 3. Campaign structure

```text
Campaign: [Product] — Sign-ups — [Month]
  Ad set: ICP segment (e.g. bootcamp grads, 0–3 YOE)
    Ad A: Pain hook + screenshot
    Ad B: Social proof + CTA
    Ad C: Feature demo video
```

- 3–5 ad variants per ad set — kill losers after 1,000 impressions or 50 clicks
- One message pillar per ad set ([[growth-strategy]])
- Landing page headline **matches** ad hook exactly

### 4. Creative rules for developers

- Show the product — screenshot or 15-sec demo
- No stock photos of handshakes
- Specific benefit: "Find a mentor in your stack" not "Grow your network"
- Lead with problem, not logo
- Testimonial or user count if available

### 5. Launch and optimize (weekly)

| Metric | Action |
|--------|--------|
| CTR < 1% | New hooks/creative |
| CPC high | Narrow audience or better landing page |
| Clicks but no sign-ups | Landing page / offer mismatch |
| CAC > target | Pause ad set; fix funnel |
| CAC < target | Increase budget 20% |

Report to [[growth-strategy]] weekly review.

### 6. Compliance

- No false claims or fake urgency
- Privacy policy linked on landing page
- Ad platform policies (especially LinkedIn professional targeting)

## Common Rationalizations

- **"We'll optimize later"** — Without week-1 kill rules, budget burns on losers.
- **"Send traffic to homepage"** — Generic pages kill conversion; dedicated landing page per campaign.
- **"More platforms = more reach"** — One platform mastered beats five at 10% budget each.

## Red Flags

- No conversion pixel firing
- Ad promise ≠ landing page headline
- CAC unknown after 2 weeks
- All budget on one ad with no variants
- Retargeting everyone including converters

## Verification

- [ ] Budget, goal, target CAC, landing page defined
- [ ] Tracking verified (test conversion fires)
- [ ] One platform chosen with 3+ ad variants
- [ ] Landing page matches ad hooks
- [ ] Weekly kill/scale rules documented
- [ ] First week metrics reported to growth-lead
