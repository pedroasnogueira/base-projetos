> **Registro histórico.** Este é o documento de passagem do planejamento, guardado como estava. As instruções dele já foram executadas em 2026-11-21 (ver [`2026-11-21.md`](2026-11-21.md)). Não as siga de novo.

# Contexto de passagem: repositório base para todos os projetos

> Para a IA que vai ler isto: este documento resume uma sessão de planejamento anterior. Os arquivos da estrutura já estão nesta pasta (vieram do `estrutura-agentes.zip`). Leia este documento inteiro antes de agir.

---

## 1. Quem sou e o que quero

- Sou o Pedro, de Belo Horizonte. Estudo Engenharia de Software (3º período) e trabalho na área administrativa.
- Vou desenvolver projetos de qualquer tipo (sistemas empresariais, apps de finanças, sites, apps de celular, automações) **com ajuda de IA**: Claude Code em casa, Gemini no trabalho.
- Quero **um repositório base (template no GitHub)** para começar todo projeto novo, que:
  1. tenha toda a estrutura de pastas e documentação de um projeto profissional;
  2. tenha guias para que qualquer IA entenda o projeto e saiba como proceder;
  3. registre o porquê de cada mudança e decisão, para eu largar um projeto por 3 meses, voltar e ter todo o contexto;
  4. distribua as tarefas entre agentes e modelos (Opus/Sonnet/Haiku) para gastar menos tokens, sem perder qualidade;
  5. defina como estruturar o código (backend, frontend, mobile, site, scripts);
  6. faça a IA me responder de forma curta (**máximo 10 linhas**), direta e bem contextualizada, para eu entender e saber explicar tudo o que o projeto faz.

## 2. O que preciso que você faça

1. **Valide** a estrutura inteira contra os estudos e as boas práticas listados na seção 5. Confira também se as versões e ferramentas das stacks ainda são as recomendadas hoje.
2. **Ajuste** o que achar necessário, mas sempre com justificativa baseada em fonte. Mudança estrutural vira ADR.
3. **Complete o que falta** (seção 6).
4. **Crie o repositório no meu GitHub**, faça os commits seguindo Conventional Commits e marque o repositório como **template**.
5. **Me responda** seguindo `docs/guias/comunicacao.md`: no máximo 10 linhas por resposta, com o quê, por quê e onde. Os detalhes vão para arquivos.

Antes de criar o repositório, me pergunte só: **nome** do repositório e se ele vai ser **público ou privado**.

---

## 3. Decisões tomadas e por quê

### 3.1 Documentação e memória do projeto
| Decisão | Por quê |
|---|---|
| Docs dentro do repositório (*docs as code*) | A documentação muda no mesmo commit que o código e não desatualiza |
| **Não copiar o conteúdo dos commits para documentos** | O Git já guarda todas as mudanças. O que se perde é o **porquê** e o **onde parei**, e isso fica nos itens abaixo |
| ADRs em `docs/adr/` (formato de Michael Nygard) | Registram cada decisão importante com contexto e consequências. ADR aprovado não se edita: mudar de ideia gera um ADR novo, que substitui o anterior |
| Conventional Commits, com o porquê no corpo | Histórico legível que permite gerar o CHANGELOG automaticamente |
| CHANGELOG (Keep a Changelog) + SemVer | Resumo do que mudou em cada versão |
| `STATUS.md` + `docs/devlog/AAAA-MM-DD.md` | Onde parei, próximos passos e diário por sessão. Resolve o problema de voltar ao projeto depois de meses |
| Docs organizadas pelo Diátaxis (guias, referência, explicação) | Cada documento tem um propósito só, o que facilita a leitura para humanos e para a IA |

### 3.2 Contexto para a IA
| Decisão | Por quê |
|---|---|
| `AGENTS.md` como fonte da verdade; `CLAUDE.md` só tem `@AGENTS.md` | AGENTS.md é um padrão aberto lido por ~20 ferramentas (Codex, Cursor, Copilot, Gemini...). Eu uso Claude e Gemini |
| **AGENTS.md curto** (~55 linhas), com os detalhes em `docs/` | Um estudo da ETH Zurich (ICLR 2026, arXiv 2602.11988) mostrou que arquivos de contexto longos não melhoram a taxa de sucesso e aumentam o custo em mais de 20%. Recomendação: um roteiro prático, escrito por humano, sem requisitos desnecessários |
| Instruções específicas em **skills**, que carregam sob demanda | Não ocupam contexto em toda sessão (documentação de custos do Claude Code) |

### 3.3 Agentes e modelos
| Decisão | Por quê |
|---|---|
| **Só a sessão principal escreve código** (single writer) | Cognition (2025 e 2026): escritores em paralelo tomam decisões implícitas que entram em conflito. Google/MIT (arXiv 2512.08296): em tarefas sequenciais, os sistemas multiagente pioraram o desempenho entre 39% e 70% |
| Subagentes só para ler e verificar: `explorador` (Haiku), `testador` (Haiku), `revisor` (Sonnet), `documentador` (Haiku, só escreve docs) | LangChain/Cognition: sistemas multiagente que "leem" são bem mais confiáveis que os que "escrevem" |
| `revisor` com contexto limpo, vendo só o diff | Cognition 2026: o revisor encontra ~2 bugs por PR (58% graves) e funciona melhor sem herdar o viés de quem codou |
| `"model": "opusplan"` no `.claude/settings.json` | Opus no modo plano e Sonnet na execução, de forma automática. Sem isso, o padrão da maioria das contas é o Opus, que é mais caro |
| Modelo forte comanda, modelo barato faz o mecânico | RouteLLM (ICLR 2025): cortou o custo em mais de 2x mantendo a qualidade. Um modelo fraco no comando falha porque não sabe quando escalar (Cognition 2026) |
| Briefing obrigatório em toda delegação (objetivo, contexto, escopo, critério de parada, formato) | MAST (Berkeley, NeurIPS 2025): as falhas multiagente se agrupam em especificação, desalinhamento e verificação |
| Sem agent teams; 4 a 6 subagentes no máximo | Agent teams custam ~7x mais tokens. As descrições dos subagentes ocupam contexto em toda sessão |
| Ciclo de 9 passos: entender → planejar → implementar → verificar → revisar → registrar → commitar → responder → `/clear` | Verificação obrigatória; estado salvo em arquivos (Anthropic, sistema de pesquisa multiagente) |

### 3.4 Arquitetura de código
| Decisão | Por quê |
|---|---|
| **Núcleo universal + perfis** (Sistema, Site, Mobile, Automação), combináveis | Uma arquitetura única não serve para site, app e script. O núcleo (docs, agentes, princípios) vale para todos (ADR 0001) |
| Princípios universais: organizar por funcionalidade (Vertical Slice / Bulletproof React), núcleo independente (Hexagonal, Cockburn), dependências apontando para dentro, porta de entrada por área, fronteiras checadas por ferramenta, configuração fora do código (12-Factor), tipagem estrita | Fontes na seção 5 |
| Perfil Sistema: monólito modular em TypeScript (Fastify + Postgres + Drizzle + React + Vite + TanStack Query), com `packages/contracts` (Zod) compartilhado | Modelo da Shopify (monólito modular em vez de microsserviços). Uma linguagem só e contratos únicos entre front e back |
| Perfil Site: Astro + Tailwind · Mobile: Expo · Automação: Python + uv (ou Apps Script + clasp) | Ferramenta adequada a cada tipo de projeto |
| Regras de domínio **opcionais**: dinheiro em centavos, multi-tenant, LGPD, autenticação, datas, fiscal, offline | Antes estavam como obrigatórias para tudo, o que não faz sentido para um site ou um script |
| Código em inglês, documentação em português, glossário de negócio | Padrão de mercado para o código. Os termos de negócio sem tradução boa ficam mapeados no glossário |

### 3.5 Comunicação da IA comigo
- Máximo de 10 linhas no chat. Arquivos não têm limite.
- Formatos fixos (fim de tarefa / explicar / erro) em `docs/guias/comunicacao.md`.
- Skill `/explicar <tema>`: usa o explorador, cruza com ADRs, devlog e git, e responde em até 10 linhas. Nunca inventa o motivo de uma decisão: se não estiver registrado, diz que não está.

---

## 4. Estrutura atual (o que já existe)

```
.
├── AGENTS.md                         → guia da IA (com placeholders a preencher por projeto)
├── CLAUDE.md                         → @AGENTS.md
├── .claude/
│   ├── settings.json                 → model: opusplan
│   ├── agents/                       → explorador, testador, revisor, documentador
│   └── skills/explicar/SKILL.md
└── docs/
    ├── adr/
    │   ├── 0000-modelo.md
    │   └── 0001-nucleo-universal-e-perfis.md
    ├── arquitetura/
    │   ├── README.md                 → princípios universais, tabela de perfis, modelo do ADR de perfil
    │   ├── regras-de-dominio.md
    │   └── perfis/
    │       ├── sistema/ (README.md, backend.md, frontend.md)
    │       ├── site.md · mobile.md · automacao.md
    ├── guias/
    │   ├── orquestracao-de-agentes.md → 10 princípios, modelos por tarefa, ciclo, briefing, antipadrões, referências
    │   └── comunicacao.md
    ├── planos/_modelo.md
    └── produto/glossario.md
```

---

## 5. Base de estudos e referências

**Agentes e contexto**
- Anthropic — Building effective agents (2024)
- Anthropic — How we built our multi-agent research system (2025): +90,2% em tarefas de amplitude; ~15x mais tokens que um chat
- Anthropic — Effective context engineering for AI agents (2025)
- Cognition — Don't Build Multi-Agents (2025) e Multi-Agents: What's Actually Working (2026)
- Cemri et al. (Berkeley) — Why Do Multi-Agent LLM Systems Fail? NeurIPS 2025 (MAST)
- Kim et al. (Google/MIT) — Towards a Science of Scaling Agent Systems (arXiv 2512.08296)
- Ong et al. — RouteLLM, ICLR 2025
- Gloaguen et al. (ETH Zurich) — Evaluating AGENTS.md, ICLR 2026 (arXiv 2602.11988)
- Claude Code Docs — Subagents; Manage costs; Model configuration (opusplan)

**Documentação e processo**
- Michael Nygard — Documenting Architecture Decisions (2011); Martin Fowler — Architecture Decision Record
- Conventional Commits 1.0.0 · Keep a Changelog · SemVer
- Diátaxis (Daniele Procida) · agents.md

**Arquitetura**
- Shopify — Deconstructing the Monolith · Alistair Cockburn — Hexagonal Architecture
- Jimmy Bogard — Vertical Slice Architecture · Bulletproof React · The Twelve-Factor App

---

## 6. O que ainda falta criar

- [ ] `README.md` do template: o que é, como usar em um projeto novo (passo a passo) e mapa dos documentos
- [ ] `STATUS.md` e `CHANGELOG.md` iniciais
- [ ] `docs/devlog/` e `docs/referencia/` (com `.gitkeep` ou um README curto)
- [ ] `docs/guias/como-iniciar-um-projeto.md`: checklist de copiar a base, escolher o perfil, criar o ADR de perfil e preencher o AGENTS.md
- [ ] `.gitignore` (Node + Python + `.env` + `CLAUDE.local.md`) e `.env.example`
- [ ] `.github/pull_request_template.md` e `.github/workflows/` (CI genérico que detecta o perfil, ou um workflow por perfil, comentado)
- [ ] Validação automática do formato de commit (commitlint + hook, ou equivalente que funcione nos perfis TS e Python)
- [ ] Configuração de exemplo do `dependency-cruiser` para o perfil Sistema
- [ ] Decidir se a base deve ter um script de inicialização (ex.: `scripts/init.sh` que pergunta o perfil e remove os outros)

## 7. Restrições

- Não aumente o AGENTS.md sem necessidade. O detalhe fica em `docs/`.
- Não adicione agentes novos sem justificativa forte.
- Mantenha tudo em português nos docs e em inglês no código.
- Toda mudança estrutural relevante vira um ADR novo no template (próximo número livre).
