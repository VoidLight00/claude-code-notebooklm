#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="$ROOT_DIR/skill/SKILL.md"
SKILL_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills/notebooklm}"
PYTHON_BIN="${PYTHON_BIN:-python3}"
PIP_BIN="${PIP_BIN:-$PYTHON_BIN -m pip}"

printf '==> Installing notebooklm-py\n'
$PIP_BIN install --upgrade notebooklm-py

printf '==> Installing Claude Code skill to %s\n' "$SKILL_DIR"
mkdir -p "$SKILL_DIR"
cp "$SKILL_SRC" "$SKILL_DIR/SKILL.md"

printf '==> Verifying notebooklm CLI\n'
notebooklm --version

printf '\nInstallation complete. Next steps:\n'
printf '  1. Run: notebooklm login\n'
printf '  2. Run: notebooklm status\n'
printf '  3. In Claude Code, try: /notebooklm 인증 상태 확인해줘\n'
