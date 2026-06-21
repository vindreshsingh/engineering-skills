---
name: browser-checks
description: Verifies web changes by exercising them in a real browser with DevTools — console, network, interaction, states, and layout. Use after any UI or front-end change, when debugging browser-only bugs, or before claiming a web change is done.
---

# Browser Checks

Code that looks right and code that works in the browser are different claims. Compilation, unit
tests, and static review cannot prove runtime behavior, layout, network timing, or interaction. For
anything the browser renders or runs, **prove it** by driving the real page: load it, interact,
watch the console and network, and capture evidence.

Run the [browser checks checklist](../../references/browser-checks-checklist.md) alongside this
process. For accessibility verification in the browser, finish with [[accessibility]]. For systematic
debugging when something fails, switch to [[fault-recovery]]. For UI quality beyond verification,
see [[ui-craft]].

## When to Use

- After any change observable in the browser (UI, routing, data fetching, forms, auth flows)
- Before marking a front-end task or PR as done
- A bug report that only reproduces in the running app
- Diagnosing console errors, failed requests, layout breakage, or interaction issues
- Validating a fix — confirm the failure is gone, not just that the code changed

Skip as the primary skill when the change has no browser surface (pure types, CLI tooling, unrelated
backend-only logic with no UI impact).

## Process

Work in order. Stop and diagnose before moving on if something is broken — a red console often
invalidates everything else.

### 1. Run the app and reach the affected view

- Start the app the way users/devs actually run it (local dev server, preview deploy, staging).
- **Hard reload** after edits unless hot-module reload is confirmed active for your change.
- Open DevTools **before** interacting — console history clears on navigation unless "Preserve log"
  is enabled.
- Navigate to the **exact route, role, and feature flag state** the change affects. A fix verified
  only as admin on `/dashboard` may still break a guest on `/`.
- If auth or cookies matter, note whether you're incognito, logged in, or impersonating — state
  changes what you see.

### 2. Check the console first

The console is the app's voice. Read it before clicking anything else.

- **Errors (red)**: treat as blockers unless you can prove they're pre-existing and unrelated.
- **Warnings (yellow)**: triage — hydration mismatches, deprecated APIs, and CORS warnings often
  indicate real bugs.
- Enable **"Preserve log"** when testing flows that navigate or reload.
- Watch for framework-specific signals:
  - **React**: hydration errors, key warnings, "Cannot update during render"
  - **Next.js**: routing errors, RSC boundary issues, failed server actions
- Click through to **source** when a stack trace appears — confirm the failing line is in your
  change or a dependency you touched.

If the console isn't clean, fix or explain before claiming done.

### 3. Inspect the network panel

What the UI shows and what the server returned are often different stories.

- Filter by **Fetch/XHR** (or your app's request type) to cut noise.
- Look for:
  - **Failed requests** (4xx/5xx, CORS blocks, cancelled)
  - **Unexpected duplicates** — same endpoint fired twice on mount
  - **Waterfalls** — serial requests that could run in parallel
  - **Wrong payloads** — missing fields, stale cache, error bodies swallowed by the UI
  - **Slow calls** on the critical path (rough signal; deep perf work uses [[perf-budget]])
- Click a request: verify **status, response body, and timing**. Does the UI match what came back?
- For mutations (POST/PUT/PATCH/DELETE): confirm the **follow-up read** reflects the change.
- Throttle to **Slow 3G** once for loading-state and timeout behavior if the change touches data
  fetching or skeletons.

### 4. Exercise the actual interaction

Don't eyeball the static render — drive the flow a user would.

- Perform the **primary action** your change enables or fixes (click, type, submit, drag, select).
- Confirm **resulting state**: DOM update, URL change, toast, redirect, persisted data on refresh.
- Test **keyboard** for interactive changes — Tab to controls, Enter/Space to activate, Esc to
  close overlays. Quick keyboard pass catches issues visual review misses.
- Test **edge inputs**: empty submit, very long text, special characters, paste, rapid double-click.
- If the change touches navigation: test **browser back/forward**, deep link (paste URL in new tab),
  and refresh mid-flow.

### 5. Test all visible states

The happy path is the easy 60%. Users hit the rest first.

| State | What to confirm |
|-------|-----------------|
| **Loading** | Skeleton/spinner shows; no flash of wrong content; no layout jump when data arrives |
| **Empty** | Meaningful empty message and next action — not a blank screen |
| **Error** | Error is visible, readable, recoverable; failed network doesn't leave a broken half-UI |
| **Partial** | Pagination, truncated lists, optimistic updates behave correctly |
| **Overflow** | Long names, large numbers, many tags — layout doesn't break |

Simulate failures when relevant: DevTools **offline**, block a request, or use a bad API response to
confirm error handling.

### 6. Check responsive layout and theme

If layout, styling, or global CSS changed:

- **Small viewport** (~375px): no horizontal scroll, touch targets usable, nav/menus work
- **Large viewport**: content doesn't stretch broken; grids reflow sensibly
- **Dark mode / theme toggle** if the product supports it — contrast and borders still read
- **200% zoom** quick check if the change affects text or form layout (pairs with [[accessibility]])

Rotate or resize once; you don't need every device, but one narrow and one wide catches most regressions.

### 7. Spot-check accessibility in the browser

Full a11y is [[accessibility]]; in browser-checks, do a fast sanity pass:

- Tab through the changed flow — focus visible, order logical, no traps
- Run **axe DevTools** or Lighthouse accessibility on the affected page — fix new violations
- If you changed a modal, dropdown, or form: confirm Esc, labels, and error messages in the live DOM

### 8. Capture proof

"Should work" is not evidence. Capture something shareable:

- **Screenshot** or short screen recording of the working flow
- **Console screenshot** if you fixed an error (before/after)
- **Network entry** — URL, status, relevant response snippet — for data bugs
- **Note the environment**: URL, browser, viewport, user role, commit or branch

Attach proof in the PR or ticket so reviewers and future-you can trust the claim.

### 9. When something fails — diagnose, don't guess

If the check surfaces a bug:

1. **Reproduce reliably** — exact steps, URL, role, input.
2. **Read the error and stack** before changing code.
3. **Change one thing at a time** and re-run the browser check.
4. Follow [[fault-recovery]] if the cause isn't obvious after one focused attempt.

## Common Rationalizations

- "The code is obviously correct." — The browser is the only authority on what the browser does.
- "It compiled, so it works." — Compilation says nothing about runtime, layout, or network behavior.
- "I'll let QA find it." — The cheapest place to catch it is immediately after your change.
- "I checked the happy path." — Empty, error, and slow-network states break in production first.
- "No console errors on my machine." — Wrong route, role, or stale cache can hide the bug; verify
  the exact scenario.
- "The test passed." — Unit tests don't render CSS, run JavaScript in a real engine, or hit your
  actual API.
- "I'll verify after the PR." — Reviewers can't merge confidence; they merge evidence.

## Red Flags

- Marking a UI change done without ever loading it in a browser
- Console errors present but unread or dismissed as "unrelated"
- Failed, duplicate, or slow network requests no one inspected
- Only the success path tried; loading/empty/error never opened
- Mutation verified in UI but not confirmed in network response or after refresh
- Responsive or theme breakage ignored ("looks fine on my laptop")
- "Works on my machine" with no screenshot, recording, or log
- Fixing symptoms (hiding an error) without confirming root behavior

## Verification

- [ ] App running; affected view reached with correct auth, route, and feature flags
- [ ] Console checked with Preserve log; errors fixed or explained; warnings triaged
- [ ] Network inspected — failures, duplicates, payloads, and mutation follow-ups verified
- [ ] Primary interaction exercised; keyboard path spot-checked; edge inputs tried
- [ ] Loading, empty, error, and overflow states confirmed (failure simulated if relevant)
- [ ] Responsive and theme checked when layout/styling changed
- [ ] Quick a11y pass — tab order and automated scan on changed UI
- [ ] Proof captured and shared (screenshot, recording, or network/console evidence)
