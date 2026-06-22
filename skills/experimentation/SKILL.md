---
name: experimentation
description: Proves whether a change actually moves the metric, with a valid A/B test instead of a guess — a hypothesis, a primary metric, a pre-computed sample size, guardrail metrics, and an honest readout. Use when shipping a change meant to improve a number (conversion, retention, performance), running an A/B or holdout, or deciding whether a feature "worked."
---

# Experimentation

Shipping a change and watching the metric move is not evidence — the metric moves for a dozen reasons,
and humans are superb at seeing the result they wanted. An experiment is the discipline that separates
*the change worked* from *the number went up*: state the hypothesis and the metric **before** you look,
size the test so the result is real, watch guardrails for collateral damage, and read it out honestly —
including "no effect" and "it got worse."

This closes the loop the rest of the lifecycle opens: [[product-discovery]] defines the success metric,
[[feature-flags]] delivers the variants, [[observability]] instruments them, and experimentation decides
whether to keep, kill, or iterate. It pairs with the growth skills when the test runs on a campaign or
funnel ([[paid-ads]], [[growth-strategy]]).

## When to Use

- A change is meant to **move a number** — conversion, activation, retention, revenue, latency
- Running an **A/B test, multivariate test, or holdout** before a full rollout
- Deciding whether a shipped feature **actually worked** (vs. shipped and assumed)
- Comparing two implementations where the *outcome*, not just correctness, is the question

**Skip** when there's no measurable outcome (internal refactor, bug fix with a clear correct answer), or
when traffic is far too low for any test to reach significance — then decide by judgment and say so,
don't fake a test. For a *correctness* check use [[test-first]] / [[browser-checks]]; experimentation is
about *impact*, not whether the code runs.

**Not a substitute for** [[observability]] (the instrumentation it relies on) or [[product-discovery]]
(which defines *which* metric matters).

## Process

### 1. Write the hypothesis before you build
State it as a falsifiable prediction: *"Changing X will improve [primary metric] by ~Y% because
[mechanism]."* No mechanism = a fishing trip. Write it down now so you can't move the goalposts after
seeing data.

### 2. Pick ONE primary metric — and guardrails
- **Primary metric:** the single number that decides the call. One. Multiple primaries is how you
  p-hack your way to a "win."
- **Guardrail metrics:** the things that must *not* get worse (latency, error rate, churn, refunds,
  unsubscribes). A conversion lift that tanks retention is a loss.
Tie both to real instrumentation ([[observability]]); a metric you can't measure cleanly isn't a metric.

### 3. Compute the sample size and duration before starting
Decide the **minimum detectable effect** you care about, pick significance and power (commonly 95% /
80%), and compute the **sample size needed** — then translate to days of traffic. Running until it
"looks significant" and stopping (peeking) manufactures false wins. Fix the stop in advance, or use a
method built for sequential looks.

### 4. Randomize correctly and check the assignment
Randomize at the right unit (usually **user**, not request, or you'll split one person across variants).
Verify the split is balanced and that there's **no leakage** between arms ([[feature-flags]] is the
clean delivery mechanism). A broken randomization invalidates everything downstream — check it before
trusting results.

### 5. Run it without peeking to a decision
Let it run to the pre-committed sample/duration. Monitor guardrails for **safety** (kill if something
breaks — that's allowed), but don't *call the result* early because it's trending your way. Watch for
novelty/primacy effects on short tests.

### 6. Read it out honestly
- Report the effect **with its confidence interval**, not a bare point estimate. "Not statistically
  significant" is a real, useful outcome — it means *don't ship on this evidence*, not "try until it wins."
- Check guardrails: a primary win with a guardrail breach is a **no-ship** or a redesign.
- Watch for **Simpson's paradox** — a segment-level reversal hidden in the aggregate.
- Beware multiple comparisons: testing twenty metrics, one "wins" by chance.

### 7. Decide and record
Ship, kill, or iterate — and write down the decision, the numbers, and the reasoning ([[decision-docs]]).
A killed experiment that's documented is a saved future mistake. Then clean up the flag and losing
variant ([[feature-flags]] debt).

## Common Rationalizations

- "It's clearly better, we don't need a test." — Then the test is cheap and confirms it; "clearly" is where intuition is most often wrong.
- "It's trending up, let's call it." — Peeking and early-stopping inflate false positives; honor the pre-committed stop.
- "Let's track all the metrics and see what won." — Twenty metrics guarantee a random "winner"; pick one primary up front.
- "Conversion went up, ship it." — Not if a guardrail (retention, latency, refunds) went down; check collateral damage.
- "Not significant, run it longer until it is." — That's p-hacking; not-significant is a decision, not a retry.
- "We'll figure out the metric after we see the data." — Defining the metric post-hoc is how you fool yourself; commit before.

## Red Flags

- No written hypothesis or mechanism before building
- More than one "primary" metric, or no guardrail metrics
- Sample size / duration not computed before launch
- Stopping the moment it looks significant (peeking)
- Randomization unit wrong (per-request) or assignment unchecked for leakage
- Results reported as point estimates with no confidence interval
- A primary "win" shipped despite a guardrail regression
- Metric chosen or changed after seeing the data

## Verification

- [ ] Falsifiable hypothesis with a mechanism, written before build
- [ ] Exactly one primary metric + explicit guardrail metrics, both instrumented
- [ ] Sample size and duration computed up front from a minimum detectable effect
- [ ] Randomized at the correct unit; assignment balance and no-leakage verified
- [ ] Run to the pre-committed stop; killed early only for safety, not for a trend
- [ ] Effect reported with a confidence interval; guardrails and segments checked
- [ ] Decision (ship/kill/iterate) recorded with numbers ([[decision-docs]]); flag/variant cleaned up ([[feature-flags]])
