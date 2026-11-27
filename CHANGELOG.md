# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [1.0.0] – 2026-11-27

Complete rewrite of the original JSP prototype as **Tasklane**.

### Added

- Spring Boot 4 API on Java 25 with PostgreSQL and Flyway migrations.
- React 19 + TypeScript single-page app built with Vite and Tailwind CSS.
- Boards with backgrounds, stars, members and labels.
- Lists and cards with drag-and-drop reordering (mouse, touch and keyboard).
- Card details: description, priority, due date, assignee, labels, checklist and comments.
- Card filtering by text, label or "my cards", and shareable card links.
- User administration with roles and account deactivation that applies to active sessions immediately.
- Optional demo workspace (`DEMO_DATA=true`).
- Multi-stage Docker image and Docker Compose stack.
- Backend integration tests, frontend unit tests and Playwright end-to-end tests, all run in GitHub Actions.
- Documentation: architecture, API reference, deployment and development guides.

### Security

- Passwords are hashed with BCrypt and verified on login (the prototype did not check passwords).
- All database access uses parameterised queries (the prototype's table search was open to SQL injection).
- CSRF protection, session fixation protection and a strict Content Security Policy.
- Database credentials are read from the environment instead of being hard-coded.

### Removed

- The legacy Spring MVC/JSP application and its vendored front-end libraries.
