---
description: Run ruff linter and formatter to check code quality
---

# Lint Python Code

Check and fix code quality issues using ruff, the fast Python linter and formatter.

## Tasks to Complete

1. **Run Linter**
   - Execute `ruff check .` to identify issues
   - Report all linting errors and warnings
   - Categorize issues by severity

2. **Auto-fix Issues** (if requested)
   - Run `ruff check --fix .` to automatically fix issues
   - Report which issues were fixed automatically

3. **Format Code**
   - Execute `ruff format .` to format all Python files
   - Ensure PEP 8 compliance
   - Report which files were reformatted

4. **Type Checking** (if mypy is installed)
   - Run `mypy .` to check type annotations
   - Report type errors with file locations

## Expected Outcome

- Clean, well-formatted code following PEP 8
- All auto-fixable issues resolved
- Clear report of remaining issues requiring manual intervention
