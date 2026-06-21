---
name: accessibility
description: Builds UI that everyone can use — keyboard, screen reader, low vision, reduced motion, and motor differences. Use when creating or changing any user-facing interface, implementing custom widgets, fixing a11y bugs, or preparing for an audit.
---

# Accessibility

Accessible UI works for people using a keyboard, a screen reader, magnification, voice control,
reduced motion, or touch — not just a mouse and perfect vision. Target **WCAG 2.2 Level AA** unless
the product has a stricter bar. Accessibility is a requirement built into every change, not a polish
step at the end; retrofitting costs far more and rarely catches everything.

This skill is the full process. Run the [accessibility checklist](../../references/accessibility-checklist.md)
alongside it for a quick pass. For visual polish and non-a11y UI states, pair with [[ui-craft]]. For
proving behavior in a running app, finish with [[browser-checks]].

## When to Use

- Building or changing any component, page, form, modal, or interactive widget
- Implementing custom controls (tabs, combobox, menu, carousel, data grid)
- Reviewing front-end work for accessibility before merge
- Fixing reported a11y issues, VPAT work, or preparing for an audit
- A design or copy change that affects structure, labels, contrast, or interaction

Skip as the primary skill for changes with no user-facing surface (pure backend, tooling). Still
apply if those changes affect auth flows, emails, or PDFs users receive.

## Process

Work in order. Later steps assume earlier foundations are solid.

### 1. Set the page foundation

Structure is free accessibility — get it right before styling.

- Use **one `<h1>` per view** and a logical heading order (`h1` → `h2` → `h3`, no skipped levels).
- Wrap major regions in landmarks: `<header>`, `<nav>`, `<main>`, `<footer>`. One `<main>` per page.
- Provide a **skip link** as the first focusable element: "Skip to main content" → `#main`.
- Set **`lang`** on `<html>` (and `lang` on inline passages in another language).
- Use real lists (`ul`/`ol`), tables (`table`/`th`/`td`), and forms (`form`, `fieldset`, `legend`)
  — not styled div stacks.
- Links go places; buttons do things. Never use `<a href="#">` or `<div onClick>` for actions.

```html
<!-- Prefer -->
<button type="button" aria-expanded="false">Menu</button>

<!-- Not -->
<div role="button" tabindex="0" onclick="...">Menu</div>
```

### 2. Prefer native semantics; use ARIA to fill gaps

The **first rule of ARIA**: if a native HTML element already gives the semantics and behavior you
need, use it. ARIA patches gaps; it does not fix bad markup.

Reach for ARIA when:

- Building a **composite widget** with no native equivalent (tabs, combobox, tree).
- **State or relationships** aren't exposed by the element alone (expanded, selected, described-by).
- **Live updates** need announcing (`aria-live`, `role="status"`, `role="alert"`).

Never:

- Put ARIA on an element that **contradicts** its role (`role="button"` on a link).
- Use ARIA as a substitute for a missing label or heading.
- Duplicate what the browser already exposes (`role="navigation"` on `<nav>` is redundant).

When building custom widgets, follow the **[WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)**
patterns for keyboard behavior, roles, and states — don't invent interaction models.

### 3. Make everything keyboard-operable

If you can't complete the flow with keyboard alone, it's not done.

- Every interactive control is **reachable** via Tab (or arrow keys inside composite widgets).
- **Focus is always visible** — never `outline: none` without a replacement that meets 3:1 contrast.
- **Tab order follows reading order.** Fix order with DOM structure, not positive `tabindex` values.
- **`tabindex="0"`** puts non-focusable elements in tab order; **`tabindex="-1"`** makes something
  programmatically focusable but not tabbable (error summaries, modal containers on open).
- **No keyboard traps** except intentional modal focus traps that restore focus on close.

Expected keys (implement or preserve natively):

| Pattern | Keys |
|---------|------|
| Button, link | Enter, Space (buttons); Enter (links) |
| Modal / menu | Esc closes; focus trapped inside modal |
| Tabs | Arrow keys move; Home/End jump |
| Combobox | Arrow keys open/navigate; type to filter |
| Radio group | Arrow keys move selection |

For SPAs: move focus to **`h1` or main landmark** on route change so screen-reader users know the
view changed. Don't rely on visual swap alone.

### 4. Name, describe, and expose state

Assistive tech reads the accessibility tree, not your CSS.

- **Every form control has a visible, associated label** — `<label for>` or wrapping label. Placeholder
  is not a label.
- **Icon-only buttons** need an accessible name: visible text, `aria-label`, or `aria-labelledby`.
  Decorative icons: `aria-hidden="true"`.
- **Images**: meaningful `alt` text, or `alt=""` if purely decorative. Complex charts need a text
  summary or long description.
- **Expose state in markup**, not just styling: `aria-expanded`, `aria-selected`, `aria-checked`,
  `aria-current`, `disabled`, `aria-disabled`, `aria-invalid`.
- **Group related controls** with `<fieldset>`/`<legend>` or `role="group"` + `aria-labelledby`.
- **Supplementary help** ties via `aria-describedby` (hint text, character count, format example).

```html
<input id="email" aria-describedby="email-hint email-error" aria-invalid="true" />
<p id="email-hint">We'll never share this.</p>
<p id="email-error" role="alert">Enter a valid email address.</p>
```

### 5. Announce dynamic changes

Visual updates that happen without navigation must be communicated.

- **Toasts / success messages**: `role="status"` or `aria-live="polite"`. Don't steal focus for
  non-critical confirmations.
- **Errors / destructive alerts**: `role="alert"` or `aria-live="assertive"`. Move focus to the
  **error summary** or first invalid field on submit.
- **Loading**: expose `aria-busy="true"` on the updating region; use `aria-live="polite"` for completion
  when content replaces a skeleton.
- **Infinite scroll / "load more"**: announce new content count or provide a visible, keyboard-accessible
  control — don't rely on scroll position alone.
- **Route changes in SPAs**: focus management (step 3) plus optional live region for page title change.

Avoid **over-announcement**: one live region per logical update, not on every keystroke.

### 6. Meet visual and motor needs

- **Contrast**: WCAG AA — 4.5:1 for normal text, 3:1 for large text (≥18pt / 14pt bold) and UI
  components plus their states (default, hover, focus, disabled).
- **Don't convey information by color alone** — add text, icon, pattern, or underline.
- **Reflow at 200% zoom** without horizontal scrolling (320 CSS px width equivalent).
- **Touch targets** at least 24×24 CSS px (WCAG 2.5.8); 44×44 is safer for primary actions.
- **No hover-only functionality** — equivalent keyboard/touch path must exist.
- **`prefers-reduced-motion`**: disable or shorten non-essential animation; keep essential feedback
  (focus ring, progress) without parallax, auto-play, or vestibular triggers.
- **Don't disable zoom** — no `user-scalable=no` or `maximum-scale=1`.

For layout and responsive behavior beyond a11y, see [[ui-craft]].

### 7. Handle forms accessibly

Forms are where most real-world a11y failures show up.

- Mark **required fields** in text (not color alone) and expose via `required` or `aria-required="true"`.
- Use appropriate **`autocomplete`** values so browsers and assistive tech can help.
- **Inline validation**: tie errors with `aria-describedby`; set `aria-invalid="true"` on the field.
- **On submit failure**: focus the **error summary** at the top (with `role="alert"` or `tabindex="-1"`)
  listing linked errors, then let the user jump to each field.
- **Don't clear the form** on error — preserve user input.
- **Time limits**: warn before expiry; offer extend or disable unless essential.

### 8. Tackle high-risk patterns deliberately

These fail often — implement to APG spec or use a battle-tested library.

| Pattern | Must-haves |
|---------|------------|
| **Modal / dialog** | Focus trap, Esc closes, `aria-modal="true"`, labelled by title, restore focus to trigger |
| **Disclosure / accordion** | `aria-expanded` on trigger; panel content in DOM or moved focus when opened |
| **Tabs** | `role="tablist"`, roving `tabindex`, `aria-selected`, keyboard arrows |
| **Combobox / autocomplete** | Listbox pairing, active descendant or roving focus, announce result count |
| **Data table** | `<th scope>`, captions or `aria-label`, sort state exposed |
| **Carousel** | Pause control, no auto-advance (or respect reduced motion), slides labelled |
| **Drag and drop** | Keyboard alternative to reorder/select — never the only path |

If you use a component library, verify it implements these — many "accessible" components don't.

### 9. Verify with multiple methods

Automated tools catch roughly **30–50%** of issues. "Passes axe" is necessary, not sufficient.

**Automated** (run in CI when possible):

- axe DevTools, Lighthouse accessibility audit, or eslint-plugin-jsx-a11y
- Fix all errors; triage warnings — don't ignore "needs review" without a human check

**Manual — do every time**:

1. **Keyboard-only pass**: Tab through the entire flow. Can you do everything? Is focus visible?
   Any traps? Does Esc close overlays?
2. **Screen reader spot-check**: VoiceOver (macOS/iOS) or NVDA (Windows). Navigate by headings and
   landmarks. Do controls announce name, role, and state? Are live regions working?
3. **Zoom to 200%**: Content readable, no clipped text, no horizontal scroll.
4. **Reduced motion**: Enable OS setting; confirm animations respect it.
5. **200% + keyboard**: combined check catches focus and reflow issues together.

Document **known gaps** if you ship with them — don't pretend untested areas are fine.

## Common Rationalizations

- "We'll add accessibility later." — Retrofitting costs far more, breaks layouts, and usually ships
  incomplete.
- "A div with onClick is fine." — You lose keyboard, focus, and AT semantics you'd rebuild badly.
- "Most of our users don't need it." — ~15–20% of people have a disability; situational limits
  (sun glare, broken arm, noisy room) affect everyone. Legal risk exists in many jurisdictions.
- "It passes the automated checker." — Automation misses focus order, meaningful labels, keyboard
  traps, and whether announcements actually help.
- "We'll use ARIA." — ARIA on broken markup makes things worse, not better.
- "Our design system handles it." — Libraries ship defaults; you still own composition, labels, and
  focus in your feature.
- "It's an internal tool." — Employees have disabilities too; internal tools often become external.

## Red Flags

- Clickable `<div>`/`<span>` instead of `<button>` or `<a>`
- No visible focus indicator; `outline: none` without replacement
- Positive `tabindex` values; tab order that jumps illogically; keyboard traps
- Inputs without labels; icon buttons with no accessible name; missing or junk `alt` text
- Placeholder used as the only label; errors shown by color alone
- `aria-hidden` on focusable or interactive content
- Modals that don't trap/restore focus or close on Esc
- Auto-playing media, carousels, or motion with no pause and no reduced-motion fallback
- Custom widgets with no keyboard model (sliders, drag-drop, menus)
- Dynamic updates with no live region or focus move — SR users miss them entirely
- Disabled zoom; contrast below AA; information conveyed by color alone
- Route changes with no focus management in SPAs

## Verification

- [ ] Page has logical landmarks, one `h1`, ordered headings, skip link, and correct `lang`
- [ ] Native elements used; ARIA only fills real gaps; custom widgets follow APG patterns
- [ ] Full keyboard path works with visible focus, correct tab order, no unintended traps
- [ ] Every control named; state exposed in markup; images have correct `alt`
- [ ] Dynamic updates announced appropriately; form errors tied to fields with sensible focus on submit
- [ ] Contrast meets AA; not color-only; 200% zoom works; reduced motion respected; targets sized
- [ ] High-risk patterns (modal, tabs, combobox, table, carousel) implemented deliberately
- [ ] Automated check (axe/Lighthouse) run; keyboard + screen reader spot-check completed
- [ ] Known gaps documented if anything was intentionally deferred
