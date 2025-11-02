# Pytest Configuration Guide

Pytest is a powerful testing framework for Python that makes it easy to write simple and scalable tests.

## Installation

```bash
uv add --dev pytest
uv add --dev pytest-cov  # For coverage
uv add --dev pytest-mock  # For mocking
uv add --dev pytest-asyncio  # For async tests
```

## Basic Configuration

Add to `pyproject.toml`:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
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
    "unit: marks tests as unit tests",
]
```

## Directory Structure

```
project/
├── src/
│   └── project_name/
│       └── module.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py            # Shared fixtures
│   ├── test_module.py         # Unit tests
│   ├── integration/
│   │   ├── __init__.py
│   │   └── test_api.py        # Integration tests
│   └── fixtures/
│       └── sample_data.json
```

## Writing Tests

### Basic Test Function

```python
def test_simple_addition():
    """Test that addition works correctly."""
    result = add(2, 3)
    assert result == 5
```

### Test Class

```python
class TestCalculator:
    """Tests for Calculator class."""

    def test_addition(self):
        calc = Calculator()
        assert calc.add(2, 3) == 5

    def test_subtraction(self):
        calc = Calculator()
        assert calc.subtract(5, 3) == 2
```

### Using Assertions

```python
def test_assertions():
    # Equality
    assert result == expected

    # Boolean
    assert is_valid()
    assert not is_invalid()

    # Membership
    assert item in collection
    assert key in dictionary

    # Type checking
    assert isinstance(obj, MyClass)

    # Exceptions
    with pytest.raises(ValueError):
        raise_error()

    # Approximate equality (floats)
    assert result == pytest.approx(expected, rel=1e-5)
```

## Fixtures

### Basic Fixture

```python
import pytest

@pytest.fixture
def sample_user():
    """Create a sample user for testing."""
    return User(name="Alice", age=30)

def test_user_greeting(sample_user):
    assert sample_user.greet() == "Hello, I'm Alice"
```

### Fixture Scopes

```python
@pytest.fixture(scope="function")  # Default, new instance per test
def function_scope():
    return setup()

@pytest.fixture(scope="class")  # One instance per test class
def class_scope():
    return setup()

@pytest.fixture(scope="module")  # One instance per module
def module_scope():
    return setup()

@pytest.fixture(scope="session")  # One instance per test session
def session_scope():
    return setup()
```

### Fixture Cleanup

```python
@pytest.fixture
def resource():
    # Setup
    res = acquire_resource()
    yield res
    # Teardown
    res.cleanup()

# Or using context manager
@pytest.fixture
def database():
    with create_database() as db:
        yield db
    # Automatic cleanup
```

### Fixture Dependencies

```python
@pytest.fixture
def database():
    return Database()

@pytest.fixture
def user_repository(database):
    return UserRepository(database)

def test_find_user(user_repository):
    user = user_repository.find(1)
    assert user is not None
```

## Parametrized Tests

### Basic Parametrization

```python
@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
    (5, 25),
])
def test_square(input, expected):
    assert square(input) == expected
```

### Multiple Parameters

```python
@pytest.mark.parametrize("a,b,expected", [
    (1, 1, 2),
    (2, 3, 5),
    (10, -5, 5),
])
def test_addition(a, b, expected):
    assert add(a, b) == expected
```

### Parametrizing Fixtures

```python
@pytest.fixture(params=[1, 2, 3])
def number(request):
    return request.param

def test_with_different_numbers(number):
    assert number > 0
```

## Test Markers

### Built-in Markers

```python
@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    pass

@pytest.mark.skipif(sys.version_info < (3, 10), reason="Requires Python 3.10+")
def test_new_feature():
    pass

@pytest.mark.xfail(reason="Known bug")
def test_buggy_feature():
    pass
```

### Custom Markers

```python
# Define in pyproject.toml
# markers = ["slow: marks tests as slow"]

@pytest.mark.slow
def test_expensive_operation():
    # Long-running test
    pass

# Run with: pytest -m "not slow"
```

## Exception Testing

```python
def test_raises_value_error():
    with pytest.raises(ValueError):
        raise ValueError("Invalid value")

def test_raises_with_message():
    with pytest.raises(ValueError, match="Invalid"):
        raise ValueError("Invalid value")

def test_exception_info():
    with pytest.raises(ValueError) as exc_info:
        raise ValueError("Invalid value")
    assert "Invalid" in str(exc_info.value)
```

## Mocking

### Using pytest-mock

```python
def test_with_mock(mocker):
    # Mock a function
    mock = mocker.patch('module.function')
    mock.return_value = 42

    result = call_function()
    assert result == 42
    mock.assert_called_once()

def test_mock_method(mocker):
    # Mock a method
    mock = mocker.patch.object(MyClass, 'method')
    mock.return_value = "mocked"

    obj = MyClass()
    assert obj.method() == "mocked"
```

### Using unittest.mock

```python
from unittest.mock import Mock, patch

def test_with_mock():
    with patch('module.function') as mock:
        mock.return_value = 42
        result = call_function()
        assert result == 42
```

## Async Tests

```python
import pytest

@pytest.mark.asyncio
async def test_async_function():
    result = await async_operation()
    assert result == expected

@pytest.fixture
async def async_client():
    client = AsyncClient()
    yield client
    await client.close()

@pytest.mark.asyncio
async def test_with_async_fixture(async_client):
    result = await async_client.get("/endpoint")
    assert result.status_code == 200
```

## Running Tests

```bash
# All tests
pytest

# Specific file
pytest tests/test_module.py

# Specific test
pytest tests/test_module.py::test_function

# Specific class
pytest tests/test_module.py::TestClass

# Pattern matching
pytest -k "test_user"

# Markers
pytest -m slow          # Only slow tests
pytest -m "not slow"    # Exclude slow tests

# Last failed
pytest --lf

# Failed first
pytest --ff

# Stop on first failure
pytest -x

# Stop after N failures
pytest --maxfail=3

# Verbose output
pytest -v

# Show print statements
pytest -s

# Show locals in tracebacks
pytest --showlocals

# Parallel execution (requires pytest-xdist)
pytest -n auto
```

## conftest.py

Shared configuration and fixtures:

```python
# tests/conftest.py
import pytest

@pytest.fixture(scope="session")
def database():
    """Create database for entire test session."""
    db = create_test_database()
    yield db
    db.drop()

@pytest.fixture(autouse=True)
def reset_database(database):
    """Reset database before each test."""
    database.clear()

def pytest_configure(config):
    """Pytest configuration hook."""
    config.addinivalue_line(
        "markers", "integration: mark test as integration test"
    )
```

## Best Practices

1. **One assertion per test**: Keep tests focused
2. **Descriptive names**: Use `test_user_creation_with_valid_data`
3. **AAA pattern**: Arrange, Act, Assert
4. **Use fixtures**: Avoid duplicating setup code
5. **Test edge cases**: Not just happy paths
6. **Fast tests**: Keep unit tests under 100ms
7. **Independent tests**: Tests should not depend on each other
8. **Clear assertions**: Make failures obvious

## Example Test File

```python
"""Tests for user module."""
import pytest
from project_name.models import User

@pytest.fixture
def valid_user_data():
    """Valid user data for testing."""
    return {
        "name": "Alice",
        "email": "alice@example.com",
        "age": 30
    }

class TestUser:
    """Tests for User model."""

    def test_create_user(self, valid_user_data):
        """Test creating a user with valid data."""
        # Arrange & Act
        user = User(**valid_user_data)

        # Assert
        assert user.name == "Alice"
        assert user.email == "alice@example.com"
        assert user.age == 30

    def test_user_greeting(self, valid_user_data):
        """Test user greeting message."""
        user = User(**valid_user_data)
        assert user.greet() == "Hello, I'm Alice"

    @pytest.mark.parametrize("age", [-1, 0, 151])
    def test_invalid_age(self, valid_user_data, age):
        """Test that invalid ages raise ValueError."""
        valid_user_data["age"] = age
        with pytest.raises(ValueError, match="Invalid age"):
            User(**valid_user_data)
```
