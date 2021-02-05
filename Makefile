GIT = $(shell which git)
GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT = $(shell git rev-parse --short HEAD)
GIT_COMMIT_TIME = $(shell git log -n 1 --pretty=format:"%ad" --date=iso)
PIP = $(shell which pip)

.PHONY: help
help: ## Show help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install-all-hooks
install-all-hooks: install-hooks-packages install-cm-template install-cm-hook install-pc-hook install-pp-hook## Install all hooks

.PHONY: install-hooks-packages
install-hooks-packages: ## Install packages for git hooks
	# Install pre-commit
	@$(PIP) install -q pre-commit

.PHONY: install-pc-hook
install-pc-hook: .pre-commit-config.yaml ## Install pre-commit hook
	# Install pre-commit hook
	@pre-commit install -c $<

.PHONY: install-cm-template
install-cm-template: ci/COMMIT_MESSAGE_TEMPLATE ## Install commit-message template
	# Install commit-message template
	@$(GIT) config commit.template $<

.PHONY: install-cm-hook
install-cm-hook: .pre-commit-config.yaml ## Install commit-message hook
	# Install commit-message hook
	@pre-commit install -c $< --hook-type commit-msg

.PHONY: install-pp-hook
install-pp-hook: .pre-commit-config.yaml ## Install pre-push hook
	# Install pytest
	@$(PIP) install -q pytest
	# Install pre-push hook
	@pre-commit install -c $< --hook-type pre-push

.PHONY: uninstall-all-hooks
uninstall-all-hooks: ## Remove all hooks
	# Remove all hooks
	@pre-commit uninstall
	@pre-commit uninstall --hook-type commit-msg
	@pre-commit uninstall --hook-type pre-push
	# Remove commit template
	@$(GIT) config --unset commit.template || true

.PHONY: reinstall-all-hooks
reinstall-all-hooks: uninstall-all-hooks install-all-hooks ## Reinstall all hooks
	# Reinstall all hooks
