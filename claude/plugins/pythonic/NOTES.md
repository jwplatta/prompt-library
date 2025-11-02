# Python Project Setup Checklist

Based on modern Python development best practices, this checklist covers everything needed to set up a new Python project.

## 1. Project Initialization

- [ ] Initialize project with `uv init <project-name>`
- [ ] Set Python version using `pyenv` and create `.python-version` file
- [ ] Create virtual environment with `uv venv`
- [ ] Initialize git repository with `git init`
- [ ] Create `.gitignore` for Python projects

## 2. Project Structure

- [ ] Create standard directory structure:
  - [ ] `src/<project_name>/` - Main application code
  - [ ] `src/<project_name>/tests/` - Test files (`test_*.py`)
  - [ ] `.github/workflows/` - CI/CD workflows
  - [ ] `.vscode/` - Editor configuration
  - [ ] `docs/` - Documentation files
  - [ ] `notebooks/` - Jupyter notebooks (if needed)

## 3. Package Management

- [ ] Install `uv` as primary package manager
- [ ] Create `pyproject.toml` for project metadata and dependencies
- [ ] Add core dependencies with `uv add <package>`
- [ ] Add development dependencies with `uv add --dev <package>`
- [ ] Sync dependencies with `uv sync`
- [ ] Configure Dependabot in `.github/dependabot.yml`

## 4. Code Quality Tools

- [ ] Install and configure `ruff` for linting and formatting
  - [ ] Add ruff configuration to `pyproject.toml`
  - [ ] Set up `ruff check` command
  - [ ] Set up `ruff format` command
  - [ ] Configure for PEP 8 compliance
- [ ] Install `mypy` or `ty` for static type checking
  - [ ] Add type hints throughout codebase
  - [ ] Configure type checker in `pyproject.toml`
- [ ] Set up pre-commit hooks (optional)

## 5. Testing Framework

- [ ] Install `pytest` with `uv add --dev pytest`
- [ ] Create `tests/` directory structure
- [ ] Configure pytest in `pyproject.toml` or `pytest.ini`
- [ ] Write initial test files (`test_*.py`)
- [ ] Set up test command: `uv run pytest`
- [ ] Configure test coverage reporting

## 6. VSCode Configuration

- [ ] Create `.vscode/settings.json` with:
  - [ ] Python interpreter path
  - [ ] Linting configuration (ruff)
  - [ ] Formatting configuration (ruff)
  - [ ] Type checking settings
- [ ] Create `.vscode/launch.json` for debugging
- [ ] Add recommended extensions to `.vscode/extensions.json`

## 7. Core Libraries & Frameworks

### Data Validation & Configuration
- [ ] Install `pydantic` for data validation
- [ ] Create settings management with Pydantic Settings
- [ ] Set up `.env` file for environment variables
- [ ] Use dataclasses for simple data structures

### API Development (if applicable)
- [ ] Install `fastapi` for REST APIs
- [ ] Install `uvicorn` as ASGI server
- [ ] Set up API routes and endpoint structure
- [ ] Configure automatic documentation (Swagger/OpenAPI)

## 8. Documentation

- [ ] Install `mkdocs` for documentation
- [ ] Create `docs/` directory structure
- [ ] Write initial `README.md` with:
  - [ ] Project description
  - [ ] Installation instructions
  - [ ] Usage examples
  - [ ] Development setup guide
- [ ] Configure MkDocs in `mkdocs.yml`
- [ ] Set up documentation build process

## 9. CI/CD Pipeline

- [ ] Create `.github/workflows/test.yml` for automated testing
  - [ ] Test on multiple Python versions
  - [ ] Test on multiple OS (Linux, macOS, Windows)
  - [ ] Run linting checks
  - [ ] Run type checking
  - [ ] Generate coverage reports
- [ ] Create `.github/workflows/deploy.yml` (if applicable)
- [ ] Set up GitHub Actions secrets for sensitive data

## 10. Docker Configuration (Optional)

- [ ] Create `Dockerfile` for containerization
- [ ] Create `docker-compose.yml` for local development
- [ ] Add `.dockerignore` file
- [ ] Document Docker usage in README

## 11. Code Style & Standards

- [ ] Follow PEP 8 style guidelines
- [ ] Use type hints throughout (`from typing import ...`)
- [ ] Write docstrings for modules, classes, and functions
- [ ] Implement consistent error handling patterns
- [ ] Use descriptive variable and function names

## 12. Makefile (Optional)

- [ ] Create `Makefile` with common commands:
  - [ ] `make install` - Install dependencies
  - [ ] `make test` - Run tests
  - [ ] `make lint` - Run linting
  - [ ] `make format` - Format code
  - [ ] `make clean` - Clean build artifacts

## 13. Version Control Best Practices

- [ ] Write clear commit messages
- [ ] Create feature branches for development
- [ ] Set up pull request templates
- [ ] Configure branch protection rules
- [ ] Tag releases with semantic versioning

## 14. Security & Dependencies

- [ ] Keep dependencies up to date
- [ ] Use virtual environments (never install globally)
- [ ] Never commit sensitive data (`.env`, credentials)
- [ ] Add security scanning to CI/CD
- [ ] Review dependency vulnerabilities regularly

## 15. Monorepo Setup (Optional)

For projects combining backend and frontend:
- [ ] Create `<project>-api/` directory for backend
- [ ] Create `<project>-ui/` directory for frontend
- [ ] Set up root-level coordination (Makefile, docker-compose)
- [ ] Configure shared tooling and CI/CD

## Key Commands Reference

```bash
# Project initialization
uv init <project-name>
uv venv

# Dependency management
uv add <package>              # Add runtime dependency
uv add --dev <package>        # Add development dependency
uv sync                       # Sync dependencies

# Code quality
ruff check                    # Lint code
ruff format                   # Format code
mypy .                        # Type checking

# Testing
uv run pytest                 # Run tests
uv run pytest --cov           # Run tests with coverage

# Running application
uv run <script.py>           # Run Python script
uvicorn app:app --reload     # Run FastAPI app
```

## Essential Tools Summary

1. **uv** - Package manager and build tool
2. **ruff** - Fast linter and formatter
3. **pytest** - Testing framework
4. **mypy/ty** - Static type checker
5. **pydantic** - Data validation
6. **fastapi** - Web framework (for APIs)
7. **mkdocs** - Documentation generator
8. **pyenv** - Python version management



## Creating Claude Plugins

- https://docs.claude.com/en/docs/claude-code/plugins
- https://docs.claude.com/en/docs/claude-code/hooks
- https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview