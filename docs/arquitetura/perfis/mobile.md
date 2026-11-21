# Perfil: Mobile

> Para apps instalados no celular (Android e iOS).
> Se o app tiver backend próprio, combine com o perfil **Sistema**: o app vira `apps/mobile` no mesmo monorepo e usa a mesma API e os mesmos contratos.

## Stack
- **Expo (React Native)** + TypeScript: um código para Android e iOS
- **Expo Router** para navegação baseada em arquivos
- **TanStack Query** para dados do servidor, **React Hook Form + Zod** para formulários
- **Testes:** Jest + React Native Testing Library; Maestro para fluxos E2E
- **Build e publicação:** EAS (Expo Application Services)

## Estrutura
```
apps/mobile/                (ou a raiz, se o app for o projeto inteiro)
├── app/                    → rotas (Expo Router): telas finas que montam features
│   ├── (tabs)/
│   └── _layout.tsx
├── src/
│   ├── features/           → uma pasta por área (mesmo padrão do frontend web)
│   │   └── transactions/
│   │       ├── api/
│   │       ├── components/
│   │       ├── hooks/
│   │       └── index.ts
│   ├── components/ui/      → componentes genéricos
│   ├── lib/                → cliente HTTP, armazenamento, formatadores
│   └── config/env.ts
├── assets/
└── e2e/                    → fluxos Maestro
```

## Padrões
- Mesma direção de importação do frontend web: genéricos → features → telas. Uma feature não importa outra.
- Tokens e dados sensíveis no **SecureStore**, nunca no AsyncStorage.
- Toda tela trata três estados: carregando, erro e vazio.
- Pense no uso offline e em rede ruim desde o início (ver [regras de domínio](../regras-de-dominio.md#offline--se-precisa-funcionar-sem-internet-balcão-campo)).
- Variáveis de ambiente públicas só com o prefixo `EXPO_PUBLIC_`. Segredos nunca vão para o app: ficam na API.
- Permissões do sistema (câmera, notificações) pedidas só no momento em que forem usadas.

## Receita: nova tela
1. Confira o contrato da API em `packages/contracts` (se houver backend).
2. Crie a chamada e o hook em `src/features/<x>/api/`.
3. Crie os componentes em `src/features/<x>/components/`.
4. Crie a rota em `app/` montando os componentes.
5. Teste no Android e no iOS (simulador ou Expo Go).
