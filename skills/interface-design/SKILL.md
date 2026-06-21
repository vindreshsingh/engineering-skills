---
name: interface-design
description: Designs clear, stable contracts for APIs, modules, events, and library boundaries. Use when adding or changing an endpoint, public function, schema, config, or any surface other code or teams depend on.
---

# Interface Design

An interface is a **promise to its callers**. Design for the people (and services) calling it — make
the easy thing the correct thing, and treat every published contract as **expensive to change**.
Once shipped, unknown consumers depend on shape, semantics, and error behavior; breaking them is a
[[migration-path]], not a quick edit.

Good interfaces are **small, explicit, consistent, and evolvable**. Bad interfaces leak internals,
overload with options, or fail silently — every caller handles errors differently forever.

Pairs with [[spec-first]] for requirements before contracts, [[migration-path]] when changing live
surfaces, [[hardening]] at trust boundaries, [[resilience]] for timeouts/idempotency on network
contracts, [[data-modeling]] when the API exposes persistence shape, and [[test-first]] / contract
tests to lock the promise.

## When to Use

- Adding or changing an HTTP endpoint, RPC method, or GraphQL field
- Defining a **public** function, class, or module export others import
- Designing event/message payloads, webhook bodies, or queue schemas
- Config or feature-flag shapes shared across services
- Drawing a boundary between modules, services, or teams
- LLM tool/function schemas ([[llm-feature-engineering]])
- Reviewing a PR that changes a public contract

Skip for purely internal helpers with no external callers — still apply if the helper is likely to
become public. Skip redesigning published APIs without a migration plan.

## Process

Work in order. Know callers and constraints before naming fields.

### 1. Identify callers and constraints

Before designing the shape:

| Question | Why |
|----------|-----|
| Who calls this? (frontend, other service, script, model tool) | Different needs — sync vs async, human vs machine |
| What's the common case? | Optimize the default path |
| What's rare but required? | Don't distort common case for edge |
| Sync or async? | Timeouts, polling, webhooks, events |
| Idempotency needed? | Retries, duplicate delivery ([[resilience]]) |
| Auth / tenancy? | Scoping in contract ([[hardening]]) |
| Existing conventions? | Match pagination, errors, naming in codebase |

Write the **call site you wish existed** before implementing the provider.

```typescript
// Design target — common case is obvious
const order = await orders.create({ cartId, idempotencyKey });

// Not — caller must know magic
await api.post('/order', { c: cartId, type: 1, flags: 0 });
```

### 2. Design from the caller in

**Caller-first** beats implementer-first:

1. Sketch happy-path usage in the caller's language.
2. Sketch error handling — what does the caller do on failure?
3. Implement the provider to match — don't export whatever was easiest internally.

The **common case** should be short, with sensible defaults. Rare options go in optional objects —
not positional boolean explosion.

```typescript
// Prefer optional config object
searchProducts({ query, filters: { inStock: true } });

// Not boolean positional
searchProducts(query, true, false, null, 20);
```

If the simplest use case needs five arguments and a comment — redesign.

### 3. Name for intent — domain language, consistently

Names are part of the contract:

- **Resources** — nouns: `Order`, `Cart`, `PaymentIntent`
- **Actions** — verbs on resources: `createOrder`, `cancelSubscription` — or HTTP verbs on REST paths
- **Fields** — `createdAt` not `timestamp1`; `emailAddress` not `email` if ambiguous in context
- **Units explicit** — `amountCents`, `durationMs`, `weightKg` — not bare `amount`
- **Booleans** — `isActive`, `hasVerifiedEmail` — not `active` (ambiguous type)

Match **existing codebase conventions** — don't invent a parallel error or pagination style.

Avoid **leaking implementation** — `RedisCacheKey`, `DbRow`, `InternalId` in public API.

### 4. Make illegal states unrepresentable

Types and schemas beat documentation warnings:

- **Enums / unions** for fixed sets — `status: 'pending' | 'paid'` not `string`
- **Required vs optional** — don't make everything optional "for flexibility"
- **Separate types** for create vs update vs read — create omits `id`; update may partial
- **Branded IDs** — `OrderId` vs `UserId` — prevent cross-entity mistakes at compile time
- **Reject unknown fields** on input when contract is strict ([[hardening]])

```json
// Create — no id, required cartId
{ "cartId": "...", "couponCode": "SAVE10" }

// Not one blob where everything is optional
{ "id": null, "cartId": null, "data": { ... } }
```

Validation at the boundary ([[hardening]]) — schema, OpenAPI, zod, protobuf — enforces the contract.

### 5. Errors — explicit, actionable, consistent

Ambiguous failure (`null`, `false`, empty 200) forces every caller to guess.

**Define:**

- **Error shape** — stable across API: code, message, details, request id
- **HTTP mapping** — 400 validation, 401 unauthenticated, 403 forbidden, 404 not found, 409 conflict,
  429 rate limit, 5xx server
- **Machine-readable codes** — `CART_EMPTY`, `PAYMENT_DECLINED` — not only English prose
- **What caller should do** — retryable vs fix input vs contact support

```json
{
  "error": {
    "code": "CART_EMPTY",
    "message": "Add items before checkout",
    "requestId": "req_abc",
    "retryable": false
  }
}
```

**Don't** leak stack traces, SQL, or internal ids to clients ([[hardening]]). Log details server-side
([[observability]]).

For libraries: `Result<T, E>`, typed exceptions, or error codes — not mixed null and throw without
documented rules.

### 6. Minimal public surface

**Expose the minimum** that callers need:

| Public | Internal |
|--------|----------|
| Stable functions/types exported from package entry | Helpers, adapters, DB row mappers |
| OpenAPI-documented routes | Handler private methods |
| Event payload schema | Full domain entity with 40 fields |

Every public symbol is a **compatibility commitment**. Prefer:

- Small facades over exposing whole modules
- `internal` / package-private / non-exported by default
- Composition — caller gets `OrderSummary`, not raw `OrderRow`

If callers need internals, the interface is wrong — fix the surface, don't make everything public.

### 7. Consistency across the system

Interfaces feel "designed" when patterns repeat:

| Pattern | Pick one per API |
|---------|------------------|
| **Pagination** | cursor + `nextCursor` vs `page` + `total` |
| **Timestamps** | ISO-8601 UTC strings vs epoch ms — document |
| **IDs** | string uuid vs int — consistent |
| **Sorting/filtering** | `sort=-createdAt`, filter query syntax |
| **Bulk operations** | batch endpoint shape, partial failure reporting |
| **Versioning** | URL prefix `/v2`, header, or additive-only |

New endpoints copy the **existing** pattern — not a third pagination style.

### 8. HTTP and RPC specifics

**REST-ish conventions** (adapt to your stack):

- Resources as paths — `POST /orders`, `GET /orders/{id}`
- **Idempotent** `PUT`/`DELETE` where appropriate; `POST` creates
- **Idempotency-Key** header on creates/payments ([[resilience]])
- **202 Accepted** + job id for async work; poll or webhook for result

**GraphQL / RPC:** same discipline — typed inputs, explicit errors, don't expose entire DB.

**Query design:**

- Lists filtered and paginated — never unbounded ([[data-modeling]])
- Expansion/include patterns documented — `?include=lineItems`

**Versioning when you must break** ([[migration-path]]):

- Prefer **additive** changes — new optional fields, new endpoints
- Deprecate old fields with timeline — don't remove until usage zero
- New major version only when coexistence required

### 9. Events, webhooks, and async contracts

Messages are interfaces too — often harder to change:

- **Schema version** in envelope — `eventType`, `schemaVersion`, `payload`
- **Additive evolution** — new optional fields; consumers ignore unknown
- **Idempotent consumers** — duplicate delivery assumed ([[resilience]])
- Webhook **signatures** documented ([[hardening]])
- Dead-letter and replay story for poison messages

Don't publish full internal entity as event — publish **what downstream needs**, stable and small.

### 10. Plan evolution before you ship

Every public contract needs a **change story**:

| Change type | Approach |
|-------------|----------|
| New optional response field | Safe — add |
| New required response field | Breaking for strict clients — version or optional first |
| Rename field | Dual-field period ([[migration-path]]) |
| Remove field | Deprecate → metric zero → remove |
| Behavior change | Feature flag, version bump, or new endpoint |

Document in OpenAPI/README/changelog. Contract tests catch accidental breaks ([[test-first]]).

Record significant boundary choices in [[decision-docs]] when teams will relitigate.

### 11. Security and resilience at the boundary

Interface design overlaps [[hardening]] and [[resilience]]:

- Authn/authz **documented** — which roles, which scopes; 403 vs 404 policy for hidden resources
- Input size limits in contract — max array length, string length
- Timeouts documented for clients — server SLA hints
- Rate limits — headers `Retry-After` on 429
- Sensitive fields — never in URLs; mark PII in schema docs

Server implements validation; client docs say what's allowed — both sides align.

### 12. Document and test the contract

- **OpenAPI / protobuf / JSON Schema** — generated or hand — single source of truth
- **Examples** for happy path and common errors
- **Contract tests** — consumer-driven or provider-verified — run in CI ([[pipeline-ops]])
- **Changelog** on breaking or behavioral changes

If docs drift from code, callers trust wrong shapes — verify generated docs from types where possible
([[source-first]]).

### 13. Scenario playbooks

**New REST endpoint**

Caller sketch → schema → errors → authz → pagination if list → OpenAPI → contract test → implement.

**New npm/internal package export**

Facade types → minimal exports → error model → semver policy → document breaking change process.

**Split monolith module to service**

Define API that replaces in-process calls → same shapes initially → migrate callers → trim to service
boundary ([[migration-path]]).

**Event for downstream analytics**

Minimal payload → version field → sample events in doc → idempotent consumer guide.

**LLM tool definition**

JSON schema strict → validate args server-side → allowlist actions → same authz as HTTP ([[llm-feature-engineering]]).

**Breaking rename**

Add new field/endpoint → dual-read/write period → deprecate old → metric → remove.

**PR review of API change**

Diff OpenAPI → identify breaking → migration plan → error codes consistent → examples updated.

## Common Rationalizations

- "Callers can read the implementation." — Good interfaces need less reading; that's the point.
- "We'll clean up the API later." — Published surface has callers; cleanup becomes migration.
- "One flexible function covers all cases." — Over-general APIs are misused and unmaintainable.
- "Errors can just be null." — Every caller invents different handling; use explicit errors.
- "We'll version if we need to." — Plan additive defaults now; breaking is expensive later.
- "Internal team can break each other." — They'll still waste time; consistency still pays.
- "GraphQL types ARE the database." — Expose intentional view models, not tables.
- "Docs are enough." — Types/schemas enforce; docs alone drift.

## Red Flags

- Simplest call site needs many args, booleans, or comments to be correct
- Inconsistent naming, error shapes, or pagination vs rest of codebase
- Public type exposes DB columns, ORM models, or internal ids
- `200 OK` with `{ "success": false }` or ambiguous null
- No machine-readable error codes
- Breaking field rename with no dual-field or version period
- Unbounded list endpoint — no pagination
- Event payload is full entity with no schema version
- New endpoint with no authz story
- OpenAPI/types out of sync with implementation
- Optional everything — invalid empty objects accepted
- Idempotent writes with no idempotency key in contract

## Verification

- [ ] Callers identified; common case sketched before implementation
- [ ] Call site short and obvious; rare options in structured optional params
- [ ] Names use domain language; units explicit; matches codebase conventions
- [ ] Types/schema prevent illegal states; input validated at boundary ([[hardening]])
- [ ] Errors explicit — codes, HTTP mapping, retry guidance; no leaky internals
- [ ] Public surface minimal; internals not exported
- [ ] Pagination, timestamps, IDs consistent with existing APIs
- [ ] Async/event contracts versioned; consumers assumed idempotent ([[resilience]])
- [ ] Evolution plan — additive default; breaking changes via [[migration-path]]
- [ ] Contract documented (OpenAPI/schema) and tested in CI ([[test-first]], [[pipeline-ops]])
- [ ] Authz, size limits, and sensitive fields addressed at design time
