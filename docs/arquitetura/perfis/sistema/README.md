# Perfil: Sistema

> Para projetos com login, banco de dados e regras de negócio: sistemas empresariais, apps de finanças web, SaaS.
> Guias detalhados: [`backend.md`](backend.md) e [`frontend.md`](frontend.md).

## Stack
TypeScript de ponta a ponta, num monorepo com pnpm workspaces:
- **Backend:** Node.js + Fastify + PostgreSQL + Drizzle ORM + Zod
- **Frontend:** React + Vite + React Router + TanStack Query + React Hook Form + Tailwind
- **Compartilhado:** `packages/contracts` com os schemas Zod usados pelos dois lados
- **Testes:** Vitest, Testing Library, Playwright
- **Qualidade:** ESLint, Prettier, TypeScript `strict`, `dependency-cruiser`

## Arquitetura: monólito modular
Um código só e um deploy só, mas dividido em módulos com fronteiras rígidas. A Shopify seguiu esse caminho em vez de migrar para microsserviços: o código fica numa base só, com fronteiras definidas e respeitadas entre os componentes. Você ganha a simplicidade do monólito e o isolamento dos microsserviços. Se um dia um módulo precisar virar serviço, as fronteiras já estão prontas.

Cada módulo do backend segue o núcleo hexagonal: `domain` → `application` → `infra` / `http` (detalhes em `backend.md`).

## Estrutura do repositório
```
projeto/
├── apps/
│   ├── api/                 → backend (backend.md)
│   ├── web/                 → frontend (frontend.md)
│   └── mobile/              → opcional: app (perfil Mobile)
├── packages/
│   ├── contracts/           → schemas Zod e tipos compartilhados
│   └── config/              → tsconfig e eslint compartilhados
├── docs/ · scripts/ · .claude/ · .github/workflows/
├── AGENTS.md · CLAUDE.md · README.md · STATUS.md · CHANGELOG.md
├── package.json · pnpm-workspace.yaml · .env.example
```

## Contratos compartilhados
Os schemas de entrada e saída da API ficam em `packages/contracts`. O backend valida com eles e o frontend (e o app) tipa formulários e respostas com os mesmos schemas. Assim, os lados não divergem.

## Padrões do banco
- Toda tabela tem `id` (UUID v7), `created_at` e `updated_at`.
- Mudança de schema = nova migração. Migração aplicada nunca é editada.
- Cada módulo é dono das suas tabelas.

## Estratégia de testes
| Camada | Tipo | Quanto |
|---|---|---|
| Domínio | Unitário, sem mocks | Toda regra |
| Casos de uso | Integração com banco de teste real | Todo caso de uso |
| Rotas HTTP | Integração | Fluxos principais e erros de validação |
| Componentes com lógica | Testing Library | O que tem comportamento |
| Fluxos críticos | E2E (Playwright) | Poucos e essenciais |

## Versão mínima
Sistema pequeno (uma ferramenta interna, um MVP)? Comece com `apps/api` e `apps/web` e um ou dois módulos. Os princípios são os mesmos e a estrutura cresce junto.
