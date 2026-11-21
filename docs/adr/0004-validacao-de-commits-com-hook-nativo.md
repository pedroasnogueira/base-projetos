# 0004. Validação de commits com hook nativo do Git e script sem dependências

- **Data:** 2026-11-21
- **Status:** aceito

## Contexto
O histórico segue Conventional Commits, para ficar legível e permitir gerar o CHANGELOG. Uma regra que só existe no papel é esquecida, principalmente por uma IA (princípio U6), então ela precisa ser checada por ferramenta.

A ferramenta mais comum, `commitlint` com `husky`, depende de Node.js. Os projetos do perfil Automação são em Python e não têm Node, e a validação precisa funcionar nos dois casos.

## Decisão
Vamos validar a mensagem de commit com:
1. `scripts/check-commit-msg.sh`: script POSIX (`sh` + `grep`), sem nenhuma dependência.
2. `.githooks/commit-msg`: hook do Git que chama o script. Ele é ativado com `git config core.hooksPath .githooks`, que o `scripts/init.sh` executa.
3. O mesmo script no CI (`.github/workflows/ci.yml`, job `commits`). Isso pega quem não ativou o hook ou fez o commit pela interface do GitHub.

## Alternativas consideradas
- **commitlint + husky:** padrão de mercado, mas exige Node e `package.json` até em projeto Python.
- **lefthook:** funciona com Node e com Python, mas é mais uma ferramenta para instalar em cada máquina. Pode entrar depois, se o projeto precisar de outros hooks (lint antes do commit, por exemplo).
- **pre-commit (framework Python):** o caso inverso do commitlint, exige Python em projeto TypeScript.

## Consequências
- Funciona igual em qualquer perfil e em Windows (Git Bash), macOS e Linux.
- O hook vale só na máquina onde foi ativado. Em cada clone novo, rode `git config core.hooksPath .githooks` (ou o `init.sh`). O CI é a garantia final.
- O script cobre o cabeçalho (tipo, escopo, `!`, descrição e até 100 caracteres). Regras mais finas, como o formato do corpo, ficam para o `revisor`.
