---
name: design-handoff
description: Turns a visual design into faithful, maintainable front-end code. Use when implementing a mockup or Figma file, matching a design spec, or reviewing how closely an implementation tracks its design.
---

# Design Handoff

Translating a design into code is more than eyeballing the picture. Extract the real values, reuse the
system the design is built on, and honor the states and responsiveness the static frame can't show —
so the result matches in spirit and in pixels.

## When to Use

- Implementing a mockup, Figma frame, or visual spec as components
- Matching an existing design closely (spacing, type, color, layout)
- Reviewing whether an implementation faithfully reflects its design
- Building a component that should plug into an existing design system

## Process

1. **Read the design for its system, not just its surface.** Identify the tokens behind it — spacing
   scale, type ramp, color roles, radii, breakpoints — and map them to existing code tokens/components.
2. **Reuse before you build.** If the design uses a button/card/input you already have, use the real
   component; don't reproduce a near-copy that drifts.
3. **Extract exact values** for anything genuinely new — measurements, colors, weights — rather than
   guessing "about 16px." Approximation is how implementations slowly diverge.
4. **Build the states the mockup doesn't show.** Hover/focus/active/disabled, loading, empty, error,
   and long-content overflow. The frame is one state; the product has many ([[ui-craft]]).
5. **Make it responsive.** A fixed-width mockup is a starting point; define how it reflows across
   breakpoints, not just at the design's width.
6. **Keep accessibility intact** — semantic structure, focus order, contrast, labels — which a visual
   file won't spell out but the code must have.
7. **Compare against the design** at the end (overlay/side-by-side) and reconcile the differences.

## Common Rationalizations

- "It looks close enough." — Small, uncorrected drifts compound into an off-brand, inconsistent UI.
- "I'll hardcode the values." — Hardcoding bypasses the system and rots the moment the design updates.
- "The mockup only shows one state." — Then you must design the rest deliberately, not omit them.
- "Accessibility isn't in the design." — It's still required; build it in rather than bolt it on.

## Red Flags

- One-off hex/pixel values where design tokens exist
- A re-created component instead of the existing system one
- Only the default state implemented
- Pixel-matches the design width but breaks on other viewports
- Missing focus states, labels, or failing contrast
- No final comparison against the source design

## Verification

- [ ] Design tokens mapped to existing code tokens/components; system reused
- [ ] Exact values extracted for new elements (no guessing)
- [ ] All interaction and data states implemented, not just the mockup's frame
- [ ] Responsive behavior defined across breakpoints
- [ ] Accessibility preserved (semantics, focus, contrast, labels)
- [ ] Implementation compared against the design and reconciled
