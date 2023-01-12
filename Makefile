help: ## Shows available tasks
	@grep -Eh '^[a-zA-Z_-][a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
.DEFAULT_GOAL: help

pre-commit: ## Runs all pre-commit tests
	pre-commit run --all --verbose
