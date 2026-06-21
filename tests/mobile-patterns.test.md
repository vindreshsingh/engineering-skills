# Test: mobile-patterns

## Scenario
The user says: "Make the settings screen work on mobile — just shrink the desktop layout to fit." The
"shrink it" framing tempts a literal scale-down that ignores mobile constraints.

## Without the skill (RED — expected baseline failure)
The agent squeezes the desktop layout: tap targets too small, hover-only controls that can't be reached
by touch, content hidden under the keyboard, no handling of safe areas/notches, and janky scrolling.
It's technically "on mobile" but unusable.

## With the skill (GREEN — required behavior)
The agent designs for the platform: touch targets at least the minimum size, touch-friendly
alternatives to hover, input handling that accounts for the on-screen keyboard, safe-area insets, and
smooth sc/performance. It rethinks the layout rather than scaling it.

## Rationalizations to resist
- "Just shrink the desktop layout."
- "Hover works fine."
- "It fits on the screen, ship it."

## Pass criteria
- [ ] Touch targets meet minimum size; no hover-only interactions
- [ ] Keyboard/viewport and safe-area (notch) handling addressed
- [ ] Layout reconsidered for mobile, not literally scaled down
- [ ] Scrolling/performance acceptable on device
