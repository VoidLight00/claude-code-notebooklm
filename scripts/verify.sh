#!/usr/bin/env bash
set -euo pipefail

printf '==> Checking Python\n'
python3 --version

printf '==> Checking Claude Code CLI\n'
if command -v claude >/dev/null 2>&1; then
  claude --version || true
else
  printf 'WARN: claude CLI was not found in PATH. Install Claude Code before using the skill.\n'
fi

printf '==> Checking notebooklm CLI\n'
if command -v notebooklm >/dev/null 2>&1; then
  notebooklm --version
else
  printf 'ERROR: notebooklm CLI not found. Run ./scripts/install.sh first.\n' >&2
  exit 1
fi

printf '==> Checking Claude Code skill file\n'
SKILL_PATH="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills/notebooklm}/SKILL.md"
if [ -f "$SKILL_PATH" ]; then
  printf 'Found skill: %s\n' "$SKILL_PATH"
else
  printf 'ERROR: Skill not found at %s. Run ./scripts/install.sh.\n' "$SKILL_PATH" >&2
  exit 1
fi

printf '==> Checking NotebookLM authentication\n'
if notebooklm status; then
  printf 'NotebookLM authentication looks ready.\n'
else
  printf 'NotebookLM is installed but not authenticated. Run: notebooklm login\n' >&2
  exit 2
fi
