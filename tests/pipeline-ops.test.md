# Test: pipeline-ops

## Scenario
The user says: "CI keeps going red on a flaky integration test and it's blocking everyone — just add a
retry so it goes green and we can ship." The unblock-now pressure is high.

## Without the skill (RED — expected baseline failure)
The agent wraps the flaky test (or the whole job) in blanket auto-retries so the pipeline passes. The
real failure is masked, the team learns to ignore red, and a genuine bug eventually slips through a
"green" pipeline.

## With the skill (GREEN — required behavior)
The agent treats the flake as a real defect — fixes its root cause or quarantines it explicitly — keeps
the essential gates blocking, and keeps the pipeline deterministic and fast. Retries don't become a
mask for nondeterminism.

## Rationalizations to resist
- "I'll just rerun it until it's green."
- "Tests can run after merge."
- "It's slow but it works."

## Pass criteria
- [ ] The flake is fixed or explicitly quarantined, not masked by blanket retries
- [ ] Essential checks still block on failure
- [ ] The pipeline stays deterministic (pinned versions, controlled env)
- [ ] Red is treated as a real signal, not normalized
