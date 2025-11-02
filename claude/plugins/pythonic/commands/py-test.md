---
description: Run pytest with proper configuration and coverage reporting
---

# Run Python Tests

Execute the project's test suite using pytest with appropriate options and coverage reporting.

## Tasks to Complete

1. **Run Tests**
   - Execute `uv run pytest` to run all tests
   - Display test results clearly
   - Report any failures with details

2. **Coverage Analysis** (if requested)
   - Run `uv run pytest --cov` for coverage report
   - Generate HTML coverage report if needed
   - Highlight areas needing more test coverage

3. **Test Filtering** (if requested)
   - Run specific test files: `uv run pytest tests/test_specific.py`
   - Run tests matching pattern: `uv run pytest -k "pattern"`
   - Run only failed tests: `uv run pytest --lf`

## Expected Outcome

- Clear test results showing passes/failures
- Coverage percentages for each module
- Actionable information about test failures
