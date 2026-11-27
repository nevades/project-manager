# Development guide

## Prerequisites

| Tool    | Version              | Notes                                     |
| ------- | -------------------- | ----------------------------------------- |
| JDK     | 25                   | e.g. [Eclipse Temurin](https://adoptium.net) |
| Node.js | 22.22+ (24 recommended) |                                         |
| Docker  | recent               | Runs PostgreSQL; not needed for unit tests |

Maven is not required; use the included wrapper (`./mvnw`, or `mvnw.cmd` on Windows).

## Running locally

```bash
docker compose up -d db                        # PostgreSQL on localhost:5432
cd backend && DEMO_DATA=true ./mvnw spring-boot:run
cd frontend && npm install && npm run dev      # http://localhost:5173
```

The Vite dev server proxies `/api` and `/actuator` to `http://localhost:8080`, so the browser sees a single origin
and session cookies work exactly as in production.

To start over with a clean database: `docker compose down -v && docker compose up -d db`.

## Repository layout

```
backend/      Spring Boot API (Maven)        → see docs/architecture.md
frontend/     React + Vite single-page app
e2e/          Playwright browser smoke tests
docs/         Project documentation and screenshots
.github/      CI workflow, Dependabot, issue and PR templates
Dockerfile    Multi-stage build: frontend → backend jar → slim JRE image
```

## Common tasks

### Add a database change

1. Create `backend/src/main/resources/db/migration/V<next>__short_description.sql`.
2. Update the JPA entity. Hibernate validates the schema on start-up, so mismatches fail fast.
3. Never edit a migration that has been merged; always add a new one.

### Add an API endpoint

1. Add a request/response `record` to the feature's `*Dtos` class with Bean Validation annotations.
2. Implement the logic in the service, calling `BoardAccess` for anything board-scoped.
3. Expose it from the controller and add an integration test in `backend/src/test`.
4. Add a hook in `frontend/src/lib/queries.ts` and the type in `frontend/src/lib/types.ts`.
5. Document it in [api.md](api.md).

### Add a board background or label colour

- Backgrounds: add a key to `BACKGROUNDS` in `frontend/src/lib/theme.ts` (keys must match `^[a-z0-9-]{1,40}$`).
- Label colours: add to `LABEL_COLORS` in `theme.ts` **and** to `LABEL_COLOR_PATTERN` in `BoardDtos.java`.

## Tests and checks

```bash
cd backend  && ./mvnw verify                                   # JUnit + MockMvc integration tests (H2)
cd frontend && npm run lint && npm run test && npm run build    # ESLint, Vitest, tsc + Vite build
cd e2e      && npm ci && npx playwright install chromium && npm test   # against a running stack
```

The e2e suite assumes a fresh database with demo data (`docker compose down -v && docker compose up --build -d`).
Set `BASE_URL` to test another host. Screenshots are written to `e2e/screenshots/`.

## Code style

- Java: 4 spaces, constructor injection, records for DTOs, no Lombok.
- TypeScript: Prettier (`npm run format`) and ESLint. Keep server state in TanStack Query rather than component
  state.
- Commits: [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:` …).
