.PHONY: help setup sync lint format format-check test check pre-commit

help:
	@echo "Available commands:"
	@echo "  make setup         Install dependencies and Git hooks"
	@echo "  make sync          Synchronize the virtual environment"
	@echo "  make lint          Check Python code with Ruff"
	@echo "  make format        Automatically fix and format Python code"
	@echo "  make test          Run automated tests"
	@echo "  make check         Run all CI quality checks"
	@echo "  make pre-commit    Run pre-commit on every tracked file"

setup:
	uv sync
	uv run pre-commit install

sync:
	uv sync

lint:
	uv run ruff check .

format:
	uv run ruff check --fix .
	uv run ruff format .

test:
	uv run pytest

check:
	uv run ruff check .
	uv run ruff format --check .
	uv run pytest

pre-commit:
	uv run pre-commit run --all-files