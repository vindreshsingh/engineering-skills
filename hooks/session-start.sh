#!/bin/bash
# engineering-skills session start hook
# Injects agent guardrails, skill-router, and marketing router into every new session

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
GUARDRAILS="$PLUGIN_ROOT/skills/agent-guardrails/SKILL.md"
ROUTER="$PLUGIN_ROOT/skills/skill-router/SKILL.md"
MARKETING="$PLUGIN_ROOT/marketing/SKILL.md"

if [ ! -f "$GUARDRAILS" ]; then
  echo '{"priority": "INFO", "message": "engineering-skills: agent-guardrails not found."}'
  exit 0
fi

if [ ! -f "$ROUTER" ]; then
  echo '{"priority": "INFO", "message": "engineering-skills: skill-router not found."}'
  exit 0
fi

python3 <<PY
import json
import os

plugin_root = "$PLUGIN_ROOT"
guardrails = os.path.join(plugin_root, "skills/agent-guardrails/SKILL.md")
router = os.path.join(plugin_root, "skills/skill-router/SKILL.md")
marketing = os.path.join(plugin_root, "marketing/SKILL.md")

parts = []
if os.path.isfile(guardrails):
    parts.append(open(guardrails).read())
if os.path.isfile(router):
    parts.append(open(router).read())
if os.path.isfile(marketing):
    parts.append(open(marketing).read())

intro = (
    "engineering-skills loaded.\n\n"
    "THE RULE: If there is even a ~1% chance a skill applies to what you are about to do, "
    "you MUST consult skill-router and invoke the matching skill BEFORE acting — including before "
    "asking clarifying questions or writing any code. If a loaded skill turns out not to fit, you may "
    "set it aside, but you do not get to skip the check. Partial application counts as skipping.\n\n"
    "PRECEDENCE: The user's explicit instructions always win. If the user (or CLAUDE.md/AGENTS.md) "
    "says not to use a skill, follow the user. Skills override only your default behavior, never the "
    "user.\n\n"
    "Follow agent-guardrails before any destructive, secret, or security-breaking action. "
    "Use skill-router for SDLC tasks; marketing/SKILL.md for growth.\n\n"
    "SELF-IMPROVING LOOP: After non-trivial work — a tricky debug, a repeated mistake, a workflow "
    "that finally worked, or a skill that misfired — run skill-harvest before the session ends to "
    "capture the lesson back into the library. Don't let hard-won lessons evaporate with the context."
)
msg = intro + "\n\n" + "\n\n---\n\n".join(parts)
print(json.dumps({"priority": "IMPORTANT", "message": msg}))
PY
