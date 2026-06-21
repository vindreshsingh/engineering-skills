---
name: mobile-patterns
description: Applies mobile app best practices — navigation, offline, push, performance, and platform conventions. Use when building or reviewing React Native, Flutter, or native iOS/Android features.
---

# Mobile Patterns

Mobile is not a narrow website — **offline**, **battery**, **app store rules**, and **platform conventions**
matter. This skill covers cross-platform mobile delivery; web-specific UI stays in [[ui-craft]] and
[[react-patterns]].

Pairs with [[ux-design]] for flows, [[test-first]] / [[e2e-testing]] for device tests,
[[perf-budget]] for startup and jank, [[hardening]] for secure storage, and [[launch-readiness]] for
store releases.

## When to Use

- Building React Native, Flutter, or native mobile features
- Navigation, deep links, or app state issues
- Offline/sync behavior
- Push notifications
- App store submission prep
- Mobile performance (startup, list scroll, memory)

Skip for responsive web-only — use [[ui-craft]] and [[react-patterns]].

## Process

### 1. Platform scope

Document:

- **Framework** — RN, Flutter, Swift, Kotlin
- **Min OS versions** — iOS / Android
- **Offline requirement** — read-only vs read-write offline

### 2. Navigation architecture

- One primary navigation pattern (tabs, stack, drawer — not all three)
- Deep links map to screens with auth guard
- Back behavior matches platform (Android back, iOS swipe)
- Modal vs push — modals for short tasks only

### 3. State and data

- API client with timeout/retry ([[resilience]])
- Optimistic UI where safe; rollback on failure
- Secure token storage (Keychain/Keystore — never AsyncStorage for secrets)
- Cache strategy for offline read ([[caching-strategy]])

### 4. Performance

| Area | Target |
|------|--------|
| Cold start | <2s to interactive |
| List scroll | 60fps; virtualized lists |
| Images | Sized, cached, WebP where supported |
| Bundle | Monitor size per release |

Profile on **real device**, not simulator only.

### 5. Push and permissions

- Request permission in context — after user sees value
- Handle denied permission gracefully
- Payload → deep link to relevant screen
- Unsubscribe / notification settings in app

### 6. Release checklist

- [ ] Version/build number bumped
- [ ] Store screenshots and metadata ([[technical-writing]])
- [ ] Privacy nutrition labels / Data safety form accurate
- [ ] Crash reporting wired ([[observability]])
- [ ] Staged rollout (Play %) / TestFlight before 100%

## Common Rationalizations

- **"Mobile web is enough"** — Push, offline, and store discovery need native/hybrid.
- **"Works on my iPhone"** — Test Android mid-range and small screens.
- **"We’ll add offline later"** — Network assumptions break on subway and flights.

## Red Flags

- Secrets in plain storage
- WebView for entire app (store rejection risk)
- No error state on failed API
- Lists without virtualization (1000+ items)
- Push permission on first launch before value

## Verification

- [ ] Navigation and deep links documented
- [ ] Token storage uses secure platform APIs
- [ ] Offline behavior defined and tested
- [ ] Performance checked on real device
- [ ] Store release checklist passed for ship
