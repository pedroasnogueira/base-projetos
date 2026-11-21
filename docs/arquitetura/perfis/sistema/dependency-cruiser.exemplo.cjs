// Example dependency-cruiser config for the "Sistema" profile.
// Copy to the repository root as `.dependency-cruiser.cjs` and run:
//   pnpm exec depcruise apps packages
// Rules mirror docs/arquitetura/perfis/sistema/backend.md (section 2) and frontend.md (section 2).
// Adjust the paths if your apps live elsewhere.
// Needs typescript ^6.0 (or >=7.1) installed: dependency-cruiser cannot use the 7.0 API.

const API = '^apps/api/src/modules/';
const WEB = '^apps/web/src/';

/** @type {import('dependency-cruiser').IConfiguration} */
module.exports = {
  forbidden: [
    // ---------- universal ----------
    {
      name: 'no-circular',
      severity: 'error',
      comment: 'Circular imports hide a wrong boundary. Rethink the split (ADR if needed).',
      from: {},
      to: { circular: true },
    },
    {
      name: 'not-to-unresolvable',
      severity: 'error',
      comment: 'Import that cannot be resolved: missing package or wrong path.',
      from: {},
      to: { couldNotResolve: true },
    },

    // ---------- backend: hexagonal layers inside each module ----------
    {
      name: 'domain-is-pure',
      severity: 'error',
      comment: 'domain/ only imports shared/. No framework, ORM or outer layer (U2).',
      from: { path: `${API}([^/]+)/domain/` },
      to: {
        pathNot: [`${API}$1/domain/`, '^apps/api/src/shared/'],
        dependencyTypesNot: ['core'],
      },
    },
    {
      name: 'application-not-to-infra-or-http',
      severity: 'error',
      comment: 'Use cases depend on ports, never on concrete infra or HTTP (U3).',
      from: { path: `${API}[^/]+/application/` },
      to: { path: [`${API}[^/]+/(infra|http)/`, 'node_modules/(fastify|drizzle-orm|@fastify/)'] },
    },
    {
      name: 'infra-not-to-http',
      severity: 'error',
      from: { path: `${API}[^/]+/infra/` },
      to: { path: `${API}[^/]+/http/` },
    },
    {
      name: 'http-only-through-application',
      severity: 'error',
      comment: 'Routes call use cases; they do not touch infra or domain directly.',
      from: { path: `${API}[^/]+/http/` },
      to: { path: `${API}[^/]+/(infra|domain)/` },
    },
    {
      name: 'modules-talk-through-index',
      severity: 'error',
      comment: 'Another module is reached only through its index.ts (U4).',
      from: { path: `${API}([^/]+)/` },
      to: {
        path: `${API}[^/]+/`,
        pathNot: [`${API}$1/`, `${API}[^/]+/index\\.ts$`],
      },
    },

    // ---------- frontend: generic -> features -> app ----------
    {
      name: 'feature-not-to-other-feature',
      severity: 'error',
      comment: 'A feature never imports another feature. Move shared code up or compose in app/.',
      from: { path: `${WEB}features/([^/]+)/` },
      to: { path: `${WEB}features/`, pathNot: `${WEB}features/$1/` },
    },
    {
      name: 'generic-not-to-features-or-app',
      severity: 'error',
      comment: 'components/, hooks/, lib/, utils/ and config/ stay free of business code.',
      from: { path: `${WEB}(components|hooks|lib|utils|config)/` },
      to: { path: `${WEB}(features|app)/` },
    },
    {
      name: 'features-not-to-app',
      severity: 'error',
      from: { path: `${WEB}features/` },
      to: { path: `${WEB}app/` },
    },
    {
      name: 'app-uses-feature-index',
      severity: 'error',
      comment: 'Pages import a feature only through its index.ts.',
      from: { path: `${WEB}app/` },
      to: { path: `${WEB}features/[^/]+/`, pathNot: `${WEB}features/[^/]+/index\\.tsx?$` },
    },
  ],
  options: {
    doNotFollow: { path: 'node_modules' },
    exclude: { path: '(^|/)(dist|build|coverage|migrations)/' },
    tsPreCompilationDeps: true,
    tsConfig: { fileName: 'tsconfig.json' },
    enhancedResolveOptions: {
      exportsFields: ['exports'],
      conditionNames: ['import', 'require', 'node', 'default', 'types'],
      extensions: ['.ts', '.tsx', '.js', '.mjs', '.cjs', '.json'],
    },
  },
};
