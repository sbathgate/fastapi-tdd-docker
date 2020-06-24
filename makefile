default: help

help:  ## Output available commands
	@echo "Available commands:"
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

lint-check:
	@docker-compose exec web flake8 .
	@echo "flake8 complete!"
	@docker-compose exec web black . --check
	@echo "black complete!"
	@docker-compose exec web /bin/sh -c "isort ./**/*.py --check-only"
	@echo "isort complete!"

lint-correct:
	@docker-compose exec web flake8 .
	@echo "flake8 complete!"
	@docker-compose exec web black .
	@echo "black complete!"
	@docker-compose exec web /bin/sh -c "isort ./**/*.py"
	@echo "isort complete!"

lint-diff:
	@docker-compose exec web flake8 .
	@echo "flake8 complete!"
	@docker-compose exec web black . --diff
	@echo "black complete!"
	@docker-compose exec web /bin/sh -c "isort ./**/*.py --diff"
	@echo "isort complete!"

postgres:  ## Access db via psql
	@echo "# \c web_dev"
	@echo "# \dt"
	@docker-compose exec users-db psql -U postgres

rebuild:  ## Rebuild docker images
	@docker-compose up -d --build

test: ## Run the current test suite
	@docker-compose exec web python -m pytest --cov="."