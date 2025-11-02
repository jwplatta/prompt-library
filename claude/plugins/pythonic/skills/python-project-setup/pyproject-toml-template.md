# pyproject.toml Template

## Complete Configuration Template

```toml
[project]
name = "project-name"
version = "0.1.0"
description = "Project description"
readme = "README.md"
requires-python = ">=3.11"
license = {text = "MIT"}
authors = [
    {name = "Your Name", email = "you@example.com"}
]
keywords = ["python", "example"]
classifiers = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]

dependencies = [
    "pydantic>=2.0.0",
    # Add runtime dependencies here
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0.0",
    "pytest-cov>=4.1.0",
    "ruff>=0.3.0",
    "mypy>=1.8.0",
]
api = [
    "fastapi>=0.110.0",
    "uvicorn[standard]>=0.27.0",
]
docs = [
    "mkdocs>=1.5.0",
    "mkdocs-material>=9.5.0",
]

[project.urls]
Homepage = "https://github.com/username/project-name"
Repository = "https://github.com/username/project-name"
Documentation = "https://project-name.readthedocs.io"
Issues = "https://github.com/username/project-name/issues"

[project.scripts]
# Define CLI entry points
project-cli = "project_name.cli:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/project_name"]

# Ruff configuration
[tool.ruff]
line-length = 100
target-version = "py311"
src = ["src", "tests"]

[tool.ruff.lint]
select = [
    "E",      # pycodestyle errors
    "W",      # pycodestyle warnings
    "F",      # pyflakes
    "I",      # isort
    "B",      # flake8-bugbear
    "C4",     # flake8-comprehensions
    "UP",     # pyupgrade
    "ARG",    # flake8-unused-arguments
    "SIM",    # flake8-simplify
    "TCH",    # flake8-type-checking
]
ignore = [
    "E501",   # line too long (handled by formatter)
    "B008",   # do not perform function calls in argument defaults
    "B904",   # raise from None
]

[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = [
    "ARG",    # Unused function arguments allowed in tests
    "S101",   # Assert allowed in tests
]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
line-ending = "auto"

# Pytest configuration
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--strict-markers",
    "--strict-config",
    "--showlocals",
    "-ra",
]
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
]

# Coverage configuration
[tool.coverage.run]
source = ["src"]
branch = true
omit = [
    "*/tests/*",
    "*/__init__.py",
]

[tool.coverage.report]
precision = 2
show_missing = true
skip_covered = false
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
    "@abstractmethod",
]

# Mypy configuration
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
strict_equality = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

# UV-specific configuration (if needed)
[tool.uv]
dev-dependencies = [
    "pytest>=8.0.0",
    "pytest-cov>=4.1.0",
    "ruff>=0.3.0",
    "mypy>=1.8.0",
]
```

## Configuration Sections Explained

### `[project]`
Basic project metadata used by build tools and package indexes.

### `[project.optional-dependencies]`
Groups of optional dependencies for different use cases:
- `dev` - Development tools (testing, linting)
- `api` - API framework dependencies (FastAPI, uvicorn)
- `docs` - Documentation generation tools

### `[tool.ruff]`
Ruff linter and formatter configuration:
- Fast Python linter combining multiple tools
- Replaces isort, flake8, pyupgrade, and more
- Automatic code formatting

### `[tool.pytest.ini_options]`
Pytest test framework configuration:
- Test discovery patterns
- Default command-line options
- Custom test markers

### `[tool.coverage]`
Code coverage settings for pytest-cov:
- Which files to measure
- Coverage reporting options
- Lines to exclude from coverage

### `[tool.mypy]`
Type checking configuration:
- Strictness settings
- Type checking rules
- Per-directory overrides

## Usage Examples

```bash
# Install project with dev dependencies
uv sync --extra dev

# Install with API dependencies
uv sync --extra api

# Install all optional dependencies
uv sync --all-extras

# Run tests with coverage
uv run pytest --cov

# Lint code
uv run ruff check .

# Format code
uv run ruff format .

# Type check
uv run mypy src
```
