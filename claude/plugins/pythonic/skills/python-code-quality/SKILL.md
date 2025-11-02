# Python Code Quality Skill

Ensure Python code follows best practices with automated linting, formatting, and type checking using ruff and mypy.

## When to Use This Skill

Use this skill when:
- User requests code linting or formatting
- User mentions code quality, PEP 8, or style issues
- User wants to fix linting errors
- User asks about type checking
- Code review processes require quality checks

## Core Capabilities

1. **Linting with Ruff**
   - Check code for style violations
   - Identify potential bugs and code smells
   - Enforce PEP 8 compliance
   - Auto-fix issues where possible

2. **Code Formatting**
   - Format code consistently with ruff
   - Organize imports automatically
   - Ensure consistent indentation and line length

3. **Type Checking with Mypy**
   - Verify type annotations are correct
   - Catch type-related bugs before runtime
   - Ensure type safety across the codebase

4. **Code Quality Metrics**
   - Complexity analysis
   - Dead code detection
   - Unused import identification

## Context Files

This skill references the following context files in this directory:
- `ruff-configuration.md` - Ruff linting and formatting rules
- `mypy-configuration.md` - Type checking configuration
- `common-issues.md` - Common Python code quality issues and fixes
- `best-practices.md` - Python coding best practices

## Key Tools and Commands

```bash
# Linting
ruff check .                    # Check for issues
ruff check --fix .              # Auto-fix issues
ruff check --watch .            # Watch mode

# Formatting
ruff format .                   # Format all files
ruff format --check .           # Check if formatting needed

# Type checking
mypy src                        # Check types
mypy --strict src               # Strict mode
```

## Common Workflows

### Pre-commit Quality Check
```bash
ruff check --fix . && ruff format . && mypy src
```

### CI/CD Pipeline
```bash
ruff check .                    # Fail if unfixed issues
ruff format --check .           # Fail if unformatted
mypy src                        # Fail on type errors
```

## Expected Outcomes

After using this skill:
- All code follows PEP 8 style guidelines
- Imports are properly organized
- Type hints are correct and comprehensive
- Code is consistently formatted
- Common bugs and issues are identified

## Integration with Other Skills

- Works with `python-project-setup` for initial configuration
- Complements `python-testing` for comprehensive quality assurance
- Used by `python-project-setup` agent for automated checks
