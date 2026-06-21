---
name: ux-design
description: Defines user flows, information architecture, and interaction design before implementation. Use when shaping a new feature UX, reviewing usability, creating wireframe specs, or preparing handoff to design-handoff and ui-craft.
---

# UX Design

Implementation without UX clarity produces rework. This skill defines **who**, **goal**, **flow**, and
**states** before pixels or code — the contract between product intent and what users experience.

Pairs with [[product-brief]] and [[spec-first]] for requirements, [[design-handoff]] for mockup-to-code,
[[ui-craft]] for implementation quality, and [[accessibility]] for inclusive flows.

## When to Use

- New feature needs user flow before UI build
- Usability review of existing experience
- Wireframe or interaction spec for engineers/designers
- PRD has stories but no journey map
- Handoff prep before Figma or high-fidelity design

Skip when changing copy-only or backend-only with no UX surface.

## Process

### 1. Frame the problem

- **User** (persona from [[product-brief]])
- **Job to be done** — one sentence
- **Success metric** — observable (completed signup, sent connection, etc.)
- **Constraints** — platform (web/mobile), accessibility, timeline

### 2. Map the happy path

```text
Entry → Steps (numbered) → Success state
```

For each step document:
- Screen/view name
- User action
- System response
- Error/empty if action fails

Keep to **one primary path** first — edge cases in step 4.

### 3. Information architecture

- Navigation: where does this feature live?
- Labels: user words, not internal jargon
- Hierarchy: primary vs secondary actions (one primary CTA per screen)

### 4. Edge and empty states

For each step in the flow:

| State | What user sees |
|-------|----------------|
| Empty | First visit, no data |
| Loading | Async in progress |
| Error | Recoverable failure |
| Success | Confirmation + next step |

Missing empty/error states cause most UI bugs.

### 5. Interaction notes

- Keyboard path for web
- Mobile: touch targets, thumb zone
- Confirmation for destructive actions
- Progressive disclosure — don't show everything at once

### 6. Handoff package

Deliver to [[design-handoff]] / [[ui-craft]]:

- User flow diagram (ASCII or mermaid)
- Screen list with purpose per screen
- Copy for headings, buttons, errors (draft)
- Open UX questions with owner

## Common Rationalizations

- **"Engineers can figure out the flow"** — They'll guess; users pay the cost.
- **"We'll UX test after launch"** — Cheaper to map empty states now.
- **"One mockup is enough"** — Flow + states prevent 80% of review churn.

## Red Flags

- No defined entry point to the feature
- Multiple primary CTAs competing on one screen
- Error states say "Something went wrong" with no recovery
- Internal feature names visible to users
- Mobile flow not considered for mobile product

## Verification

- [ ] User, goal, and success metric documented
- [ ] Happy path with numbered steps
- [ ] Empty, loading, error, success defined per critical screen
- [ ] One primary CTA per screen
- [ ] Handoff package ready for design-handoff or ui-craft
- [ ] Open questions have owners
