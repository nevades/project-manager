# Deployment

Tasklane ships as one Docker image (web app + API) that needs a PostgreSQL database. The included
`docker-compose.yml` runs both and is suitable for small teams on a single server.

## 1. Prepare the server

Install Docker Engine with the Compose plugin, then:

```bash
git clone https://github.com/nevades/project-manager.git tasklane
cd tasklane
cp .env.example .env
```

## 2. Configure `.env`

```dotenv
APP_PORT=8080
DB_USERNAME=tasklane
DB_PASSWORD=<a long random password>
DEMO_DATA=false
REGISTRATION_ENABLED=true        # set to false after your team has signed up
SESSION_COOKIE_SECURE=true       # required once you serve over HTTPS
```

Generate a password with `openssl rand -base64 32`.

> The database password is applied when the volume is **first** created. To change it later, change it inside
> PostgreSQL (`ALTER USER tasklane PASSWORD '…'`) as well as in `.env`.

## 3. Start

```bash
docker compose up --build -d
docker compose ps          # both services should be "healthy"
```

The first account you register becomes the administrator.

If PostgreSQL must not be reachable from other machines, remove the `ports` section of the `db` service in
`docker-compose.yml` (the app talks to it over the internal Docker network).

## 4. Put it behind HTTPS

Run a reverse proxy in front of port 8080 and set `SESSION_COOKIE_SECURE=true`. A minimal
[Caddy](https://caddyserver.com/) configuration, which obtains certificates automatically:

```caddyfile
tasks.example.com {
    reverse_proxy localhost:8080
}
```

The equivalent for nginx:

```nginx
server {
    listen 443 ssl;
    server_name tasks.example.com;
    # ssl_certificate / ssl_certificate_key …

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Backups

Back up the database regularly:

```bash
docker compose exec -T db pg_dump -U tasklane tasklane | gzip > tasklane-$(date +%F).sql.gz
```

Restore into a fresh stack:

```bash
docker compose up -d db
gunzip -c tasklane-2026-01-31.sql.gz | docker compose exec -T db psql -U tasklane tasklane
docker compose up -d
```

## Upgrading

```bash
git pull
docker compose up --build -d
```

Database migrations run automatically on start-up. Take a backup first.

## Running without Docker Compose

The image only needs these environment variables:

| Variable                | Example                                   |
| ----------------------- | ----------------------------------------- |
| `DB_URL`                | `jdbc:postgresql://db-host:5432/tasklane` |
| `DB_USERNAME`           | `tasklane`                                |
| `DB_PASSWORD`           | `…`                                       |
| `SESSION_COOKIE_SECURE` | `true`                                    |
| `DEMO_DATA`             | `false`                                   |
| `REGISTRATION_ENABLED`  | `true` / `false`                          |

```bash
docker build -t tasklane .
docker run -d -p 8080:8080 -e DB_URL=… -e DB_USERNAME=… -e DB_PASSWORD=… tasklane
```

Or build the jar directly (`cd frontend && npm ci && npm run build`, copy `dist/` to
`backend/src/main/resources/static/`, then `cd backend && ./mvnw package`) and run
`java -jar target/tasklane-*.jar` on any machine with Java 25.

## Health checks and monitoring

- `GET /actuator/health/liveness` and `/actuator/health/readiness` report status (used by the Docker `HEALTHCHECK`).
- Logs go to stdout: `docker compose logs -f app`.
