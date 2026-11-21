#!/usr/bin/env bash
# Turns a fresh copy of the base template into a new project (ADR 0005).
#
# Usage (from the repository root, in Git Bash on Windows, or any terminal on macOS/Linux):
#   bash scripts/init.sh                 # asks the questions
#   bash scripts/init.sh --dry-run       # shows what it would do, changes nothing
#   bash scripts/init.sh --name "My app" --profiles sistema,mobile
#
# Profiles: sistema, site, mobile, automacao (combine with commas).
# What it does:
#   1. enables the commit-message hook (git config core.hooksPath .githooks)
#   2. removes the architecture guides of profiles the project does not use
#   3. removes the template's own history (devlog, handoff) and resets README, STATUS and CHANGELOG
#   4. creates the project's profile ADR with the next free number and links it in AGENTS.md
set -euo pipefail

DRY_RUN=false
NAME=""
PROFILES=""
ALL_PROFILES="sistema site mobile automacao"

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --name) NAME="${2:-}"; shift ;;
    --profiles) PROFILES="${2:-}"; shift ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) echo "Opção desconhecida: $1" >&2; exit 2 ;;
  esac
  shift
done

if [ ! -f AGENTS.md ] || [ ! -d docs/adr ]; then
  echo "Rode na raiz do repositório (onde fica o AGENTS.md)." >&2
  exit 1
fi
if [ ! -f docs/arquitetura/README.md ] || ! grep -q "Modelo do ADR de perfil" docs/arquitetura/README.md; then
  echo "Este repositório não parece uma cópia nova do template. Nada foi alterado." >&2
  exit 1
fi

run() {
  if $DRY_RUN; then echo "  [dry-run] $*"; else "$@"; fi
}
write_file() { # write_file <path>  (content from stdin)
  if $DRY_RUN; then echo "  [dry-run] write $1"; cat >/dev/null; else cat >"$1"; fi
}

# ---------- questions ----------
if [ -z "$NAME" ]; then
  read -r -p "Nome do projeto: " NAME
fi
[ -n "$NAME" ] || { echo "O nome do projeto é obrigatório." >&2; exit 1; }

if [ -z "$PROFILES" ]; then
  echo "Perfis (ver docs/arquitetura/README.md, seção 3):"
  echo "  sistema   login, banco e regras de negócio"
  echo "  site      conteúdo, pouca lógica de servidor"
  echo "  mobile    app instalado no celular"
  echo "  automacao scripts, rotinas, dados, integrações"
  read -r -p "Quais? (separe por vírgula, ex.: sistema,mobile): " PROFILES
fi

PROFILES=$(echo "$PROFILES" | tr 'A-Z' 'a-z' | tr -d ' ' | sed 's/automação/automacao/g')
CHOSEN=""
IFS=',' read -r -a requested <<<"$PROFILES"
for p in "${requested[@]}"; do
  case " $ALL_PROFILES " in
    *" $p "*) case " $CHOSEN " in *" $p "*) ;; *) CHOSEN="$CHOSEN $p" ;; esac ;;
    *) echo "Perfil desconhecido: '$p'. Use: $ALL_PROFILES" >&2; exit 1 ;;
  esac
done
CHOSEN="${CHOSEN# }"
[ -n "$CHOSEN" ] || { echo "Escolha pelo menos um perfil." >&2; exit 1; }

label() {
  case "$1" in
    sistema) echo "Sistema" ;; site) echo "Site" ;; mobile) echo "Mobile" ;; automacao) echo "Automação" ;;
  esac
}
guide() {
  case "$1" in
    sistema) echo "docs/arquitetura/perfis/sistema/README.md" ;;
    site) echo "docs/arquitetura/perfis/site.md" ;;
    mobile) echo "docs/arquitetura/perfis/mobile.md" ;;
    automacao) echo "docs/arquitetura/perfis/automacao.md" ;;
  esac
}
LABELS=""; GUIDES=""
for p in $CHOSEN; do
  LABELS="${LABELS:+$LABELS + }$(label "$p")"
  GUIDES="${GUIDES:+$GUIDES, }$(guide "$p")"
done

TODAY=$(date +%Y-%m-%d)
last=$(ls docs/adr | grep -E '^[0-9]{4}-' | sed 's/-.*//' | sort -n | tail -1)
NEXT=$(printf '%04d' $((10#$last + 1)))
ADR="docs/adr/${NEXT}-perfil-e-stack.md"

echo
echo "Projeto: $NAME"
echo "Perfis:  $LABELS"
echo "ADR:     $ADR"
$DRY_RUN && echo "(dry-run: nada será alterado)"
echo

# ---------- 1. commit hook ----------
echo "1. Ativando a validação de commits (.githooks/commit-msg)"
if git rev-parse --git-dir >/dev/null 2>&1; then
  run git config core.hooksPath .githooks
else
  echo "  não é um repositório git: pulado (rode 'git init' e o script de novo)"
fi

# ---------- 2. unused profiles ----------
echo "2. Removendo os guias dos perfis que o projeto não usa"
for p in $ALL_PROFILES; do
  case " $CHOSEN " in *" $p "*) continue ;; esac
  if [ "$p" = sistema ]; then target=docs/arquitetura/perfis/sistema; else target="docs/arquitetura/perfis/$p.md"; fi
  [ -e "$target" ] && run rm -rf "$target"
done

# ---------- 3. template history and fresh files ----------
echo "3. Limpando o histórico do template e criando README, STATUS e CHANGELOG do projeto"
for f in docs/devlog/*.md CONTEXTO-HANDOFF.md; do
  [ -e "$f" ] && [ "$(basename "$f")" != README.md ] && run rm -f "$f"
done

write_file README.md <<EOF
# $NAME

<!-- O que é, para quem e o problema que resolve, em 2 ou 3 frases. -->

## Como rodar
<!-- Pré-requisitos e comandos. Os mesmos da seção "Comandos" do AGENTS.md. -->

## Documentação
- Onde o projeto parou: [STATUS.md](STATUS.md)
- Decisões: [docs/adr/](docs/adr/) · Arquitetura: [docs/arquitetura/](docs/arquitetura/README.md)
- Como trabalhar com IA neste projeto: [AGENTS.md](AGENTS.md)

Criado a partir do template [base-projetos](https://github.com/pedroasnogueira/base-projetos).
EOF

write_file STATUS.md <<EOF
# Status

> Onde o projeto parou. Reescrito pelo \`documentador\` ao fim de cada tarefa (máximo ~30 linhas).

**Atualizado em:** $TODAY

## Estado atual
Projeto criado a partir do template. Perfil(is): $LABELS (ADR $NEXT).

## Em andamento
- Nada.

## Próximos passos
1. Preencher as seções "Projeto", "Comandos" e "Regras inegociáveis" do \`AGENTS.md\`.
2. Completar o ADR $NEXT com o contexto e as regras de domínio.
3. Criar a estrutura de pastas do perfil (ver $GUIDES).

## Problemas conhecidos
- Nenhum.
EOF

write_file CHANGELOG.md <<'EOF'
# Changelog

Todas as mudanças relevantes deste projeto ficam registradas aqui.
O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e o projeto usa [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Não lançado]

### Adicionado
- Estrutura inicial a partir do template base-projetos.
EOF

# ---------- 4. profile ADR + AGENTS.md ----------
echo "4. Criando $ADR e ligando no AGENTS.md"
write_file "$ADR" <<EOF
# $NEXT. Perfil e stack deste projeto

- **Data:** $TODAY
- **Status:** proposto

## Contexto
<!-- O que o projeto é, para quem, e o que ele precisa (login? banco? offline? SEO?). -->

## Decisão
Perfil(is): $LABELS
Stack: a do(s) perfil(is) ($GUIDES), com estes desvios: <!-- nenhum, ou quais e por quê -->
Regras de domínio aplicáveis: <!-- dinheiro / multi-tenant / dados pessoais / autenticação / datas / fiscal / offline (ver docs/arquitetura/regras-de-dominio.md) -->

## Alternativas consideradas
- <!-- outro perfil ou outra stack, e por que não -->

## Consequências
<!-- O que fica mais fácil, o que fica mais difícil. -->
EOF

if $DRY_RUN; then
  echo "  [dry-run] atualizar a seção Arquitetura do AGENTS.md"
else
  sed -i.bak \
    -e "s#^- \*\*Perfil(is):\*\* .*#- **Perfil(is):** $LABELS (decisão no ADR \`$(basename "$ADR")\`)#" \
    -e "s#^- \*\*Guias a seguir:\*\* .*#- **Guias a seguir:** $GUIDES#" \
    AGENTS.md
  rm -f AGENTS.md.bak
fi

echo
echo "Pronto. Próximos passos (detalhes em docs/guias/como-iniciar-um-projeto.md):"
echo "  - Preencha o AGENTS.md e o $ADR."
echo "  - Confira com 'git status' e faça o primeiro commit: chore: initialize project from template"
echo "  - Este script não é mais necessário: pode apagar scripts/init.sh."
