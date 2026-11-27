# Tasklane

Tasklane is a self-hosted Kanban board for teams. Organise work into boards, lists and cards, drag cards between
columns, and keep everyone in sync with assignees, due dates, labels, checklists and comments.

[![CI](https://github.com/nevades/project-manager/actions/workflows/ci.yml/badge.svg)](https://github.com/nevades/project-manager/actions/workflows/ci.yml)

## Features

- **Boards** with colour backgrounds, descriptions and stars for quick access
- **Lists and cards** with drag-and-drop reordering (mouse, touch and keyboard)
- **Card details**: description, priority, due date, assignee, labels, checklist with progress, and comments
- **Collaboration**: invite members by email; owners manage the board, members manage its content
- **Filtering**: search cards by title or label, or show only the cards assigned to you
- **User administration**: the first account becomes an admin who can change roles and deactivate accounts
- **Secure by default**: BCrypt password hashing, session cookies, CSRF protection and a strict Content Security Policy

## Tech stack

| Layer    | Technology                                                                    |
| -------- | ----------------------------------------------------------------------------- |
| Frontend | React 19, TypeScript, Vite, Tailwind CSS 4, TanStack Query, dnd-kit           |
| Backend  | Java 25, Spring Boot 4 (Web MVC, Security, Data JPA, Validation), Flyway      |
| Database | PostgreSQL 17 (H2 in-memory for tests)                                        |
| Tooling  | Maven wrapper, ESLint, Prettier, Vitest, JUnit 5, Docker, GitHub Actions      |

## Quick start (Docker)

The fastest way to run Tasklane is Docker Compose. You only need [Docker](https://docs.docker.com/get-docker/).

```bash
git clone https://github.com/nevades/project-manager.git
cd project-manager
docker compose up --build
```

Open <http://localhost:8080>. With demo data enabled (the default for Docker Compose) you can sign in with:

| Email              | Password   |
| ------------------ | ---------- |
| `demo@example.com` | `demo1234` |

or click **Explore the demo workspace** on the sign-in page. You can also create your own account.

To stop the stack run `docker compose down`. Add `-v` to also delete the database volume.

## Configuration

Copy `.env.example` to `.env` to override defaults. Docker Compose reads it automatically.

| Variable                | Default                                       | Description                                              |
| ----------------------- | --------------------------------------------- | -------------------------------------------------------- |
| `APP_PORT`              | `8080`                                        | Host port for the web app (Compose only)                 |
| `DB_URL`                | `jdbc:postgresql://localhost:5432/tasklane`   | JDBC URL of the PostgreSQL database                      |
| `DB_USERNAME`           | `tasklane`                                    | Database user                                            |
| `DB_PASSWORD`           | `tasklane`                                    | Database password – **change this in production**        |
| `DB_PORT`               | `5432`                                        | Host port the database is published on (Compose only)    |
| `DEMO_DATA`             | `false` (`true` in Compose)                   | Seed a demo account and sample boards on an empty DB     |
| `REGISTRATION_ENABLED`  | `true`                                        | Allow self sign-up                                       |
| `SESSION_COOKIE_SECURE` | `false`                                       | Send the session cookie over HTTPS only                  |
| `PORT`                  | `8080`                                        | Port the Spring Boot server listens on                   |

> **Production checklist:** set a strong `DB_PASSWORD`, set `DEMO_DATA=false`, serve the app behind HTTPS and set
> `SESSION_COOKIE_SECURE=true`. Consider `REGISTRATION_ENABLED=false` for private instances.

## Local development

Run the API and the frontend dev server separately for hot reload.

**Prerequisites:** JDK 25, Node.js 20.19+ (24 recommended) and Docker (for PostgreSQL).

```bash
# 1. Start PostgreSQL
docker compose up -d db

# 2. Start the API on http://localhost:8080 (with demo data)
cd backend
DEMO_DATA=true ./mvnw spring-boot:run        # Windows PowerShell: $env:DEMO_DATA="true"; ./mvnw spring-boot:run

# 3. In another terminal, start the frontend on http://localhost:5173
cd frontend
npm install
npm run dev
```

The Vite dev server proxies `/api` requests to the backend, so open <http://localhost:5173>.

### Useful commands

| Where       | Command                    | What it does                                   |
| ----------- | -------------------------- | ---------------------------------------------- |
| `backend/`  | `./mvnw verify`            | Compile and run all backend tests              |
| `backend/`  | `./mvnw spring-boot:run`   | Run the API                                    |
| `frontend/` | `npm run dev`              | Start the dev server with hot reload           |
| `frontend/` | `npm run lint`             | Lint with ESLint                               |
| `frontend/` | `npm run test`             | Run unit tests with Vitest                     |
| `frontend/` | `npm run build`            | Type-check and build the production bundle     |
| `frontend/` | `npm run format`           | Format sources with Prettier                   |

## Project structure

```
.
├── backend/                 Spring Boot API
│   └── src/main/
│       ├── java/…/tasklane/
│       │   ├── board/       Boards, members, lists and labels
│       │   ├── card/        Cards, checklist items and comments
│       │   ├── security/    Authentication, CSRF and session configuration
│       │   ├── user/        Users and admin endpoints
│       │   ├── common/      Error handling (RFC 9457 problem details)
│       │   └── web/         SPA routing and demo data seeder
│       └── resources/db/migration/   Flyway SQL migrations
├── frontend/                React single-page app
│   └── src/
│       ├── components/      Shared UI (header, modal, avatar, …)
│       ├── features/        Pages: auth, boards, board, card, admin
│       └── lib/             API client, query hooks, types and helpers
├── Dockerfile               Multi-stage build producing a single image
└── docker-compose.yml       App + PostgreSQL
```

In production the React build is bundled into the Spring Boot jar and served from the same origin as the API.

## API overview

All endpoints live under `/api` and exchange JSON. Errors use the
[RFC 9457](https://www.rfc-editor.org/rfc/rfc9457) problem-details format.

| Method & path                                   | Description                          |
| ----------------------------------------------- | ------------------------------------ |
| `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/logout` | Account and session |
| `GET /api/auth/me`                              | Current user                         |
| `GET/POST /api/boards`                          | List or create boards                |
| `GET/PUT/DELETE /api/boards/{id}`               | Board with lists, cards, labels      |
| `POST /api/boards/{id}/members`                 | Add a member by email                |
| `POST /api/boards/{id}/lists`, `POST /api/lists/{id}/move` | Create and reorder lists  |
| `POST /api/lists/{id}/cards`, `POST /api/cards/{id}/move`  | Create and move cards     |
| `GET/PUT/DELETE /api/cards/{id}`                | Card details                         |
| `POST /api/cards/{id}/checklist`, `POST /api/cards/{id}/comments` | Checklist and comments |
| `GET /api/admin/users`, `PUT /api/admin/users/{id}` | User administration (admins only) |

Mutating requests must send the `X-XSRF-TOKEN` header with the value of the `XSRF-TOKEN` cookie
(call `GET /api/auth/csrf` once to obtain it).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Commits follow [Conventional Commits](https://www.conventionalcommits.org/).
