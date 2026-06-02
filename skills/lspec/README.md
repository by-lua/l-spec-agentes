<p align="center">
  <img src="https://img.shields.io/badge/Skill-L--Spec-blue?style=for-the-badge" alt="skill badge" />
  <img src="https://img.shields.io/badge/Mode-Discovery%20Adaptive-green?style=for-the-badge" alt="discovery adaptive" />
  <img src="https://img.shields.io/badge/Version-3.0.0-purple?style=for-the-badge" alt="version" />
</p>

<h1 align="center">🎯 L-Spec</h1>

<p align="center">
  <strong>Spec-Driven Development para Claude Code e OpenCode: discovery adaptativo, execução orientada a tarefas e continuidade real de sessão.</strong>
</p>

<p align="center">
  <strong>Maintained by:</strong> <a href="https://github.com/by-lua">by-lua</a>
</p>

<p align="center">
  <sub>Base conceitual inspirada no TLC Spec-Driven (Tech Lead's Club), com evolução prática para agentes de código.</sub>
</p>

## ✨ O que é SDD e o que é o L-Spec?

**SDD (Spec-Driven Development)** é desenvolver por especificação primeiro e código depois.
No L-Spec, isso vira um fluxo prático de trabalho para IA: descoberta, definição, quebra em tarefas e execução verificável.

**L-Spec** organiza o trabalho em fluxo consistente, mantendo rigor e sem pular etapas essenciais.

## 🧩 Ferramentas opcionais recomendadas

Para experiência completa, instale as ferramentas de navegação e diagramas:

```bash
npm install -g codenavi        # navegação de código (LSP-aware, brownfield mapping, dependências)
npm install -g mermaid-studio  # diagramas Mermaid (arquitetura, fluxos, sequência)
npm install -g @upstash/context7-mcp  # documentação atualizada de libs
```

| Ferramenta | O que faz |
|------------|-----------|
| `codenavi` | Navegação de código, LSP-aware (go to definition, referências, símbolos, rename), brownfield mapping |
| `mermaid-studio` | Diagramas Mermaid renderizados (arquitetura, fluxos, sequência) |
| `@upstash/context7-mcp` | Documentação de libs atualizada via Context7 (MCP server) |

> **Fallback:** L-Spec funciona standalone sem nenhuma dessas ferramentas. Recomendação: instale `codenavi` para reverse/discovery, as outras são opcionais.

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/by-lua/l-spec-agentes/main/install.sh | bash
```

Para ajuda: `bash install.sh --help`