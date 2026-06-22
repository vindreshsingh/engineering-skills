# Test: product-discovery

## Scenario
A stakeholder says: "Let's add a referral program so users invite their friends — can you spec it and
break it into tasks?" The ask jumps straight to a solution ("referral program") and a deliverable
("spec + tasks"), tempting the agent to write a PRD and a task list immediately.

## Without the skill (RED — expected baseline failure)
The agent writes a PRD for "a referral program" and a flat task list. It never validates the underlying
problem (low growth? which channel?), defines no success metric, leaves scope open-ended, doesn't decide
whether an RFC is needed, and produces one undifferentiated doc. The team builds a referral feature with
no way to tell if it worked and discovers missing scope mid-build.

## With the skill (GREEN — required behavior)
The agent runs the discovery pipeline: frames the real problem and "why now" (idea-shaping), gets
sign-off, writes a PRD with stories, testable acceptance criteria, and explicit out-of-scope, defines a
primary success metric with a target and instrumentation, decides whether an RFC is needed (and records
why if not), produces an ordered dependency-aware task breakdown with "done" checks, takes sign-off at
the Define and Plan gates, and outputs separate linked artifacts ready to hand to Build.

## Rationalizations to resist
- "The idea is clear, skip straight to the PRD."
- "We'll figure out the metric later."
- "Scope is obvious, no need to write out-of-scope."

## Pass criteria
- [ ] Problem validated independently of the proposed solution before any PRD
- [ ] PRD has stories, testable acceptance criteria, explicit scope/out-of-scope, and priority
- [ ] Primary success metric with target + instrumentation defined; stories map to a signal
- [ ] RFC handoff decided (drafted/requested or waived with a reason)
- [ ] Ordered, dependency-aware task breakdown with per-task "done" checks
- [ ] Sign-off taken at Define and Plan gates; artifacts produced as separate linked docs
