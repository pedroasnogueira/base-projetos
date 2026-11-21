# Changelog

Todas as mudanças relevantes deste template ficam registradas aqui.
O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e o projeto usa [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Não lançado]

## [0.1.0] - 2026-11-21

### Adicionado
- Núcleo universal: `AGENTS.md`, `CLAUDE.md`, agentes (`explorador`, `testador`, `revisor`, `documentador`), skill `/explicar` e `opusplan` no `.claude/settings.json`.
- Guias de arquitetura com princípios universais, quatro perfis (Sistema, Site, Mobile, Automação) e regras de domínio opcionais.
- ADRs 0001 a 0005 com as decisões do template.
- `README.md`, `STATUS.md`, `CHANGELOG.md`, devlog e `docs/referencia/` com as versões das ferramentas conferidas em 2026-11-21.
- Guia `docs/guias/como-iniciar-um-projeto.md` e script `scripts/init.sh` (com `--dry-run`).
- Validação de Conventional Commits sem dependências: `scripts/check-commit-msg.sh` + `.githooks/commit-msg`.
- CI genérico (`.github/workflows/ci.yml`), template de pull request, `.gitignore`, `.gitattributes` (scripts sempre com LF) e `.env.example`.
- Configuração de exemplo do `dependency-cruiser` para o perfil Sistema, testada.
- `.gemini/settings.json` para o Gemini CLI ler o `AGENTS.md`.
