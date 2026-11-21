# Versões de referência

> Conferidas em **2026-11-21** nos registros oficiais (npm, PyPI, nodejs.org, endoflife.date). Use como ponto de partida ao criar um projeto e confira de novo se tiver passado muito tempo. Os guias de perfil citam só o nome das ferramentas, para não desatualizarem.

## Ambiente
| Ferramenta | Usar | Observação |
|---|---|---|
| Node.js | **26 LTS** (ou 24 LTS) | O 26 virou LTS em outubro de 2026. O CI usa `lts/*`. |
| pnpm | 12.x | Fixe a versão no campo `packageManager` do `package.json`. |
| Python | **3.14 ou 3.15** | O 3.15 saiu em outubro de 2026. Bibliotecas novas podem demorar para suportá-lo; na dúvida, use o 3.14. |
| uv | 0.13.x | |

## TypeScript: atenção
| Ferramenta | Usar | Observação |
|---|---|---|
| TypeScript | **6.0.x** por enquanto | O 7.0 (compilador nativo) ainda não serve para o ecossistema: o `typescript-eslint` 8.73 aceita só `<6.1` e o `dependency-cruiser` 18.8 não funciona com o 7.0 (testado). Reavalie quando os dois suportarem 7.x. |

## Perfil Sistema
| Ferramenta | Versão | Ferramenta | Versão |
|---|---|---|---|
| Fastify | 5.x | React | 19.x |
| Drizzle ORM / drizzle-kit | 0.45 / 0.31 | Vite | 8.x |
| Zod | 4.x | React Router | 8.x |
| Vitest | 5.x | TanStack Query | 5.x |
| Playwright | 1.65 | React Hook Form | 7.x |
| ESLint | 10.x (só *flat config*) | Tailwind CSS | 4.x (configuração no CSS) |
| Prettier | 3.x | dependency-cruiser | 18.x |

## Perfil Site e Mobile
| Ferramenta | Versão |
|---|---|
| Astro | 7.x |
| Expo SDK / Expo Router | 58 |

## Perfil Automação
| Ferramenta | Versão |
|---|---|
| Ruff | 0.17.x |
| mypy | 2.x |
| pyright (alternativa ao mypy) | 1.1.x |
| Pydantic | 2.x |
| Typer | 0.29.x |
| pytest | 9.x |

## GitHub Actions (usadas em `.github/workflows/ci.yml`)
`actions/checkout@v7` · `actions/setup-node@v7` · `pnpm/action-setup@v6` · `astral-sh/setup-uv@v10`

## Claude Code
- `"model": "opusplan"` continua válido (Opus no modo plano, Sonnet na execução).
- Campo `model` dos subagentes aceita `haiku`, `sonnet`, `opus`, `fable`, um ID completo ou `inherit`.
- `/usage` mostra o consumo e quanto cada subagente e skill gastou.
