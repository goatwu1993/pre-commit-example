GIT = $(shell which git)
GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT = $(shell git rev-parse --short HEAD)
GIT_COMMIT_TIME = $(shell git log -n 1 --pretty=format:"%ad" --date=iso)
PIP = $(shell which pip)

.PHONY: help
help: ## Show help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'

.PHONY: install-dev
install-dev: install-commit-message-template install-dev-pkgs install-hooks ## Install dev tools

.PHONY: install-dev-pkgs
install-dev-pkgs: ## Install dev packages
	# Install dev packages
	@$(PIP) install -q pre-commit commitizen pytest

.PHONY: install-hooks
install-hooks: .pre-commit-config.yaml install-dev-pkgs ## Install packages for git hooks
	# Install git hooks
	@pre-commit install -c $< -t pre-commit -t commit-msg -t pre-push

.PHONY: install-commit-message-template
install-commit-message-template: ci/COMMIT_MESSAGE_TEMPLATE ## Install commit-message template
	# Install commit-message template
	@$(GIT) config commit.template $<

.PHONY: uninstall-hooks
uninstall-hooks: ## Uninstall hooks
	# Remove all hooks
	@pre-commit uninstall -t pre-commit -t commit-msg -t pre-push

.PHONY: uninstall-commit-message-template
uninstall-commit-message-template: ## Uninstall commit-message template
	# Remove commit template
	@$(GIT) config --unset commit.template || true

.PHONY: uninstall-dev
uninstall-dev: uninstall-hooks uninstall-commit-message-template ## Uninstall dev tools
	# Uninstall all hooks

.PHONY: reinstall-dev
reinstall-dev: uninstall-dev install-dev ## Reinstall dev tools
	# Reinstall all hooks
