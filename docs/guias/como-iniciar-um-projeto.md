# Como iniciar um projeto a partir da base

> Passo a passo para transformar o template num projeto novo. O `scripts/init.sh` faz os passos 3 a 6 sozinho; este guia explica cada um e serve para quem preferir fazer à mão.

## Checklist

### 1. Criar o repositório a partir do template
- No GitHub, abra o `base-projetos` e clique em **Use this template → Create a new repository**.
- Ou pelo terminal: `gh repo create <nome> --template pedroasnogueira/base-projetos --private --clone`

### 2. Escolher o perfil
Leia a tabela da seção 3 de [`docs/arquitetura/README.md`](../arquitetura/README.md). Perfis podem ser combinados (ex.: Sistema + Mobile).

### 3. Rodar o script de inicialização
No Windows, use o **Git Bash** na pasta do projeto:
```
bash scripts/init.sh --dry-run    # mostra o que vai fazer
bash scripts/init.sh              # faz
```
O que ele faz (ADR 0005):
- [ ] ativa a validação de commits: `git config core.hooksPath .githooks` (ADR 0004)
- [ ] apaga os guias dos perfis não usados em `docs/arquitetura/perfis/`
- [ ] apaga o histórico do template (`docs/devlog/AAAA-MM-DD*.md`) e recomeça `README.md`, `STATUS.md` e `CHANGELOG.md`
- [ ] cria `docs/adr/NNNN-perfil-e-stack.md` com o próximo número livre e preenche a seção "Arquitetura" do `AGENTS.md`

### 4. Completar o ADR de perfil
Preencha o contexto, os desvios de stack e as **regras de domínio** que se aplicam ([`regras-de-dominio.md`](../arquitetura/regras-de-dominio.md)). Mude o status para `aceito`.

### 5. Preencher o AGENTS.md
- [ ] **Projeto:** 2 ou 3 frases. Sem visão geral longa (ADR 0002).
- [ ] **Comandos:** instalar, rodar, testes, lint, tipos. O `testador` usa exatamente estes.
- [ ] **Regras inegociáveis:** copie as regras de domínio escolhidas no ADR.

### 6. Criar a estrutura do perfil
Siga o guia do perfil. Confira as versões em [`docs/referencia/versoes.md`](../referencia/versoes.md) antes de instalar.
- [ ] **TypeScript (Sistema, Site, Mobile):** crie os scripts `lint`, `typecheck` e `test` no `package.json`, que o CI chama. Fixe o pnpm no campo `packageManager`.
- [ ] **Python (Automação):** configure `ruff`, `mypy` e `pytest` no `pyproject.toml` e gere o `uv.lock`, que o CI usa.
- [ ] **Sistema:** copie `docs/arquitetura/perfis/sistema/dependency-cruiser.exemplo.cjs` para a raiz como `.dependency-cruiser.cjs` e ative a linha `depcruise` no CI.
- [ ] Liste as variáveis de ambiente no `.env.example`.

### 7. Primeiro commit
```
git add -A
git commit -m "chore: initialize project from template"
```

### 8. Abrir a IA
- **Claude Code:** abra na pasta do projeto. Ele lê o `CLAUDE.md`, que importa o `AGENTS.md`, e usa o `opusplan` do `.claude/settings.json`.
- **Gemini CLI:** o `.gemini/settings.json` já aponta para o `AGENTS.md`.
- Primeira tarefa sugerida: "Leia o STATUS.md e me diga os próximos passos."

## Atualizar um projeto antigo com melhorias do template
O template evolui. Para trazer uma melhoria (um agente ajustado, um guia novo), compare com `git diff` ou copie o arquivo e registre no devlog do projeto. Mudança estrutural vira ADR no projeto também.
