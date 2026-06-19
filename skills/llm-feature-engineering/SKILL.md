---
name: llm-feature-engineering
description: Builds reliable product features on top of LLMs — prompts, tools, evals, and guardrails. Use when adding AI/LLM functionality, designing prompts or agent tools, or making a flaky model-powered feature trustworthy.
---

# LLM Feature Engineering

An LLM is a non-deterministic dependency that can be wrong, slow, or manipulated. Treating it like a
normal function call produces flaky, unsafe features. Engineer around its nature: specify behavior
clearly, constrain outputs, measure quality with evals, and never trust its output blindly.

## When to Use

- Adding an AI feature: generation, summarization, extraction, classification, chat, agents
- Designing prompts, system instructions, or tool/function definitions for a model
- A model-powered feature is inconsistent, hallucinating, or hard to trust
- Putting an LLM feature into production and needing to keep it good

## Process

1. **Define the task and success criteria first.** What's the input, the required output shape, and
   what "good" means — before tuning prompts. Vague goals make unmeasurable features.
2. **Constrain the output.** Ask for structured output (JSON/schema, tool calls) and validate it;
   never `eval` or trust raw model text as if it were correct ([[hardening]]).
3. **Write clear, specific instructions.** State the role, the steps, the format, and the edge cases.
   Give examples of good output. Keep only relevant context in the prompt ([[context-curation]]).
4. **Ground it in real data.** For factual tasks, retrieve and pass the source rather than relying on
   model memory ([[source-first]]); cite what it used.
5. **Build an eval set.** A handful of representative inputs with expected outcomes you can re-run.
   This is your test suite for a non-deterministic system — without it you're guessing.
6. **Handle the failure modes.** Timeouts/retries and fallbacks ([[resilience]]), refusals, partial or
   malformed output, and prompt-injection from untrusted input. Decide what happens when the model is
   wrong or unavailable.
7. **Watch cost, latency, and tokens.** Pick the right model for the job, cap context, and instrument
   quality, cost, and latency in production ([[observability]]).
8. **Iterate from real outputs.** Change the prompt, re-run the evals, keep what measurably improves.

## Common Rationalizations

- "The prompt works on my examples." — Two examples isn't an eval; non-determinism breaks the third.
- "The model is smart, it'll figure it out." — Underspecified tasks drift; specify the contract.
- "We'll just parse the text." — Unvalidated free text breaks downstream; constrain and validate output.
- "Prompt injection won't happen to us." — Any untrusted text in the prompt is an attack surface.
- "Use the biggest model to be safe." — Often slower and pricier with no quality gain; match model to task.

## Red Flags

- No eval set — quality judged by eyeballing a couple of runs
- Trusting/executing raw model output without validation
- Untrusted user/content text concatenated into prompts with no defense
- No fallback when the model errors, refuses, or returns garbage
- Unbounded context and no cost/latency tracking
- Prompt changes shipped with no before/after measurement

## Verification

- [ ] Task, output contract, and "good" defined before prompt tuning
- [ ] Output is structured and validated; raw model text is never blindly trusted
- [ ] Factual tasks are grounded in retrieved source, not model memory
- [ ] A re-runnable eval set exists and gates prompt changes
- [ ] Failure modes handled: errors, refusals, malformed output, prompt injection
- [ ] Cost, latency, and quality are instrumented in production
