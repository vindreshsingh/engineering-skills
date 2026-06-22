---
name: launch-campaign
description: Turns a shipped feature into a complete go-to-market launch kit — positioning, seeded community, SEO landing, launch content, a social post pack, email and referral loops, and a measurement plan — by running the marketing persona team in the correct order with gates. Use after a feature is released (post launch-readiness) when you need to actually market it, not just one blog post or tweet.
---

# Launch Campaign

A feature that ships without a launch is a feature nobody hears about. The default failure is a single
tweet with no positioning, no seeded community, no landing page, and no way to tell if it worked. This
skill is the **go-to-market conductor**: it drives a shipped feature through the Grow phase as a
sequence — strategy, community, SEO, content, social, email, referral, measurement — running the right
marketing persona at each step, gating on the critical ordering rule, and producing a complete launch
kit instead of one improvised post.

It is the Grow-phase analogue of [[product-discovery]] and composes the marketing skills under
`skills/marketing/` — it does not replace them. It decides *which marketing skill and agent run when*
and refuses to drive traffic before the ground is prepared. Output is a **launch kit**, not code.

## When to Use

- A feature or product **just shipped** ([[launch-readiness]] passed) and needs to be marketed
- You need a coordinated campaign — positioning + content + social + SEO + email — not a one-off post
- Kicking off a launch and want the marketing team (`agents/marketing/…`) to act as a sequence, not a roster
- Closing the loop after [[product-discovery]] → Build → ship: the **discover → build → launch** arc

**Skip** when:
- You need exactly one artifact (one blog post, one keyword pass) — load that marketing skill directly
  via `marketing/SKILL.md` ([[content-marketing]], [[seo-growth]], …)
- The feature isn't shipped yet — finish [[launch-readiness]] first (rollout, monitoring, rollback)
- It's ongoing growth ops on a live product, not a launch — use [[growth-strategy]] directly

**Not a substitute for** [[launch-readiness]] (the *engineering* release gate — rollout/rollback/monitoring)
or the individual marketing skills it sequences. This skill markets a launch; it does not make the
release safe.

## Process

Run the phases **in order**, each with a persona lens, a governing skill, and an **exit gate**. Keep
one written campaign brief as the source of truth. The launch kit's artifacts mirror the repo's
`docs/launch/` convention.

### 1. Intake — what shipped, and for whom
- Pull the **ICP, problem, and primary success metric** from the [[product-discovery]] package (or
  define them now if absent). State what changed for the user and the **one number** this launch moves.
- **Gate:** ICP, the user-facing value, and the launch's primary metric are written down. No ICP → no
  campaign (cuts the #1 marketing red flag).

### 2. Strategy & briefs — growth-lead lens
- Skill: [[growth-strategy]]. Produce **positioning**, the channel plan, the campaign calendar, and a
  short **brief per channel**. growth-lead writes briefs — not posts or articles.
- **Gate (sign-off):** positioning and channel plan approved before any asset is produced.

### 3. Seed the community — community-manager lens
- Skill: [[community-engagement]]. Seed content, welcome flow, and early-adopter touchpoints **before**
  any traffic is driven.
- **Gate (critical ordering rule):** community is seeded before social distribution runs. Driving
  traffic to an empty community wastes the launch — do not skip or reorder this.

### 4. SEO landing & keywords — seo-strategist lens
- Skill: [[seo-growth]]. Landing-page on-page SEO and a keyword map with **one page per keyword** (no
  cannibalization). Hand spoke topics to content.
- **Gate:** landing page is SEO-ready and keywords are assigned without overlap.

### 5. Launch content — content-marketer lens
- Skill: [[content-marketing]]. The launch blog/announcement plus supporting tutorials, built on the
  SEO spoke topics. content-marketer hands social snippets to the next step.
- **Gate:** launch article(s) drafted and tied to the positioning and keywords.

### 6. Social distribution — social-media-manager lens
- Skill: [[social-distribution]]. A **post pack** and launch thread, **per-platform** (no single
  caption cross-posted everywhere). Coordinate timing with community-manager.
- **Gate:** platform-tailored posts + launch thread ready; community seeded (step 3) confirmed first.

### 7. Lifecycle loops — email-marketer & referral-manager lenses
- Skills: [[email-nurture]] (welcome/nurture sequence) and [[referral-loop]] (invite/viral loop) where
  they fit the product. These convert and compound the launch traffic.
- **Gate:** email sequence and referral loop drafted, or explicitly waived with a reason.

### 8. Measurement & review — growth-lead + product-analyst lenses
- Define how each channel reports to the **primary metric** from step 1, and set the **weekly review**
  cadence ([[observability]] for instrumentation; product-analyst reads results back to the PM).
- **Gate:** every channel maps to the primary metric; a weekly review is scheduled.

### 9. Assemble the launch kit
Produce the artifacts as separate, linked docs under `docs/launch/`:
- Campaign brief + positioning (step 2)
- Community seed plan (step 3)
- SEO landing + keyword map (step 4)
- Launch blog/announcement + tutorials (step 5)
- Per-platform social post pack + launch thread (step 6)
- Email sequence + referral loop, or recorded waiver (step 7)
- Measurement plan + weekly-review cadence (step 8)

State the launch date and the owner of the weekly review. The campaign is ready when it could run
without re-deciding *what to say*, *where*, or *how success is measured*.

## Common Rationalizations

- "Just post it on social first." — Without positioning and a seeded community, posts bounce; run steps 2–3 first.
- "SEO can wait." — Every month delayed is compounding organic traffic lost; do it at launch (step 4).
- "One caption works everywhere." — Cross-posting one caption tanks engagement; tailor per platform (step 6).
- "We'll measure later." — A launch with no primary metric can't be judged or improved; define it in step 1.
- "Marketing is separate from product." — Community and analyst feedback loops back to the PM; wire the review (step 8).
- "Do the whole launch in one pass." — Skipping the strategy and community gates is how a launch fizzles.

## Red Flags

- No ICP or primary metric defined before assets are produced
- Social launch fired before the community is seeded (ordering rule violated)
- One caption cross-posted to every platform
- Keywords assigned to multiple pages (cannibalization)
- A "launch" that's a single post with no positioning, landing page, or measurement
- Marketing started before the feature actually shipped ([[launch-readiness]] skipped)
- The kit is one wall of text instead of linked, named artifacts with an owner and a review cadence

## Verification

- [ ] ICP, user-facing value, and primary launch metric written down (step 1)
- [ ] Positioning + channel plan + per-channel briefs approved before assets ([[growth-strategy]])
- [ ] Community seeded **before** social traffic — ordering rule respected ([[community-engagement]])
- [ ] Landing page SEO-ready; one page per keyword, no cannibalization ([[seo-growth]])
- [ ] Launch content drafted on the SEO spokes; social snippets handed off ([[content-marketing]])
- [ ] Per-platform social post pack + launch thread ready ([[social-distribution]])
- [ ] Email sequence and referral loop drafted or explicitly waived ([[email-nurture]], [[referral-loop]])
- [ ] Every channel maps to the primary metric; weekly review scheduled with an owner
- [ ] Launch kit produced as separate linked docs under `docs/launch/`
