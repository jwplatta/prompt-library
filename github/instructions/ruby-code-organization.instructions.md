---
applyTo: **/*.rb
description: Code organization, file structure, and dependency management for Ruby
---

# Ruby Code Organization Patterns

## File Naming

### File Naming Conventions
- Use snake_case for file names
- Match file names to class names: `iron_condor.rb` ’ `IronCondor`
- Use descriptive directory names: `tools/`, `strategies/`, `data_objects/`

## Module Structure

### Module Organization
```ruby
module MyApp
  module SubModule
    class MyClass
      # Implementation
    end
  end
end
```

## Dependency Injection

### Dependency Injection Pattern
```ruby
class OrderManager
  def initialize(client: nil)
    @client = client || ClientFactory.create_client
  end
end
```

For basic organization principles, see **ruby-core.instructions.md**.