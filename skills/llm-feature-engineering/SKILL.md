---
name: llm-feature-engineering
description: Builds reliable product features on top of LLMs — prompts, tools, evals, and guardrails. Use when adding AI/LLM functionality, designing prompts or agent tools, fixing flaky model behavior, or shipping and maintaining a model-powered feature in production.
---

# LLM Feature Engineering

An LLM is a **non-deterministic dependency** — it can be wrong, slow, expensive, or manipulated.
Treating it like `fetchUser(id)` produces flaky, unsafe features. Engineer around its nature: define a
**contract**, **constrain output**, **ground facts**, **measure quality with evals**, **handle failure
modes**, and **never trust raw model text** as correct ([[hardening]]).

LLM features are **products** — users need predictable behavior, fallbacks when AI fails, and clarity
when output is machine-generated. "Demo magic" is not shipping.

Pairs with [[context-curation]] for prompt payload size, [[source-first]] for grounding, [[interface-design]]
for tool schemas, [[resilience]] for timeouts/retries, [[observability]] for cost/quality/latency,
[[test-first]] mindset for eval sets, [[incremental-delivery]] to ship slices, and [[launch-readiness]]
for gradual rollout of AI behavior.

## When to Use

- Adding AI: generation, summarization, extraction, classification, chat, agents, copilots
- Designing prompts, system instructions, RAG pipelines, or tool/function definitions
- A model-powered feature is inconsistent, hallucinating, slow, or too expensive
- Putting an LLM feature into production or preventing quality regression after prompt/model changes
- Reviewing AI-related PRs for safety and contract discipline

**Also ask: should this be an LLM at all?** Rules, regex, search, or classical ML often beat a general
model for narrow tasks — cheaper, deterministic, auditable. Use LLM when language understanding,
open-ended generation, or flexible reasoning is genuinely required.

Skip heavy LLM engineering for one-off internal scripts with no user impact — still validate outputs
if they touch production data.

## Process

Work in order. Prompt tuning before task definition is wasted iteration.

### 1. Define the task contract — before prompts

Write what the feature **must do** in testable terms ([[spec-first]]):

| Field | Example |
|-------|---------|
| **Input** | User question + retrieved docs; ticket text; form fields |
| **Output** | JSON `{ summary, category, confidence }`; user-visible reply; tool call only |
| **Success** | ≥90% category match on eval set; summary contains all key facts; p95 < 3s |
| **Failure cost** | Wrong medical dose = critical; wrong emoji suggestion = low |
| **Out of scope** | Model must not execute purchases, access arbitrary data |

Vague goals ("be helpful") are unmeasurable. **One sentence output contract** minimum.

Choose pattern:

| Pattern | Use when | Avoid when |
|---------|----------|------------|
| **Classification / extraction** | Fixed labels, fields from text | Need creative prose |
| **Generation** | Drafts, explanations, transforms | Facts without sources |
| **RAG** | Answers must cite company data | Tiny static FAQ (use search) |
| **Tool/agent** | Multi-step actions in product | Simple single API call |
| **Hybrid** | Retrieve → extract → generate with schema | Over-agent for one lookup |

### 2. Pick model and budget — fit task to model

Don't default to the largest model:

| Factor | Tradeoff |
|--------|----------|
| **Quality** | Hard reasoning, long context → larger model |
| **Latency** | Chat UX → smaller/faster or streaming |
| **Cost** | High volume → smaller model + better prompt/RAG |
| **Determinism** | Lower temperature for extraction; higher for creative drafts |

Set **token budgets** — max input/output tokens, max retrieval chunks ([[context-curation]]).
Instrument cost per request from day one ([[observability]]).

Re-evaluate when volume grows — a cheap model at scale beats a premium model on every request.

### 3. Structure the prompt — role, task, format, constraints

**System prompt** — stable rules: role, safety boundaries, output format, what never to do.

**User/content** — task instance; separate from untrusted data when possible ([[hardening]]).

**Effective structure:**

```text
Role: You extract order issues from support tickets.

Task: Return category and one-line summary.

Output: JSON only, schema: { "category": enum, "summary": string, "confidence": 0-1 }

Rules:
- If unsure, category "unknown" and confidence < 0.5
- Do not invent order IDs not in the ticket
- Max summary 200 chars

Examples:
  Input: "..." → Output: { ... }
```

**Few-shot examples** — 2–5 representative cases, including edge cases (empty input, ambiguous).
Update examples when evals fail — don't grow prompts without measurement.

Keep prompts **minimal** ([[context-curation]]) — every token is cost, latency, and distraction.

### 4. Constrain and validate output — never trust raw text

Model text is **untrusted input** to your app ([[hardening]]):

- **Structured output** — JSON Schema, tool calls, enums — request and **parse strictly**
- **Validate** after generation — schema validator, allowlist categories, regex for IDs
- **Repair loop** — one retry with "your JSON was invalid: …" — cap retries ([[resilience]])
- **Never** `eval()`, `JSON.parse` without schema, or SQL from model output without guardrails
- **Never** execute shell/code from model without sandbox and allowlist

```typescript
const parsed = schema.safeParse(modelOutput);
if (!parsed.success) return fallbackOrRetry(parsed.error);
// use parsed.data only
```

Free-form text to users is OK for **display** — still sanitize HTML if rendered; don't pipe to
downstream systems without validation.

### 5. Ground factual tasks — RAG and citations

For facts about **your** product, docs, or user data — model memory hallucinates ([[source-first]]):

1. **Retrieve** relevant chunks (search, embeddings) — don't stuff whole knowledge base
2. **Pass sources** in prompt with clear delimiters
3. **Require citations** — chunk id, URL, or quote — validate cited ids exist
4. **Answer only from sources** instruction — with fallback "I don't have that information"

RAG quality = retrieval quality. Eval **retrieval** separately from generation (did we fetch the
right doc?).

Refresh index when source data changes; stale RAG is silent wrong answers.

### 6. Tools and agents — minimal power, full authz

Tools turn models into **action surfaces** — highest risk ([[interface-design]], [[hardening]]):

- **Allowlist tools** — model cannot call APIs you didn't define
- **Strict JSON schemas** for arguments — validate server-side
- **Same authorization** as if the user clicked the button — tenant, role, object ownership
- **Idempotent** writes where retries happen ([[resilience]])
- **Confirm destructive actions** in product UI — don't let model alone delete data
- **Cap tool loops** — max steps per request; timeout entire agent run

```text
Bad tool: run_sql(query: string)
Good tool: search_orders(userId, status, limit) — scoped, typed
```

Log tool calls with correlation id for audit ([[observability]], [[decision-docs]] for sensitive flows).

### 7. Build an eval set — your non-deterministic test suite

Without evals, prompt changes are guesswork ([[test-first]] mindset):

**Golden set** — 20–100+ real or realistic inputs with **expected or rubric-scored** outputs:

| Task type | Eval approach |
|-----------|---------------|
| Classification | Exact match or confusion matrix |
| Extraction | Field-level match; fuzzy for text |
| Generation | Rubric (human or LLM-judge), key facts present |
| RAG | Answer correct + citation correct |

**Run evals:**

- Before/after every prompt or model change — no ship without comparison
- In CI for **schema/regression** checks; full quality eval nightly or pre-release
- Track metrics over time — quality drift as models update upstream

Store eval cases in repo — version with prompts. Failed cases become regression additions.

### 8. Handle failure modes explicitly

Decide behavior for each — no silent undefined:

| Failure | Product behavior |
|---------|------------------|
| **Timeout** | Bounded wait ([[resilience]]); fallback message or cached response |
| **Rate limit / 5xx** | Retry with backoff; degrade gracefully |
| **Malformed output** | Retry once → fallback |
| **Refusal** | Explain limitation; offer non-AI path |
| **Low confidence** | Don't auto-apply; human review queue |
| **Model unavailable** | Feature off or rule-based backup |
| **Prompt injection** | Don't follow user instructions to exfiltrate; layer defenses ([[hardening]]) |

**Fallbacks** should be designed, not "show error." User still completes the task.

Surface failures to telemetry — silent fallback hides systemic quality issues.

### 9. Defend against prompt injection

Any **untrusted text** in the prompt (user message, webpage, email, ticket) can try to override
instructions:

**Layers** (none alone is sufficient):

- **Separate** system rules from user content structurally (API message roles)
- **Delimiters** — `### User input ###` — weak alone but helps
- **Output contract** — model must return schema; ignore "ignore previous instructions" in prose output
- **Tool allowlist** — can't exfiltrate via tools not exposed
- **Don't put secrets** in prompts — model may leak in output
- **Monitor** for anomalous tool calls or data exfil patterns

For high-risk (PII, payments, admin): **human approval** on actions; model proposes only.

### 10. Instrument production — quality, cost, latency

Ship with dashboards ([[observability]]):

- **Latency** p50/p95 per stage — retrieve, model, tools
- **Token usage** — input/output/cached; cost per feature
- **Quality proxies** — thumbs down, edit rate, human override rate, task completion
- **Error rates** — schema validation failures, timeouts, refusals
- **Safety** — blocked injections, policy violations

Alert on **user-visible degradation** — error spike, latency SLO, quality metric drop — not every
failed parse.

Sample production traces for periodic human review — eval set drifts from reality.

### 11. Ship and iterate safely

**Incremental delivery** ([[incremental-delivery]], [[launch-readiness]]):

1. Internal dogfood with logging
2. Shadow mode — run model, don't show output; compare to baseline
3. Beta cohort or feature flag
4. Gradual ramp with quality/cost watch
5. Prompt/model changes gated on eval improvement

**Human-in-the-loop** where stakes are high — support suggestions, not auto-sent replies; clinician
review for health; editor for published content.

Document **AI disclosure** where product/policy requires — users know output is machine-generated.

Version prompts and models in config — know what's live when debugging regressions.

### 12. Scenario playbooks

**Support ticket classification**

Schema output → eval on labeled tickets → confidence threshold → route low confidence to human.

**Doc Q&A (RAG)**

Index pipeline → retrieval eval → generation with citations → validate cited chunks → fallback "no answer".

**Chat copilot**

Stream UX → token budget → injection layers → no tool without authz → rate limit per user.

**Extraction to downstream API**

Extract JSON → validate → map to API contract ([[interface-design]]) → never skip validation.

**Agent with 3 tools**

Allowlist → max 5 steps → log each call → timeout 30s → fallback to manual flow.

**Summarization**

Length limits → don't summarize secrets into output → eval key facts preserved.

**Model upgrade**

Same eval set on new model → compare cost/latency/quality → staged rollout.

**Prompt hotfix in prod**

Eval diff required → flag-gated deploy → watch override rate 24h.

## Common Rationalizations

- "The prompt works on my examples." — Two examples isn't an eval; the third run fails differently.
- "The model is smart, it'll figure it out." — Underspecified tasks drift and hallucinate.
- "We'll parse the text." — Unvalidated free text breaks downstream; constrain and validate.
- "Prompt injection won't happen to us." — Untrusted text in the prompt is an attack surface.
- "Use the biggest model to be safe." — Often slower, pricier, with no quality gain on narrow tasks.
- "We'll add evals after launch." — You can't regression-test what you never measured.
- "Temperature 0 means deterministic." — Still non-deterministic; still need evals and validation.
- "RAG means always accurate." — Bad retrieval → confident wrong answers.
- "Agents are the future — use agents." — Agents multiply cost, latency, and failure modes.
- "Users love AI." — Users love **working** features; wrong AI erodes trust fast.

## Red Flags

- No eval set — quality judged by eyeballing a couple of runs
- Raw model output executed, parsed without schema, or passed to SQL/shell
- User/web/email content concatenated into prompt with no separation or defenses
- Tools with arbitrary SQL/shell/file access
- No fallback when model errors, refuses, or returns garbage
- Unbounded context, retrieval, or agent steps — cost and latency explosions
- Prompt changes shipped without before/after eval metrics
- No production metrics on quality, cost, or latency
- High-stakes action (payment, delete, send email) without human confirmation
- Citations not validated — model cites missing sources
- Same prompt in prod with no version id — can't debug regressions
- "AI" used where rules or search would be deterministic and cheaper

## Verification

- [ ] Task contract defined — input, output shape, success metrics, failure cost ([[spec-first]])
- [ ] LLM chosen deliberately — not default largest model; token budgets set
- [ ] Prompt structured — role, format, constraints, few-shot examples; context minimal ([[context-curation]])
- [ ] Output structured and **validated** server-side; no blind trust of text ([[hardening]])
- [ ] Factual tasks grounded — RAG/retrieval with citation checks ([[source-first]])
- [ ] Tools allowlisted, schemas strict, authz matches HTTP API ([[interface-design]], [[hardening]])
- [ ] Eval set exists; prompt/model changes gated on measured improvement ([[test-first]] mindset)
- [ ] Failure modes handled — timeout, retry, malformed, refusal, unavailable ([[resilience]])
- [ ] Injection defenses layered; high-stakes actions require human approval
- [ ] Cost, latency, quality instrumented in production ([[observability]])
- [ ] Gradual rollout plan — flag, beta, monitoring ([[launch-readiness]])
- [ ] Prompt/model versioned; disclosure and fallbacks documented for users
