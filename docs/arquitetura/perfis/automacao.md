# Perfil: Automação

> Para scripts, rotinas agendadas, tratamento de dados, relatórios e integrações entre sistemas.

## Stack
- **Python 3.14 ou mais recente** (versões conferidas em `docs/referencia/versoes.md`), com **uv** para gerenciar ambiente e dependências
- **Ruff** (lint e formatação), **mypy** ou **pyright** (tipos), **pytest** (testes)
- **Pydantic** para validar configuração e dados de entrada
- **Typer** se o script tiver linha de comando com opções
- Bibliotecas de dados conforme a necessidade (pandas, polars, openpyxl)

> Se a automação roda dentro do Google Workspace (planilhas, Gmail), use **Apps Script com TypeScript (clasp)**, mantendo a mesma separação entre núcleo e bordas descrita abaixo.

## Estrutura
```
projeto/
├── src/
│   └── <nome_do_projeto>/
│       ├── core/           → regras e transformações puras (testáveis sem arquivo nem rede)
│       ├── io/             → leitura e escrita: arquivos, planilhas, APIs, banco
│       ├── jobs/           → cada rotina: junta io + core (ex.: daily_report.py)
│       ├── config.py       → configuração validada (Pydantic Settings)
│       └── cli.py          → ponto de entrada (Typer)
├── tests/                  → espelha src/
├── data/                   → exemplos de entrada para testes (nunca dados reais sensíveis)
├── docs/ · .claude/ · AGENTS.md · CLAUDE.md · README.md · STATUS.md · CHANGELOG.md
├── pyproject.toml · uv.lock
└── .env.example
```

## Padrões
- **Núcleo puro:** a função que calcula ou transforma recebe dados e devolve dados. Quem lê e grava arquivo é a camada `io/`. Assim, dá para testar a lógica com dados de exemplo.
- **Idempotência:** rodar a rotina duas vezes não pode duplicar o resultado (não reenviar e-mail, não lançar duas vezes).
- **Modo de teste:** toda rotina que envia ou altera algo tem uma opção `--dry-run` que mostra o que faria sem fazer.
- **Logs claros:** início, fim, quantos registros foram processados e o que falhou, sem dados sensíveis.
- **Falha alta:** erro inesperado para a rotina com mensagem clara. Nunca engula exceções.
- **Agendamento** (cron, GitHub Actions, Task Scheduler) documentado no `README.md`.

## Versão mínima
Um script de uma vez só pode ser um arquivo único, mas com a separação entre funções de cálculo e funções de leitura/escrita, e com pelo menos um teste. Quando passar de ~300 linhas ou ganhar uma segunda rotina, migre para a estrutura acima.

## Receita: nova rotina
1. Escreva a transformação em `core/` com teste usando dados de exemplo.
2. Escreva a leitura e a escrita em `io/`.
3. Junte as duas em `jobs/<nome>.py`, com `--dry-run`.
4. Exponha no `cli.py` e documente como rodar e agendar.
