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

cp skill.md claude-code/SKILL.md
cp skill.md cortex/skill.md
cp skill.md antigravity/skill.md
