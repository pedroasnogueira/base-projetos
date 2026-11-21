# Frontend: estrutura e padrões

> Stack: React + TypeScript · Vite · React Router · TanStack Query · React Hook Form + Zod · Tailwind CSS · Vitest + Testing Library · Playwright.
> Princípios gerais em [`../../README.md`](../../README.md). Visão do perfil em [`README.md`](README.md). Estrutura baseada no *Bulletproof React*.

---

## 1. Estrutura de pastas

```
apps/web/
├── src/
│   ├── app/                        → camada da aplicação
│   │   ├── routes/                 → páginas (uma por rota), finas: só montam features
│   │   ├── providers.tsx           → QueryClient, Router, tema, autenticação
│   │   └── layout/                 → shell da aplicação (menu, cabeçalho)
│   │
│   ├── features/                   → uma pasta por área de negócio
│   │   └── sales/
│   │       ├── api/                → chamadas HTTP + hooks do TanStack Query
│   │       │   ├── register-sale.ts
│   │       │   └── get-sales.ts
│   │       ├── components/         → componentes desta feature
│   │       │   ├── SaleForm.tsx
│   │       │   └── SaleForm.test.tsx
│   │       ├── hooks/              → hooks de UI desta feature
│   │       ├── utils/              → funções auxiliares desta feature
│   │       └── index.ts            → API pública da feature
│   │
│   ├── components/                 → componentes genéricos, sem regra de negócio
│   │   └── ui/                     → Button, Input, Modal, Table…
│   ├── hooks/                      → hooks genéricos (useDebounce…)
│   ├── lib/                        → cliente HTTP configurado, formatadores
│   │   ├── api-client.ts
│   │   └── format.ts               → formatMoney, formatDate
│   ├── config/
│   │   └── env.ts                  → variáveis de ambiente validadas
│   ├── utils/                      → funções puras genéricas
│   └── main.tsx
│
└── e2e/                            → testes Playwright dos fluxos críticos
```

---

## 2. Direção das importações

```
components/ · hooks/ · lib/ · utils/   (genéricos)
              ↓
          features/
              ↓
            app/
```

- `app/` pode importar de `features/` e dos genéricos.
- `features/` importa dos genéricos, mas **nunca de outra feature**. Se duas features precisam da mesma coisa, ela sobe para os genéricos ou é composta em `app/`.
- Os genéricos não importam de `features/` nem de `app/`.
- Uma feature é importada só pelo seu `index.ts`.

Regras verificadas pelo `dependency-cruiser` (ou `eslint-plugin-boundaries`) no CI.

---

## 3. Gerenciamento de estado

Use a ferramenta certa para cada tipo de estado. A maioria dos bugs de frontend vem de misturar esses tipos.

| Tipo de estado | Ferramenta | Exemplo |
|---|---|---|
| Dados do servidor | **TanStack Query** | lista de vendas, saldo do caixa |
| Formulário | **React Hook Form + Zod** (schemas de `contracts`) | formulário de venda |
| Estado de UI local | `useState` / `useReducer` | modal aberto, aba ativa |
| Estado na URL | parâmetros de busca do React Router | filtros, página da tabela |
| Global do cliente | Contexto do React (só se realmente necessário) | usuário logado, tema |

**Regra:** nunca copie dados do servidor para um estado local ou global. O TanStack Query já é o cache.

---

## 4. Padrões de código

### Componentes
- Um componente por arquivo, com nome em `PascalCase`.
- Páginas em `app/routes/` são finas: buscam parâmetros e montam componentes das features.
- Componentes de `components/ui/` são burros: recebem props e não chamam API.
- Componente passou de ~200 linhas? Quebre em partes menores.

### Chamadas à API
- Toda chamada passa por `lib/api-client.ts` (base URL, autenticação, tenant se houver, e erros num lugar só).
- Cada endpoint tem um arquivo em `features/<x>/api/` com a função de chamada e o hook do TanStack Query.
- As respostas são validadas/tipadas com os schemas de `packages/contracts`.

### Regras de negócio
- **O frontend não decide regra de negócio.** Ele pode validar para dar uma experiência melhor (campo obrigatório, formato), mas quem decide é o backend.
- Formatação de valores (dinheiro, datas) acontece só em `lib/format.ts`. Se o projeto lida com dinheiro, os valores trafegam em centavos (ver [`regras-de-dominio.md`](../../regras-de-dominio.md)).

### Estilo e acessibilidade
- Tailwind para estilos. Nada de CSS solto espalhado.
- Todo campo tem `label`. Todo botão de ícone tem `aria-label`.
- Layout responsivo, pensado primeiro para a menor tela em que o sistema será usado (celular ou tablet, se for o caso).

---

## 5. Receita: como criar uma tela nova

1. **Contrato:** confirme que o schema já existe em `packages/contracts`.
2. **API:** crie a função e o hook em `features/<x>/api/`.
3. **Componentes:** crie os componentes em `features/<x>/components/`, reaproveitando `components/ui/`.
4. **Exporte** o que a página precisa pelo `features/<x>/index.ts`.
5. **Rota:** crie a página em `app/routes/` montando os componentes.
6. **Testes:** teste de componente para o que tem lógica. Se for um fluxo crítico, teste E2E.
7. **Verificação:** lint, tipos, testes e fronteiras passando (`testador`).
