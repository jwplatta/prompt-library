# Python Project Setup Skill

Set up new Python projects following modern best practices with uv, ruff, pytest, and proper project structure.

## When to Use This Skill

Use this skill when:
- User requests to create a new Python project
- User wants to initialize Python tooling in an existing directory
- User mentions setting up a Python development environment
- User asks about Python project structure or best practices

## Core Capabilities

1. **Project Initialization**
   - Initialize projects with `uv init`
   - Set up proper directory structure
   - Configure Python version with pyenv

2. **Dependency Management**
   - Install and configure uv package manager
   - Add essential dependencies (pytest, ruff, mypy, pydantic)
   - Set up development vs runtime dependencies

3. **Configuration Files**
   - Create `pyproject.toml` with tool configurations
   - Set up `.gitignore` for Python projects
   - Configure VSCode settings for Python development
   - Create `.python-version` for version management

4. **Project Structure**
   - Create `src/<project_name>/` for source code
   - Set up `tests/` directory for test files
   - Create `docs/` for documentation
   - Set up `.vscode/` for editor configuration

## Context Files

This skill references the following context files in this directory:
- `project-structure-template.md` - Standard directory layout
- `pyproject-toml-template.md` - Configuration template
- `vscode-settings-template.json` - Editor configuration
- `gitignore-template.md` - Python gitignore patterns
- `readme-template.md` - README structure

## Key Tools and Commands

```bash
# Project initialization
uv init <project-name>

# Dependency management
uv add pytest --dev
uv add ruff --dev
uv add mypy --dev
uv add pydantic

# Sync dependencies
uv sync
```

## Expected Outcomes

After using this skill, the user should have:
- A fully initialized Python project with modern tooling
- Proper project structure following best practices
- All essential dependencies installed
- Configuration files set up correctly
- Version control initialized (git)
- Documentation scaffolding in place

## Integration with Other Skills

- Works with `python-code-quality` skill for linting setup
- Works with `python-testing` skill for test framework configuration
- Complements the `python-project-setup` agent for full orchestration
