# Ruff Configuration Guide

Ruff is a fast Python linter and formatter that replaces multiple tools (isort, flake8, pyupgrade, etc.).

## Basic Configuration

Add to `pyproject.toml`:

```toml
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
    "RUF",    # Ruff-specific rules
]

ignore = [
    "E501",   # line too long (handled by formatter)
    "B008",   # do not perform function calls in argument defaults
]

[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = [
    "ARG",    # Unused function arguments allowed in tests
    "S101",   # Assert allowed in tests
]
"__init__.py" = [
    "F401",   # Unused imports allowed in __init__.py
]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
line-ending = "auto"

[tool.ruff.lint.isort]
known-first-party = ["project_name"]
```

## Rule Categories

### Error Detection (E, W, F)
- **E**: PEP 8 style errors
- **W**: PEP 8 style warnings
- **F**: PyFlakes logical errors

### Code Quality (B, C4, SIM)
- **B**: Bugbear - likely bugs and design problems
- **C4**: Comprehensions - simplify list/dict/set comprehensions
- **SIM**: Simplify - code simplification suggestions

### Modernization (UP)
- **UP**: PyUpgrade - use modern Python syntax
  - `typing.List` → `list`
  - `Optional[str]` → `str | None` (Python 3.10+)

### Organization (I)
- **I**: isort - import sorting and organization

### Performance (ARG, TCH)
- **ARG**: Detect unused function arguments
- **TCH**: Type checking imports (move to TYPE_CHECKING block)

## Common Rules

### E/W Series (PEP 8)
- `E111`: Indentation is not a multiple of 4
- `E201`: Whitespace after '('
- `E202`: Whitespace before ')'
- `E203`: Whitespace before ':'
- `E302`: Expected 2 blank lines
- `E303`: Too many blank lines
- `W291`: Trailing whitespace

### F Series (PyFlakes)
- `F401`: Unused import
- `F811`: Redefinition of unused name
- `F821`: Undefined name
- `F841`: Local variable assigned but never used

### B Series (Bugbear)
- `B002`: Using * in exception handling
- `B006`: Mutable default argument
- `B007`: Loop variable not used
- `B008`: Function calls in default arguments
- `B904`: Use `raise ... from ...` for exception chaining

### UP Series (PyUpgrade)
- `UP006`: Use `list` instead of `typing.List`
- `UP007`: Use `X | Y` instead of `typing.Union[X, Y]`
- `UP032`: Use f-strings instead of `.format()`

## Commands Reference

### Linting

```bash
# Check all files
ruff check .

# Check specific file
ruff check src/module.py

# Auto-fix issues
ruff check --fix .

# Show fixes without applying
ruff check --diff .

# Watch mode (re-run on file changes)
ruff check --watch .

# Output JSON format
ruff check --output-format=json .
```

### Formatting

```bash
# Format all files
ruff format .

# Format specific file
ruff format src/module.py

# Check if formatting needed (CI)
ruff format --check .

# Show diff without applying
ruff format --diff .
```

### Configuration Testing

```bash
# Show active configuration
ruff check --show-settings

# Show all available rules
ruff rule --all

# Show specific rule documentation
ruff rule F401
```

## Per-File Ignores

Ignore specific rules for specific files:

```toml
[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = ["ARG", "S101"]      # Tests can use assert and unused args
"__init__.py" = ["F401"]                # Unused imports OK in __init__
"scripts/**/*.py" = ["T201"]            # print() OK in scripts
"migrations/**/*.py" = ["E501"]         # Long lines OK in migrations
```

## VSCode Integration

Add to `.vscode/settings.json`:

```json
{
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit",
      "source.fixAll": "explicit"
    }
  },
  "ruff.enable": true,
  "ruff.lint.enable": true,
  "ruff.format.enable": true
}
```

## Performance Tips

Ruff is extremely fast (10-100x faster than alternatives):
- Written in Rust for performance
- Parallel processing by default
- Incremental linting in watch mode
- Caching for repeated runs

## Migration from Other Tools

### From Black
Ruff's formatter is compatible with Black:
```bash
ruff format .  # Replaces: black .
```

### From isort
```bash
ruff check --select I --fix .  # Replaces: isort .
```

### From flake8
```bash
ruff check .  # Replaces: flake8 .
```

### From pyupgrade
```bash
ruff check --select UP --fix .  # Replaces: pyupgrade .
```

## Best Practices

1. **Run formatter last**: `ruff check --fix . && ruff format .`
2. **Use in CI**: Check both linting and formatting
3. **Configure per-file ignores**: For tests, init files, migrations
4. **Enable auto-fix**: Most issues can be fixed automatically
5. **Use with pre-commit**: Run checks before commits
6. **Review rule changes**: Stay updated with new releases
