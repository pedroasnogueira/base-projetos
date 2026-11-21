# Arquitetura: princípios universais e perfis

> Este arquivo vale para **qualquer** projeto. A estrutura concreta de pastas e a stack vêm do **perfil** escolhido para o projeto.

---

## 1. Como usar

1. Escolha o perfil que combina com o projeto (seção 3).
2. Registre a escolha num ADR (`docs/adr/NNNN-perfil-e-stack.md`, com o próximo número livre), a partir do modelo da seção 4.
3. Preencha a seção "Arquitetura" do `AGENTS.md` com o perfil e os caminhos dos guias dele.
4. Apague os perfis que o projeto não usa (ou deixe, se pretende adicionar um app depois).
5. Confira a lista de [regras de domínio](regras-de-dominio.md) e copie para o AGENTS.md as que se aplicam.

---

## 2. Princípios universais

Valem para sistema, site, app ou script.

### U1 — Organize por funcionalidade, não por tipo de arquivo
Tudo o que muda junto fica junto. Em vez de `controllers/`, `services/` e `models/` espalhados, cada área do produto tem a sua pasta com tudo dentro. É a ideia da *Vertical Slice Architecture* [1] e do *Bulletproof React* [2]: pouco acoplamento entre fatias, muito dentro de cada fatia.

### U2 — A lógica principal não depende de detalhes externos
Regras de negócio, cálculos e transformações ficam em código puro, separados de banco, rede, interface e framework. É o núcleo da *Arquitetura Hexagonal* (Ports & Adapters) de Alistair Cockburn [3]. Num script pequeno, isso pode ser só separar a função de cálculo da função que lê o arquivo. O princípio é o mesmo em qualquer escala.

### U3 — Dependências apontam para dentro
A borda (interface, rotas, CLI, leitura de arquivos) depende do núcleo, nunca o contrário.

### U4 — Cada área tem uma porta da frente
Uma pasta de funcionalidade expõe o que os outros podem usar num arquivo de entrada (`index.ts`, `__init__.py`). Ninguém importa arquivos internos de outra área.

### U5 — Comece simples e cresça quando doer
Use a menor estrutura que resolve o problema. Monorepo, módulos e camadas entram quando a necessidade aparece, não antes. Toda mudança estrutural vira um ADR.

### U6 — Regras checadas por ferramenta
Formatação, lint, tipos e fronteiras entre pastas são verificados automaticamente no CI. Regra que só existe no papel é esquecida, principalmente por uma IA.

### U7 — Configuração fora do código
Nada de URL, senha ou chave no código. Tudo vem de variáveis de ambiente, validadas na inicialização, como no *Twelve-Factor App* [4]. O `.env.example` lista todas as variáveis, sem valores reais.

### U8 — Tipagem estrita
TypeScript em modo `strict` ou Python com type hints checados (`mypy`/`pyright`). Nada de `any` sem justificativa.

### U9 — Teste o que custa caro errar
Toda regra de negócio tem teste unitário. Os fluxos críticos para o usuário têm teste ponta a ponta. Componentes visuais simples não precisam.

### Convenções universais
| Item | Padrão |
|---|---|
| Idioma do código | Inglês (nomes, funções, tabelas, commits) |
| Idioma da documentação | Português |
| Termos de negócio | Mapeados em `docs/produto/glossario.md` |
| Arquivos e pastas | `kebab-case` (TS) ou `snake_case` (Python) |
| Testes | Ao lado do arquivo testado, ou em `tests/` espelhando a estrutura |

---

## 3. Perfis

| Perfil | Quando usar | Exemplos | Guia |
|---|---|---|---|
| **Sistema** | Tem login, banco de dados e regras de negócio | Sistema da loja, app de finanças web, ERP, SaaS | [`perfis/sistema/`](perfis/sistema/README.md) |
| **Site** | Conteúdo, pouca ou nenhuma lógica de servidor | Site institucional, landing page, portfólio, blog | [`perfis/site.md`](perfis/site.md) |
| **Mobile** | App instalado no celular | App de finanças, app de clientes da loja | [`perfis/mobile.md`](perfis/mobile.md) |
| **Automação** | Scripts, rotinas, tratamento de dados, integrações | Scripts do trabalho, robô de relatórios, ETL | [`perfis/automacao.md`](perfis/automacao.md) |

**Combinações são normais.** Um app de finanças completo é *Sistema + Mobile*: a mesma API atende o site e o app, e os dois compartilham os contratos. Um site com área do cliente é *Site + Sistema*.

**Não está coberto** (jogos, IA/ML, desktop, embarcados)? Crie um perfil novo seguindo os princípios universais e registre num ADR.

---

## 4. Modelo do ADR de perfil

```markdown
# NNNN. Perfil e stack deste projeto

- Data: AAAA-MM-DD
- Status: aceito

## Contexto
O que o projeto é, para quem, e o que ele precisa (login? banco? offline? SEO?).

## Decisão
Perfil(is): Sistema | Site | Mobile | Automação
Stack: a do perfil, com estes desvios: ...
Regras de domínio aplicáveis: dinheiro / multi-tenant / dados pessoais / ...

## Consequências
...
```

---

## Referências

1. Jimmy Bogard — *Vertical Slice Architecture*. https://www.jimmybogard.com/vertical-slice-architecture/
2. Alan Alickovic — *Bulletproof React: Project Structure*. https://github.com/alan2207/bulletproof-react/blob/master/docs/project-structure.md
3. Alistair Cockburn — *Hexagonal Architecture (Ports & Adapters)*. https://alistair.cockburn.us/hexagonal-architecture/
4. *The Twelve-Factor App*. https://12factor.net/
5. Shopify Engineering — *Deconstructing the Monolith*. https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity
