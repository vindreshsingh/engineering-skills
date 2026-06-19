#!/usr/bin/env bash
# validate.sh — structural checks for the engineering-skills repo.
# Verifies every skill and agent has valid frontmatter and required sections,
# directory names match the declared `name`, and JSON manifests parse.
# Exits non-zero if anything fails. Run: bash scripts/validate.sh

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

errors=0
fail() { printf '  ✗ %s\n' "$1"; errors=$((errors + 1)); }

# Read a frontmatter field (first match) from a file's top YAML block.
frontmatter_field() {
  # $1 file, $2 field
  awk -v f="$2" '
    NR==1 && $0!="---" { exit 1 }
    NR>1 && $0=="---" { exit }
    NR>1 {
      if ($0 ~ "^"f":") { sub("^"f":[[:space:]]*",""); print; exit }
    }
  ' "$1"
}

required_sections=("When to Use" "Process" "Common Rationalizations" "Red Flags" "Verification")
# Meta-skills are routers/indexes, not step-by-step processes — exempt from the
# process-section check (frontmatter is still validated).
meta_skills=" skill-router "

echo "Validating skills..."
for dir in skills/*/; do
  name="$(basename "$dir")"
  file="${dir}SKILL.md"
  if [ ! -f "$file" ]; then fail "$name: missing SKILL.md"; continue; fi

  if [ "$(head -1 "$file")" != "---" ]; then
    fail "$name: SKILL.md must start with YAML frontmatter (---)"
    continue
  fi

  fname="$(frontmatter_field "$file" name)"
  fdesc="$(frontmatter_field "$file" description)"

  [ -n "$fname" ] || fail "$name: frontmatter missing 'name'"
  [ -n "$fdesc" ] || fail "$name: frontmatter missing 'description'"
  if [ -n "$fname" ] && [ "$fname" != "$name" ]; then
    fail "$name: frontmatter name '$fname' != directory name"
  fi

  case "$meta_skills" in *" $name "*) continue ;; esac

  for section in "${required_sections[@]}"; do
    grep -qE "^##[[:space:]]+$section" "$file" || fail "$name: missing section '## $section'"
  done
done

echo "Validating agents..."
for file in agents/*.md; do
  [ -f "$file" ] || continue
  base="$(basename "$file")"
  if [ "$(head -1 "$file")" != "---" ]; then
    fail "agents/$base: must start with YAML frontmatter (---)"; continue
  fi
  [ -n "$(frontmatter_field "$file" name)" ] || fail "agents/$base: frontmatter missing 'name'"
  [ -n "$(frontmatter_field "$file" description)" ] || fail "agents/$base: frontmatter missing 'description'"
done

echo "Validating JSON manifests..."
for json in .claude-plugin/plugin.json .claude-plugin/marketplace.json hooks/hooks.json; do
  if [ -f "$json" ]; then
    python3 -c "import json,sys; json.load(open('$json'))" 2>/dev/null \
      || fail "invalid JSON: $json"
  else
    fail "missing manifest: $json"
  fi
done

echo
if [ "$errors" -eq 0 ]; then
  count="$(find skills -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"
  echo "✓ All checks passed ($count skills)."
  exit 0
else
  echo "✗ $errors problem(s) found."
  exit 1
fi
