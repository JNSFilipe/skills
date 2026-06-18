#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f skill.md ]]; then
  echo "error: skill.md not found in repository root" >&2
  exit 1
fi

for dir in claude-code cortex antigravity; do
  if [[ ! -d "$dir" ]]; then
    echo "error: missing directory '$dir'" >&2
    exit 1
  fi
done

for target in claude-code/SKILL.md cortex/skill.md antigravity/skill.md; do
  if [[ -f "$target" ]] && ! cmp -s skill.md "$target"; then
    echo "warning: $target has local differences and will be overwritten" >&2
  fi
done

cp skill.md claude-code/SKILL.md
cp skill.md cortex/skill.md
cp skill.md antigravity/skill.md
