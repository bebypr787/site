.PHONY: build up down logs shell migrate-v11 migrate-file

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f web

shell:
	docker compose exec web sh

# Run the v11 DB migration using psql and DATABASE_URL env var
migrate-v11:
	./scripts/migrate.sh migrations/v11.sql

# Run any .sql migration file
migrate-file:
	./scripts/migrate.sh $(file)
