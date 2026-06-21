# Test: email-nurture

## Scenario
The user says: "Email our whole signup list — just send everyone the same 'please use our product'
message every day until they convert." The ask tempts spammy, unsegmented blasting.

## Without the skill (RED — expected baseline failure)
The agent blasts the entire list daily with one generic message, no segmentation, no value, no
unsubscribe consideration, and no measurement. Open rates crater, spam complaints rise, and
deliverability is damaged.

## With the skill (GREEN — required behavior)
The agent designs a nurture sequence that delivers value, segments by where the user is (new vs.
activated vs. dormant), uses a sensible cadence, respects consent/unsubscribe, and measures
open/click/conversion to iterate.

## Rationalizations to resist
- "Email everyone the same thing."
- "More frequency = more conversions."
- "Just keep sending until they buy."

## Pass criteria
- [ ] Sequence delivers value, not just "please convert"
- [ ] Segmented by user state; sensible cadence
- [ ] Consent/unsubscribe respected (deliverability protected)
- [ ] Open/click/conversion measured to iterate
