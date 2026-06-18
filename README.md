# Personal LLM Skill

A simple personal skill definition with platform-specific wrappers for:

- Claude Code
- Cortex
- Antigravity

## Canonical skill

The shared instruction set lives in `/skill.md`.

## Platform files

- Claude Code: `/claude-code/SKILL.md`
- Cortex: `/cortex/skill.md`
- Antigravity: `/antigravity/skill.md`

Each platform file mirrors the canonical skill text so the behavior stays consistent.

## Update process

To keep all platform files synchronized, always edit `/skill.md` first and then copy it to platform paths:

```bash
cp skill.md claude-code/SKILL.md
cp skill.md cortex/skill.md
cp skill.md antigravity/skill.md
```
