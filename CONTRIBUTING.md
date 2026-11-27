# Contributing

Thanks for your interest in improving Tasklane!

## Getting started

Follow the [development guide](docs/development.md) to run the API and the frontend locally. The
[architecture overview](docs/architecture.md) explains how the code is organised.

Found a bug or have an idea? Open an issue using one of the templates. Security problems should be reported
privately as described in [SECURITY.md](SECURITY.md).

## Workflow

1. Create a branch from `main`, for example `feat/card-attachments` or `fix/drag-on-touch`.
2. Make your change, with tests where it makes sense.
3. Make sure everything passes locally:
   ```bash
   cd backend && ./mvnw verify
   cd frontend && npm run lint && npm run test && npm run build
   ```
   For UI changes, also run the browser tests against a fresh stack (see [docs/development.md](docs/development.md)).
4. Open a pull request with a clear description. CI runs the same checks.

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<optional scope>): <short summary in the imperative mood>
```

Common types: `feat`, `fix`, `refactor`, `test`, `docs`, `build`, `ci`, `chore`, `style`.
Example: `feat(card): add attachments to cards`.

## Code style

- **Java:** 4-space indentation, constructor injection, records for DTOs, one Flyway migration per schema change.
  Never edit a migration that has already been released; add a new `V<n>__description.sql` instead.
- **TypeScript/React:** run `npm run format` (Prettier) and `npm run lint` (ESLint). Keep server state in TanStack
  Query hooks in `src/lib/queries.ts`.
