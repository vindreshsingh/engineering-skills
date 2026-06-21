---
name: marketing-router
description: Routes marketing tasks to the right skill and agent in the marketing team. Load when you need to market a product, grow traffic, write content, post on social, improve SEO, or engage a community — and you're not sure which marketing skill or agent to use.
---

# Marketing Router

The marketing team has **eight skills** and **eight agents**, grouped under `skills/marketing/` and
`agents/marketing/`. This router maps your task to the right process — then load that skill's
`SKILL.md` and follow it fully ([[skill-router]] pattern for the Grow phase).

## When to Use

- Product is live and you need marketing but don't know where to start
- Unsure whether you need strategy, content, social, SEO, or community
- Onboarding the marketing team for a campaign
- Coordinating multiple marketing agents on one launch

Skip when you already know the agent — go directly to `prompts/agents/marketing/<agent>.md`.

## Process

### 1. Classify the marketing task

| You need to… | Load skill | Run agent |
|--------------|------------|-----------|
| Plan GTM, positioning, channels, campaign calendar | [[growth-strategy]] | `growth-lead` |
| Write blog, tutorial, newsletter, landing copy | [[content-marketing]] | `content-marketer` |
| Post on X/LinkedIn/Reddit, launch threads | [[social-distribution]] | `social-media-manager` |
| Improve rankings, keywords, landing page SEO | [[seo-growth]] | `seo-strategist` |
| Build community, welcome flows, engagement | [[community-engagement]] | `community-manager` |
| Plan and run paid ads (Google, LinkedIn, Reddit) | [[paid-ads]] | `paid-media-manager` |
| Design email welcome / nurture sequences | [[email-nurture]] | `email-marketer` |
| Build referral / invite loops | [[referral-loop]] | `referral-manager` |

Skill files live at `skills/marketing/<skill-name>/SKILL.md`.

### 2. Default sequence for a new product launch

Run in this order unless the campaign brief says otherwise:

```text
growth-lead (strategy + briefs)
  → community-manager (seed before traffic)
  → seo-strategist (landing page + keywords)
  → content-marketer (launch blog + tutorials)
  → social-media-manager (post pack + launch thread)
  → growth-lead (weekly review)
```

**Critical rule:** `community-manager` seeds content **before** `social-media-manager` drives traffic.

### 3. Load references when executing

| Skill | Reference checklist |
|-------|---------------------|
| `social-distribution` | [channel-checklist.md](references/channel-checklist.md) |
| `paid-ads` | [paid-ads-checklist.md](references/paid-ads-checklist.md) |
| `email-nurture` | [email-nurture-checklist.md](references/email-nurture-checklist.md) |
| `referral-loop` | [referral-loop-checklist.md](references/referral-loop-checklist.md) |
| `content-marketing` | [content-checklist.md](references/content-checklist.md) |
| `seo-growth` | [seo-checklist.md](references/seo-checklist.md) |
| `community-engagement` | [community-checklist.md](references/community-checklist.md) |
| `growth-strategy` | All of the above when reviewing channel feasibility |

### 4. Hand off rules

- **growth-lead** produces briefs — does not write posts or articles
- **content-marketer** hands social snippets to **social-media-manager**
- **seo-strategist** hands spoke topics to **content-marketer**
- **community-manager** coordinates launch timing with **social-media-manager**
- All agents report metrics to **growth-lead** for weekly review

## Common Rationalizations

- **"Let's just post on social first"** — Without positioning and seeded community, posts bounce.
- **"SEO can wait"** — Every month delayed is compounding traffic lost.
- **"One person does it all"** — Run agents sequentially; each has a focused process.
- **"Marketing is separate from product"** — Community feedback loops back to product-manager.

## Red Flags

- No ICP defined before content creation
- Social launch before community is seeded
- Same caption cross-posted to every platform
- SEO keywords assigned to multiple pages (cannibalization)
- No primary metric or weekly review

## Verification

- [ ] Task mapped to correct skill and agent
- [ ] Launch sequence respected (community before social traffic)
- [ ] Reference checklist identified for the skill
- [ ] Next agent in the chain noted
