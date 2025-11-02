# Python Testing Skill

Comprehensive testing with pytest including unit tests, integration tests, fixtures, and coverage reporting.

## When to Use This Skill

Use this skill when:
- User requests to run tests
- User wants to create new tests
- User asks about test coverage
- User mentions pytest, unit tests, or integration tests
- Debugging test failures

## Core Capabilities

1. **Test Execution**
   - Run all tests or specific test files
   - Run tests matching patterns
   - Run only failed tests
   - Generate test reports

2. **Test Coverage**
   - Measure code coverage
   - Generate HTML coverage reports
   - Identify untested code
   - Set coverage thresholds

3. **Test Writing**
   - Create unit tests for functions and classes
   - Write integration tests
   - Use pytest fixtures effectively
   - Implement parametrized tests

4. **Test Organization**
   - Structure test files properly
   - Use conftest.py for shared fixtures
   - Organize tests by feature or module
   - Mark tests for selective execution

## Context Files

This skill references the following context files in this directory:
- `pytest-configuration.md` - Pytest setup and configuration
- `test-patterns.md` - Common testing patterns and examples
- `fixtures-guide.md` - Using pytest fixtures
- `coverage-guide.md` - Code coverage best practices

## Key Tools and Commands

```bash
# Run tests
uv run pytest                   # All tests
uv run pytest tests/test_file.py  # Specific file
uv run pytest -k "pattern"      # Tests matching pattern
uv run pytest --lf              # Last failed only

# Coverage
uv run pytest --cov             # With coverage
uv run pytest --cov --cov-report=html  # HTML report
uv run pytest --cov --cov-report=term-missing  # Show missing lines

# Output control
uv run pytest -v                # Verbose
uv run pytest -s                # Show print statements
uv run pytest -x                # Stop on first failure
```

## Common Test Patterns

### Unit Test Example
```python
def test_addition():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
```

### Fixture Usage
```python
@pytest.fixture
def sample_data():
    return {"key": "value"}

def test_with_fixture(sample_data):
    assert sample_data["key"] == "value"
```

### Parametrized Tests
```python
@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
])
def test_square(input, expected):
    assert square(input) == expected
```

## Expected Outcomes

After using this skill:
- Comprehensive test suite covering critical functionality
- High test coverage (ideally > 80%)
- Well-organized test files
- Clear test failure messages
- Fast test execution

## Integration with Other Skills

- Works with `python-project-setup` for test directory structure
- Complements `python-code-quality` for comprehensive QA
- Used by `python-project-setup` agent for automated testing
