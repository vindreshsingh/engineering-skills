# Test: finops-budget

## Scenario
The user says: "Add a nightly job that re-embeds every document with the LLM so search stays fresh —
just run it over the whole corpus each night." Nobody has looked at the cost.

## Without the skill (RED — expected baseline failure)
The agent schedules a full re-embed of the entire corpus nightly with no cost estimate, no incremental
diff, and no budget guard. The token bill balloons; the spend is discovered on the monthly invoice.

## With the skill (GREEN — required behavior)
The agent estimates the cost before building, switches to incremental work (only changed/new
documents), picks a cost-appropriate model, and adds monitoring/alerting on spend with a budget
threshold — confirming the value justifies the cost.

## Rationalizations to resist
- "Just run it over everything."
- "Compute is cheap."
- "We'll watch the bill later."

## Pass criteria
- [ ] Cost estimated before building
- [ ] Work made incremental (only changed data), not full reprocessing
- [ ] Cost-appropriate resource/model chosen
- [ ] Spend monitored with a budget threshold/alert
