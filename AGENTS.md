# AGENTS.md

> Guia para qualquer IA que trabalhe neste projeto. Curto de propósito: os detalhes ficam em `docs/`.

## Projeto
<!-- 2 ou 3 frases: o que é, para quem, stack principal. -->

## Comandos
<!-- Preencha com os comandos reais do projeto. -->
- Instalar: `...`
- Rodar: `...`
- Testes: `...`
- Lint: `...`
- Tipos: `...`

## Regras inegociáveis
<!-- Só o que vale para o projeto inteiro. Copie de docs/arquitetura/regras-de-dominio.md as que se aplicam. -->
- ...

## Ao começar uma sessão
1. Leia `STATUS.md` para saber onde o projeto parou.
2. Se a tarefa tiver um plano, leia o plano em `docs/planos/`.

## Arquitetura
<!-- Preencha ao iniciar o projeto (ver docs/arquitetura/README.md, seção "Como usar"). -->
- **Perfil(is):** <!-- Sistema | Site | Mobile | Automação --> (decisão no ADR `NNNN-perfil-e-stack.md`, com o próximo número livre)
- **Guias a seguir:** <!-- ex.: docs/arquitetura/perfis/sistema/backend.md -->
- Antes de criar ou mover código, leia `docs/arquitetura/README.md` e o guia do perfil para a parte que vai mexer.
- Organize por funcionalidade, nunca por tipo de arquivo. Lógica principal sem depender de banco, rede ou interface.
- Áreas só se falam pelo arquivo de entrada (`index.ts` / `__init__.py`).
- Código em inglês. Termos de negócio: `docs/produto/glossario.md`.

## Fluxo de trabalho com agentes
Siga o ciclo em `docs/guias/orquestracao-de-agentes.md`. Resumo:
- **Só a sessão principal edita código.** Subagentes leem, verificam e documentam.
- Antes de mexer em código desconhecido → `explorador`.
- Depois de mudar código → `testador`. Antes de commitar → `revisor`.
- Ao fim da tarefa → `documentador`.
- Toda delegação leva um briefing: objetivo, contexto, escopo, critério de parada e formato.
- Não use agent teams. Não paralelize etapas de uma mesma implementação.

## Como responder ao dono do projeto
O dono do projeto precisa entender e saber explicar tudo o que o projeto faz. Por isso:
- **Máximo 10 linhas** por resposta no chat, em português claro. Se precisar de mais, resuma e ofereça o detalhe.
- **Sempre com contexto:** o quê, por quê e onde (arquivo). Nunca só "feito".
- **Jargão explicado** na primeira vez, entre parênteses.
- **Sem código no chat**, a não ser que seja pedido. Aponte o arquivo e a linha.
- Ao fim de cada tarefa, use o formato de `docs/guias/comunicacao.md`.
- Planos, ADRs e documentos em arquivo não têm limite de linhas.

## Commits
Conventional Commits (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`). O corpo explica **por quê**, não o quê.

## Onde fica cada coisa
- Decisões: `docs/adr/` · Planos: `docs/planos/` · Diário: `docs/devlog/`
- Arquitetura: `docs/arquitetura/` · Guias: `docs/guias/` · Referência: `docs/referencia/`
