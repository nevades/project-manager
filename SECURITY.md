# Security policy

## Supported versions

Security fixes are applied to the latest release on the `main` branch.

## Reporting a vulnerability

Please **do not open a public issue** for security problems.

Report vulnerabilities privately through GitHub:
**Security → Report a vulnerability** on this repository
([private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)).

Include the affected version or commit, steps to reproduce, and the impact you observed. You can expect an initial
response within a week. Once a fix is released the advisory will be published with credit to the reporter, unless
you prefer to stay anonymous.

## Hardening checklist for operators

- Use a strong, unique `DB_PASSWORD` and do not publish the database port to the internet.
- Serve Tasklane over HTTPS and set `SESSION_COOKIE_SECURE=true`.
- Set `DEMO_DATA=false` in production.
- Disable self sign-up with `REGISTRATION_ENABLED=false` for private instances.
- Keep the image up to date (`git pull && docker compose up --build -d`) and back up the database.
