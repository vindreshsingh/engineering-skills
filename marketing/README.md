# Marketing Team

A separate **Growth & Marketing** team — agents, skills, and references grouped under `marketing/`
for clarity. Use this team after a product ships (or in parallel with Ship) to drive traffic,
engagement, sign-ups, and retention.

## Structure

```
marketing/
  README.md           → This guide
  SKILL.md            → Team router — maps marketing tasks to the right skill/agent
  references/         → Checklists (SEO, content, channels, community, paid, email, referral)

skills/marketing/     → Step-by-step marketing processes (8 skills)
agents/marketing/     → Role personas (8 agents)
prompts/agents/marketing/ → Copy-paste prompts for each agent
```

## Team roster

| Agent | Skill | Delivers |
|-------|-------|----------|
| `growth-lead` | `growth-strategy` | GTM plan, positioning, campaign calendar |
| `content-marketer` | `content-marketing` | Blogs, tutorials, newsletters, landing copy |
| `social-media-manager` | `social-distribution` | Social posts, threads, launch sequences |
| `seo-strategist` | `seo-growth` | Keywords, on-page SEO, content clusters |
| `community-manager` | `community-engagement` | Welcome flows, engagement, seed content |
| `paid-media-manager` | `paid-ads` | Paid campaigns, CAC optimization |
| `email-marketer` | `email-nurture` | Welcome + activation email sequences |
| `referral-manager` | `referral-loop` | Invite flows, viral loops |

## Typical flow

```
growth-lead → community-manager (seed first) + seo-strategist
→ content-marketer → social-media-manager
→ email-marketer + referral-manager (post-activation)
→ paid-media-manager (when organic converts)
→ growth-lead (weekly review)
```

## Quick start

1. Load [SKILL.md](SKILL.md) to route your task to the right skill.
2. Open [prompts/agents/marketing/](../prompts/agents/marketing/) and pick an agent.
3. Fill `[BRACKETS]` in the copy-paste block and run in your AI agent.

**Start here for a new product:** [growth-lead prompt](../prompts/agents/marketing/growth-lead.md)

## References

| Checklist | Use with |
|-----------|----------|
| [channel-checklist.md](references/channel-checklist.md) | `social-distribution` |
| [content-checklist.md](references/content-checklist.md) | `content-marketing` |
| [seo-checklist.md](references/seo-checklist.md) | `seo-growth` |
| [community-checklist.md](references/community-checklist.md) | `community-engagement` |
| [paid-ads-checklist.md](references/paid-ads-checklist.md) | `paid-ads` |
| [email-nurture-checklist.md](references/email-nurture-checklist.md) | `email-nurture` |
| [referral-loop-checklist.md](references/referral-loop-checklist.md) | `referral-loop` |

## Relationship to SDLC

Marketing runs **after Ship** (or overlaps for launch prep). See [docs/agent-org.md](../docs/agent-org.md)
and [docs/sdlc-walkthrough.md](../docs/sdlc-walkthrough.md) for the full lifecycle example.
