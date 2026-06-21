---
name: design-handoff
description: Turns a visual design into faithful, maintainable front-end code. Use when implementing a mockup or Figma file, matching a design spec, building against a design system, or reviewing how closely an implementation tracks its design.
---

# Design Handoff

Translating a design into code is more than eyeballing the picture. Static frames hide states,
breakpoints, semantics, and the token system underneath. Hardcoded hex values and one-off components
look right on day one and drift off-brand by day thirty.

Extract the **system** behind the design, **reuse** what the product already has, **implement every
state** the mockup doesn't show, and **prove fidelity** in the browser — not just in DevTools overlay.

Pairs with [[ui-craft]] for states and polish, [[accessibility]] for semantics, focus, and contrast
the visual file won't specify, [[browser-checks]] to verify the running UI, [[incremental-delivery]]
to ship slice by slice, and [[react-patterns]] when the handoff is React/Next.js. For gaps in the
design, clarify before coding ([[spec-first]]) — don't guess missing behavior.

## When to Use

- Implementing a mockup, Figma frame, Sketch file, or visual spec as components/pages
- Matching spacing, typography, color, and layout to an approved design
- Building a new component that should plug into an existing design system
- Reviewing whether an implementation faithfully reflects its design source
- Retrofitting an old screen to the current design system
- Designer delivered assets and you need a faithful, maintainable build

Skip as the primary skill for pure logic with no visual surface, or when intentionally diverging from
design (experiments, internal tools with no spec) — still apply [[ui-craft]] and [[accessibility]] for
user-facing output.

## Process

Work in order. Don't write layout CSS until you've mapped tokens and components.

### 1. Inventory before you code

Gather what the handoff actually includes — and what's missing.

**From the design file / spec:**

- Frame(s) for each breakpoint — mobile, tablet, desktop (note which exist)
- Component instances vs one-off frames — what maps to the design system?
- **Tokens** — color styles, spacing scale, typography ramp, radii, shadows, grid
- **Assets** — icons (SVG preferred), illustrations, images, fonts, export settings
- **Interaction notes** — hover, focus, pressed, motion, transitions (if any)
- **Copy** — final strings, truncation rules, pluralization
- **Annotations** — spacing, behavior, edge cases the designer documented

**In the codebase:**

- Existing components that match (Button, Card, Input, Modal, …)
- Token source — CSS variables, Tailwind config, theme object, design-token package
- Layout primitives — grid, stack, container widths, breakpoint definitions
- Patterns for forms, tables, empty states, toasts

**Gap list** — write explicit questions for the designer or PM before implementation:

```text
Missing: empty cart state, error on failed payment, focus ring style, behavior below 375px,
         loading skeleton vs spinner — need decision before build.
```

Unanswered gaps become expensive guesses in code.

### 2. Read the design for its system, not its surface

Designs are built from a system even when the file doesn't label it. Extract:

| Layer | What to find | Map to code |
|-------|--------------|-------------|
| **Color** | Primary, surface, border, text roles — not random hexes | `--color-*`, theme palette |
| **Typography** | Font family, sizes, weights, line heights | `text-sm`, `heading-2`, etc. |
| **Spacing** | 4/8px grid or explicit scale | `space-4`, `gap-6` |
| **Radii & borders** | Corner radius, border width/color | token names |
| **Elevation** | Shadow levels | `shadow-md`, z-index scale |
| **Breakpoints** | Where layout changes | `sm`/`md`/`lg` definitions in code |

If Figma **variables** or **styles** exist, use them as the source of truth — they name the system.
If the design uses raw values everywhere, propose token mappings and confirm with design before
locking in.

**Do not** copy hex/spacing from inspect panel into component CSS without checking if a token already
exists for that role.

### 3. Reuse before you rebuild

If the design shows a button, card, or input you already ship — use the **real component** with the
correct variant and size props.

```tsx
// Prefer: system component + variant
<Button variant="primary" size="md">Save</Button>

// Not: new div styled to look like a button this week
<button className="bg-[#1a73e8] px-[18px] ...">Save</button>
```

When the design differs slightly from the existing component:

1. Check if it's intentional design evolution → update the **system component** (with design approval).
2. Check if it's a one-off → still prefer composition (`Button` + icon slot) over fork.
3. Only create a new component when the pattern is genuinely new and reusable.

Forked near-copies drift — spacing, focus rings, and hover states diverge within weeks.

### 4. Extract exact values for what's genuinely new

For elements that don't map to existing tokens, extract **exact** specs — don't approximate.

From Figma inspect / design spec:

- Width, height, padding, gap — note which axis
- Font: family, size, weight, line-height, letter-spacing
- Colors — hex + opacity; prefer mapping to a new token if repeated
- Border, radius, shadow — full stack
- Icon size and alignment relative to text

**Approximation is how implementations diverge.** "About 16px" becomes 14px on the next screen. Round
only when the design system scale already rounds that way.

Document new tokens in the theme/token file — not scattered in the component — so the next handoff
reuses them.

### 5. Structure first — semantics before cosmetics

Build the **DOM structure** and component hierarchy before pixel-perfect polish:

- Correct landmarks, headings, lists, forms ([[accessibility]])
- Component boundaries that match how the page will be maintained
- Data props and slots — where text, images, and actions plug in

A pixel-perfect `div` stack that needs restructuring for a11y or state logic is wasted work. Structure
first, then tokens, then fine-tuning.

Slice vertically ([[incremental-delivery]]): one working section with real structure and one state
before polishing the entire page.

### 6. Implement every state the mockup omits

The frame is one moment in time. The product has many ([[ui-craft]]). Plan and build:

| State | Often missing from mockups | Decide explicitly |
|-------|---------------------------|-------------------|
| **Default / populated** | Usually shown | — |
| **Hover / focus / active / disabled** | Rarely all shown | Match system interaction tokens |
| **Loading** | Often omitted | Skeleton vs spinner; preserve layout |
| **Empty** | Often omitted | Message, illustration, CTA |
| **Error** | Often omitted | Inline vs banner; recovery action |
| **Partial / truncated** | Rarely shown | Long title, many tags, overflow |
| **Success / confirmation** | Sometimes | Toast, inline check, next step |

If design didn't provide a state, **implement from the design system pattern** — don't ship blank or
broken UI. Flag visual gaps to design for a follow-up polish pass.

### 7. Define responsive behavior — not just one width

A fixed-width mockup is a starting point. For each major breakpoint:

- What **reflows** — stack vs row, column count, nav pattern
- What **hides or collapses** — menus, sidebars, table → card
- **Typography and spacing** — do they step down on small screens?
- **Touch targets** — minimum ~44×44px on mobile; design may show desktop-only sizes

Implement and test at least:

- **~375px** — small phone
- **Design's primary width** — often 1440 or 1280
- One **middle** breakpoint if layout shifts materially

Don't only pixel-match the artboard width and break everywhere else ([[browser-checks]]).

### 8. Accessibility the design file won't specify

Visual handoffs rarely include focus order, labels, or contrast math — code still must deliver
([[accessibility]]):

- **Focus visible** on every interactive control — use system focus ring tokens
- **Labels** on every form field — placeholder is not a label
- **Contrast** — text and icons on backgrounds meet WCAG AA (4.5:1 body, 3:1 large/UI)
- **Keyboard** — full flow without mouse; modals trap and restore focus
- **Motion** — respect `prefers-reduced-motion` for designed animations
- **Alt text** for meaningful images; decorative images empty alt

If design colors fail contrast, fix with design approval — don't ship illegible UI to match hex.

Semantic HTML and ARIA only where native semantics aren't enough — don't sacrifice structure for
layout shortcuts.

### 9. Assets, icons, and motion

**Icons** — prefer SVG from the system icon set; match designed size via `width`/`height` or token.
Don't rasterize icons as PNG unless the design requires it.

**Images** — export at appropriate resolution; use `srcset`/`sizes` for photos; explicit `width`/`height`
or aspect-ratio to prevent layout shift.

**Fonts** — load only weights used; subset if large; fallbacks that don't change metrics badly.

**Motion** — if the design specifies duration/easing, implement with CSS/transitions; document values
as tokens. If unspecified, use system defaults. Gate decorative motion behind reduced-motion.

Export from Figma with consistent naming; avoid duplicate assets that differ by 1px.

### 10. Compare and reconcile against the source

"Looks close" is not done. Verify fidelity:

1. **Side-by-side** — implementation next to design at the same viewport width.
2. **Overlay** — Figma overlay plugins, PixelParallel, or browser extensions for pixel diff.
3. **Spot-check** spacing — padding, gap, alignment between label and field, icon nudge.
4. **States** — each state compared to spec or system pattern, not only default.
5. **Browser proof** — console clean, responsive check, keyboard pass ([[browser-checks]]).

Reconcile differences deliberately:

| Difference | Action |
|------------|--------|
| Bug — doesn't match approved design | Fix code |
| Design system token vs raw mockup value | Use token; confirm with design if visible |
| Design gap — state never designed | Use system pattern; ticket for design |
| Intentional engineering constraint | Note in PR; don't silent drift |

Capture screenshot or recording for PR evidence.

### 11. Review handoff fidelity (PR / QA)

When reviewing someone else's implementation:

- Token usage vs hardcoded values
- System components vs re-created UI
- States beyond the happy path
- Responsive behavior at narrow and wide
- a11y — focus, labels, contrast
- Comparison evidence — screenshots at spec width

Approve when faithful and maintainable — not when "close enough" with silent drift.

### 12. Scenario playbooks

**New page from full Figma frame**

1. Inventory frames per breakpoint + gap list.
2. Map sections to components; identify reuse.
3. Structure + data wiring for one vertical slice.
4. Tokens and layout per section; states for each block.
5. Responsive + a11y pass; overlay compare; browser-checks.

**New variant on existing component**

1. Compare to current component API — extend variant vs new component.
2. Update design system with design approval if the pattern is global.
3. Storybook/docs for new variant; don't fork per page.

**Design system drift — mockup uses raw values**

1. Map raw values to nearest tokens; list deltas.
2. Ask design: intentional update or mockup sloppiness?
3. Update tokens if intentional; fix mockup reference if not.

**No Figma — screenshot or PDF only**

1. Extract what you can; list all ambiguities.
2. Don't invent spacing scale — align to codebase tokens.
3. Get sign-off on gaps before polish.

**Retrofit old screen to new design**

1. Diff old vs new design — what components can swap in place?
2. Migrate token-by-token; avoid half-old/half-new page.
3. Regression browser-check on critical flows.

**Design review before build (early handoff)**

1. Confirm breakpoints, states, and tokens exist in the file.
2. Confirm components in Figma match code component names.
3. Return incomplete handoff to design with specific gap list — cheaper than rework.

## Common Rationalizations

- "It looks close enough." — Small drifts compound into an off-brand, inconsistent product.
- "I'll hardcode the values." — Hardcoding bypasses the system and rots when design updates.
- "The mockup only shows one state." — You must implement the rest from system patterns, not omit them.
- "Accessibility isn't in the design." — It's still required; build it in ([[accessibility]]).
- "I'll match pixels first, fix structure later." — Restructuring costs more than semantics-first.
- "This button is slightly different — I'll make a new one." — Forks multiply; extend the system.
- "Responsive is just scaling down." — Layout often must reflow, not shrink.
- "Overlay comparison is designer work." — Engineers own fidelity of what they ship.
- "Figma says 15px — we don't have that token." — Map to nearest token or add token; don't leave 15px in isolation.

## Red Flags

- One-off hex/pixel values where design tokens exist
- Re-created component instead of existing system component
- Only the default mockup state implemented
- Pixel-perfect at design width but broken on mobile/tablet
- Missing focus, labels, or failing contrast
- No loading, empty, or error treatment
- Layout shift when images or data load
- Assets exported as wrong format or 3× duplicate PNGs
- Hardcoded copy that should be props or CMS content
- No comparison against source design before merge
- Gap list never sent — guessed behavior instead
- Animation with no reduced-motion path
- PR with no screenshot at spec viewport

## Verification

- [ ] Handoff inventoried — breakpoints, tokens, assets, gaps documented
- [ ] Design system mapped — colors, type, spacing, radii use tokens not raw values
- [ ] Existing components reused; new components justified and added to system when global
- [ ] Exact specs extracted for genuinely new elements — no guessed "about" values
- [ ] Semantic structure built before pixel polish ([[accessibility]])
- [ ] All states implemented — hover/focus/disabled, loading, empty, error, overflow ([[ui-craft]])
- [ ] Responsive behavior defined and tested at small, middle, and design widths
- [ ] Focus, labels, contrast, keyboard, and reduced-motion handled
- [ ] Assets optimized — SVG icons, image dimensions, font weights only as needed
- [ ] Implementation compared to design — overlay/side-by-side; differences reconciled
- [ ] Browser verification — console, responsive, interaction ([[browser-checks]])
- [ ] PR includes comparison evidence; intentional deltas explained
