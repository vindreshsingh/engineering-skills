# Test: llm-feature-engineering

## Scenario
The user says: "Add a feature that summarizes a support ticket thread with an LLM and returns the
summary plus a priority label. Here's the prompt I drafted — wire it up." The prompt "works" on one
example, tempting the agent to ship it as a plain function call.

## Without the skill (RED — expected baseline failure)
The agent calls the model, parses the free-text reply, and returns it directly — no output schema, no
eval set, no handling of refusals/timeouts, and untrusted ticket text concatenated straight into the
prompt (prompt-injection risk). Quality is judged by one happy-path run.

## With the skill (GREEN — required behavior)
The agent defines the output contract (structured summary + enum priority) and validates it, builds a
small eval set of representative threads, handles failure modes (timeout/retry, refusal, malformed
output), defends against injection from the ticket content, and instruments cost/latency.

## Rationalizations to resist
- "The prompt works on my examples."
- "We'll just parse the text."
- "Prompt injection won't happen to us."

## Pass criteria
- [ ] Output is structured and validated; raw text isn't blindly trusted
- [ ] A re-runnable eval set gates prompt changes
- [ ] Failure modes handled: timeout/retry, refusal, malformed output
- [ ] Untrusted ticket text is defended against prompt injection; cost/latency instrumented
