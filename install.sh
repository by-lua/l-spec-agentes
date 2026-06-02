#!/usr/bin/env bash
# L-Spec — Instalador para Claude Code e OpenCode
set -uo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_URL="https://github.com/by-lua/l-spec-agentes.git"
SKILLS_SOURCE="skills"

# ── Ler args ou entrar no modo interativo ───────────────────────────────────
ask_interactive() {
  echo ""
  echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║     L-Spec — Instalador                ║${NC}"
  echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
  echo ""

  # 1) Qual agente?
  echo -e "${YELLOW}Qual agente?${NC}"
  echo "  1) OpenCode"
  echo "  2) Claude Code"
  echo "  3) Ambos"
  echo -n "Escolha (1/2/3) [3]: "
  read -r agent_choice
  agent_choice="${agent_choice:-3}"
  
  case "$agent_choice" in
    1) TARGET="opencode" ;;
    2) TARGET="claude" ;;
    3) TARGET="both" ;;
    *) echo -e "${RED}✗ Opção inválida${NC}"; exit 1 ;;
  esac

  # 2) Escopo?
  echo ""
  echo -e "${YELLOW}Escopo?${NC}"
  echo "  1) Global — skills disponíveis para todos os projetos"
  echo "  2) Projeto — skills só neste projeto (cria .claude/ ou .opencode/)"
  echo -n "Escolha (1/2) [1]: "
  read -r scope_choice
  scope_choice="${scope_choice:-1}"
  
  case "$scope_choice" in
    1) SCOPE="global"; PROJECT_ROOT="" ;;
    2) SCOPE="project"
       echo -n "Caminho do projeto [$(pwd)]: "
       read -r proj
       PROJECT_ROOT="${proj:-$(pwd)}" ;;
    *) echo -e "${RED}✗ Opção inválida${NC}"; exit 1 ;;
  esac

  # 3) Confirmar
  echo ""
  echo -e "${BLUE}Resumo:${NC}"
  echo "  Agente(s): $TARGET"
  echo "  Escopo:    $SCOPE${PROJECT_ROOT:+, projeto: $PROJECT_ROOT}"
  echo -n "Confirmar? [Y/n]: "
  read -r confirm
  if [[ "$confirm" =~ ^[Nn] ]]; then
    echo "Aborted."
    exit 0
  fi
}

# ── Modo não-interativo: parse args ──────────────────────────────────────
parse_args() {
  TARGET="${1:-both}"
  SCOPE="${2:-global}"
  PROJECT_ROOT="${3:-}"
}

# ── Paths ──────────────────────────────────────────────────────────────────
opencode_global_skills()  { echo "$HOME/.config/opencode/skills"; }
opencode_global_commands() { echo "$HOME/.config/opencode/commands"; }
opencode_project_skills()  { echo "$1/.opencode/skills"; }
opencode_project_commands(){ echo "$1/.opencode/commands"; }
opencode_project_config()  { echo "$1/.opencode/opencode.json"; }

claude_global_skills()   { echo "$HOME/.claude/skills"; }
claude_project_skills() { echo "$1/.claude/skills"; }
claude_project_commands(){ echo "$1/.claude/commands"; }

# ── Listar skills ──────────────────────────────────────────────────────────
list_skills() {
  local src="$SKILLS_SOURCE"
  find "$src" -maxdepth 1 -type d | while read -r d; do
    [[ "$(basename "$d")" == "skills" ]] && continue
    echo "$(basename "$d")"
  done | sort
}

# ── Copiar skill ──────────────────────────────────────────────────────────
copy_skill() {
  local src="$1" dst="$2"
  mkdir -p "$dst"
  rm -rf "$dst"/*
  cp -R "$src/"* "$dst/"/
}

# ── Instalar OpenCode ─────────────────────────────────────────────────────
install_opencode() {
  local scope="$1"; local proj_root="$2"
  echo ""
  echo -e "${BLUE}── OpenCode ──────────────────────────────${NC}"

  if [ "$scope" = "global" ]; then
    skills_dir="$(opencode_global_skills)"
    commands_dir="$(opencode_global_commands)"
  else
    skills_dir="$(opencode_project_skills "$proj_root")"
    commands_dir="$(opencode_project_commands "$proj_root")"
  fi

  # Verificar ou criar dir
  if [ "$scope" = "global" ] && [ ! -d "$skills_dir" ]; then
    echo -e "  ${YELLOW}→ Criando diretório global: $skills_dir${NC}"
    mkdir -p "$skills_dir"
    mkdir -p "$commands_dir"
  elif [ "$scope" = "project" ]; then
    mkdir -p "$skills_dir"
    mkdir -p "$commands_dir"
    # Gerar opencode.json se não existir
    local cfg="$(opencode_project_config "$proj_root")"
    if [ ! -f "$cfg" ]; then
      mkdir -p "$(dirname "$cfg")"
      cat > "$cfg" <<'JSON'
{
  "skills": {
    "paths": [".opencode/skills"]
  }
}
JSON
      echo -e "  ${GREEN}✓${NC} opencode.json criado"
    fi
  fi

  # Copiar skills
  local count=0
  for skill in $(list_skills); do
    copy_skill "$SKILLS_SOURCE/$skill" "$skills_dir/$skill"
    echo -e "  ${GREEN}✓${NC} $skill (skill)"
    ((count++))
  done

  # Copiar slash commands (cada skill com command.md → .md)
  local cmd_count=0
  for skill in $(list_skills); do
    if [ -f "$SKILLS_SOURCE/$skill/SKILL.md" ]; then
      # Gerar command a partir do nome da skill
      local cmd_name="lspec-$(echo "$skill" | sed 's/lspec-//')"
      cat > "$commands_dir/${cmd_name}.md" <<CMD
# $skill

Carrega a skill L-Spec: $skill

\`\`\`markdown
---
command: $cmd_name
---
\`\`\`

CMD
      echo -e "  ${GREEN}✓${NC} $cmd_name (slash command)"
      ((cmd_count++))
    fi
  done

  echo -e "  ${GREEN}✓${NC} $count skills + $cmd_count comandos instalados"
  echo "  Path: $skills_dir"
}

# ── Instalar Claude Code ───────────────────────────────────────────────────
install_claude() {
  local scope="$1"; local proj_root="$2"
  echo ""
  echo -e "${BLUE}── Claude Code ───────────────────────────${NC}"

  if [ "$scope" = "global" ]; then
    skills_dir="$(claude_global_skills)"
  else
    skills_dir="$(claude_project_skills "$proj_root")"
  fi

  # Verificar ou criar dir
  if [ "$scope" = "global" ] && [ ! -d "$skills_dir" ]; then
    echo -e "  ${YELLOW}→ Criando diretório global: $skills_dir${NC}"
    mkdir -p "$skills_dir"
  elif [ "$scope" = "project" ]; then
    mkdir -p "$skills_dir"
  fi

  # Copiar skills
  local count=0
  for skill in $(list_skills); do
    copy_skill "$SKILLS_SOURCE/$skill" "$skills_dir/$skill"
    echo -e "  ${GREEN}✓${NC} $skill"
    ((count++))
  done

  echo -e "  ${GREEN}✓${NC} $count skills instaladas"
  echo "  Path: $skills_dir"
}

# ── Main ───────────────────────────────────────────────────────────────────
main() {
  if [ $# -eq 0 ]; then
    ask_interactive
  else
    parse_args "$@"
    if [ "$SCOPE" = "project" ] && [ -z "$PROJECT_ROOT" ]; then
      echo -e "${RED}✗ Escopo project requer o caminho do projeto como 3º argumento${NC}"
      exit 1
    fi
  fi

  echo ""
  echo -e "${GREEN}Installing L-Spec${NC} → $TARGET ($SCOPE)"

  local run_both=false
  case "$TARGET" in
    both) run_both=true; install_opencode "$SCOPE" "$PROJECT_ROOT"; install_claude "$SCOPE" "$PROJECT_ROOT" ;;
    opencode) install_opencode "$SCOPE" "$PROJECT_ROOT" ;;
    claude) install_claude "$SCOPE" "$PROJECT_ROOT" ;;
    *) echo -e "${RED}✗ Destino desconhecido: $TARGET${NC}"; echo "Use: opencode | claude | both"; exit 1 ;;
  esac

  echo ""
  echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║  ✓ L-Spec instalado com sucesso!      ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
  echo ""
  echo "Use: /lspec discover | /lspec specify | /lspec design | /lspec tasks | /lspec execute"
  echo ""
}

main "$@"