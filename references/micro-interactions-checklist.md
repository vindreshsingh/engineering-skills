# Micro-Interactions Checklist

Run alongside the [[micro-interactions]] skill when adding click feedback or view transitions.

## Intent & Accessibility

- [ ] Each animation has a stated purpose (confirm press, orient navigation, show progress)
- [ ] `prefers-reduced-motion: reduce` handled — motion off or minimal cross-fade only
- [ ] State not conveyed by motion alone (text, color, icon, or aria-live also present)
- [ ] Keyboard Enter/Space gets the same feedback as click

## Click / Tap Feedback

- [ ] Press state on `:active` or explicit pressed attribute — visible within ~150ms
- [ ] Only `transform` and/or `opacity` animated (not width, height, margin, box-shadow spread)
- [ ] Hit target ≥44×44px after any scale transform
- [ ] Hover styles wrapped in `@media (hover: hover)` for touch devices
- [ ] Click handler does not `await` animation before executing action
- [ ] Loading/disabled state after submit handled ([[ui-craft]])

## View Transitions

- [ ] One strategy chosen (View Transitions API, framework support, or CSS enter/exit)
- [ ] Fallback when `document.startViewTransition` unavailable — instant swap OK
- [ ] `view-transition-name` only on elements that should morph; unique per shared element
- [ ] Duration 200–350ms for route/modal; no UI chrome >500ms
- [ ] Focus managed after transition ([[accessibility]])
- [ ] In-flight transition cancelled or replaced on rapid re-navigation

## React / Performance

- [ ] `'use client'` only on interactive leaves or single transition wrapper ([[react-patterns]])
- [ ] Not animating large lists on mount (cap stagger or animate container only)
- [ ] No heavy motion library added without bundle check ([[perf-budget]])
- [ ] Verified on mobile, reduced motion, and throttled CPU ([[browser-checks]])
