#!/usr/bin/env bash
# L-Spec — Atualizador (Claude Code + OpenCode)
set -uo pipefail

# Re-executa install (que faz update por copy)
exec "$(dirname "$0")/install.sh" "$@"
