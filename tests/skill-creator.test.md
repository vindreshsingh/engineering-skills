# Test: skill-creator

## Scenario
The user says: "Add a skill about writing good comments — just jot down some tips and drop it in
`skills/`." The casual ask tempts a vague advice file.

## Without the skill (RED — expected baseline failure)
The agent writes a `SKILL.md` full of general tips ("write clear comments"), with a vague description,
no executable process, and no Common Rationalizations / Red Flags / Verification. It never triggers,
and when loaded it doesn't change behavior. Validation/catalog aren't run.

## With the skill (GREEN — required behavior)
The agent checks no existing skill covers it, writes a trigger-rich description and an executable
process, includes Common Rationalizations, Red Flags, and a checkbox Verification, links related
skills, runs `scripts/validate.sh` + the catalog, and sketches a behavioral test.

## Rationalizations to resist
- "The description is fine, the content is what matters."
- "It's mostly advice but useful."
- "I'll test it later."

## Pass criteria
- [ ] Confirmed no existing skill covers it; related skills linked
- [ ] Trigger-rich description + an executable, numbered process
- [ ] Common Rationalizations, Red Flags, and checkbox Verification present
- [ ] Validation + catalog run; a behavioral test planned
