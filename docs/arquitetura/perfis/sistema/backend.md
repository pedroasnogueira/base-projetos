# Backend: estrutura e padrões

> Stack: Node.js + TypeScript · Fastify · PostgreSQL · Drizzle ORM · Zod · Vitest.
> Princípios gerais em [`../../README.md`](../../README.md). Visão do perfil em [`README.md`](README.md).

---

## 1. Estrutura de pastas

```
apps/api/
├── src/
│   ├── modules/                    → um módulo por área de negócio
│   │   └── sales/
│   │       ├── domain/             → entidades e regras puras (sem import externo)
│   │       │   ├── sale.ts
│   │       │   ├── sale.test.ts
│   │       │   └── errors.ts
│   │       ├── application/        → casos de uso + portas (interfaces)
│   │       │   ├── register-sale.ts
│   │       │   ├── register-sale.test.ts
│   │       │   └── ports.ts        → ex.: interface SaleRepository
│   │       ├── infra/              → implementações das portas
│   │       │   ├── sale-repository.drizzle.ts
│   │       │   └── schema.ts       → tabelas Drizzle deste módulo
│   │       ├── http/               → rotas Fastify (borda de entrada)
│   │       │   └── routes.ts
│   │       └── index.ts            → API pública do módulo
│   │
│   ├── shared/                     → núcleo comum, sem regra de módulo específico
│   │   ├── money.ts                → se o projeto lida com dinheiro
│   │   ├── result.ts               → Result<T, E> para erros esperados
│   │   ├── errors.ts               → classes base de erro
│   │   └── tenant.ts               → se o projeto for multi-tenant
│   │
│   ├── infra/                      → infraestrutura global
│   │   ├── db.ts                   → conexão com o banco
│   │   ├── env.ts                  → variáveis de ambiente validadas com Zod
│   │   ├── logger.ts
│   │   └── server.ts               → monta o Fastify e registra os módulos
│   │
│   └── main.ts                     → ponto de entrada
│
├── migrations/                     → migrações geradas pelo Drizzle (nunca editar à mão)
└── tests/                          → helpers e setup de testes de integração
```

---

## 2. O papel de cada camada

| Camada | Pode importar | Não pode importar | Contém |
|---|---|---|---|
| `domain/` | `shared/` | Fastify, Drizzle, `application/`, `infra/`, `http/` | Entidades, invariantes, cálculos, erros de negócio |
| `application/` | `domain/`, `shared/`, `packages/contracts` | `infra/`, `http/`, Drizzle, Fastify | Casos de uso (um arquivo por ação) e portas |
| `infra/` | `application/` (portas), `domain/`, `shared/`, Drizzle | `http/` | Repositórios, clientes de APIs externas |
| `http/` | `application/`, `packages/contracts`, Fastify | `infra/` direto, `domain/` direto | Rotas, validação de entrada, mapeamento de erro → status HTTP |
| `index.ts` | tudo do módulo | — | Registra as rotas e exporta o que outros módulos podem usar |

Essas regras são verificadas pelo `dependency-cruiser` no CI.

---

## 3. Padrões de código

### Caso de uso
Um arquivo por ação, com nome de verbo: `register-sale.ts`, `close-cash-register.ts`. Recebe as dependências (portas) por parâmetro e retorna `Result`.

```ts
// application/register-sale.ts
export function makeRegisterSale(deps: { sales: SaleRepository; stock: StockGateway }) {
  return async (input: RegisterSaleInput, ctx: TenantContext): Promise<Result<Sale, SaleError>> => {
    // 1. valida regras de negócio (domain)
    // 2. persiste via porta
    // 3. retorna resultado
  };
}
```

### Rota HTTP
A rota só faz três coisas: valida a entrada com o schema de `contracts`, chama o caso de uso e traduz o resultado em resposta HTTP. Nenhuma regra de negócio na rota.

### Erros
- **Esperados** (estoque insuficiente, caixa fechado): retornados como `Result` e convertidos em `4xx` na rota.
- **Inesperados** (banco fora do ar): exceção, capturada pelo handler global, logada e devolvida como `500` sem detalhes internos.

### Banco de dados
- Cada módulo declara as próprias tabelas em `infra/schema.ts`. Só o módulo dono acessa as suas tabelas.
- Toda tabela de negócio tem `id` (UUID v7), `created_at` e `updated_at` (e `tenant_id`, se o projeto for multi-tenant).
- Mudança de schema = nova migração (`drizzle-kit generate`). Migração aplicada nunca é editada.
- Operações que alteram mais de uma tabela rodam em transação.
- Regras de dinheiro, multi-tenant, dados pessoais etc.: ver [`regras-de-dominio.md`](../../regras-de-dominio.md) e o que o AGENTS.md do projeto marcou como aplicável.

### Comunicação entre módulos
- Um módulo chama outro **só** pelo que o `index.ts` exporta.
- Se a dependência for de mão dupla, é sinal de que a fronteira está errada: registre a dúvida num ADR antes de seguir.

---

## 4. Receita: como criar uma funcionalidade nova

1. **Contrato:** crie ou atualize o schema Zod em `packages/contracts`.
2. **Domínio:** escreva a regra em `domain/` e o teste unitário junto.
3. **Caso de uso:** crie `application/<verbo-substantivo>.ts`. Se precisar de algo novo do banco, declare na porta em `ports.ts`.
4. **Infra:** implemente o método novo no repositório. Se mudou tabela, gere a migração.
5. **HTTP:** adicione a rota em `http/routes.ts` usando o schema do contrato.
6. **Testes:** teste de integração do caso de uso e da rota.
7. **Verificação:** lint, tipos, testes e fronteiras passando (`testador`).

## 5. Receita: como criar um módulo novo

1. Copie a estrutura de pastas de um módulo existente (`domain/`, `application/`, `infra/`, `http/`, `index.ts`).
2. Registre o módulo em `infra/server.ts`.
3. Adicione o módulo às regras do `dependency-cruiser`.
4. Se for uma área de negócio nova, registre a decisão num ADR.
