# base-projetos

Template para começar qualquer projeto (sistema, site, app de celular ou automação) já com estrutura profissional, documentação que guarda o **porquê** de cada decisão e um fluxo de trabalho com IA (Claude Code, Gemini) pensado para gastar poucos tokens sem perder qualidade.

## O que vem pronto
- **Guia para a IA:** `AGENTS.md` curto, lido pelo Claude Code (via `CLAUDE.md`) e pelo Gemini CLI (via `.gemini/settings.json`).
- **Agentes:** `explorador`, `testador`, `revisor` e `documentador` em `.claude/agents/`, cada um com o modelo certo (Haiku ou Sonnet). Só a sessão principal escreve código.
- **Memória do projeto:** ADRs (decisões), `STATUS.md` (onde parei), devlog (diário), CHANGELOG e Conventional Commits validados por hook e no CI.
- **Arquitetura:** princípios universais e quatro perfis combináveis: Sistema, Site, Mobile e Automação.
- **CI genérico:** detecta TypeScript ou Python e roda lint, tipos e testes.
- **Respostas curtas:** a IA responde em até 10 linhas, com o quê, por quê e onde. A skill `/explicar <tema>` explica qualquer parte do projeto.

## Como usar num projeto novo
1. Clique em **Use this template → Create a new repository** (ou `gh repo create <nome> --template pedroasnogueira/base-projetos --clone`).
2. Na pasta do projeto, no Git Bash: `bash scripts/init.sh`. Ele pergunta o nome e o perfil e prepara tudo.
3. Preencha o `AGENTS.md` (projeto, comandos, regras) e o ADR de perfil que o script criou.
4. Abra o Claude Code na pasta e comece.

Passo a passo completo: [`docs/guias/como-iniciar-um-projeto.md`](docs/guias/como-iniciar-um-projeto.md).

## Mapa dos documentos
| Onde | O que tem | Tipo (Diátaxis) |
|---|---|---|
| [`AGENTS.md`](AGENTS.md) | Regras e comandos para qualquer IA | — |
| [`STATUS.md`](STATUS.md) | Onde o projeto parou e próximos passos | — |
| [`CHANGELOG.md`](CHANGELOG.md) | O que mudou em cada versão | Referência |
| [`docs/guias/`](docs/guias/) | Como iniciar um projeto, orquestração de agentes, comunicação da IA | Guias |
| [`docs/arquitetura/`](docs/arquitetura/README.md) | Princípios, perfis e regras de domínio | Explicação |
| [`docs/adr/`](docs/adr/) | Decisões de arquitetura e o porquê de cada uma | Explicação |
| [`docs/referencia/`](docs/referencia/README.md) | Versões das ferramentas e outros dados de consulta | Referência |
| [`docs/planos/`](docs/planos/_modelo.md) | Planos de tarefas grandes | — |
| [`docs/devlog/`](docs/devlog/README.md) | Diário por sessão de trabalho | — |
| [`docs/produto/glossario.md`](docs/produto/glossario.md) | Termos de negócio ↔ nomes no código | Referência |

## Decisões deste template
| ADR | Decisão |
|---|---|
| [0001](docs/adr/0001-nucleo-universal-e-perfis.md) | Núcleo universal + perfis de arquitetura |
| [0002](docs/adr/0002-agents-md-curto-como-fonte-da-verdade.md) | AGENTS.md curto como fonte da verdade |
| [0003](docs/adr/0003-agentes-single-writer-e-modelos.md) | Um só escritor, subagentes de leitura, modelo por tarefa |
| [0004](docs/adr/0004-validacao-de-commits-com-hook-nativo.md) | Validação de commits com hook nativo do Git |
| [0005](docs/adr/0005-script-de-inicializacao.md) | Script de inicialização |
