#!/usr/bin/env bash
# L-Spec — Desinstalador (Claude Code + OpenCode)
set -uo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo ""
echo -e "╔═══════════════════════════╗"
echo -e "║    L-Spec — Uninstall     ║"
echo -e "╚═══════════════════════════╝"
echo ""

remove_skill_dir() {
  local path="$1"; local name="$2"
  if [ -d "$path" ]; then
    rm -rf "$path"
    echo -e "  ${GREEN}✓${NC} $name removido: $path"
  else
    echo -e "  ${RED}—${NC} $name não encontrado: $path"
  fi
}

# Remover skills
for skill_dir in skills/*/; do
  skill_name="$(basename "$skill_dir")"
  remove_skill_dir "$HOME/.claude/skills/$skill_name" "Claude Code"
  remove_skill_dir "$HOME/.opencode/skills/$skill_name" "OpenCode"
done

echo ""
echo -e "${GREEN}✓ L-Spec desinstalado!${NC}"
echo ""
