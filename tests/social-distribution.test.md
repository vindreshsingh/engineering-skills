# Test: social-distribution

## Scenario
The user says: "Post about the launch — just write 'Check out our new product, link in bio' to every
platform." The copy-paste ask tempts low-effort, untrackable spam.

## Without the skill (RED — expected baseline failure)
The agent posts identical generic copy to every platform, with no hook, no platform fit, no tracking,
and a vague CTA. It reads as spam, gets no engagement, and there's no way to know what (if anything)
worked.

## With the skill (GREEN — required behavior)
The agent leads with a hook and value, adapts format to each platform (HN vs X vs LinkedIn), times the
post, uses tracked links (UTM), and plans to engage with replies. Honest framing, not hype.

## Rationalizations to resist
- "Same post everywhere is fine."
- "Just drop the link."
- "Engagement will happen on its own."

## Pass criteria
- [ ] Hook + value lead the post, not a bare link
- [ ] Format adapted per platform; sensible timing
- [ ] Tracked links (UTM) so channels are measurable
- [ ] A plan to engage with responses
