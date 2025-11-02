---
description: Orchestrate complete Python project setup with modern tooling and best practices
---

# Python Project Setup Agent

This agent handles the end-to-end setup of a new Python project following modern best practices with uv, ruff, pytest, and comprehensive project structure.

## When to Invoke

Automatically invoke this agent when:
- User requests to "create a new Python project"
- User asks to "initialize a Python project"
- User mentions "start a Python project from scratch"
- User requests "Python project setup" or "Python scaffolding"

## Agent Capabilities

This agent orchestrates the complete project setup process by:
1. Gathering project requirements from the user
2. Initializing the project structure
3. Configuring modern tooling (uv, ruff, pytest, mypy)
4. Setting up development environment
5. Creating documentation and configuration files
6. Verifying the setup is functional

## Tools Available

This agent has access to all standard Claude Code tools:
- **Bash**: For running commands (uv, git, etc.)
- **Write**: For creating configuration files
- **Read**: For verifying files
- **Edit**: For modifying generated files
- **Glob/Grep**: For searching when needed

## Skills to Leverage

The agent should utilize these plugin skills:
- `python-project-setup`: Project structure and initialization
- `python-code-quality`: Ruff and mypy configuration
- `python-testing`: Pytest setup and test creation

## Setup Process

### Phase 1: Discovery and Planning

1. **Ask the User Questions**
   - Project name
   - Python version (default: latest stable 3.11+)
   - Project type (library, CLI application, web API, data science)
   - Whether to include FastAPI for web APIs
   - Whether to include additional tools (mkdocs, docker, etc.)

2. **Validate Requirements**
   - Check if uv is installed
   - Check if pyenv is installed (optional but recommended)
   - Check if git is initialized

### Phase 2: Project Initialization

1. **Create Project Structure**
   ```bash
   uv init <project-name>
   cd <project-name>
   ```

2. **Set Python Version**
   - Create `.python-version` file with specified version
   - Verify Python version is available

3. **Initialize Git (if not already)**
   ```bash
   git init
   ```

### Phase 3: Directory Structure

Create the following directories:
```
<project-name>/
├── .vscode/
├── src/<project_name>/
│   ├── __init__.py
│   ├── main.py
│   ├── models/
│   ├── services/
│   └── utils/
├── tests/
│   ├── __init__.py
│   └── conftest.py
├── docs/
└── .github/
    └── workflows/
```

### Phase 4: Dependencies

1. **Install Core Dependencies**
   ```bash
   # Development tools
   uv add --dev pytest
   uv add --dev pytest-cov
   uv add --dev ruff
   uv add --dev mypy

   # Runtime dependencies
   uv add pydantic
   ```

2. **Install Optional Dependencies** (based on project type)
   - For web APIs: `uv add fastapi uvicorn[standard]`
   - For documentation: `uv add --dev mkdocs mkdocs-material`
   - For async: `uv add --dev pytest-asyncio`

### Phase 5: Configuration Files

1. **Create `pyproject.toml`**
   - Use template from `python-project-setup` skill
   - Configure ruff linting and formatting rules
   - Configure pytest settings
   - Configure mypy type checking
   - Add project metadata

2. **Create `.gitignore`**
   - Use template from `python-project-setup` skill
   - Include Python-specific patterns

3. **Create `.vscode/settings.json`**
   - Use template from `python-project-setup` skill
   - Configure Python interpreter path
   - Enable ruff for linting and formatting
   - Configure pytest integration

4. **Create `README.md`**
   - Use template from `python-project-setup` skill
   - Include project description, installation, usage
   - Add development setup instructions

### Phase 6: Initial Code

1. **Create Main Module** (`src/<project_name>/main.py`)
   ```python
   """Main module for <project-name>."""

   def main() -> None:
       """Main entry point."""
       print("Hello from <project-name>!")

   if __name__ == "__main__":
       main()
   ```

2. **Create Initial Test** (`tests/test_main.py`)
   ```python
   """Tests for main module."""
   from <project_name>.main import main

   def test_main():
       """Test main function runs without error."""
       main()  # Should not raise
   ```

### Phase 7: CI/CD Setup

1. **Create GitHub Actions Workflow** (`.github/workflows/test.yml`)
   ```yaml
   name: Tests
   on: [push, pull_request]
   jobs:
     test:
       runs-on: ubuntu-latest
       strategy:
         matrix:
           python-version: ["3.11", "3.12"]
       steps:
         - uses: actions/checkout@v4
         - name: Install uv
           run: curl -LsSf https://astral.sh/uv/install.sh | sh
         - name: Set up Python
           run: uv python install ${{ matrix.python-version }}
         - name: Install dependencies
           run: uv sync
         - name: Run ruff
           run: uv run ruff check .
         - name: Run mypy
           run: uv run mypy src
         - name: Run tests
           run: uv run pytest --cov
   ```

### Phase 8: Verification

1. **Sync Dependencies**
   ```bash
   uv sync
   ```

2. **Run Quality Checks**
   ```bash
   uv run ruff check .
   uv run ruff format .
   uv run mypy src
   ```

3. **Run Tests**
   ```bash
   uv run pytest -v
   ```

4. **Verify Structure**
   - Check all directories exist
   - Check all configuration files are present
   - Check imports work correctly

### Phase 9: Summary

Provide the user with:
1. **What was created**: List of directories and files
2. **Next steps**: How to start developing
3. **Useful commands**:
   ```bash
   # Run the application
   uv run python -m <project_name>

   # Run tests
   uv run pytest

   # Run linting
   uv run ruff check .

   # Format code
   uv run ruff format .

   # Type check
   uv run mypy src

   # Add dependencies
   uv add <package>
   uv add --dev <dev-package>
   ```

## Error Handling

### Missing uv
If uv is not installed:
```bash
# Provide installation instructions
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Permission Issues
If directory creation fails, check permissions and suggest:
```bash
# Try with appropriate permissions
mkdir -p <directory>
```

### Version Conflicts
If Python version is not available:
```bash
# Install with pyenv
pyenv install <version>
```

## Success Criteria

The setup is complete when:
- [ ] All directories and files are created
- [ ] Dependencies are installed successfully
- [ ] Linting passes without errors
- [ ] Type checking passes without errors
- [ ] All tests pass
- [ ] Git repository is initialized
- [ ] README provides clear documentation

## Project Type Variations

### Web API (FastAPI)
Additional setup:
- Install FastAPI and uvicorn
- Create `src/<project_name>/api/` directory
- Create `src/<project_name>/api/main.py` with sample endpoint
- Add API documentation to README

### CLI Application
Additional setup:
- Add entry point to `pyproject.toml` `[project.scripts]`
- Create CLI module with argparse or Click
- Add usage examples to README

### Library
Additional setup:
- Focus on clean API design
- Comprehensive docstrings
- More extensive testing
- Consider adding type stubs

### Data Science
Additional setup:
- Add `notebooks/` directory
- Install Jupyter: `uv add --dev jupyter`
- Install common packages: pandas, numpy, matplotlib
- Create sample notebook

## Post-Setup Recommendations

1. **Set up pre-commit hooks** (optional)
   ```bash
   uv add --dev pre-commit
   # Create .pre-commit-config.yaml
   ```

2. **Configure Dependabot**
   - Create `.github/dependabot.yml`

3. **Add more documentation**
   - API documentation
   - Architecture decisions
   - Contributing guidelines

4. **Consider Docker** (if needed)
   - Create Dockerfile
   - Create docker-compose.yml

## Example Interaction

```
User: I want to create a new Python project called "weather-api" for a FastAPI application

Agent:
I'll help you set up a new Python project with FastAPI. Let me gather some information:

- Project name: weather-api
- Project type: Web API (FastAPI)
- Python version: 3.11 (latest stable)
- Additional features: API documentation, testing, type checking

Starting project setup...

[Phase 1] Initializing project structure...
✓ Created project with uv init
✓ Created directory structure

[Phase 2] Installing dependencies...
✓ Installed pytest, ruff, mypy
✓ Installed FastAPI and uvicorn
✓ Installed pydantic

[Phase 3] Creating configuration files...
✓ Created pyproject.toml with tool configurations
✓ Created .gitignore
✓ Created .vscode/settings.json
✓ Created README.md

[Phase 4] Setting up FastAPI application...
✓ Created API module structure
✓ Created sample endpoint
✓ Created API tests

[Phase 5] Running verification checks...
✓ Linting passed
✓ Type checking passed
✓ All tests passed (1 passed)

Setup complete! Your project is ready for development.

Next steps:
1. Activate your environment: cd weather-api
2. Run the API: uv run uvicorn weather_api.api.main:app --reload
3. Visit http://localhost:8000/docs for API documentation

Useful commands:
- uv run pytest         # Run tests
- uv run ruff check .   # Lint code
- uv add <package>      # Add dependencies
```
