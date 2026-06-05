---
name: lspec
description: Spec-Driven Development para Claude Code e OpenCode. Fluxo Discovery→Specify→Tasks→Execute obrigatório. Clarify e Design são opcionais. Baseado no TLC Spec-Driven v2.
license: CC-BY-4.0
metadata:
  author: Felipe Rodrigues - github.com/felipfr
  version: 2.0.0
---

## ⚡ AUTO-TRIGGER — DETECÇÃO AUTOMÁTICA DE INTENÇÃO

**REGRRA ABSOLUTA:** Enquanto esta skill estiver carregada, QUALQUER menção do usuário a uma das situações abaixo DEVE disparar automaticamente o fluxo de Discovery (`lspec discovery`). NÃO espere o usuário digitar `/lspec discovery` manualmente.

**Como funciona:** detecte a categoria pelo contexto, pergunte o MÍNIMO necessário e avance para Specify → Tasks → Execute seguindo o fluxo obrigatório.

> ⚠️ **PROIBIDO delegar subagente (Explorer/Fixer/Coder/etc) diretamente sem antes passar pelo Discovery**

---

### Gatilhos para PROJETO NOVO / INICIALIZAÇÃO
iniciar projeto, novo projeto, setup, começar do zero, greenfield, projeto do zero, criar projeto, quero criar, vamos criar, bora criar, montar um projeto, estrutura inicial, organizar projeto, configurar projeto, setup inicial, iniciar do zero, partir do zero, esqueleto, boilerplate, scaffold, inicializar repositório

### Gatilhos para FEATURE / FUNCIONALIDADE NOVA
feature, funcionalidade, adicionar, adiciona, criar, implementar, quero que faça, preciso que, fazer uma, preciso de uma, nova funcionalidade, novo recurso, nova capability, novo módulo, quero adicionar, capacidade nova, adicionar suporte, suporte a, habilitar, ativar, permitir, criar sistema de, criar módulo de, criar tela de, criar página de, adicionar página, adicionar tela, criar componente, novo comando, novo endpoint, nova rota, nova API, novo serviço, nova integração, integração com, conectar com, ligar com, sincronizar com, integrar com, importar dados de, exportar dados para, gerar relatório de, dashboard de, painel de, tela de, formulário de, listagem de, cadastro de, registro de, busca de, pesquisa de, filtro de, ordenação de, paginação de, autenticação, login, cadastro, registro, recuperar senha, notificação, email, push, webhook, CRUD de

### Gatilhos para BUG / CORREÇÃO / ERRO
bug, corrige, corrigir, correção, quebrou, quebrado, erro, errado, crash, crashou, travou, não funciona, não está funcionando, não está rodando, não roda, não carrega, não aparece, não mostra, não exibe, não envia, não recebe, não salva, não atualiza, não deleta, não responde, resposta vazia, retorno vazio, retorna vazio, deu erro, deu ruim, falha, falhou, failure, fail, exception, exceção, exception log, stack trace, traceback, panic, pânico, loop infinito, timeout, estourou, memória, memory leak, vazamento, null pointer, undefined, NaN, infinito, broken, quebrado, corrompido, duplicado, registro duplicado, inconsistente, inconsistência, fora do ar, offline, 404, 500, 403, 401, erro de, problema com, problema em, problema no, tá zuado, tá estranho, tá esquisito, tá bugado, tá com erro, tá quebrado, tá dando erro, tá falhando, tá caindo, tá offline, tá fora

### Gatilhos para TESTE / VALIDAÇÃO / E2E (inclusive em produção)
testar, testei, testando, teste, rodar teste, executar teste, validar, validação, verificar, verificação, checar, checagem, conferir, conferência, e2e, end-to-end, ponta a ponta, fluxo completo, teste manual, teste automatizado, bateria de testes, suite de testes, regressão, smoke test, teste de aceitação, UAT, teste em produção, testar no site, testar ao vivo, testar no live, testar no real, testa no ambiente, testa no live, testa em produção, testa no site, testa no real, sobe e testa, subir e testar, colocar no ar e testar, rodar no live, fazer teste, testa produção, homologação, teste funcional, cenário de teste, script de teste, até o final, fluxo até o fim, fluxo completo, simular checkout, simular compra, simular usuário, simular fluxo, bater o site, bater endpoint, fazer requisição, ver se passa, ver se quebra, ver o que acontece, ver se funciona, ver se tá ok, ver se roda, testar API, testar endpoint, testar fluxo de, testar funcionalidade, experimentar testar

### Gatilhos para REVERSE / MAPEAMENTO / ANÁLISE DE CÓDIGO
reverse, mapear, mapeamento, mapeia, reverse engineer, engenharia reversa, analisar código, analisar código fonte, entender código, documentar código, documentar arquitetura, documentar projeto, fazer mapa, gerar mapa, mapear código, mapear estrutura, descobrir como funciona, como é o código, como tá organizado, qual a stack, quais tecnologias, stack do projeto, estrutura do projeto, arquitetura do projeto, levantar requisitos, levantar funcionalidades, catalogar, inventariar, auditar, analisar dependências, quais libs, quais pacotes, código legado, brownfield, explorar código, mapear fluxo, mapear rotas, mapear endpoints

### Gatilhos para PEQUENA MUDANÇA / AJUSTE RÁPIDO
ajuste, ajustar, pequena mudança, mudança pequena, alteração simples, alteração rápida, tweak, ajuste fino, modificar, modifica, alterar, altera, atualizar, atualiza, mudar, muda, renomear, renomeia, trocar, troca, substituir, substitui, editar, edita, remover, remove, deletar, deleta, apagar, apaga, limpar, limpa, refatorar, refatora, reorganizar, reorganiza, mover, move, copiar, copia, extrair, extrai, inline, inlinar, simplificar, simplifica, melhorar, melhora, otimizar, otimiza, performático, performance, lentidão, lento, demora, lerdou, deixar mais rápido, acelerar

### Gatilhos para DISCUSSÃO / DÚVIDA / CONVERSA SOBRE O PROJETO
sobre o projeto, sobre a arquitetura, o que acha, como faria, melhor abordagem, melhor forma, como implementar, como fazer, dúvida sobre, dúvida de, qual a melhor, qual caminho, o que recomenda, sugestão, sugestões, opinião, conselho, brainstorm, pensar junto, discutir, debate, conversar sobre, trocar ideia, alinhar, esclarecer, ajuda com, help com, visão geral, ideia inicial, conceito, proposta, o que você pensa

---

> **Total:** centenas de gatilhos em 7 categorias (projeto novo, feature, bug, teste/E2E, reverse, pequena mudança, discussão).  
> Ao detectar qualquer um, **NÃO** delegue subagente — inicie Discovery e pergunte o mínimo necessário.

---

# LSpec PI (base TLC original)

> PI adaptation note: this is an integral adaptation of TLC original for PI.
> Keep TLC behavior as source of truth; adapt only command surface and packaging in PI.
> Command aliases in PI: /lspec, /lspec-discovery, /lspec-specify, /lspec-design, /lspec-tasks, /lspec-execute, /lspec-ask, /lspec-pause, /lspec-resume.


Plan and implement projects with precision. Granular tasks. Clear dependencies. Right tools. Zero ceremony.

```
┌───────────┐   ┌──────────┐   ┌──────────┐   ┌─────────┐   ┌─────────┐
│ DISCOVERY │ → │ SPECIFY  │ → │ CLARIFY* │ → │ DESIGN* │ → │  TASKS  │ → │ EXECUTE │
└───────────┘   └──────────┘   └──────────┘   └─────────┘   └─────────┘
   required        required       optional      optional      required      required

* Opcional por contexto da tarefa
```

## Fluxo Base do L-Spec PI

Fluxo fixo: todo trabalho passa por `Discovery → Specify → Tasks → Execute`.

Regras:
- Discovery: obrigatório (sempre inicia aqui)
- Specify: obrigatório
- Tasks: obrigatório
- Execute: obrigatório
- Clarify: opcional, apenas quando houver ambiguidade real
- Design: opcional, apenas quando houver decisão arquitetural/padrão novo

## Project Structure

```
.specs/
├── project/
│   ├── PROJECT.md      # Vision & goals
│   ├── ROADMAP.md      # Features & milestones
│   └── STATE.md        # Memory: decisions, blockers, lessons, todos, deferred ideas
├── codebase/           # Brownfield analysis (existing projects)
│   ├── STACK.md
│   ├── ARCHITECTURE.md
│   ├── CONVENTIONS.md
│   ├── STRUCTURE.md
│   ├── TESTING.md
│   ├── INTEGRATIONS.md
│   └── CONCERNS.md
├── features/           # Feature specifications
│   └── [feature]/
│       ├── spec.md     # Requirements with traceable IDs
│       ├── context.md  # User decisions for gray areas (when clarify is needed)
│       ├── design.md   # Architecture & components (when design is needed)
│       └── tasks.md    # Atomic tasks with verification (required)
└── fixes/              # Bug fix documentation (sempre registrado)
    └── [fix-name]/
        ├── spec.md     # Bug description, root cause, solution
        └── context.md  # Decisions during fix (opcional)
```

## Workflow

**⚠️ REGRAS CRÍTICAS — OBRIGATÓRIO SEGUIR:**

### COMPLIANCE GATE — ANTES DE QUALQUER EDIT

**Este gate é BLOQUEANTE.** Roda antes de cada edit no código.

```
╔══════════════════════════════════════════════════════════════════╗
║  GATE: COMPLIANCE CHECK — antes de cada edit                   ║
╠══════════════════════════════════════════════════════════════════╣
║  □  .specs/features/<feature>/spec.md existe                   ║
║  □  spec.md foi lida e compreendida                            ║
║  □  Arquivos a editar estão listados na spec ou tasks          ║
║  □  Mudança NÃO foge do escopo da spec                         ║
║  □  STATE.md foi atualizado na última fase                     ║
╠══════════════════════════════════════════════════════════════════╣
║ ⚠️  Se ANY □ = false → BLOQUEIA. Não edita. Pergunta.        ║
╚══════════════════════════════════════════════════════════════════╝
```

### GATE: Estado Salvo Entre Fases

**Antes de iniciar qualquer fase nova:**

```
╔══════════════════════════════════════════════════════════════════╗
║  GATE: STATE SAVED — antes de iniciar nova fase                 ║
╠══════════════════════════════════════════════════════════════════╣
║  □  .specs/features/<feature>/STATE.md existe                  ║
║  □  Última fase registrada                                      ║
║  □  Pendências atualizadas                                      ║
║  □  Commits feitos (se aplicável)                               ║
╠══════════════════════════════════════════════════════════════════╣
║ ⚠️  Se ANY □ = false → SALVA ANTES de iniciar nova fase.      ║
╚══════════════════════════════════════════════════════════════════╝
```

### Proibidos

- ❌ **quick mode** — sempre implementar completo, sem atalhos
- ❌ **auto-sizing** — não redimensionar automaticamente sem aprovação
- ❌ **pular fases** — Discovery → Specify → Tasks → Execute (todas obrigatórias)
- ❌ **features em fixes/** — toda estrutura vai em `features/`
- ❌ **editar sem Compliance Gate** — verificar checklist antes de cada edit
- ❌ **não salvar STATE.md** — autosave é obrigatório, não opcional

---

**New project:**

1. Initialize project → PROJECT.md + ROADMAP.md
2. For each feature → Discovery → Specify → (Clarify) → (Design) → Tasks → Execute

**Existing codebase:**

1. Map codebase → 7 brownfield docs
2. Initialize project → PROJECT.md + ROADMAP.md
3. For each feature → mesmo fluxo fixo (Discovery → Specify → (Clarify) → (Design) → Tasks → Execute)

**Bug/fix:**

1. Discovery detecta bug → identifica pasta `features/[feature-afetada]/`
2. Specify do fix → documenta em `.specs/fixes/[fix-name]/spec.md`:
   - Bug report (comportamento esperado vs atual)
   - Root cause analysis (o que causou)
   - Solução implementada (o que mudou)
3. **Regra híbrida de feature spec:** No Specify, o fluxo avalia:
   - O fix **muda contrato/comportamento/saída esperada** da feature? → Atualiza `.specs/features/[feature-afetada]/spec.md` com a nova expectativa
   - O fix é só **correção de implementação interna**? → Feature spec original permanece. Só documenta em `fixes/`

   O critério é simples: se o teste de aceitação da feature mudar, o spec precisa ser atualizado. Se não, o spec continua verdadeiro e o fix é só histórico de aprendizado.

4. Tasks → Execute seguem o fluxo normal, carregando tanto a feature spec (quando aplicável) quanto o fix spec

## Context Loading Strategy

**Base load (~15k tokens):**

- PROJECT.md (if exists)
- ROADMAP.md (when planning/working on features)
- STATE.md (persistent memory)

**On-demand load:**

- Codebase docs (when working in existing project)
- CONCERNS.md (when planning features that touch flagged areas, estimating risk, or modifying fragile components)
- TESTING.md (when creating tasks or executing — drives test type assignment and gate checks)
- spec.md (when working on specific feature)
- context.md (when designing or implementing from user decisions)
- design.md (when implementing from design)
- tasks.md (when executing tasks)

**Never load simultaneously:**

- Multiple feature specs
- Multiple architecture docs
- Archived documents

**Target:** <40k tokens total context
**Reserve:** 160k+ tokens for work, reasoning, outputs
**Monitoring:** Display status when >40k (see [context-limits.md](references/context-limits.md))

## Sub-Agent Delegation

Use sub-agents (the Task tool or equivalent) to keep the main context window lean and enable
parallel execution. The orchestrating agent plans and coordinates; sub-agents do the heavy lifting.

**When to delegate to a sub-agent:**

| Activity | Delegate? | Why |
|---|---|---|
| Research (design phase, brownfield mapping) | Yes | Research output is large; only the summary matters to the main context |
| Implementing a task | Yes | File reads, edits, test output consume context; only the result matters |
| Parallel `[P]` tasks | Yes (one per task) | The only way to actually run tasks in parallel |
| Sequential tasks with no `[P]` | Yes | Keeps implementation artifacts out of the main context |
| Planning, task creation, validation reports | No | These require the full accumulated context to be coherent |
| Clarify/Design support tasks | Yes, when needed | Only if ambiguity or architecture decisions demand it |

**Context each sub-agent receives:**

The orchestrating agent MUST provide each sub-agent with:
- The specific task definition from tasks.md (What, Where, Depends on, Reuses, Done when, Tests, Gate)
- Relevant coding principles and conventions (coding-principles.md, CONVENTIONS.md)
- TESTING.md, if it exists (for gate check commands and test patterns)
- Any spec/design context the task references

The sub-agent does NOT receive: other tasks' definitions, accumulated chat history, validation reports
from other tasks, or STATE.md (unless the task explicitly references a decision/blocker).

**What sub-agents return:**

Each sub-agent reports back:
- Status: Complete | Blocked | Partial
- Files changed: [list]
- Gate check result: [pass/fail + test counts]
- SPEC_DEVIATION markers (if any)
- Issues encountered (if any)

The orchestrating agent uses this to update tasks.md status, traceability, and decide next steps.

## Commands

**Project-level:**
| Trigger Pattern | Reference |
|----------------|-----------|
| Initialize project, setup project | [project-init.md](references/project-init.md) |
| Create roadmap, plan features | [roadmap.md](references/roadmap.md) |
| Map codebase, analyze existing code | [brownfield-mapping.md](references/brownfield-mapping.md) |
| Document concerns, find tech debt, what's risky | [concerns.md](references/concerns.md) |
| Record decision, log blocker, add todo | [state-management.md](references/state-management.md) |
| Pause work, end session | [session-handoff.md](references/session-handoff.md) |
| Resume work, continue | [session-handoff.md](references/session-handoff.md) |

**Feature-level (fluxo padrão):**
| Trigger Pattern | Reference |
|----------------|-----------|
| Specify feature, define requirements | [specify.md](references/specify.md) |
| Discuss feature, capture context, how should this work | [discuss.md](references/discuss.md) |
| Design feature, architecture | [design.md](references/design.md) |
| Break into tasks, create tasks | [tasks.md](references/tasks.md) |
| Implement task, build, execute | [implement.md](references/implement.md) |
| Validate, verify, test, UAT, walk me through it | [validate.md](references/validate.md) |

## PI Package Integrations

This skill leverages complementary PI packages to enhance execution. Before specific tasks, check if the relevant PI package is available and prefer it when installed.

### Code Exploration → codenavi + codenavi

Whenever the workflow requires exploring or navigating code (brownfield mapping, code reuse analysis, pattern identification, dependency tracing, go-to-definition, references, diagnostics, symbols, rename), **always** check if `codenavi` and `@davehardy20/codenavi` are installed in the PI environment:

```bash
pi list | grep -E 'cymbal|lsp-tools'
```

If `codenavi` is installed, delegate code navigation and search to it — it provides a native layer for faster understanding and changes with less trial/error. If `codenavi` is also available, it adds LSP precision for technical implementation.

Fallback: if neither PI package is available, use the built-in code analysis tools (see [code-analysis.md](references/code-analysis.md)) and recommend:

```
pi install npm:codenavi
pi install npm:@davehardy20/codenavi
```

Display this recommendation at most once per session.

### Diagrams → mermaid-studio

Whenever the workflow requires creating or rendering mermaid diagrams (architecture overviews, data flows, component diagrams, sequence diagrams, etc.), **always** check if `mermaid-studio` is installed:

```bash
pi list | grep mermaid
```

If installed, delegate diagram rendering to `mermaid-studio` — it renders mermaid as ASCII in the TUI, making architecture and flow visible during the session without external tools. If not installed, proceed with inline mermaid code blocks as usual and recommend:

```
pi install npm:mermaid-studio
```

Display this recommendation at most once per session.

## Knowledge Verification Chain

When researching, designing, or making any technical decision, follow this chain in strict order. Never skip steps.

```
Step 1: Codebase → check existing code, conventions, and patterns already in use
Step 2: Project docs → README, docs/, inline comments, .specs/codebase/
Step 3: Context7 MCP → resolve library ID, then query for current API/patterns
Step 4: Web search → official docs, reputable sources, community patterns
Step 5: Flag as uncertain → "I'm not certain about X — here's my reasoning, but verify"
```

**Rules:**

- Never skip to Step 5 if Steps 1-4 are available
- Step 5 is ALWAYS flagged as uncertain — never presented as fact
- **NEVER assume or fabricate.** If you cannot find an answer, say "I don't know" or "I couldn't find documentation for this". Inventing APIs, patterns, or behaviors causes cascading failures across design → tasks → implementation. Uncertainty is always preferable to fabrication.

## Output Behavior

**Model guidance:** After completing lightweight tasks (validation, state updates, session handoff), naturally mention once that such tasks work well with faster/cheaper models. Track in STATE.md under `Preferences` to avoid repeating. For heavy tasks (brownfield mapping, complex design), briefly note the reasoning requirements before starting.

Be conversational, not robotic. Don't interrupt workflow—add as a natural closing note. Skip if user seems experienced or has already acknowledged the tip.

## Code Analysis

Use available tools with graceful degradation. See [code-analysis.md](references/code-analysis.md).
