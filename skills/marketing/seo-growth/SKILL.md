---
name: seo-growth
description: Improves organic search visibility — keyword research, on-page SEO, landing pages, technical basics, and content gaps. Use when you need more search traffic, better page rankings, or SEO-optimized pages for a developer product.
---

# SEO Growth

Organic search is the highest-ROI channel for developer tools — intent is built in. Someone searching
"developer networking platform" is closer to signing up than someone scrolling X. This skill turns
search demand into **ranked pages** that convert, without black-hat tricks that get you penalized.

Chains from [[growth-strategy]] (ICP, keywords, goals) and [[content-marketing]] (articles to optimize).
Complements [[social-distribution]] (social drives links and brand searches).

## When to Use

- New product/site with no organic traffic
- Rankings stuck on page 2–3 for target keywords
- Launching a landing page or docs site
- Auditing existing pages for SEO fixes
- Planning a content cluster around a topic
- After launch — monthly SEO review

Skip when traffic goal is purely viral/social and SEO is explicitly deferred (document why).

## Process

### 1. Baseline audit

Gather current state:

- **Site URL** and key pages (home, sign-up, pricing, blog)
- **Analytics** — sessions, top pages, bounce rate, conversions (or "none yet")
- **Search Console** — impressions, clicks, average position (or setup needed)
- **Competitors** — 3–5 similar products ranking for your terms
- **Technical** — HTTPS, mobile-friendly, page speed (Core Web Vitals rough check)

List **quick wins** vs **long-term** fixes.

### 2. Keyword research

For developer products, cluster keywords by intent:

| Intent | Example keywords | Page type |
|--------|------------------|-----------|
| **Informational** | "how to find a coding mentor", "developer networking tips" | Blog / guide |
| **Commercial** | "best developer networking app", "linkedin alternative for developers" | Comparison / landing |
| **Transactional** | "developer connection platform", "join dev community" | Home / sign-up |
| **Branded** | "[product name]", "[product] review" | Home, about |

Process:

1. Brainstorm 20–30 seed terms from ICP ([[growth-strategy]])
2. Check competitor pages ranking for those terms
3. Prioritize by: search volume (rough), difficulty (low/med/high), business fit
4. Pick **5 primary keywords** and **10 long-tail** for first 60 days
5. Map **one primary keyword per page** — no cannibalization

Document in a keyword map:

```text
Page URL | Primary keyword | Secondary keywords | Search intent | Status
```

### 3. On-page optimization

For each target page:

**Title tag** (50–60 chars): Primary keyword near front + benefit  
**Meta description** (150–160 chars): Keyword + CTA verb  
**H1**: One per page; matches intent, not identical to title  
**H2/H3**: Related keywords naturally; answer sub-questions  
**URL**: Short, readable, keyword if sensible (`/developer-networking` not `/page?id=3`)  
**Body**: Answer the query in first 200 words; 800+ words for blog targets  
**Internal links**: 2–3 links to related pages with descriptive anchor text  
**Images**: Alt text describing image + keyword where natural  
**CTA**: Above fold and end of page — sign up, try demo, join waitlist

**Developer-specific:**

- Code examples and CLI commands in content (increases dwell time)
- FAQ schema for common questions (rich snippets)
- Fast load — devs bounce on slow pages

### 4. Landing page essentials

Home / sign-up page must have:

- Clear **value prop** in H1 (what + for whom)
- **Social proof** — user count, testimonials, logos (real or `[PLACEHOLDER]`)
- **Feature bullets** tied to benefits, not jargon
- **FAQ section** — targets long-tail "is X good for Y" queries
- **Open Graph / Twitter cards** — title, description, image for social shares
- **Structured data** — `SoftwareApplication` or `WebApplication` JSON-LD where appropriate

### 5. Content cluster plan

Build topical authority with a **hub + spokes**:

```text
Hub: "Developer Networking Guide" (pillar page)
  → Spoke: How to find a mentor
  → Spoke: Building your dev brand on LinkedIn vs niche platforms
  → Spoke: First 30 days as a new developer — who to connect with
  → Spoke: [Product] vs LinkedIn for developers
```

Each spoke links to hub and to sign-up. Hub links to all spokes. Hand spoke drafts to [[content-marketing]].

### 6. Technical SEO checklist

Minimum bar:

- [ ] `robots.txt` allows crawling of public pages
- [ ] XML sitemap submitted to Search Console
- [ ] Canonical tags on duplicate/thin pages
- [ ] No broken links (404 audit)
- [ ] Mobile responsive
- [ ] LCP < 2.5s on key pages (rough — fix biggest issues)
- [ ] HTTPS everywhere
- [ ] hreflang if multi-language

### 7. Measure and iterate (monthly)

| Metric | Source | Action if flat |
|--------|--------|----------------|
| Impressions | Search Console | Expand keywords, fix titles |
| CTR | Search Console | Rewrite meta descriptions |
| Average position | Search Console | Improve content depth, backlinks |
| Organic sessions | Analytics | Map which pages convert |
| Sign-ups from organic | Analytics + UTM | Optimize high-traffic low-convert pages |

Feed learnings to [[growth-strategy]] weekly review.

## Common Rationalizations

- **"SEO takes too long — skip it"** — It compounds. Start month 1 or month 6 is lost traffic forever.
- **"Keyword stuffing helps rankings"** — Google penalizes it. Write for humans.
- **"We need backlinks before content"** — Good content earns links; publish first.
- **"Our SPA doesn't need SSR"** — If Google can't render it, you don't rank. Fix rendering.

## Red Flags

- Multiple pages targeting the same primary keyword
- Title tags missing or duplicate across pages
- Thin pages (<300 words) targeting competitive terms
- No analytics or Search Console installed
- Blocking `/blog` or `/docs` in robots.txt
- Fake testimonials or review schema

## Verification

SEO work is done when:

- [ ] Baseline audit documented with quick wins listed
- [ ] Keyword map with 5 primary + 10 long-tail terms and page mapping
- [ ] On-page checklist applied to each target page (title, meta, H1, CTA)
- [ ] Landing page has value prop, proof, FAQ, OG tags
- [ ] Content cluster plan (hub + 3+ spokes) handed to content-marketer
- [ ] Technical checklist passed or gaps logged with owners
- [ ] Monthly metrics template set up
