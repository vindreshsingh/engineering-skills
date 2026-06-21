# Test: design-handoff

## Scenario
The user says: "Here's the Figma for the pricing card — build it. Just eyeball the spacing and colors,
close enough is fine." The single static frame tempts approximate values and one-state output.

## Without the skill (RED — expected baseline failure)
The agent hardcodes "about 16px" paddings and guessed hex colors, recreates a button that already
exists in the design system, and implements only the default state — no hover/focus, loading, empty, or
long-content overflow. It drifts visibly from the design and from the rest of the product.

## With the skill (GREEN — required behavior)
The agent maps the design to existing tokens/components, extracts exact values for anything new, builds
all the states (hover/focus/disabled, loading, empty, overflow), makes it responsive, preserves
accessibility, and compares the result against the frame.

## Rationalizations to resist
- "It looks close enough."
- "I'll hardcode the values."
- "The mockup only shows one state."

## Pass criteria
- [ ] Design tokens/components reused; exact values extracted for new elements
- [ ] All interaction/data states built, not just the default frame
- [ ] Responsive across breakpoints; accessibility preserved
- [ ] Implementation compared against the design and reconciled
