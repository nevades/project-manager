# API reference

All endpoints are under `/api`, accept and return JSON, and use the session cookie for authentication.

## Conventions

**CSRF.** Every `POST`, `PUT` and `DELETE` must include the header `X-XSRF-TOKEN` with the current value of the
`XSRF-TOKEN` cookie. Call `GET /api/auth/csrf` once to receive the cookie.

**Errors** use [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457) problem details:

```json
{ "title": "Not Found", "status": 404, "detail": "Board not found.", "instance": "/api/boards/9" }
```

| Status | Meaning                                                                   |
| ------ | ------------------------------------------------------------------------- |
| `400`  | Validation failed or the request is not allowed for this resource state |
| `401`  | Not signed in, wrong credentials, or the account was deactivated          |
| `403`  | Signed in but not permitted (e.g. not the board owner, missing CSRF token) |
| `404`  | Resource does not exist **or you are not a member of its board**         |
| `409`  | Conflict, e.g. email already registered or user already a member         |

### Example session with curl

```bash
BASE=http://localhost:8080
curl -c jar -b jar $BASE/api/auth/csrf
TOKEN=$(awk '/XSRF-TOKEN/ {print $7}' jar)
curl -c jar -b jar -H "X-XSRF-TOKEN: $TOKEN" -H 'Content-Type: application/json' \
     -d '{"email":"demo@example.com","password":"demo1234"}' $BASE/api/auth/login
curl -b jar $BASE/api/boards
```

## Authentication

| Method | Path                 | Body                                   | Response            |
| ------ | -------------------- | -------------------------------------- | ------------------- |
| GET    | `/api/auth/csrf`     | –                                      | `{headerName, token}` and sets the cookie |
| GET    | `/api/auth/config`   | –                                      | `{registrationEnabled, demoEnabled}` |
| POST   | `/api/auth/register` | `{email, displayName, password}`       | `201` User          |
| POST   | `/api/auth/login`    | `{email, password}`                    | User                |
| POST   | `/api/auth/logout`   | –                                      | `204`               |
| GET    | `/api/auth/me`       | –                                      | User                |

Passwords must be 8–128 characters. The first account ever registered becomes `ADMIN`.

**User**: `{ id, email, displayName, role: "USER" | "ADMIN", active, createdAt }`

## Boards

| Method | Path                                   | Body                                   | Response          | Who            |
| ------ | -------------------------------------- | -------------------------------------- | ----------------- | -------------- |
| GET    | `/api/boards`                          | –                                      | BoardSummary[]    | any user       |
| POST   | `/api/boards`                          | `{name, description?, background?}`    | `201` BoardSummary | any user      |
| GET    | `/api/boards/{id}`                     | –                                      | BoardDetail       | member         |
| PUT    | `/api/boards/{id}`                     | `{name, description, background}`      | BoardSummary      | owner          |
| DELETE | `/api/boards/{id}`                     | –                                      | `204`             | owner          |
| PUT    | `/api/boards/{id}/star`                | `{starred}`                            | `204`             | member         |
| POST   | `/api/boards/{id}/members`             | `{email}`                              | `201` Member      | owner          |
| DELETE | `/api/boards/{id}/members/{userId}`    | –                                      | `204`             | owner, or self to leave |

New boards get three lists: *To do*, *In progress* and *Done*. `background` is one of `ocean`, `grape`, `sunset`,
`forest`, `aurora`, `peach`, `slate`, `midnight`.

**BoardSummary**: `{ id, name, description, background, starred, role: "OWNER" | "MEMBER", updatedAt }`

**BoardDetail**: BoardSummary fields plus `members: Member[]`, `labels: Label[]` and
`lists: [{ id, name, position, cards: CardSummary[] }]`.

## Labels and lists

| Method | Path                         | Body               | Response          |
| ------ | ---------------------------- | ------------------ | ----------------- |
| POST   | `/api/boards/{id}/labels`    | `{name, color}`    | `201` Label       |
| PUT    | `/api/labels/{id}`           | `{name, color}`    | Label             |
| DELETE | `/api/labels/{id}`           | –                  | `204`             |
| POST   | `/api/boards/{id}/lists`     | `{name}`           | `201` List        |
| PUT    | `/api/lists/{id}`            | `{name}`           | List              |
| POST   | `/api/lists/{id}/move`       | `{position}`       | `204`             |
| DELETE | `/api/lists/{id}`            | –                  | `204` (deletes its cards) |

Label `color` is one of `green`, `lime`, `yellow`, `orange`, `red`, `pink`, `purple`, `blue`, `sky`, `gray`.

## Cards

| Method | Path                            | Body                    | Response          |
| ------ | ------------------------------- | ----------------------- | ----------------- |
| POST   | `/api/lists/{id}/cards`         | `{title}`               | `201` CardSummary |
| GET    | `/api/cards/{id}`               | –                       | CardDetail        |
| PUT    | `/api/cards/{id}`               | UpdateCard              | CardDetail        |
| POST   | `/api/cards/{id}/move`          | `{listId, position}`    | `204`             |
| DELETE | `/api/cards/{id}`               | –                       | `204`             |

**UpdateCard** replaces all editable fields:

```json
{
  "title": "Fix login bug",
  "description": "Steps to reproduce…",
  "priority": "HIGH",
  "dueDate": "2030-01-31",
  "assigneeId": 2,
  "completed": false,
  "labelIds": [4]
}
```

`priority` is `NONE`, `LOW`, `MEDIUM`, `HIGH` or `URGENT`. `assigneeId` must be a board member and `labelIds` must
belong to the same board; `null` clears `dueDate`/`assigneeId`. Cards can only be moved within their board.

**CardSummary**: `{ id, listId, title, position, priority, dueDate, completed, assignee, labelIds, hasDescription,
checklistDone, checklistTotal, commentCount }`

**CardDetail**: `{ id, listId, listName, boardId, title, description, priority, dueDate, completed, assignee,
labelIds, createdBy, createdAt, updatedAt, checklist: ChecklistItem[], comments: Comment[] }`

## Checklist items and comments

| Method | Path                              | Body                 | Response               |
| ------ | --------------------------------- | -------------------- | ---------------------- |
| POST   | `/api/cards/{id}/checklist`       | `{content}`          | `201` ChecklistItem    |
| PUT    | `/api/checklist-items/{id}`       | `{content, done}`    | ChecklistItem          |
| DELETE | `/api/checklist-items/{id}`       | –                    | `204`                  |
| POST   | `/api/cards/{id}/comments`        | `{body}`             | `201` Comment          |
| DELETE | `/api/comments/{id}`              | –                    | `204` (author only)    |

## Administration (admins only)

| Method | Path                      | Body              | Response |
| ------ | ------------------------- | ----------------- | -------- |
| GET    | `/api/admin/users`        | –                 | User[]   |
| PUT    | `/api/admin/users/{id}`   | `{role, active}`  | User     |

Admins cannot remove their own admin role or deactivate themselves.

## Health

`GET /actuator/health` (plus `/liveness` and `/readiness`) is public and used by the Docker health check.
