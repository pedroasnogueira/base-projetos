#!/usr/bin/env sh
# Checks that a commit message follows Conventional Commits 1.0.0.
# Usage: scripts/check-commit-msg.sh <file-with-message>
# Used by .githooks/commit-msg (locally) and by .github/workflows/ci.yml (in CI).
# No dependencies: plain POSIX sh + grep, so it works in TypeScript and Python projects alike.

msg_file="$1"
if [ -z "$msg_file" ] || [ ! -f "$msg_file" ]; then
  echo "uso: $0 <arquivo-com-a-mensagem>" >&2
  exit 2
fi

# First line that is not a git comment.
header=$(grep -v '^#' "$msg_file" | head -n 1 | tr -d '\r')

# Commits created by git itself are accepted as they are.
case "$header" in
  "Merge "* | "Revert \""* | "fixup! "* | "squash! "* | "amend! "*) exit 0 ;;
esac

types='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert'
pattern="^($types)(\([a-z0-9._/-]+\))?!?: [^ ].*"

if ! printf '%s\n' "$header" | grep -Eq "$pattern"; then
  cat >&2 <<MSG
Mensagem de commit fora do padrão:
  $header

Use Conventional Commits:  <tipo>(<escopo opcional>): <descrição>
  tipos: $(echo "$types" | tr '|' ' ')
  exemplo: feat(sales): add Pix discount
Explique o PORQUÊ no corpo. Guia: AGENTS.md, seção "Commits" (ADR 0004).
MSG
  exit 1
fi

if [ "${#header}" -gt 100 ]; then
  echo "A primeira linha do commit tem ${#header} caracteres; o limite é 100." >&2
  exit 1
fi
