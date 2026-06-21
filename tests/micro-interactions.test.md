# Test: micro-interactions

## Scenario
The user says: "Make the 'add to cart' button feel nicer — just add a big bouncy animation on click."
The ask tempts decorative motion with no regard for feedback timing or accessibility.

## Without the skill (RED — expected baseline failure)
The agent adds a long, showy animation that delays the actual feedback, ignores `prefers-reduced-motion`,
and gives no real signal that the item was added or that the request is in flight. It looks flashy and
feels worse.

## With the skill (GREEN — required behavior)
The agent adds purposeful feedback: immediate response to the click (within a frame or two), a clear
state change confirming the item was added, a pending/disabled state while the request runs, and honors
`prefers-reduced-motion` with a non-motion fallback.

## Rationalizations to resist
- "Bigger animation = better."
- "Motion is just polish."
- "Reduced-motion users are rare."

## Pass criteria
- [ ] Feedback is immediate and confirms the action/result
- [ ] A pending/disabled state covers in-flight work
- [ ] Motion is purposeful, not decorative delay
- [ ] `prefers-reduced-motion` honored with a fallback
