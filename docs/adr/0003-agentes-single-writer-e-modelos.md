# 0003. Agentes: um só escritor, subagentes de leitura e modelo por tarefa

- **Data:** 2026-11-21
- **Status:** aceito

## Contexto
Queremos dividir o trabalho entre agentes e modelos (Opus, Sonnet, Haiku) para gastar menos tokens sem perder qualidade. As pesquisas mostram que mais agentes nem sempre ajudam:
- Em tarefas sequenciais, todas as variantes multiagente testadas pioraram o desempenho entre 39% e 70% (Kim et al., Google/MIT, arXiv 2512.08296).
- Escritores em paralelo tomam decisões implícitas que entram em conflito (Cognition, 2025 e 2026).
- As falhas multiagente se concentram em especificação, desalinhamento e verificação (MAST, Cemri et al., NeurIPS 2025).
- Rotear o trabalho simples para modelos menores corta o custo em mais de 2x com a mesma qualidade (RouteLLM, ICLR 2025).

Os detalhes e as referências completas estão em `docs/guias/orquestracao-de-agentes.md`.

## Decisão
Vamos:
1. Deixar só a sessão principal editar código (*single writer*).
2. Ter quatro subagentes, com o modelo fixado no arquivo de cada um: `explorador` (Haiku, leitura), `testador` (Haiku, verificação), `revisor` (Sonnet, revisão do diff com contexto limpo) e `documentador` (Haiku, só arquivos de documentação).
3. Usar `"model": "opusplan"` no `.claude/settings.json`: Opus no modo plano, Sonnet na execução.
4. Exigir um briefing (objetivo, contexto, escopo, critério de parada, formato) em toda delegação.
5. Não usar *agent teams* e manter entre 4 e 6 subagentes. Esse limite é uma escolha nossa: a documentação do Claude Code só avisa que as descrições ocupam contexto e devem ser curtas.

## Alternativas consideradas
- **Um agente por camada (backend, frontend, testes) escrevendo em paralelo:** o caso que as pesquisas mostram que dá errado.
- **Agent teams:** cada colega é uma instância separada. Segundo a documentação do Claude Code, o gasto chega a cerca de 7x o de uma sessão normal.
- **Sessão principal no Haiku para economizar:** um modelo fraco no comando não sabe quando escalar (Cognition, 2026).

## Consequências
- Um agente novo só entra depois de fazer falta em pelo menos 3 tarefas reais, e com um ADR.
- Os modelos estão nos arquivos `.claude/agents/*.md`. Quando surgirem modelos novos, revise esses arquivos e este ADR.
