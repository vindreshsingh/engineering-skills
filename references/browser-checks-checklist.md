# Browser Checks Checklist

Quick reference to run alongside the [[browser-checks]] skill. Prove the change in a real browser —
don't assume from code or tests alone.

## Setup

- [ ] App started the way devs/users run it (local, preview, staging).
- [ ] Hard reload after edits (or HMR confirmed active).
- [ ] DevTools open; **Preserve log** enabled for multi-step flows.
- [ ] Correct route, auth role, and feature flags for the scenario under test.

## Console

- [ ] All errors read and resolved (or confirmed pre-existing and unrelated).
- [ ] Warnings triaged — hydration, deprecation, CORS not ignored blindly.
- [ ] Stack traces traced to source in changed code where applicable.

## Network

- [ ] No failed requests (4xx/5xx, CORS, cancelled) on the happy path.
- [ ] No unexpected duplicate calls on mount or navigation.
- [ ] Request/response payloads match what the UI shows.
- [ ] Mutations verified — follow-up read or refresh shows persisted change.
- [ ] Slow 3G throttle used once if loading states or fetching changed.

## Interaction

- [ ] Primary user action performed — not just static visual review.
- [ ] Resulting state confirmed (DOM, URL, toast, redirect, persistence).
- [ ] Keyboard path spot-checked (Tab, Enter/Space, Esc for overlays).
- [ ] Edge inputs tried — empty submit, long text, special chars, double-click.
- [ ] Back/forward, deep link, and refresh tested if navigation changed.

## States

- [ ] Loading — skeleton/spinner, no wrong-content flash, no layout jump.
- [ ] Empty — meaningful message and action, not blank screen.
- [ ] Error — visible, readable, recoverable; simulated failure if relevant.
- [ ] Overflow — long content doesn't break layout.

## Layout & theme

- [ ] Small viewport (~375px) — no horizontal scroll, nav/menus work.
- [ ] Large viewport — layout doesn't break or over-stretch.
- [ ] Dark mode / theme checked if applicable.
- [ ] 200% zoom quick check if forms or text layout changed.

## Accessibility (quick pass)

- [ ] Tab through changed flow — focus visible, logical order, no traps.
- [ ] axe DevTools or Lighthouse a11y scan — new violations fixed.
- [ ] Modals/forms — Esc, labels, live errors work in live DOM.

## Proof

- [ ] Screenshot, recording, or console/network capture attached.
- [ ] Environment noted — URL, browser, viewport, role, branch/commit.
