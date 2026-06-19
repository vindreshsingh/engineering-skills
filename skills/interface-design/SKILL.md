---
name: interface-design
description: Designs clear, stable contracts for APIs, modules, and library boundaries. Use when adding or changing an endpoint, public function, schema, or any interface other code depends on.
---

# Interface Design

An interface is a promise to its callers. Design it for the people calling it, make the easy thing
the correct thing, and treat every published contract as expensive to change.

## When to Use

- Adding or changing an HTTP endpoint, RPC, or public function signature
- Defining a data schema, event payload, or config shape
- Drawing a boundary between modules or services
- Publishing anything other code (or other teams) will depend on

## Process

1. **Design from the caller in.** Write the call site you wish existed first, then build to it. The
   common case should be short and obvious.
2. **Name for intent.** Names should say what and why, in the domain's language, consistently across
   the surface.
3. **Make illegal states unrepresentable.** Prefer types and required fields that prevent misuse over
   docs that warn against it.
4. **Be explicit about errors.** Define how failures are signaled and what each means; don't return
   ambiguous nulls or swallow errors.
5. **Decide what's public vs. internal.** Expose the minimum; the smaller the surface, the easier it
   is to keep stable.
6. **Plan for evolution.** Additive changes over breaking ones; version when you must break; keep
   defaults backward-compatible.
7. **Keep it consistent** with the conventions already in the codebase — pagination, naming, error
   shapes, units.

## Common Rationalizations

- "Callers can read the code." — A good interface needs far less reading; design saves everyone time.
- "We'll clean up the API later." — Once published, it has callers and cleanup becomes a breaking change.
- "One flexible function covers all cases." — Over-general interfaces are hard to use correctly and to evolve.
- "Errors can just be nulls." — Ambiguous returns push failure handling onto every caller, inconsistently.

## Red Flags

- The simplest use case requires many arguments or boilerplate
- Boolean/positional parameters whose meaning isn't clear at the call site
- Inconsistent naming, error shapes, or units across the surface
- Internal details leaking into the public type
- No story for how the contract changes without breaking callers

## Verification

- [ ] The common call site is short and self-explanatory
- [ ] Names convey intent and are consistent
- [ ] Types/required fields make misuse hard; errors are explicit
- [ ] Public surface is minimal; internals stay internal
- [ ] There's a backward-compatible path for future change
- [ ] Conventions match the surrounding codebase
