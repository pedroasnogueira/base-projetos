# 0002. AGENTS.md curto como fonte da verdade para as IAs

- **Data:** 2026-11-21
- **Status:** aceito

## Contexto
Os projetos são feitos com mais de uma IA (Claude Code em casa, Gemini no trabalho). Cada ferramenta procura um arquivo de instruções diferente, e manter vários arquivos com o mesmo conteúdo faz eles divergirem.

Também existe um custo: o arquivo de contexto é lido em toda sessão. O estudo da ETH Zurich *Evaluating AGENTS.md* (Gloaguen et al., ICLR 2026, arXiv 2602.11988) mostrou que arquivos de contexto, escritos por humano ou gerados por IA, em geral **não aumentam** a taxa de sucesso das tarefas e **aumentam o custo em mais de 20%**. As instruções são seguidas, mas visões gerais do repositório não ajudam. O que vale a pena colocar são práticas que fogem do padrão.

A documentação do Claude Code dá a mesma orientação: manter o CLAUDE.md abaixo de ~200 linhas e mover instruções específicas para *skills*, que só carregam quando usadas.

## Decisão
Vamos:
1. Usar o `AGENTS.md` como a única fonte da verdade. Ele é um padrão aberto (agents.md) lido por várias ferramentas.
2. Deixar no `CLAUDE.md` só a linha `@AGENTS.md` (importação), mais o que for exclusivo do Claude Code. No Gemini CLI, o `.gemini/settings.json` faz o mesmo papel.
3. Manter o `AGENTS.md` curto (por volta de 60 linhas), com comandos, regras inegociáveis e práticas fora do padrão. Os detalhes ficam em `docs/`, e o AGENTS.md só aponta para eles.
4. Colocar instruções de fluxos específicos em skills (`.claude/skills/`).

## Alternativas consideradas
- **AGENTS.md longo e completo:** mais fácil de achar tudo num lugar, mas o estudo da ETH mostra custo maior sem ganho.
- **Um arquivo por ferramenta (CLAUDE.md, GEMINI.md...) com conteúdo copiado:** diverge com o tempo.

## Consequências
- O `.gemini/settings.json` já aponta o Gemini CLI para o AGENTS.md (`context.fileName`). Outras ferramentas compatíveis com agents.md leem o arquivo sem configuração.
- Toda proposta de aumentar o AGENTS.md precisa de motivo. O padrão é colocar o detalhe em `docs/`.
- Uma visão geral do projeto no AGENTS.md deve ficar em 2 ou 3 frases.
