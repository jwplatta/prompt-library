---
description: Manage Python dependencies with uv package manager
---

# Manage Python Dependencies

Add, update, or remove project dependencies using the uv package manager.

## Tasks to Complete

1. **Add Dependencies**
   - For runtime: `uv add <package-name>`
   - For development: `uv add --dev <package-name>`
   - Confirm package was added to `pyproject.toml`

2. **Update Dependencies**
   - Run `uv sync` to sync all dependencies
   - Update specific package: `uv add <package-name>@latest`
   - Report outdated packages if requested

3. **Remove Dependencies**
   - Run `uv remove <package-name>` to remove a package
   - Clean up unused dependencies

4. **Verify Environment**
   - Ensure virtual environment is active
   - Verify all dependencies are installed correctly
   - Check for dependency conflicts

## Expected Outcome

- Up-to-date dependencies in sync with `pyproject.toml`
- Clean, conflict-free dependency tree
- Clear confirmation of changes made
