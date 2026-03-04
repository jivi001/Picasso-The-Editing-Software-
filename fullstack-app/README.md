# TaskForge - Production-Ready Full-Stack App

TaskForge is a full-stack task dashboard with JWT authentication, secure password hashing, PostgreSQL persistence, and Dockerized deployment support.

## Step 1: Architecture Explanation

### System architecture
- `frontend` (Next.js + React + TypeScript + Tailwind): handles auth UI and dashboard CRUD.
- `backend` (Express + TypeScript): exposes REST APIs, validates input, enforces auth/rate limits, and talks to PostgreSQL.
- `database` (PostgreSQL + SQL migrations): normalized `users` and `items` schema.
- `docker` (Dockerfiles + docker-compose): local production-like orchestration.

### Request flow
1. User signs up/logs in from Next.js UI.
2. Backend verifies credentials and returns JWT.
3. Frontend stores token in `localStorage`.
4. Token is sent in `Authorization: Bearer <token>` for protected routes.
5. Backend validates JWT, then executes scoped CRUD for that user.

### Security and reliability
- Passwords hashed with `bcryptjs`.
- JWT token signing/verification with configurable expiry.
- Input validation using `zod`.
- API rate limiting using `express-rate-limit`.
- Secure headers via `helmet`.
- Centralized API error middleware with consistent JSON responses.
- Structured request logging with `morgan`.

## Step 2: Folder Structure

```text
fullstack-app/
  backend/
    src/
      config/
      controllers/
      db/
      middleware/
      routes/
      services/
      types/
      utils/
      validators/
    tests/
    package.json
  frontend/
    public/
    src/
      app/
      components/
      lib/
    package.json
  database/
    migrations/
    schema.sql
  docker/
    backend.Dockerfile
    frontend.Dockerfile
  docker-compose.yml
  .env.example
  package.json
  README.md
```

## Step 3: Backend Code

Backend features implemented:
- JWT auth endpoints: signup/login/logout/me
- User endpoints: list current user and profile
- Item endpoints: full CRUD
- Validation middleware and schemas
- Auth middleware for protected routes
- Rate limiter and secure headers
- Migration runner script
- Unit tests for crypto/token/validation utilities

Main backend entry files:
- `backend/src/server.ts`
- `backend/src/app.ts`
- `backend/src/routes/index.ts`

## Step 4: Frontend Code

Frontend features implemented:
- Landing page
- Signup page
- Login page
- Protected dashboard page
- Responsive CRUD task UI
- API client with typed errors
- Token storage helper and logout flow

Main frontend entry files:
- `frontend/src/app/page.tsx`
- `frontend/src/app/login/page.tsx`
- `frontend/src/app/signup/page.tsx`
- `frontend/src/app/dashboard/page.tsx`

## Step 5: Database Setup

### Normalized schema
- `users (1) -> (many) items`
- `items.user_id` is a foreign key to `users.id` with `ON DELETE CASCADE`

See:
- `database/migrations/001_initial_schema.sql`
- `database/schema.sql`

### Migration instructions
- Local/manual:
  1. Start PostgreSQL.
  2. From project root run:
     ```bash
     npm run migrate
     ```
- Docker Compose:
  - Migration SQL auto-runs on first DB boot via `/docker-entrypoint-initdb.d`.

## Step 6: Running Instructions

### Prerequisites
- Node.js 20+
- npm 10+
- PostgreSQL 16+ (if not using Docker)

### 1) Install dependencies
```bash
npm install
```

### 2) Configure environment
1. Copy root env file:
   ```bash
   cp .env.example .env
   ```
2. Update values as needed (`DATABASE_URL`, `JWT_SECRET`, etc.).

### 3) Run with local PostgreSQL
```bash
npm run migrate
npm run dev
```

App URLs:
- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:4000/api`
- Health check: `http://localhost:4000/api/health`

### Run with Docker
```bash
docker compose up --build
```

## Step 7: Deployment Instructions

### Option A: Docker deployment (single host or VM)
1. Copy project to target host.
2. Set production `.env`.
3. Run:
   ```bash
   docker compose up -d --build
   ```
4. Put Nginx/Caddy in front for TLS and domain routing.

### Option B: Vercel (frontend) + AWS/Render/Railway (backend + Postgres)

Frontend (Vercel):
1. Import `frontend` as Next.js project.
2. Set env var:
   - `NEXT_PUBLIC_API_URL=https://<your-backend-domain>/api`
3. Deploy.

Backend (AWS ECS/EC2 or similar):
1. Build backend image from `docker/backend.Dockerfile`.
2. Provide env vars:
   - `DATABASE_URL`
   - `JWT_SECRET`
   - `JWT_EXPIRES_IN`
   - `FRONTEND_URL`
   - `RATE_LIMIT_WINDOW_MS`
   - `RATE_LIMIT_MAX`
   - `BCRYPT_SALT_ROUNDS`
3. Run DB migrations once before serving traffic.
4. Expose port `4000` behind a load balancer/reverse proxy.

## API Endpoints

Base URL: `http://localhost:4000/api`

### Auth
- `POST /auth/signup`
- `POST /auth/login`
- `POST /auth/logout` (auth required)
- `GET /auth/me` (auth required)

### Users
- `GET /users` (auth required)
- `GET /users/me` (auth required)

### Items
- `GET /items` (auth required)
- `GET /items/:id` (auth required)
- `POST /items` (auth required)
- `PUT /items/:id` (auth required)
- `DELETE /items/:id` (auth required)

## Example Requests

### Signup
```bash
curl -X POST http://localhost:4000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d "{\"fullName\":\"Alex Doe\",\"email\":\"alex@example.com\",\"password\":\"StrongPass123\"}"
```

### Login
```bash
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"alex@example.com\",\"password\":\"StrongPass123\"}"
```

### Create item
```bash
curl -X POST http://localhost:4000/api/items \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d "{\"title\":\"Ship MVP\",\"description\":\"Deploy app\",\"status\":\"in_progress\",\"dueDate\":\"2026-03-20\"}"
```

## Testing Instructions

Run backend tests:
```bash
npm run test
```

Current test scope:
- password hashing and verification
- JWT sign/verify
- request schema validation

## Production Notes

- Use a strong random `JWT_SECRET` in production.
- Restrict `FRONTEND_URL` to your real domain.
- Put HTTPS termination in front of services.
- Configure DB backups and monitoring.
- Add refresh token/session revocation if long-lived token control is required.
