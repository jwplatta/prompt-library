# Python Project Structure Template

## Standard Directory Layout

```
project_name/
├── .vscode/                    # VSCode editor configuration
│   ├── settings.json          # Python, ruff, mypy settings
│   └── launch.json            # Debug configurations
├── src/                       # Source code directory
│   └── project_name/          # Main package (use underscores)
│       ├── __init__.py        # Package initialization
│       ├── main.py            # Entry point (if applicable)
│       ├── models/            # Data models (Pydantic)
│       ├── services/          # Business logic
│       ├── api/               # API routes (if using FastAPI)
│       └── utils/             # Utility functions
├── tests/                     # Test directory
│   ├── __init__.py
│   ├── conftest.py            # Pytest fixtures
│   ├── test_main.py           # Test files (prefix with test_)
│   └── integration/           # Integration tests
├── docs/                      # Documentation
│   ├── index.md
│   └── api/                   # API documentation
├── .github/                   # GitHub configuration
│   ├── workflows/             # CI/CD workflows
│   │   └── test.yml
│   └── dependabot.yml         # Dependency updates
├── .gitignore                 # Git ignore patterns
├── .python-version            # Python version for pyenv
├── pyproject.toml             # Project metadata and dependencies
├── README.md                  # Project documentation
└── uv.lock                    # Locked dependencies (generated)
```

## File Naming Conventions

- **Python packages**: Use underscores (e.g., `my_package`)
- **Project names**: Use underscores (e.g., `my_project`)
- **Test files**: Prefix with `test_` (e.g., `test_models.py`)
- **Private modules**: Prefix with `_` (e.g., `_internal.py`)

## Directory Purpose

### `src/project_name/`
Main application code organized by function:
- `models/` - Data classes, Pydantic models, database models
- `services/` - Business logic and service layer
- `api/` - API endpoints and route handlers (FastAPI)
- `utils/` - Helper functions and utilities
- `config/` - Configuration management

### `tests/`
Test files mirroring the structure of `src/`:
- Unit tests for each module
- Integration tests in `integration/` subdirectory
- `conftest.py` for shared fixtures
- Use pytest conventions

### `docs/`
Project documentation:
- User guides
- API documentation
- Architecture decisions
- Setup instructions

## Module Organization

Each Python module should follow this pattern:

```python
# frozen_string_literal equivalent in Python
"""Module docstring describing purpose."""

from typing import Any, Optional

import third_party_package

from project_name import local_module


class MyClass:
    """Class docstring."""

    def __init__(self, param: str) -> None:
        """Initialize with param."""
        self.param = param

    def method(self) -> str:
        """Method docstring."""
        return self.param


def public_function() -> None:
    """Public function docstring."""
    pass


def _private_function() -> None:
    """Private helper function."""
    pass
```

## Best Practices

1. **Use `src/` layout**: Prevents accidental imports of local code
2. **Type hints everywhere**: Add type annotations to all functions
3. **Docstrings**: Document all public classes and functions
4. **Test organization**: Mirror source structure in tests
5. **Configuration**: Use environment variables or config files, never hardcode
6. **Dependencies**: Separate dev dependencies from runtime dependencies
