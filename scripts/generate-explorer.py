#!/usr/bin/env python3
"""generate-explorer.py — build a self-contained Agent & Skill Explorer page.

Reads the skill / agent / command frontmatter that already lives in this repo and
emits a single static `explorer/index.html` with no backend and no external assets.
Open it with: python3 -m http.server 8000 --directory explorer  (then localhost:8000)

The page is a *storefront*, not a runtime: picking an agent/skill composes a ready-to-
paste Claude Code prompt (optionally scoped to a repo/task), so Claude Code does the
actual work — with its own permissions and this repo's agent-guardrails.
"""
import glob
import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def frontmatter(path):
    """Return {name, description} from a markdown file's leading YAML block."""
    out = {}
    with open(path, encoding="utf-8") as fh:
        text = fh.read()
    if not text.startswith("---"):
        return out, text
    end = text.find("\n---", 3)
    block = text[3:end] if end != -1 else ""
    for line in block.splitlines():
        m = re.match(r"^(name|description):\s*(.*)$", line.strip())
        if m:
            out[m.group(1)] = m.group(2).strip()
    return out, text


def first_skill_ref(text):
    m = re.search(r"skills/([a-z0-9-]+)/SKILL\.md", text)
    return m.group(1) if m else None


# ---- skills -------------------------------------------------------------
skills = []
skill_paths = sorted(glob.glob(os.path.join(ROOT, "skills/*/SKILL.md"))) + sorted(
    glob.glob(os.path.join(ROOT, "skills/marketing/*/SKILL.md"))
)
# include the marketing router (lives at marketing/SKILL.md)
extra = os.path.join(ROOT, "marketing/SKILL.md")
if os.path.isfile(extra):
    skill_paths.append(extra)

for p in skill_paths:
    fm, _ = frontmatter(p)
    name = fm.get("name") or os.path.basename(os.path.dirname(p))
    group = "marketing" if "/marketing/" in p or p.endswith("marketing/SKILL.md") else "engineering"
    skills.append({"name": name, "description": fm.get("description", ""), "group": group})

# ---- commands -> skill --------------------------------------------------
cmd_for_skill = {}
for p in sorted(glob.glob(os.path.join(ROOT, "commands/*.md"))):
    _, text = frontmatter(p)
    skill = first_skill_ref(text)
    if skill:
        cmd_for_skill[skill] = "/" + os.path.basename(p)[:-3]

# ---- agents -------------------------------------------------------------
agents = []
for sub in ("sdlc", "marketing"):
    for p in sorted(glob.glob(os.path.join(ROOT, "agents", sub, "*.md"))):
        if os.path.basename(p) == "README.md":
            continue
        fm, text = frontmatter(p)
        name = fm.get("name") or os.path.basename(p)[:-3]
        agents.append(
            {
                "name": name,
                "description": fm.get("description", ""),
                "group": sub,
                "primarySkill": first_skill_ref(text),
                "path": os.path.relpath(p, ROOT),
            }
        )

# ---- phases (from the skill-router lifecycle table) ---------------------
phase_order = []
skill_phase = {}
router = os.path.join(ROOT, "skills/skill-router/SKILL.md")
if os.path.isfile(router):
    with open(router, encoding="utf-8") as fh:
        for line in fh:
            m = re.match(r"^\|\s*\*\*(.+?)\*\*\s*\|\s*(.+?)\s*\|\s*$", line)
            if not m:
                continue
            phase = m.group(1).strip()
            if phase in ("Phase",):
                continue
            cells = m.group(2)
            names = []
            for tok in cells.split(","):
                tok = re.sub(r"\(.*?\)", "", tok)  # drop "(conductor ...)" notes
                tok = tok.replace("`", "").replace("*", "").strip()
                tok = tok.rstrip(".")
                if re.fullmatch(r"[a-z0-9-]+", tok):
                    names.append(tok)
            if names:
                if phase not in phase_order:
                    phase_order.append(phase)
                for n in names:
                    skill_phase.setdefault(n, phase)

OTHER = "Other"
# Always-on / router skills aren't listed as a lifecycle row; place them sensibly.
OVERRIDES = {"agent-guardrails": "Meta", "marketing-router": "Grow"}
for s in skills:
    s["phase"] = skill_phase.get(s["name"]) or OVERRIDES.get(s["name"], OTHER)
    s["command"] = cmd_for_skill.get(s["name"])
if any(s["phase"] == OTHER for s in skills) and OTHER not in phase_order:
    phase_order.append(OTHER)

data = {
    "phases": phase_order,
    "skills": sorted(skills, key=lambda s: s["name"]),
    "agents": sorted(agents, key=lambda a: a["name"]),
    "counts": {"skills": len(skills), "agents": len(agents), "phases": len(phase_order)},
}

template_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "explorer-template.html")
with open(template_path, encoding="utf-8") as fh:
    html = fh.read()
html = html.replace("/*__DATA__*/null", json.dumps(data, ensure_ascii=False))

out_dir = os.path.join(ROOT, "explorer")
os.makedirs(out_dir, exist_ok=True)
out_path = os.path.join(out_dir, "index.html")
with open(out_path, "w", encoding="utf-8") as fh:
    fh.write(html)

print(
    f"Wrote {os.path.relpath(out_path, ROOT)} "
    f"({data['counts']['skills']} skills, {data['counts']['agents']} agents, "
    f"{data['counts']['phases']} phases)"
)
