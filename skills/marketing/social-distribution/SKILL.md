---
name: social-distribution
description: Plans and writes short-form social content and distributes it across platforms — posts, threads, carousels, and launch announcements. Use when you need daily social presence, launch threads, or platform-specific content that drives traffic and engagement.
---

# Social Distribution

Social is where developers **discover** products between commits. This skill turns strategy and
long-form content into **platform-native posts** — not the same caption pasted everywhere. Each
platform has different norms; respect them or get ignored.

Chains from [[growth-strategy]] (channels, pillars, calendar) and [[content-marketing]] (articles to
snippet). Feeds traffic to landing pages optimized via [[seo-growth]]; engagement handled by
[[community-engagement]] in comments and DMs.

## When to Use

- Daily/weekly social posting cadence
- Launch announcement threads (X, LinkedIn)
- Repurposing a blog post into social snippets
- Product update posts, feature highlights, tips
- Engagement replies and quote-tweet strategy (templates)
- Planning a Show HN / Product Hunt / Reddit launch post

Skip for long-form articles — use [[content-marketing]]. Skip for in-community moderation —
use [[community-engagement]].

## Process

### 1. Load the distribution brief

From [[growth-strategy]] or gather:

- **Platforms** (primary + secondary) — X, LinkedIn, Reddit, Instagram, etc.
- **Cadence** — e.g. X 1/day, LinkedIn 3/week, Reddit 1/week value post
- **Campaign theme** — this week's pillar
- **Links** — landing page, UTM-tagged URLs per platform
- **Voice** — technical, helpful, no cringe hype
- **Assets** — GIFs, screenshots, demo video links from content team

Build UTM pattern: `?utm_source=x&utm_medium=social&utm_campaign=[campaign]`

### 2. Platform playbooks

Adapt format and tone per platform:

**X / Twitter**

- Hooks in first line — pain, stat, or bold claim
- Threads: 5–10 tweets, one idea per tweet, last tweet = CTA + link
- Code snippets, screenshots, short demo GIFs perform well
- Reply to relevant dev conversations (don't spam links)
- 1–2 hashtags max; often zero is better

**LinkedIn**

- Professional story arc — problem → journey → lesson → soft CTA
- Carousels: 5–8 slides, one point per slide, last slide CTA
- Tag people sparingly; authenticity over engagement bait
- Comment on posts in your ICP's feed

**Reddit**

- **Read subreddit rules first** — many ban self-promotion
- Value-first post: full guide in text; link at end or in comment if allowed
- r/SideProject, r/webdev, r/cscareerquestions, r/startups — pick where ICP lives
- Never astroturf; be transparent you're the builder

**Dev.to / Hashnode**

- Cross-post tutorials with canonical URL if blog exists
- Add `discussion` tag; engage in comments

**Hacker News / Product Hunt**

- One-shot launch; prepare title, tagline, first comment (maker story)
- HN: "Show HN: [Product] — [specific benefit]" not marketing speak
- PH: clear screenshots, maker comment, respond to every question for 24h

### 3. Content batch — weekly pack

Produce a **7-day pack** (adjust cadence to brief):

| Day | Platform | Type | Hook (draft) | CTA | Asset |
|-----|----------|------|--------------|-----|-------|
| Mon | X | Tip thread | | | |
| Tue | LinkedIn | Story post | | | |
| Wed | X | Product demo GIF | | | |
| Thu | Reddit | Value post | | | |
| Fri | LinkedIn | Carousel | | | |
| Sat | X | User quote / win | | | |
| Sun | X | Behind-the-build | | | |

Each row: full draft text ready to copy-paste, character count for X, hashtag notes.

### 4. Launch sequence (when applicable)

For product/feature launch, run this sequence:

1. **T-7 days** — teaser ("building something for dev networking")
2. **T-3 days** — problem thread (pain without naming product)
3. **T-1 day** — "launching tomorrow" + what to expect
4. **Launch day** — thread + LinkedIn + Reddit/HN/PH per brief
5. **T+1** — thank you + early user highlight
6. **T+7** — results/learnings post (transparency builds trust)

Draft all six in one sitting; schedule or queue.

### 5. Engagement rules

- **Reply within 24h** to comments on your posts — template helpful replies, not "thanks!"
- **Quote tweets / reshare** user wins and feedback (with permission)
- **Never** argue in public threads — take heated DMs offline
- **Track** which hooks got saves/shares — feed back to [[growth-strategy]] weekly review

### 6. Compliance and quality gate

Before publishing:

- [ ] Link works and UTM tags correct
- [ ] No unverified claims
- [ ] Platform character limits respected
- [ ] Reddit/forum post follows that community's rules
- [ ] Screenshots don't expose private user data

## Common Rationalizations

- **"Same post everywhere saves time"** — Lazy cross-posting gets zero engagement everywhere.
- **"More hashtags = more reach"** — On X and LinkedIn, hashtag stuffing looks spammy.
- **"Reddit is free advertising"** — Reddit will ban you. Lead with value.
- **"We'll engage later"** — First-hour replies boost reach; schedule time for launch day.

## Red Flags

- Every post is "Sign up now!" with no value
- Links broken or missing UTM tracking
- Launch day with no maker story or demo
- Ignoring comments on launch posts
- Posting promotional content in communities that forbid it

## Verification

Distribution pack is done when:

- [ ] Weekly post pack with full drafts per platform
- [ ] UTM links defined for each platform
- [ ] Launch sequence drafted (if launch campaign)
- [ ] Engagement reply templates for common questions
- [ ] Platform rule check for Reddit/forum posts
- [ ] Quality gate checklist passed
