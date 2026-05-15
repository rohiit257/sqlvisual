# SQL Visual

AI-powered SQL analytics platform scaffolded as a production-minded monorepo.

## Stack

- Frontend: Next.js 15, TypeScript, Tailwind CSS, shadcn/ui conventions
- Backend: FastAPI, Python 3.12, pydantic-settings
- Data: PostgreSQL 16, Redis 7
- Local orchestration: Docker Compose

## Structure

```text
.
├── backend/              # FastAPI application
├── frontend/             # Next.js app-router application
├── infra/postgres/init/  # PostgreSQL initialization scripts
├── docker-compose.yml
├── .env.example
└── Makefile
```

## Quick Start

1. Copy environment variables:

   ```bash
   cp .env.example .env
   ```

   On Windows with `make`:

   ```bash
   make bootstrap
   ```

2. Start the full local stack:

   ```bash
   docker compose up --build
   ```

3. Open the apps:

   - Frontend: http://localhost:3000
   - Backend health: http://localhost:8000/api/v1/health
   - Backend OpenAPI: http://localhost:8000/api/v1/openapi.json

## Development

Common commands:

```bash
make up        # Start Dockerized local development
make down      # Stop containers
make logs      # Follow logs
make ps        # Show running services
make lint      # Run configured linters
make test      # Run backend tests
```

The Docker Compose setup mounts `frontend/` and `backend/` into their containers, so Next.js and Uvicorn both hot reload during development.

## Backend Notes

The FastAPI app uses a factory pattern in `backend/app/main.py`, settings via `pydantic-settings`, versioned API routing, async SQLAlchemy session wiring, Redis management, structured trace-aware logging, and global exception handling.

### LangChain SQL Agent

Set `GROQ_API_KEY` in `.env` to enable the SQL analytics agent.

Endpoints:

```bash
POST /api/v1/analytics/query
POST /api/v1/analytics/query/stream
```

Request body:

```json
{
  "question": "Which product categories drove the most revenue?",
  "model": "llama-3.3-70b-versatile"
}
```

The non-streaming endpoint returns:

```json
{
  "answer": "...",
  "sql": "...",
  "rows": [],
  "execution_time": 1.23,
  "trace_id": "..."
}
```

Supported Groq models are `llama-3.3-70b-versatile` and `deepseek-r1-distill-llama-70b`. The streaming endpoint is Server-Sent Events compatible and emits `start`, token/tool events, `final`, or `error`.

## Frontend Notes

The Next.js app uses the app router, Tailwind CSS variables compatible with shadcn/ui, a dark dashboard shell, sidebar placeholder, chat placeholder, and a typed fetch wrapper in `frontend/src/lib/api/client.ts`.

## Database

PostgreSQL initialization scripts live in `infra/postgres/init`. They create the `analytics` and `northwind` schemas, import a Northwind sample dataset, add query logging and schema metadata tables, and build analytics indexes/views. See `docs/database.md` for the ERD, tuning notes, and sample query catalog.
