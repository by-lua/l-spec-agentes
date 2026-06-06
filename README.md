# L-Spec

SDD (Spec-Driven Development) para Claude Code e OpenCode — **projetos novos E existentes**.

Não sabe por onde começar? O L-Spec mapeia o código existente, constrói a documentação e só então implementa. Tudo começa com spec, nunca com código.

> Este projeto foi **adaptado do [L-Spec PI](https://github.com/by-lua/lspec-pi)** — a versão original para PI.dev. As funcionalidades são idênticas; as ferramentas de suporte e o instalador são específicos para Claude Code e OpenCode.

## O que é SDD?

SDD é desenvolver por especificação primeiro e código depois.
No L-Spec: discovery adaptativo, requisitos claros, tarefas atômicas e execução verificável.

### Sem SDD você perde

- Clareza de escopo (o projeto vai crescendo no improviso)
- Rastreabilidade (fica difícil provar o que foi validado)
- Continuidade entre sessões (cada conversa recomeça do zero)
- Qualidade de entrega (mais bug, mais retrabalho, commits confusos)

### Com L-Spec você ganha

- Discovery adaptativo + requisitos claros antes de codar
- Research obrigatório (análise do codebase)
- Execution por tarefas atômicas e verificáveis
- Menos reescrita, menos bugs e commits mais limpos
- **Contexto vivendo no projeto (`.specs/`) e não só na memória do agente**

> O conhecimento do projeto fica versionado no repositório.
> Qualquer agente pode continuar de onde parou, sem depender da memória de uma sessão específica.

---

## Pipeline Completo com Gates

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    L-SPEC PIPELINE COM GATES                               │
├───────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐│
│  │DISCOVERY │───▶│ RESEARCH │───▶│ SPECIFY  │───▶│ TASKS  │───▶│ EXECUTE  ││
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘│
│       │              │              │                           │            │
│       ▼              ▼              ▼                           ▼            │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐              ┌──────────┐      │
│  │ DISCUSS* │    │ DISCUSS* │    │ CLARIFY* │              │  GATE    │      │
│  └──────────┘    └──────────┘    └──────────┘              │  CHECK   │      │
│       │              │              │                      └──────────┘      │
│       ▼              ▼              ▼                           │ │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐               ▼            │
│  │  STATE │    │  STATE   │    │  STATE   │           ┌──────────┐      │
│  │  GATE    │    │  GATE    │    │  GATE    │           │  COMMIT  │      │
│  └──────────┘    └──────────┘    └──────────┘           └──────────┘      │
│                                                                             │
│  (*) OPCIONAL — só se área cinzenta/ambígua ou necessidade arquitetural    │
└───────────────────────────────────────────────────────────────────────────────┘
```

### Tabela de Fases

| FASE       | QUANDO RODA                                         |
|------------|------------------------------------------------------|
| Discovery  | SEMPRE                                               |
| Research   | SEMPRE (OBRIGATÓRIO antes de Specify)                |
| Discuss*   | OPCIONAL — só se área cinzenta/ambígua              |
| Specify | SEMPRE (OBRIGATÓRIO)                                |
| Clarify*   | OPCIONAL — só se ambiguidade nos requisitos           |
| Design*    | OPCIONAL — só se necessidade arquitetural            |
| Tasks      | SEMPRE                                               |
| Execute    | SEMPRE                                               |

### Auto-detecção

- `BUG` → Discovery curto (3 perguntas) → Research → Tasks → Execute
- `FEATURE` → Discovery focado → Research → Specify → Tasks → Execute
- `NOVO` → 6 fases completas + Research

---

## Gates e Travamentos (Enforcement)

###1. Compliance Gate (Bloqueante)

**Antes de QUALQUER edit no código**, execute o checklist:

```
┌────────────────────────────────────────────────────────────────┐
│ COMPLIANCE GATE CHECKLIST                                       │
├────────────────────────────────────────────────────────────────┤
│ [ ] 1. Discovery completo — contexto coletado                  │
│ [ ] 2. Requirements claros — spec.md existente │
│ [ ] 3. Design verificado — design.md existe (se aplicável)    │
│ [ ] 4. Tasks aprovadas — tasks.md com artefatos definidas     │
│ [ ] 5. State atualizado — STATE.md reflete estado atual       │
└────────────────────────────────────────────────────────────────┘
```

**Se qualquer item ❌ → BLOQUEIA. Resolva antes de editar.**

### 2. State Saved Gate (Bloqueante)

**Entre cada fase**, verifique:

```
┌────────────────────────────────────────────────────────────────┐
│ STATE SAVED GATE │
├────────────────────────────────────────────────────────────────┤
│ [ ] STATE.md existe para esta feature                          │
│ [ ] Última fase completada está marcada                       │
│ [ ] Progresso atualizado (ROADMAP.md)                         │
│ [ ] Decisões documentadas (AD-NNN)                            │
│ [ ] Blockers identificados (B-NNN)                            │
└────────────────────────────────────────────────────────────────┘
```

### 3. Design Reference Enforcement

**Antes de implementar (Execute)**, se Design foi executado:

```
┌────────────────────────────────────────────────────────────────┐
│ DESIGN REFERENCE ENFORCEMENT                                   │
├────────────────────────────────────────────────────────────────┤
│ [ ] design.md existe em features/[name]/                       │
│ [ ] Design foi aprovado pelo usuário                          │
│ [ ] Componentes definidos no design                           │
│ [ ] Interfaces documentadas                                    │
│ [ ] Code reuse identificado                                   │
└────────────────────────────────────────────────────────────────┘
```

### 4. Artifact Enforcement

Cada fase produz **artefatos** que a próxima fase precisa. Sem artefato = bloqueia.

| FASE       | PRODUZ                  | PRÓXIMA FASE PRECISA    |
|------------|-------------------------|-------------------------|
| Discovery  | PROJECT.md, ROADMAP.md   | Research, Specify       |
| Research   | findings documentados    | Design, Specify         |
| Specify    | spec.md                 | Tasks, Design           |
| Design     | design.md               | Tasks |
| Tasks      | tasks.md                | Execute |
| Execute    | código + commits        | validação final         |

**Sem artefato da fase anterior → Execute bloqueado.**

### 5. Enforcement Pattern

O padrão de enforcement combina **Compliance Gate + State Saved Gate**:

```
┌─────────────────────────────────────────────────────────────────┐
│ ENFORCEMENT PATTERN (OBRIGATÓRIO)                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ANTES DE CADA FASE:                                            │
│  ┌──────────────────┐    ┌──────────────────┐                   │
│  │ Compliance Gate  │ AND │ State Saved Gate │                   │
│  │ (5 itens)        │     │ (verificação)    │                   │
│  └────────┬─────────┘    └────────┬─────────┘                   │
│           │                       │                              │
│           └───────────┬───────────┘                              │
│                       ▼                                          │
│              ┌──────────────┐                                    │
│              │ AVANÇAR?     │                                    │
│              └──────────────┘                                    │
│                                                                  │
│  AMBOS gates devem passar para prosseguir.                      │
│  Se um falhar → BLOQUEIA e resolve antes.                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## NUNCA Rules (Completas)

**NUNCA:**
- Quick mode
- Auto-sizing
- Pular fases obrigatórias
- Parar no meio do fluxo
- Editar código fora do spec/design
- Pular Autosave de estado
- Prosseguir com gate vermelho
- Criar estrutura `fixes/` (tudo é feature — prefixo `fix-`/`bug-` em `features/`)
- Fabricar informação (se não sabe, diga "não sei")
- Modificar testes escritos no RED
- Enfraquecer asserções para passar
- "While I'm here" durante implementação

**SEMPRE:**
- Pipeline completo (mesmo em BUG flow)
- Autosave de estado em cada fase
- Confirmar antes de avançar
- Atualizar STATE.md
- Verificar design.md antes de implementar
- Testes primeiro (RED phase)
- Gate check após cada tarefa
- Commit atômico por tarefa
- Reuse de código existente

---

## Fluxo por Tipo

**PROJETO NOVO:**
```
Discovery (completo) → Research → Discuss? → Specify → Clarify? → Design? → Tasks → Execute
```

**BUG:**
```
Discovery (curto) → Research → Specify → Tasks → Execute
```

**FEATURE:**
```
Discovery (focado) → Research → Specify → Clarify? → Tasks → Execute
```

**PROJETO EXISTENTE (sem .specs/):**
```
Discovery (curto) → Research → Specify → Clarify? → Design? → Tasks → Execute
```

---

## Research — Análise do Codebase (NÃO perguntas ao usuário)

Fase **OBRIGATÓRIA** entre Discovery e Specify.

**Quando executar:**
- Feature envolve tecnologia unfamiliar
- Integrações com sistemas novos
- Padrões não usados anteriormente neste codebase

**Knowledge Verification Chain (ordem estrita):**
```
Codebase → Project docs → Context7 MCP → Web search → Flag as uncertain
```

**CRITICAL: NUNCA assuma ou fabrication informação.** Se não conseguir encontrar resposta, diga "Eu não sei" ou "Não consegui encontrar documentação para isso". Informação inventada propaga através de design → tasks → implementação e causa falhas em cascata.

---

## Estrutura de Projeto

```
.specs/
├── project/
│   ├── PROJECT.md       # Visão, objetivos, stack
│   ├── ROADMAP.md       # Features e milestones
│   └── STATE.md         # Decisões, blockers, estado atual
└── features/
    └── [feature]/
        ├── spec.md      # Requisitos testáveis
        ├── context.md   # Decisões de áreas cinzentas (opcional)
        ├── design.md    # Decisões arquiteturais (opcional)
        └── tasks.md     # Tarefas atômicas
```

**Nota:** Bugs são registrados como features em `features/` — prefixo `fix-` ou `bug-` no nome.

---

## Autosave de Estado

**Em cada fase, AO FINALIZAR:**
1. Salvar decisões em STATE.md
2. Atualizar progresso em ROADMAP.md
3. Persistir contexto para próxima sessão

**STATE.md atualizado:**
- AD-NNN: decisões
- B-NNN: blockers
- L-NNN: aprendizados
- Todos pendentes
- Deferred ideas

---

## Git Workflow

**Onde editar:**
1. Clone o repositório git do projeto
2. Edite no clone local
3. Commit atômico por tarefa
4. Push quando gate passar

**Formato de commit (Conventional Commits 1.0.0):**
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types permitidos:** `feat`, `fix`, `refactor`, `docs`, `test`, `style`, `perf`, `build`, `ci`, `chore`

**Regras:**
- One task = one commit
- Description = o que foi FEITO, não planejado
- Include only files in task definition
- Tests no mesmo commit se parte da tarefa

---

## Ferramentas Recomendadas

### Claude Code / OpenCode Tools

**Code navigation via `codenavi` (LSP-aware):**

- `codenavi search` — busca por símbolos
- `codenavi goto` — ir para definição
- `codenavi refs` — referências cruzadas

**Diagramas via `mermaid-studio`:**
- Renderiza Mermaid em ASCII no terminal

**Documentação via `@upstash/context7-mcp` (MCP server):**
- Resolve IDs de bibliotecas
- Query na documentação atual via Context7

```bash
npm install -g codenavi        # navegação de código (LSP-aware)
npm install -g mermaid-studio  # diagramas Mermaid em ASCII no terminal
npm install -g @upstash/context7-mcp  # documentação de libs via Context7 (MCP server)
```

> Recomendação: `codenavi` é o mais importante para reverse e discovery.

---

## Pitfalls Críticos

### 1. Fabricação de Informação
```
❌ "Provavelmente funciona assim..."
✅ "Não sei, vou pesquisar"
```

### 2. Pular Gates
```
❌ "Vou pular o gate check, parece ok"
✅ "Gate vermelho = para e resolve"
```

### 3. Scope Creep
```
❌ "Enquanto estou aqui, já vou fazer X"
✅ "Is this in my task definition? If no, don't touch it"
```

### 4. Silenciar Testes
```
❌ "Vou desabilitar esse teste temporariamente"
✅ "Teste falhando = problema real, resolve"
```

### 5. Auto-sizing
```
❌ "Parece que é só isso, vou ajustar"
✅ "Verificar blast radius manualmente"
```

### 6. Saltar Autosave
```
❌ "Vou lembrar do estado mentalmente"
✅ "STATE.md atualizado após cada fase"
```

### 7. Testes Fracos
```
❌ "Teste passa sem implementação = ok"
✅ "Teste deve falhar no RED, passar no GREEN"
```

### 8. SPEC_DEVIATION Silenciosa
```
❌ "Implementation divergiu, mas tudo bem"
✅ "// SPEC_DEVIATION: [what diverged] // Reason: [why]"
```

---

## Qual Comando Usar

### Single Entry Point — `/lspec`

O comando `/lspec` é o **único ponto de entrada**. Ele auto-detecta o tipo de projeto e executa o pipeline completo.

**Não precisa escolher comando por fase.** O sistema avança automaticamente.

| Cenário | Comando | O que acontece |
|---------|---------|----------------|
| Projeto novo | `/lspec criar um sistema de...` | Discovery completo (17 perguntas) → Research → Specify → ... |
| Feature em projeto existente | `/lspec adicionar login com...` | Discovery focado → Research → Specify → ... |
| Bug em projeto existente | `/lspec corrigir erro de...` | Discovery curto (3 perguntas) → Research → Tasks → Execute |
| Projeto existente sem specs | `/lspec mapear o código atual` | **Reverse mode** — survey do código → spec gerada automaticamente |

### Reverse — Quando Usar

Use `/lspec reverse` (ou `/lspec mapear`) quando:

- Projeto existe mas **não tem `.specs/`**
- Precisa entender estrutura antes de mexer
- Vai接手 projeto de outra pessoa

O reverse escaneia o código, gera `.specs/project/` e `.specs/features/[name]/` automaticamente.

---

## Comandos Disponíveis

| Comando         | Descrição                                    |
|-----------------|---------------------------------------------|
| `/lspec`        | Fluxo principal (single entry point)          |
| `/lspec discover` | Discovery de projeto                       |
| `/lspec specify` | Definir feature |
| `/lspec design`  | Design técnico                              |
| `/lspec tasks`   | Decompor em tarefas                        |
| `/lspec execute` | Executar tarefas |
| `/lspec ask`     | Perguntar durante processo                  |
| `/lspec pause`   | Pausar sessão                               |
| `/lspec resume`  | Resumir sessão                             |
| `/lspec help`    | Ajuda                                       |

---

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

## Referências internas

- `skills/lspec/README.md`
- `skills/lspec/SKILL.md`
- `skills/lspec-discovery/SKILL.md`
- `skills/lspec-specify/SKILL.md`
- `skills/lspec-design/SKILL.md`
- `skills/lspec-tasks/SKILL.md`
- `skills/lspec-execute/SKILL.md`
- `skills/lspec-auto/SKILL.md`
- `skills/lspec-next/SKILL.md`
- `skills/lspec-validate/SKILL.md`
- `skills/lspec-resume/SKILL.md`
- `skills/lspec-pause/SKILL.md`
