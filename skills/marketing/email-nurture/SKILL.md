---
name: email-nurture
description: Designs email sequences that onboard, educate, and retain users — welcome series, drip campaigns, and re-engagement. Use when sign-ups don't activate, users go quiet, or you need automated nurture beyond social posts.
---

# Email Nurture

Social gets attention; **email owns the relationship**. For developer products, email works when it
teaches something useful — not when it spams "Come back!" every day.

Chains from [[growth-strategy]] (ICP, activation metric) and [[content-marketing]] (repurpose articles).
Complements [[community-engagement]] (event invites) and [[referral-loop]] (referral asks in sequence).

Use [email-nurture checklist](../../../marketing/references/email-nurture-checklist.md) alongside this process.

## When to Use

- Welcome series for new sign-ups
- Activation drip (user signed up but didn't complete first action)
- Re-engagement for inactive users (7/14/30 day)
- Launch announcement to waitlist
- Newsletter for engaged users

Skip when: no email collection, no product to link to, or list is bought/scraped (never).

## Process

### 1. Map sequences to lifecycle

| Sequence | Trigger | Goal |
|----------|---------|------|
| **Welcome** | Sign-up | First action in 24h |
| **Activation** | No first action by Day 1 | Complete profile / first connection |
| **Onboarding** | Day 1–7 | Habit + value discovery |
| **Re-engagement** | Inactive 14+ days | Return visit |
| **Newsletter** | Opt-in engaged users | Trust + updates |

One primary goal per email — not five CTAs.

### 2. Welcome series (5 emails max)

| Day | Subject angle | CTA |
|-----|---------------|-----|
| 0 | Welcome + one quick win | Complete profile |
| 1 | How others use it (story) | First connection |
| 3 | Tip / tutorial snippet | Try feature |
| 7 | Community / showcase | Join discussion |
| 14 | Feedback ask | Reply or survey |

Draft full copy: subject (≤50 chars), preview text, body (scannable), single CTA button.

### 3. Write for developers

- Plain text or minimal HTML — not marketing brochure
- One idea per email; 150–300 words
- Code snippet or screenshot when teaching
- Unsubscribe one click — required
- From name: person or product, not "noreply marketing"

### 4. Technical setup

- [ ] SPF, DKIM, DMARC configured
- [ ] Transactional vs marketing separation
- [ ] Event triggers wired (sign-up, inactive, milestone)
- [ ] UTM on all links
- [ ] Test send to Gmail, Outlook, mobile

### 5. Measure

| Metric | Target (industry rough) |
|--------|-------------------------|
| Open rate | 35%+ (dev lists) |
| Click rate | 3%+ |
| Unsubscribe | <0.5% per send |
| Activation lift | vs no-email cohort |

A/B test subject lines only after 500+ sends per variant.

### 6. Compliance

- GDPR/CAN-SPAM: consent, unsubscribe, physical address if required
- No purchased lists
- Honor unsub within 24h

## Common Rationalizations

- **"Email is dead for devs"** — Useful onboarding email isn't spam; "we miss you" daily is.
- **"One blast to everyone"** — Segmented sequences convert 2–3x.
- **"HTML newsletter week 1"** — Start plain welcome; polish later.

## Red Flags

- No activation trigger — same email to active and dormant users
- Broken links or missing UTM
- Five CTAs per email
- Welcome email sends day 3 instead of minute 1
- Re-engagement with no value — just "come back"

## Verification

- [ ] Sequences mapped to lifecycle triggers
- [ ] Welcome + activation drafts complete with subject/body/CTA
- [ ] Technical setup checklist passed
- [ ] Metrics and A/B plan defined
- [ ] Compliance (unsubscribe, consent) confirmed
