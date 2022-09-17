.DEFAULT_GOAL := help
PYTHON ?= python

.PHONY: venv
venv: ## Create venv and install adapter in develop mode
	virtualenv -p python3.8 venv
	source venv/bin/activate && pip install -U pip && pip install -r requirements-dev.txt && pip install -e .

.PHONY: mypy
mypy: ## Runs mypy against staged changes for static type checking.
	@\
	pre-commit run --hook-stage manual mypy-check | grep -v "INFO"

.PHONY: flake8
flake8: ## Runs flake8 against staged changes to enforce style guide.
	@\
	pre-commit run --hook-stage manual flake8-check | grep -v "INFO"

.PHONY: black
black: ## Runs black  against staged changes to enforce style guide.
	@\
	pre-commit run --hook-stage manual black-check -v | grep -v "INFO"

.PHONY: lint
lint: ## Runs flake8 and mypy code checks against staged changes.
	@\
	pre-commit run flake8-check --hook-stage manual | grep -v "INFO"; \
	pre-commit run mypy-check --hook-stage manual | grep -v "INFO"

.PHONY: linecheck
linecheck: ## Checks for all Python lines 100 characters or more
	@\
	find dbt -type f -name "*.py" -exec grep -I -r -n '.\{100\}' {} \;

.PHONY: unit
unit: ## Runs unit tests with py38.
	@\
	tox -e py38

.PHONY: test
test: ## Runs unit tests with py38 and code checks against staged changes.
	@\
	tox -p -e py38; \
	pre-commit run black-check --hook-stage manual | grep -v "INFO"; \
	pre-commit run flake8-check --hook-stage manual | grep -v "INFO"; \
	pre-commit run mypy-check --hook-stage manual | grep -v "INFO"

.PHONY: integration
integration: ## Runs flink integration tests with py38.
	@\
	tox -e py38-flink --

.PHONY:  build
build: ## build package
	python -m build

.PHONY:  clean
clean: clean-build clean-cache clean-test ## remove build and test artifacts and caches

.PHONY:  clean-build
clean-build: ## remove build artifacts
	$(PYTHON) setup.py clean
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

.PHONY:  clean-cache
clean-cache: ## remove backup and cache files
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '.*~' -exec rm -f {} +
	find . -name '#*#' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
	find . -name '.mypy_cache' -type d -exec rm -fr {} +
	find . -name '.pytest_cache' -type d -exec rm -fr {} +

.PHONY:  clean-test
clean-test: ## remove test and coverage artifacts
	find . -type f -name ".coverage" -delete
	find . -type d -name ".pytest_cache" -exec rm -fr {} +
	find . -type d -name "htmlcov" -exec rm -fr {} +

upload: ## Create package and upload to pypi
upload: build
	twine check dist/*
	check-wheel-contents dist/*.whl --ignore W007,W008
	twine upload dist/* --non-interactive

.PHONY: help
help: ## Show this help message.
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@grep -E '^[7+a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
