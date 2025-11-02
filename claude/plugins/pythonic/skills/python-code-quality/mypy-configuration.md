# Mypy Type Checking Configuration

Mypy is a static type checker for Python that helps catch bugs before runtime.

## Basic Configuration

Add to `pyproject.toml`:

```toml
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
show_error_codes = true
show_column_numbers = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[[tool.mypy.overrides]]
module = "third_party_package.*"
ignore_missing_imports = true
```

## Strictness Levels

### Minimal (Getting Started)
```toml
[tool.mypy]
python_version = "3.11"
warn_return_any = false
warn_unused_configs = true
```

### Moderate (Recommended)
```toml
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
check_untyped_defs = true
```

### Strict (Maximum Safety)
```toml
[tool.mypy]
strict = true
python_version = "3.11"
```

## Common Configuration Options

### Type Checking Strictness

```toml
# Require type annotations
disallow_untyped_defs = true          # Functions must have type hints
disallow_untyped_calls = true         # Can't call untyped functions
disallow_incomplete_defs = true       # All params must be typed

# Optional handling
no_implicit_optional = true           # Optional must be explicit
strict_optional = true                # None checking enabled

# Any type usage
disallow_any_unimported = false       # Allow Any from untyped imports
disallow_any_expr = false             # Forbid Any in expressions
disallow_any_decorated = false        # Forbid Any in decorators
disallow_any_explicit = false         # Forbid explicit Any
```

### Warning Messages

```toml
warn_return_any = true                # Warn on returning Any
warn_redundant_casts = true           # Warn on unnecessary casts
warn_unused_ignores = true            # Warn on unused type: ignore
warn_unused_configs = true            # Warn on unused config options
warn_no_return = true                 # Warn on missing returns
warn_unreachable = true               # Warn on unreachable code
```

### Error Reporting

```toml
show_error_codes = true               # Show error codes in messages
show_column_numbers = true            # Show column numbers
pretty = true                         # Pretty print errors
color_output = true                   # Colorize output
error_summary = true                  # Show error summary
```

## Type Hints Guide

### Basic Types

```python
from typing import Any, Optional, Union

# Simple types
def greet(name: str) -> str:
    return f"Hello, {name}"

# Optional (can be None)
def find_user(user_id: int) -> Optional[User]:
    return user_map.get(user_id)

# Modern Optional syntax (Python 3.10+)
def find_user(user_id: int) -> User | None:
    return user_map.get(user_id)

# Union types
def process(value: Union[int, str]) -> bool:
    return True

# Modern Union syntax (Python 3.10+)
def process(value: int | str) -> bool:
    return True
```

### Collections

```python
from typing import List, Dict, Set, Tuple

# Lists
def process_items(items: List[str]) -> List[int]:
    return [len(item) for item in items]

# Modern syntax (Python 3.9+)
def process_items(items: list[str]) -> list[int]:
    return [len(item) for item in items]

# Dictionaries
def get_config() -> Dict[str, Any]:
    return {"key": "value"}

# Modern syntax
def get_config() -> dict[str, Any]:
    return {"key": "value"}

# Sets
def unique_items(items: Set[int]) -> int:
    return len(items)

# Tuples (fixed size)
def get_coordinates() -> Tuple[float, float]:
    return (1.0, 2.0)

# Tuples (variable size)
def get_numbers() -> Tuple[int, ...]:
    return (1, 2, 3, 4, 5)
```

### Callable Types

```python
from typing import Callable

# Function that takes int and returns str
Handler = Callable[[int], str]

def process(handler: Handler) -> None:
    result = handler(42)

# Multiple parameters
Callback = Callable[[str, int], bool]

# No parameters
Factory = Callable[[], MyClass]
```

### Generic Types

```python
from typing import TypeVar, Generic

T = TypeVar('T')

class Container(Generic[T]):
    def __init__(self, value: T) -> None:
        self.value = value

    def get(self) -> T:
        return self.value

# Usage
container: Container[int] = Container(42)
value: int = container.get()
```

### Protocol Types

```python
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None: ...

def render(item: Drawable) -> None:
    item.draw()

# Any class with draw() method works
class Circle:
    def draw(self) -> None:
        print("Drawing circle")

render(Circle())  # Type checks!
```

## Commands Reference

```bash
# Check all files
mypy src

# Check specific file
mypy src/module.py

# Strict mode
mypy --strict src

# Show error codes
mypy --show-error-codes src

# Generate type stubs
stubgen -p mypackage -o stubs

# Check against installed packages
mypy --install-types
mypy --non-interactive --install-types
```

## Common Errors and Fixes

### Error: "Argument has incompatible type"

```python
# Problem
def greet(name: str) -> str:
    return f"Hello, {name}"

greet(123)  # Error: Argument 1 has incompatible type "int"

# Fix: Pass correct type
greet("World")

# Or: Convert type
greet(str(123))
```

### Error: "Function is missing a return statement"

```python
# Problem
def get_value() -> int:
    if condition:
        return 42
    # Missing return!

# Fix: Add return for all paths
def get_value() -> int:
    if condition:
        return 42
    return 0
```

### Error: "Need type annotation"

```python
# Problem
items = []  # Error: Need type annotation

# Fix: Add type annotation
items: list[str] = []

# Or: Initialize with values
items = ["a", "b", "c"]
```

### Error: "Incompatible return type"

```python
# Problem
def get_name() -> str:
    return None  # Error: Incompatible return

# Fix: Use Optional
def get_name() -> str | None:
    return None
```

## Ignoring Errors

```python
# Ignore single line
result = unsafe_function()  # type: ignore

# Ignore with reason
result = unsafe_function()  # type: ignore[arg-type]

# Ignore entire file
# mypy: ignore-errors
```

## Third-Party Package Stubs

### Installing Type Stubs

```bash
# Install stubs for requests
uv add --dev types-requests

# Common stubs
uv add --dev types-requests
uv add --dev types-redis
uv add --dev types-PyYAML
```

### Handling Missing Stubs

```toml
[[tool.mypy.overrides]]
module = "untyped_package.*"
ignore_missing_imports = true
```

## VSCode Integration

Add to `.vscode/settings.json`:

```json
{
  "python.linting.mypyEnabled": true,
  "python.linting.enabled": true,
  "python.analysis.typeCheckingMode": "basic"
}
```

## Best Practices

1. **Start gradual**: Enable mypy gradually, module by module
2. **Use strict mode**: `strict = true` for new projects
3. **Add type hints everywhere**: Functions, methods, variables
4. **Use Protocol for duck typing**: Better than inheritance
5. **Leverage modern syntax**: Use `list` instead of `List` (Python 3.9+)
6. **Install type stubs**: For all third-party packages
7. **Run in CI**: Fail builds on type errors
8. **Document with types**: Types serve as documentation

## Incremental Adoption

```toml
# Start with specific directories
[tool.mypy]
files = ["src/critical_module"]
strict = true

# Gradually expand
files = ["src/critical_module", "src/api"]

# Eventually cover everything
files = ["src"]
```
