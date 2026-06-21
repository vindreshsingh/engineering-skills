---
name: referral-loop
description: Designs viral and referral mechanics that turn happy users into growth — invite flows, incentives, and share loops. Use for network products, community platforms, or when word-of-mouth should drive sign-ups.
---

# Referral Loop

The best channel is **users inviting users** — especially for connection products where value grows
with network size. Referral fails when the invite is spammy or the incentive feels like a pyramid scheme.

Chains from [[growth-strategy]] (ICP, north-star metric) and [[community-engagement]] (engaged users
refer more). Complements [[email-nurture]] (referral prompts in sequences) and [[social-distribution]]
(share assets).

Use [referral-loop checklist](../../../marketing/references/referral-loop-checklist.md) alongside this process.

## When to Use

- Network/product value increases with more users (developer-connection, communities)
- NPS or satisfaction high but organic invites low
- Launching invite-only or waitlist with referral priority
- Adding "invite a friend" to activation flow

Skip when: product isn't shareable, no clear invite moment, or core experience broken (fix product first).

## Process

### 1. Find the natural invite moment

Best triggers — user just got value:

| Moment | Example copy |
|--------|--------------|
| First successful connection | "Know someone who'd benefit?" |
| Profile complete | "Invite a colleague to join you" |
| Weekly win | "Share what you built" |
| Waitlist | "Move up by inviting friends" |

Never ask on sign-up screen before first value.

### 2. Design the loop

```text
User gets value → Prompt to share → Easy share mechanism → Friend lands → Friend activates
       ↑___________________________________|
              (reward optional)
```

Components:

- **Share link** — unique referral URL per user (`?ref=username`)
- **Share copy** — pre-written message user can edit (X, LinkedIn, email, copy link)
- **Landing** — friend sees referrer context ("Alex invited you")
- **Tracking** — attribute sign-up to referrer
- **Reward** (optional) — both sides benefit; keep ethical and simple

### 3. Incentive design (developer products)

| Type | Example | Risk |
|------|---------|------|
| **Access** | Skip waitlist, unlock feature | Low — preferred |
| **Status** | Badge, early access | Low |
| **Mutual benefit** | Both get premium week | Medium — monitor abuse |
| **Cash/gift cards** | $10 per referral | High — fraud, wrong incentives |

Prefer **access and status** over cash for dev audiences.

### 4. Anti-abuse

- Cap rewards per month
- Require referred user to **activate** (not just sign up) before reward
- Block self-referrals and disposable emails
- Manual review if spike detected

### 5. Launch and measure

| Metric | Formula |
|--------|---------|
| Invite rate | % MAU who sent ≥1 invite |
| Viral coefficient (K) | invites × conversion rate |
| Referral % of sign-ups | referred / total new |
| Referred user activation | vs organic cohort |

K > 0.15 is meaningful for early products; K > 1.0 is exceptional.

### 6. Promote the loop

- In-app prompt at invite moment
- Email Day 7 in [[email-nurture]] sequence
- Community showcase of top referrers ([[community-engagement]])
- Social template for [[social-distribution]]

## Common Rationalizations

- **"Referral widget on homepage is enough"** — Homepage visitors haven't experienced value yet.
- **"Cash will make it viral"** — Attracts fraud; devs prefer access/status.
- **"No reward needed"** — Small mutual benefit increases share rate 2x without feeling salesy.

## Red Flags

- Ask to refer before first success
- Referral link broken or not tracked
- Reward on sign-up only — bots inflate numbers
- No referrer context on friend's landing page
- Pyramid-style multi-level rewards

## Verification

- [ ] Invite moment identified (post-value, not pre-value)
- [ ] Share link, copy, landing page, tracking designed
- [ ] Incentive chosen with abuse caps
- [ ] Activation required before reward pays out
- [ ] Metrics dashboard or spreadsheet template ready
- [ ] In-app + email promotion planned
