# Guia de orquestração de agentes

> Como este projeto usa IA com subagentes: quem faz o quê, com qual modelo e por quê.
> Cada regra aqui vem de uma pesquisa ou de um relato de engenharia, listados no fim.

---

## 1. Os 10 princípios

### P1 — Comece com um agente só e adicione complexidade só se provar valor
Os times que mais tiveram sucesso com agentes usaram padrões simples e combináveis, não frameworks complexos [1]. Na média, sistemas multiagente ganham pouco em relação a um agente único [4], e em tarefas sequenciais todas as variantes multiagente testadas pelo Google pioraram o desempenho entre 39% e 70% [5].
**Na prática:** a sessão principal faz o trabalho. Subagente é exceção justificada, não o padrão.

### P2 — Só um agente escreve código (single writer)
Quando vários agentes escrevem em paralelo, as decisões implícitas de cada um (estilo, casos de borda, APIs) entram em conflito e o resultado fica frágil [3][6]. A Cognition, que constrói o Devin, resume o que funciona hoje: os agentes somam inteligência, mas a escrita fica num fio só [6].
**Na prática:** só a sessão principal edita código. Os subagentes leem, verificam e documentam.

### P3 — Subagentes servem para ler e verificar
Sistemas multiagente que mais "leem" são bem mais fáceis de acertar do que os que "escrevem" [7]. Subagentes só de leitura (busca no código, busca na web) são comuns e funcionam [6].
**Na prática:** explorador (leitura), testador (verificação), revisor (verificação). O documentador é a única exceção e escreve apenas arquivos de documentação, nunca código.

### P4 — O revisor precisa de contexto limpo
O padrão gerador → verificador funciona: o Devin Review encontra em média 2 bugs por PR, cerca de 58% deles graves. Ele funciona melhor quando o revisor **não** compartilha o histórico de quem codou e vê só o diff, porque assim evita herdar o viés do autor e a perda de atenção de contextos longos [6].
**Na prática:** o revisor é um subagente que começa do zero e lê apenas `git diff` + AGENTS.md.

### P5 — Paralelize só o que é independente
O ganho multiagente aparece em tarefas de amplitude, com várias frentes independentes ao mesmo tempo. No sistema de pesquisa da Anthropic, isso rendeu +90,2% sobre um agente único [2]. No estudo do Google, o resultado vai de +80,8% em tarefas decomponíveis a −70% em planejamento sequencial [5].
**Na prática:** paralelize investigações independentes ("como funciona o módulo A?" e "como funciona o módulo B?"). Nunca paralelize etapas de uma mesma implementação.

### P6 — Modelo forte orquestra, modelo barato executa o trabalho mecânico
Rotear tarefas simples para modelos menores corta custo sem perder qualidade: o RouteLLM reduziu o custo em mais de 2x mantendo a qualidade das respostas [8]. O caminho inverso, um modelo fraco no comando pedindo ajuda ao forte, ainda não funciona: o modelo fraco não sabe quando escalar nem o que perguntar [6]. A Anthropic usa um modelo forte como líder e modelos menores como subagentes [2].
**Na prática:** a sessão principal roda no Sonnet (ou no Opus para planejar). O Haiku fica só com tarefas mecânicas e bem delimitadas.

### P7 — Contexto é um recurso finito
Bom contexto é o menor conjunto possível de informação de alto sinal que maximiza o resultado [9]. Um subagente pode gastar dezenas de milhares de tokens, mas devolve só um resumo condensado (tipicamente 1.000 a 2.000 tokens) [9].
**Na prática:** todo subagente tem um formato de resposta curto e definido. AGENTS.md curto, detalhes em `docs/`. Use `/clear` entre tarefas não relacionadas.

### P8 — Delegue com um briefing completo
Os primeiros agentes da Anthropic cometiam erros como criar 50 subagentes para perguntas simples e duplicar trabalho por falta de divisão clara [2]. A taxonomia MAST (UC Berkeley) agrupa as falhas multiagente em três categorias: **especificação** ruim, **desalinhamento** entre agentes e **verificação** falha [4].
**Na prática:** toda delegação usa o modelo de briefing da seção 4.

### P9 — Verificação é etapa obrigatória, não opcional
Falha na verificação é uma das três grandes causas de falha [4]. A Anthropic recomenda dar alvos de verificação, como testes e saída esperada, para o agente checar o próprio trabalho [10].
**Na prática:** nenhuma tarefa termina sem passar pelo testador e pelo revisor.

### P10 — O estado vive em arquivos, não na memória do chat
O agente líder da Anthropic salva o plano em memória externa, porque o contexto pode ser truncado [2].
**Na prática:** o plano vai para `docs/planos/`, o estado para `STATUS.md` e a história para `docs/devlog/`, `docs/adr/` e o git.

---

## 2. Qual modelo para qual tarefa

| Tarefa | Quem faz | Modelo | Por quê |
|---|---|---|---|
| Planejar feature, decidir arquitetura, bug difícil | Sessão principal (modo plano) | **Opus** | Raciocínio profundo; erro aqui custa caro |
| Implementar código | Sessão principal | **Sonnet** | Dá conta da maioria das tarefas de código e custa menos [10] |
| Encontrar arquivos, entender um trecho | `explorador` | **Haiku** | Trabalho mecânico e só de leitura |
| Rodar testes, lint, tipos | `testador` | **Haiku** | Mecânico; devolve só as falhas |
| Revisar diff antes do commit | `revisor` | **Sonnet** | Exige julgamento; contexto limpo |
| Revisar código crítico (dinheiro, auth, dados) | `revisor` | **Opus** (sob demanda) | Erro aqui é caro demais |
| Atualizar STATUS, devlog, CHANGELOG, ADR | `documentador` | **Haiku** | Escrita estruturada a partir de um resumo |

**A troca é automática.** O `.claude/settings.json` define `"model": "opusplan"`: a sessão principal usa o Opus no modo plano (Shift+Tab) e passa sozinha para o Sonnet na execução. Cada subagente usa o modelo fixado no próprio arquivo. A única ação manual é entrar no modo plano quando a tarefa pedir planejamento.

Para trocar o modelo de um subagente numa única chamada, peça: *"use o revisor com o modelo opus para revisar o módulo financeiro"*.

---

## 3. O ciclo de cada tarefa

```
1. ENTENDER     → explorador (Haiku)          "onde e como isso funciona hoje?"
2. PLANEJAR     → sessão principal (Opus)     modo plano · salva em docs/planos/
3. IMPLEMENTAR  → sessão principal (Sonnet)   em passos pequenos, com teste a cada passo
4. VERIFICAR    → testador (Haiku)            falhou? volta para o passo 3
5. REVISAR      → revisor (Sonnet)            BLOQUEADO? volta para o passo 3
6. REGISTRAR    → documentador (Haiku)        STATUS · devlog · CHANGELOG · ADR
7. COMMITAR     → sessão principal            Conventional Commits, com o porquê no corpo
8. RESPONDER    → sessão principal            resumo de fim de tarefa (docs/guias/comunicacao.md)
9. LIMPAR       → /clear                      antes da próxima tarefa
```

Tarefas pequenas (um typo, um ajuste de texto) pulam os passos 1, 2 e 5. O passo 4 nunca é pulado quando há código.

---

## 4. Modelo de briefing de delegação

Toda vez que a sessão principal chamar um subagente, a mensagem deve ter:

```
OBJETIVO: o que precisa ser descoberto ou verificado, em uma frase.
CONTEXTO: o mínimo que o subagente precisa saber (ele não viu esta conversa).
ESCOPO: onde procurar / o que olhar. O que NÃO fazer.
CRITÉRIO DE PARADA: quando a resposta está boa o suficiente.
FORMATO: o formato definido no arquivo do agente (ou um ajuste específico).
```

Exemplo:
```
OBJETIVO: descobrir como o desconto é aplicado hoje no fechamento da venda.
CONTEXTO: vamos adicionar desconto por forma de pagamento (Pix).
ESCOPO: src/modules/vendas/. Não precisa olhar testes nem UI.
CRITÉRIO DE PARADA: quando souber a função e o fluxo do cálculo do total.
FORMATO: padrão do explorador.
```

---

## 5. Antipadrões (não fazer)

- ❌ **Subagente implementando código.** Ele começa sem contexto, relê tudo e decide coisas sozinho (P2).
- ❌ **Dois agentes editando ao mesmo tempo.** Geram conflitos de estilo e de decisão (P2).
- ❌ **Haiku como sessão principal "para economizar".** Um modelo fraco no comando não sabe quando escalar (P6).
- ❌ **Agent teams num projeto solo.** Cada colega é uma instância separada, com contexto próprio: com os colegas em modo plano, o gasto chega a cerca de 7x o de uma sessão normal [10].
- ❌ **Agentes demais.** As descrições de todos eles ocupam contexto em toda sessão, e a documentação pede descrições curtas [11]. O limite de 4 a 6 é uma decisão deste template (ADR 0003), não um número da documentação.
- ❌ **Delegar sem briefing.** É a principal fonte de trabalho duplicado e de respostas fora do alvo (P8).
- ❌ **Subagente devolvendo log inteiro.** Anula o motivo de ter delegado (P7).

---

## 6. Controle de custo

- Multiagente custa caro: agentes gastam cerca de 4x mais tokens que um chat, e sistemas multiagente cerca de 15x [2]. Só vale quando o valor da tarefa paga a conta.
- A quantidade de tokens sozinha explicou 80% da variação de desempenho no sistema da Anthropic [2]. Mais tokens ajudam, por isso gaste onde importa (planejar, revisar) e economize no mecânico.
- Rode `/usage` toda semana para ver quanto cada subagente consome.
- `/clear` entre tarefas. `/compact` só quando precisar manter a continuidade.
- Pedidos específicos gastam menos: "valide o campo X em `auth.ts`" em vez de "melhore o código" [10].

---

## 7. Como evoluir este guia

Este guia é um ponto de partida. Quando algo não funcionar:
1. Registre no devlog o que aconteceu.
2. Ajuste o agente ou a regra.
3. Se a mudança for estrutural (novo agente, troca de modelo padrão), crie um ADR.

Não adicione um agente novo sem antes ter sentido a falta dele em pelo menos 3 tarefas reais (P1).

---

## Referências

1. Anthropic — *Building effective agents* (2024). https://www.anthropic.com/engineering/building-effective-agents
2. Anthropic — *How we built our multi-agent research system* (2025). https://www.anthropic.com/engineering/multi-agent-research-system
3. Cognition (Walden Yan) — *Don't Build Multi-Agents* (2025). https://cognition.ai/blog/dont-build-multi-agents
4. Cemri et al., UC Berkeley — *Why Do Multi-Agent LLM Systems Fail?* NeurIPS 2025. https://arxiv.org/abs/2503.13657
5. Kim et al., Google Research / MIT — *Towards a Science of Scaling Agent Systems* (2025). https://arxiv.org/abs/2512.08296
6. Cognition (Walden Yan) — *Multi-Agents: What's Actually Working* (2026). https://cognition.com/blog/multi-agents-working
7. LangChain (Harrison Chase) — *How and when to build multi-agent systems* (2025). https://blog.langchain.com/how-and-when-to-build-multi-agent-systems
8. Ong et al., UC Berkeley / LMSYS — *RouteLLM: Learning to Route LLMs from Preference Data*, ICLR 2025. https://arxiv.org/abs/2406.18665
9. Anthropic — *Effective context engineering for AI agents* (2025). https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
10. Claude Code Docs — *Manage costs effectively*. https://code.claude.com/docs/en/costs
11. Claude Code Docs — *Subagents*. https://code.claude.com/docs/en/sub-agents
