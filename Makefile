build:
	@echo "Building subgraph-app"
	@go build -o bin/subgraph-app -v .
	@echo "done."

db:
	@echo "building docker images"
	@docker compose build
	@echo done.

du:
	@echo "starting docker images"
	@docker compose up

dp:
	@echo "starting ONLY docker postgres"
	@docker compose -f docker-compose.psql.yml up

da: db du
