---
name: contract-testing
description: Catches breaking changes between services before they ship, by testing the contract each consumer actually depends on instead of spinning up the whole system. Use when services deploy independently, when a provider API change could break a consumer, or when end-to-end integration tests are too slow and flaky to guard every service boundary.
---

# Contract Testing

Once services deploy independently, the dangerous change is invisible from inside any single repo: a
provider renames a field, drops it from a response, or tightens validation — its own tests pass, it
ships, and a *consumer* breaks in production. End-to-end tests can catch this but are slow, flaky, and
require the whole system running. Contract testing closes the gap cheaply: capture **exactly what each
consumer depends on** as a contract, and verify the provider still honors it — on each side's own CI,
without deploying the other.

The key idea is **consumer-driven**: the contract is defined by what consumers *actually use*, not by
the provider's full spec. A provider is free to change anything no consumer relies on, and is blocked
the moment it breaks something one does. This sits between [[interface-design]] (designing the
contract) and [[migration-path]] (rolling out a deliberate breaking change); it's the automated guard
that an *accidental* break can't slip through.

## When to Use

- **Services deploy independently** (microservices, a gateway + backends, a public API + clients)
- A provider API change *could* break a consumer and you want CI to catch it, not production
- **E2E integration tests are too slow/flaky** to guard every boundary on every commit
- Splitting a monolith into services — each new seam needs a contract ([[migration-path]])
- A team owns an API that other teams/clients consume and you need a safe change signal

**Skip** when:
- It's a **single deployable** — internal function/module boundaries are covered by [[test-first]] and
  [[interface-design]], not contract tests
- The dependency is a **stable third-party API you don't control** — you can't make them verify your
  contract; pin versions and test your adapter ([[dependency-hygiene]], [[resilience]]) instead
- There's exactly one consumer and one provider in the same repo/deploy — a normal integration test is
  simpler

**Not a substitute for** [[e2e-testing]] (which proves the whole journey works) or [[test-first]]
(which proves each service's logic) — contract testing proves the **boundary** holds; keep a thin layer
of E2E for the critical path on top.

## Process

### 1. Identify the contract boundaries
List the **consumer→provider** relationships that cross a deploy boundary (service→service,
client→API, event producer→consumer). Each pair is a contract. Synchronous (HTTP/gRPC) and asynchronous
(messages/events) boundaries both need one — don't forget the event schemas.

### 2. Derive the contract from what the consumer actually uses
Write the contract from the **consumer's** real usage: the request it sends and the **specific fields it
reads** from the response (not the whole payload). This is what makes it consumer-driven — the provider
only owes what's actually depended on. Capturing the full provider schema instead defeats the point and
makes every provider change a false break.

### 3. Verify both sides against the same contract
Two checks, each runnable on that side's own CI without the other service live:
- **Consumer side:** run the consumer against a **mock/stub built from the contract** — proves the
  consumer works against what it claims to need.
- **Provider side:** replay the contract's expectations against the **real provider** — proves the
  provider still satisfies every consumer's contract.
A contract only one side checks is decoration; the value is both sides bound to one artifact.

### 4. Share contracts so the provider knows its consumers
The provider must verify against **every** consumer's contract, so contracts need a shared home — a
broker, a versioned repo, or published artifacts. A provider that can't see its consumers' contracts
can't be stopped from breaking them. Tag contracts by environment/version so you know which are live.

### 5. Wire verification into CI as a release gate
Run consumer and provider verification in [[pipeline-ops]] CI. The provider's pipeline **fails the
build** if a change violates a live consumer contract — that's the whole point: the break is caught at
PR time, not at deploy. Gate merges on it for the services that have contracts.

### 6. Distinguish a deliberate breaking change from an accident
A failed contract verification is either a bug (fix it) **or** an intended breaking change. For the
latter, this is where contract testing hands off to [[migration-path]]: version the contract, support
old + new during the transition, coordinate consumer upgrades, and only drop the old contract when no
live consumer uses it. Contract tests tell you **when it's safe** to remove the old shape.

### 7. Keep contracts current and pruned
A contract for a consumer that no longer exists is noise that blocks valid provider changes. When a
consumer is retired, remove its contract; when usage changes, regenerate from real usage (step 2). Treat
the contract set like any inventory — owned, current, pruned ([[simplify]]).

## Common Rationalizations

- "Our E2E tests already cover this." — E2E is slow, flaky, and needs everything live; it can't run on the provider's PR before deploy. Contract tests can.
- "The provider's own tests pass." — Provider tests check what the provider expects to return, not what consumers actually depend on; the gap is exactly the break.
- "Just capture the whole provider schema." — Then every harmless provider change is a false failure; derive the contract from real consumer usage.
- "Only the consumer needs to test it." — A contract the provider never verifies can't stop the provider from breaking it; both sides bind to it.
- "We'll find breaks in staging." — Staging is after merge and after both deploy; the point is to fail the provider's build at PR time.
- "Contracts are extra maintenance." — Far less than debugging a cross-service production break with no boundary signal.

## Red Flags

- Independent services with only E2E (or no) tests guarding their boundaries
- Contracts capturing the full provider schema instead of consumer-used fields
- A contract verified on only one side
- Provider CI that can't see, or doesn't run against, its consumers' contracts
- Breaking changes shipped without versioning the contract or coordinating consumers ([[migration-path]])
- Stale contracts for retired consumers blocking valid provider changes
- Event/message boundaries with no schema contract (only HTTP covered)

## Verification

- [ ] Cross-deploy consumer→provider boundaries identified (sync **and** async/events)
- [ ] Each contract derived from the consumer's *actual* usage, not the full provider schema
- [ ] Both sides verified against the same contract — consumer vs a stub, provider vs the real contract
- [ ] Contracts shared so the provider verifies against every live consumer
- [ ] Verification runs in CI and **fails the provider build** on a contract break ([[pipeline-ops]])
- [ ] Deliberate breaks routed through [[migration-path]] (versioned, dual-support, coordinated)
- [ ] Stale contracts pruned; a thin [[e2e-testing]] layer kept for the critical journey
