---
name: browser-checks
description: Verifies web changes by actually exercising them in a browser with devtools. Use after a UI or front-end change to confirm it renders, behaves, and logs cleanly — instead of assuming from the code.
---

# Browser Checks

Code that looks right and code that works are different claims. For anything the browser renders or
runs, prove it by driving the real page: load it, interact, watch the console and network.

## When to Use

- After any change observable in the browser (UI, routing, data fetching, forms)
- A bug report that only reproduces in the running app
- Before claiming a front-end change is done
- Diagnosing console errors, failed requests, or layout/interaction issues

Skip it for changes the browser can't exercise (pure types, tooling, unrelated backend logic).

## Process

1. **Run the app and open the affected view.** Reload after edits unless hot-reload is active.
2. **Check the console** for errors and warnings — including ones that predate your change but now matter.
3. **Check the network panel** for failed, slow, duplicated, or unexpected requests and payloads.
4. **Exercise the actual interaction** — click, type, submit, navigate — rather than eyeballing the
   static render. Then confirm the resulting state.
5. **Test the states**: loading, empty, error, and the unhappy paths, not just success.
6. **Check responsive and theme** if layout or styling changed (small/large viewport, dark mode).
7. **Capture proof** — a screenshot, the network entry, or the log line — and share it instead of
   "should work."

## Common Rationalizations

- "The code is obviously correct." — The browser is the only authority on what the browser does.
- "It compiled, so it works." — Compilation says nothing about runtime, layout, or network behavior.
- "I'll let QA find it." — The fastest, cheapest place to catch it is right after you change it.
- "I checked the happy path." — Users find the empty and error states first.

## Red Flags

- Marking a UI change done without ever loading it
- Console errors present but unread
- Failed/duplicate requests no one looked at
- Only the success path was tried
- "Works on my machine" with no captured evidence

## Verification

- [ ] The change was exercised in a running browser, not assumed
- [ ] Console is clean (or remaining warnings are understood)
- [ ] Network requests succeed and look correct
- [ ] Loading/empty/error states were checked
- [ ] Responsive/theme verified when relevant
- [ ] Proof (screenshot/log/network) captured and shared
