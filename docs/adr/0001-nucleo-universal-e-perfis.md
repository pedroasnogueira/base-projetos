# 0001. Estrutura base: núcleo universal + perfis de arquitetura

- **Data:** 2026-11-21
- **Status:** aceito

## Contexto
Esta estrutura é a base de todos os projetos futuros, de qualquer tipo: sistemas empresariais, apps de finanças, sites, apps de celular e automações. Ela é desenvolvida em grande parte com IA, então precisa dar à IA contexto claro sem desperdiçar tokens.

Uma arquitetura única não serve para todos esses casos. Um monorepo com API e banco é exagero para um site institucional, e um app de celular tem necessidades próprias.

## Decisão
Vamos dividir a base em duas camadas:
1. **Núcleo universal**, que vale para todo projeto: AGENTS.md, agentes da IA, ciclo de trabalho, ADRs, devlog, STATUS, CHANGELOG, Conventional Commits e os princípios universais de `docs/arquitetura/README.md`.
2. **Perfis de arquitetura**, escolhidos por projeto: Sistema, Site, Mobile e Automação, cada um com a sua stack e estrutura de pastas. Os perfis podem ser combinados.

Regras que dependem do domínio (dinheiro, multi-tenant, dados pessoais, fiscal, offline) ficam em `docs/arquitetura/regras-de-dominio.md` e são ativadas por projeto.

Cada projeto registra o perfil e a stack escolhidos num ADR próprio (`NNNN-perfil-e-stack.md`), com o próximo número livre depois dos ADRs herdados do template.

## Alternativas consideradas
- **Uma arquitetura única para tudo:** simples de manter, mas força complexidade desnecessária nos projetos pequenos e não atende apps nem automações.
- **Um template separado por tipo de projeto:** cada um evolui sozinho e as melhorias no núcleo (agentes, documentação) precisariam ser copiadas várias vezes.

## Consequências
- Uma melhoria no núcleo vale para todos os projetos.
- Começar um projeto exige uma decisão consciente: escolher o perfil e as regras de domínio.
- Tipos de projeto ainda não cobertos (jogos, IA/ML, desktop) ganham um perfil novo, com ADR próprio, quando surgirem.
