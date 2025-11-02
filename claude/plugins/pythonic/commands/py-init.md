---
description: Initialize a new Python project with modern tooling (uv, ruff, pytest)
---

# Initialize Python Project

Initialize a new Python project following modern best practices. This command sets up the project structure, tooling, and configuration.

## Tasks to Complete

1. **Project Initialization**
   - Run `uv init <project-name>` to create the project
   - Create `.python-version` file for pyenv compatibility
   - Initialize git repository if not already present

2. **Directory Structure**
   - Create `src/<project_name>/` for main code
   - Create `tests/` directory for test files
   - Create `.vscode/` for editor configuration
   - Create `docs/` for documentation

3. **Essential Dependencies**
   - Add `pytest` as dev dependency: `uv add --dev pytest`
   - Add `ruff` as dev dependency: `uv add --dev ruff`
   - Add `mypy` as dev dependency: `uv add --dev mypy`
   - Add `pydantic` as runtime dependency: `uv add pydantic`

4. **Configuration Files**
   - Create `pyproject.toml` with ruff and pytest configuration
   - Create `.gitignore` for Python projects
   - Create `.vscode/settings.json` with Python and ruff settings

5. **Documentation**
   - Create `README.md` with project overview and setup instructions
   - Create initial documentation structure

## Expected Outcome

A fully initialized Python project ready for development with:
- Modern package management (uv)
- Fast linting and formatting (ruff)
- Testing framework (pytest)
- Type checking (mypy)
- Editor configuration (VSCode)
- Version control (git)

## User Inputs Required

- Project name
- Python version (default: latest stable)
- Whether to include FastAPI for API projects
