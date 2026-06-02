#!/usr/bin/env bash
# L-Spec — Instalador para Claude Code e OpenCode
set -uo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Opções
TARGET="${1:-both}"  # opencode | claude | both
SCOPE="${2:-global}"  # global | project
PROJECT_ROOT="${3:-}"

echo ""
echo -e "${BLUE}╔═══════════════════════════╗${NC}"
echo -e "${BLUE}║    L-Spec — Install       ║${NC}"
echo -e "${BLUE}╚═══════════════════════════╝${NC}"
echo ""

usage() {
  echo "Uso: bash install.sh [opencode|claude|both] [global|project] [project-root]"
  echo ""
  echo "  opencode|claude|both  — instalar no OpenCode, Claude Code, ou ambos (padrão: both)"
  echo "  global|project        — escopo: global (~/.claude/ ou ~/.opencode/) ou projeto"
  echo "  project-root          — caminho do projeto (obrigatório se scope=project)"
  echo ""
  echo "Exemplos:"
  echo "  bash install.sh                      # ambos, global"
  echo "  bash install.sh opencode global      # só OpenCode, global"
  echo "  bash install.sh both project /my/proj  # ambos, no projeto /my/proj"
}

help_flag=false
for arg in "$@"; do
  case "$arg" in
    -h|--help) help_flag=true; shift ;;
  esac
done

if [ "$help_flag" = true ] || [ "$1" = "--help" ]; then
  usage; exit 0
fi

TARGET="${1:-both}"
SCOPE="${2:-global}"
PROJECT_ROOT="${3:-}"

# Validação
if [ "$SCOPE" = "project" ] && [ -z "$PROJECT_ROOT" ]; then
  echo -e "${RED}✗ Escopo project requer project-root (3º argumento)${NC}"
  usage; exit 1
fi

# Função: instalar em um destino
install_target() {
  local target="$1"; local scope="$2"; local proj_root="$3"
  local dest=""; local name=""

  case "$target" in
    opencode)
      if [ "$scope" = "global" ]; then
        dest="$HOME/.opencode/skills"
      else
        dest="$proj_root/.opencode/skills"
      fi
      name="OpenCode"
      ;;
    claude)
      if [ "$scope" = "global" ]; then
        dest="$HOME/.claude/skills"
      else
        dest="$proj_root/.claude/skills"
      fi
      name="Claude Code"
      ;;
    *) echo -e "${RED}✗ Destino desconhecido: $target${NC}"; return 1 ;;
  esac

  if [ -d "$dest" ]; then
    echo -e "  ${GREEN}→${NC} $name ($scope): $dest"
  else
    echo -e "  ${RED}✗${NC} $name não encontrado: $dest"
    return 1
  fi

  mkdir -p "$dest"

  # Copia todas as skills
  local count=0
  for skill_dir in skills/*/; do
    skill_name="$(basename "$skill_dir")"
    rm -rf "$dest/$skill_name"
    mkdir -p "$dest/$skill_name"
    cp -R "$skill_dir"/* "$dest/$skill_name/" 2>/dev/null || true
    echo -e "    ${GREEN}✓${NC} $skill_name"
    ((count++))
  done

  echo -e "  ${GREEN}✓${NC} $count skills instaladas em $name ($scope)"
}

# Executa para cada alvo
if [ "$TARGET" = "both" ] || [ "$TARGET" = "opencode" ]; then
  echo -e "${BLUE}→ Instalando no OpenCode...${NC}"
  install_target opencode "$SCOPE" "$PROJECT_ROOT" || true
fi
if [ "$TARGET" = "both" ] || [ "$TARGET" = "claude" ]; then
  echo -e "${BLUE}→ Instalando no Claude Code...${NC}"
  install_target claude "$SCOPE" "$PROJECT_ROOT" || true
fi

echo ""
echo -e "${GREEN}✓ L-Spec instalado!${NC}"
echo "Use: /l spec | /l discover | /l specify | /l design | /l tasks | /l execute"
echo ""
