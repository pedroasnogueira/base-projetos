---
name: explicar
description: Explica, em no máximo 10 linhas, como uma parte do projeto funciona, por que foi feita assim e onde está. Use quando o usuário pedir /explicar ou perguntar "como funciona", "por que", "o que mudou".
---

# /explicar

O usuário quer entender uma parte do projeto a ponto de conseguir explicá-la para outra pessoa.

## Passos
1. **Localize:** delegue ao subagente `explorador` encontrar os arquivos e o fluxo ligados ao tema. Não leia o projeto inteiro.
2. **Busque o porquê:** procure o tema em `docs/adr/`, `docs/devlog/` e, se precisar, em `git log --oneline -S "<termo>"` ou `git log --grep "<termo>"`.
3. **Se for "o que mudou":** use `CHANGELOG.md`, `docs/devlog/` e `git log --since`.
4. **Responda** no formato abaixo, com no máximo 10 linhas, em português claro, explicando o jargão entre parênteses.

## Formato
```
📌 Resumo: <1 linha: o que é>
⚙️ Como funciona: <3–4 linhas: o fluxo, em linguagem simples>
🎯 Por que é assim: <1–2 linhas: a decisão (cite ADR ou data do devlog)>
📁 Onde: <arquivos principais, com caminho>
```

## Regras
- Sem código no chat, a não ser que o usuário peça.
- Não achou o motivo de uma decisão em ADR, devlog ou commit? Diga "o motivo não está registrado" em vez de inventar. Sugira criar um ADR.
- Se o tema não existir no projeto, diga isso em uma linha.
- Se a explicação precisar de mais de 10 linhas, dê o resumo e pergunte "Quer o detalhe?".
