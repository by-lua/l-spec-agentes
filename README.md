# L-Spec

SDD (Spec-Driven Development) para Claude Code e OpenCode, mantendo o fluxo completo de especificação antes da execução.

> Este projeto foi **adaptado do [L-Spec PI](https://github.com/by-lua/lspec-pi)** — a versão original para PI.dev. As funcionalidades são idênticas; as ferramentas de suporte e o instalador são específicos para Claude Code e OpenCode.

## O que é SDD?

SDD é desenvolver por especificação primeiro e código depois.
No L-Spec isso significa: discovery adaptativo, requisitos claros, tarefas atômicas e execução verificável.

## Por que SDD existe (e o que você perde sem ele)?

A maioria das sessões com IA perde 40–60% dos tokens com retrabalho: ambiguidade, reescrita e "achei que era isso".
O SDD reduz esse desperdício definindo o que será feito **antes** da implementação.

### Sem SDD você perde

- Clareza de escopo (o projeto vai crescendo no improviso)
- Rastreabilidade (fica difícil provar o que foi validado)
- Continuidade entre sessões (cada conversa recomeça do zero)
- Qualidade de entrega (mais bug, mais retrabalho, commits confusos)

### Com L-Spec você ganha

- Discovery adaptativo + requisitos claros antes de codar
- Execução por tarefas atômicas e verificáveis
- Menos reescrita, menos bugs e commits mais limpos
- **Contexto vivendo no projeto (`.specs/`) e não só na memória do agente**

> No L-Spec, o conhecimento do projeto fica versionado no repositório.
> Qualquer agente pode continuar de onde parou, sem depender da memória de uma sessão específica.

## Fluxo

`DISCOVERY → SPECIFY → (CLARIFY opcional) → (DESIGN opcional) → TASKS → EXECUTE`

- Sem quick mode
- Sem autosize
- Tudo passa por discovery adaptativo
- Autosave de estado
- Pause/Resume work
- Ask para perguntas durante o processo

## Instalação

```bash
curl -fsSL https://raw.githubusercontent.com/by-lua/l-spec-agentes/main/install.sh | bash
```

O instalador pergunta:
1. **Qual agente?** → OpenCode / Claude Code / Ambos
2. **Escopo?** → Global (skills pra todos os projetos) ou Projeto (só neste projeto)
3. **Confirmar?** → resumo antes de instalar

Para mais opções: `bash install.sh --help`

## Upgrade

```bash
curl -fsSL https://raw.githubusercontent.com/by-lua/l-spec-agentes/main/update.sh | bash
```
Ou simplesmente re-executar o install: `bash install.sh` — sobrescreve skills e scripts.

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/by-lua/l-spec-agentes/main/uninstall.sh | bash
```

## Ferramentas recomendadas

Use essas para experiência completa (todas opcionais — L-Spec funciona sem elas):

```bash
npm install -g codenavi        # navegação de código (LSP-aware)
npm install -g mermaid-studio  # diagramas Mermaid em ASCII no terminal
npm install -g @upstash/context7-mcp  # documentação de libs via Context7 (MCP server)
```

### codenavi
Navegação e busca de código nativa para o agente — acelera entendimento e mudanças com menos tentativa/erro.

### mermaid-studio
Renderiza diagramas Mermaid em ASCII no terminal, deixando arquitetura e fluxo visíveis durante a sessão sem ferramenta externa.

### @upstash/context7-mcp
Server MCP que resolve IDs de bibliotecas e faz query na documentação atual via Context7.

> Recomendação: `codenavi` é o mais importante para reverse e discovery.

## Comandos disponíveis

| Comando | Descrição |
|---------|-----------|
| `/lspec` | Fluxo principal |
| `/lspec discover` | Discovery de projeto |
| `/lspec specify` | Definir feature |
| `/lspec design` | Design técnico |
| `/lspec tasks` | Decompor em tarefas |
| `/lspec execute` | Executar tarefas |
| `/lspec ask` | Perguntar durante processo |
| `/lspec pause` | Pausar sessão |
| `/lspec resume` | Resumir sessão |
| `/lspec help` | Ajuda |

## Estrutura de arquivos

```
/
├── .specs/
│   ├── project/          # Project.md, ROADMAP.md, STATE.md
│   ├── features/         # specs de features
│   ├── fixes/            # specs de bugs
│   └── handoffs/         # pause/resume
└── .claude/ ou .opencode/
    └── skills/           # skills instaladas
```

## Recomendado: L-Spec Subagents (by-lua)

Extensão para delegação por especialidade:

- Opus como orquestrador
- Gemini como designer
- GPT como executor

Repo: https://github.com/by-lua/lspec-subagents

## Referências internas

- `skills/lspec/README.md`
- `skills/lspec/references/`