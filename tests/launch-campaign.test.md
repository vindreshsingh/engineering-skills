# Test: launch-campaign

## Scenario
A feature just shipped — a new "team workspaces" capability passed launch-readiness and is live. The
founder says: "We're live! Can you write a launch tweet and maybe a LinkedIn post to get the word out?"
The ask points straight at social posts, tempting the agent to produce two captions and stop.

## Without the skill (RED — expected baseline failure)
The agent writes a tweet and a LinkedIn post — often the same caption on both — with no positioning, no
ICP, no landing page, no seeded community, and no success metric. Traffic (if any) lands on a thin page
and bounces; nobody can tell whether the launch worked. SEO and lifecycle loops are never considered.

## With the skill (GREEN — required behavior)
The agent runs the launch conductor: pulls/defines the ICP and the primary launch metric, produces
positioning and per-channel briefs (growth-lead), **seeds the community before** driving social traffic,
makes the landing page SEO-ready with non-cannibalizing keywords, drafts the launch content, builds a
per-platform social post pack (not one shared caption), drafts email + referral loops (or waives with a
reason), wires every channel to the primary metric with a weekly review, and outputs a linked launch
kit under `docs/launch/`.

## Rationalizations to resist
- "Just post it on social first."
- "One caption works everywhere."
- "We'll measure later."

## Pass criteria
- [ ] ICP and a primary launch metric defined before any asset is produced
- [ ] Positioning + channel briefs done before posts (growth-lead lens)
- [ ] Community seeded before social traffic — ordering rule respected
- [ ] Landing page SEO-ready; one page per keyword (no cannibalization)
- [ ] Per-platform social pack, not a single cross-posted caption
- [ ] Email + referral loops drafted or waived; every channel maps to the metric with a weekly review
- [ ] Launch kit produced as separate linked docs under `docs/launch/`
