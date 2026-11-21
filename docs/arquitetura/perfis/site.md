# Perfil: Site

> Para sites de conteúdo, com pouca ou nenhuma lógica de servidor: institucional, landing page, portfólio, blog.
> Se o site precisar de login, banco ou regras de negócio, combine com o perfil **Sistema**.

## Stack
- **Astro** + TypeScript: gera HTML estático, rápido e bom para SEO
- **Tailwind CSS** para estilos
- **Conteúdo** em Markdown/MDX com *content collections* tipadas
- Ilhas de **React** só onde houver interatividade (formulário, carrossel)
- **Testes:** Playwright para as páginas e formulários principais
- **Deploy:** hospedagem estática (Vercel, Netlify ou Cloudflare Pages)

## Estrutura
```
projeto/
├── src/
│   ├── pages/              → uma rota por arquivo (index.astro, contato.astro)
│   ├── layouts/            → estruturas de página (BaseLayout.astro)
│   ├── components/
│   │   ├── ui/             → genéricos: Button, Card
│   │   └── sections/       → blocos de página: Hero, Pricing, Faq
│   ├── content/            → textos em Markdown, organizados por coleção
│   │   └── blog/
│   ├── lib/                → funções utilitárias, formatadores
│   └── styles/
├── public/                 → imagens, favicon, arquivos servidos como estão
├── e2e/
├── docs/ · .claude/ · AGENTS.md · CLAUDE.md · README.md · STATUS.md · CHANGELOG.md
└── .env.example
```

## Padrões
- O conteúdo (texto) fica separado do layout (código): dá para trocar textos sem mexer em componente.
- JavaScript só onde for necessário. Por padrão, as páginas são HTML puro.
- Toda página tem `title`, `description` e Open Graph definidos no layout.
- Imagens otimizadas pelo componente de imagem do Astro, sempre com `alt`.
- Formulários enviados para um serviço (ou uma função serverless), nunca expondo chaves no cliente.
- Meta de desempenho: Lighthouse acima de 90 em todas as categorias.

## Receita: nova página
1. Crie o conteúdo em `src/content/` (se for texto) ou direto na página.
2. Monte a página em `src/pages/` usando um layout e as seções de `components/sections/`.
3. Confira título, descrição e imagem de compartilhamento.
4. Rode o Lighthouse e o teste E2E da página.
