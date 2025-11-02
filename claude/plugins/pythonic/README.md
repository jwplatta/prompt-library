# Pythonic Plugin

A Claude Code plugin for developing with Python the way I like to.

## Overview

This plugin provides commands, skills, agents, and hooks to streamline Python project setup and development workflows.

- **uv** for fast, reliable package management
- **ruff** for lightning-fast linting and formatting
- **pytest** for comprehensive testing
- **mypy** for static type checking
- **pydantic** for data validation
- **FastAPI** for building APIs (optional)

## Features

### Commands

Slash commands for common Python development tasks:

- `/py-init` - Initialize a new Python project with modern tooling
- `/py-test` - Run pytest with coverage reporting
- `/py-lint` - Run ruff linter and formatter
- `/py-deps` - Manage Python dependencies with uv

### Skills

Extended capabilities that Claude uses automatically:

- **python-project-setup** - Project structure and initialization
- **python-code-quality** - Linting, formatting, and type checking
- **python-testing** - Comprehensive testing with pytest

### Agents

Specialized agent for complex workflows:

- **python-project-setup** - Orchestrates complete project setup from scratch

### Hooks

Event-driven automation (disabled by default):

- `before-write` - Auto-format files with ruff
- `after-write` - Auto-fix linting issues
- `before-commit` - Run quality checks before commits
- `test-on-save` - Run related tests on file save

## Installation

1. **Install the plugin** in your Claude Code plugins directory:
   ```bash
   cd ~/.claude/plugins
   git clone <repository-url> pythonic
   ```

2. **Install required tools** on your system:
   ```bash
   # Install uv (package manager)
   curl -LsSf https://astral.sh/uv/install.sh | sh

   # Install pyenv (optional but recommended)
   curl https://pyenv.run | bash
   ```

3. **Restart Claude Code** to load the plugin

## Quick Start

### Creating a New Python Project

```bash
# Using the command
/py-init

# Or ask Claude
"Create a new Python project called 'my-app'"
```

Claude will:
1. Ask about your project requirements
2. Initialize the project structure
3. Install dependencies
4. Configure tooling (ruff, pytest, mypy)
5. Create documentation and configuration files
6. Verify everything works

### Managing Dependencies

```bash
# Add runtime dependency
uv add requests

# Add development dependency
uv add --dev black

# Or use the command
/py-deps
```

### Running Tests

```bash
# Run all tests
/py-test

# Or directly
uv run pytest
uv run pytest --cov
```

### Linting and Formatting

```bash
# Check and fix code quality
/py-lint

# Or directly
uv run ruff check --fix .
uv run ruff format .
```

## Configuration

### Enabling Hooks

Edit `hooks/hooks.json` to enable automation:

```json
{
  "hooks": {
    "before-write": {
      "enabled": true,
      "command": "uv run ruff format {file_path}"
    }
  }
}
```

### Customizing Project Templates

Modify templates in `skills/python-project-setup/`:
- `pyproject-toml-template.md` - Change default dependencies or rules
- `vscode-settings-template.json` - Adjust editor settings
- `project-structure-template.md` - Modify directory layout

## References

- [uv Documentation](https://docs.astral.sh/uv/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [pytest Documentation](https://docs.pytest.org/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Claude Code Plugins](https://docs.claude.com/en/docs/claude-code/plugins)

## License

MIT