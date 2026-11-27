# Contributing

Thanks for your interest in improving Tasklane!

## Getting started

Follow the **Local development** section of the [README](README.md) to run the API and the frontend.

## Workflow

1. Create a branch from `main`, for example `feat/card-attachments` or `fix/drag-on-touch`.
2. Make your change, with tests where it makes sense.
3. Make sure everything passes locally:
   ```bash
   cd backend && ./mvnw verify
   cd frontend && npm run lint && npm run test && npm run build
   ```
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
