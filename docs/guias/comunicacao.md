# Guia de comunicação da IA com o dono do projeto

> Objetivo: o dono do projeto entende o que cada parte faz, por que foi feita assim e onde ela está, a ponto de explicar para outra pessoa ou resolver um problema sozinho.

## Regras
1. **Máximo de 10 linhas** por resposta no chat.
2. **Português claro.** Termo técnico explicado entre parênteses na primeira vez que aparece.
3. **Contexto sempre:** toda resposta diz o quê, por quê e onde.
4. **Sem código no chat**, a não ser que seja pedido. Aponte `arquivo:linha`.
5. **Ligue às decisões:** se algo segue um ADR, cite o número ("ver ADR 0004").
6. **Honestidade:** se algo ficou incompleto, com risco ou com uma suposição, diga em uma linha.
7. Precisou de mais de 10 linhas? Dê o resumo e termine com "Quer o detalhe?". O detalhe vai para um arquivo em `docs/`, não para o chat.

Arquivos (planos, ADRs, guias, devlog) não têm limite de linhas.

---

## Formato: fim de tarefa
```
✅ O que foi feito: <1–2 linhas, do ponto de vista de quem usa o sistema>
🎯 Por quê: <1–2 linhas: o problema resolvido ou a decisão tomada (ADR, se houver)>
⚙️ Como funciona: <2–3 linhas: o fluxo, em linguagem simples>
📁 Onde: <2–3 arquivos principais>
⚠️ Atenção: <riscos, pendências ou suposições; omita se não houver>
```

Exemplo:
```
✅ O que foi feito: agora o caixa não fecha se o valor contado for diferente do esperado sem uma justificativa.
🎯 Por quê: evitar diferença de caixa sem explicação (regra pedida pelo dono da loja).
⚙️ Como funciona: no fechamento, o sistema compara o valor contado com a soma das vendas em dinheiro menos as sangrias (retiradas do caixa). Se houver diferença, exige um texto explicando.
📁 Onde: apps/api/src/modules/cash/application/close-cash-register.ts e apps/web/src/features/cash/components/CloseCashForm.tsx
⚠️ Atenção: diferenças de até R$ 1,00 são aceitas sem justificativa (suposição; confirmar com o dono).
```

## Formato: explicar algo que já existe
```
📌 Resumo: <1 linha: o que é>
⚙️ Como funciona: <3–4 linhas: o fluxo>
🎯 Por que é assim: <1–2 linhas: a decisão por trás (ADR ou devlog)>
📁 Onde: <arquivos principais>
```

## Formato: erro ou problema
```
❌ O que aconteceu: <1 linha>
🔍 Causa: <1–2 linhas>
🛠️ Correção: <1–2 linhas: o que foi ou deve ser feito>
🛡️ Prevenção: <1 linha: teste ou regra que evita que aconteça de novo>
```

---

## Comando `/explicar`
Para entender qualquer parte do projeto, use `/explicar <tema>`. Exemplos:
- `/explicar fechamento de caixa`
- `/explicar por que usamos Postgres`
- `/explicar o que mudou na última semana`

A IA consulta o código, os ADRs, o devlog e o git, e responde no formato "explicar algo que já existe".
