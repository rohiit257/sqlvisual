.PHONY: help bootstrap up down logs ps restart frontend backend lint test

help:
	@echo "Available commands:"
	@echo "  make bootstrap  Copy .env.example to .env if needed"
	@echo "  make up         Start all services with Docker Compose"
	@echo "  make down       Stop services"
	@echo "  make logs       Follow service logs"
	@echo "  make ps         List running services"
	@echo "  make restart    Restart services"
	@echo "  make frontend   Run frontend locally"
	@echo "  make backend    Run backend locally"
	@echo "  make lint       Run available linters"
	@echo "  make test       Run backend tests"

bootstrap:
	@if not exist .env copy .env.example .env

up:
	docker compose up --build

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

restart:
	docker compose restart

frontend:
	cd frontend && npm run dev

backend:
	cd backend && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

lint:
	cd backend && ruff check app tests
	cd frontend && npm run lint

test:
	cd backend && pytest

