---
applyTo: **/*.rb
description: Essential Ruby coding patterns and conventions - use this as primary reference
---

# Ruby Core Guidelines

**Essential Ruby patterns for daily development. For advanced patterns, see specialized instruction files.**

## Core Principles

### String Literals
```ruby
# ALWAYS include at the top of every Ruby file
# frozen_string_literal: true
```

### Module Organization
- Use nested modules for logical grouping
- Follow consistent namespace patterns
- Place related functionality under common parent modules

### File Structure
- Use `require_relative` for local dependencies
- Order requires logically: core dependencies first, then local files
- Group requires by category with comments when helpful

## Ruby Style Guidelines

### String Formatting
```ruby
# Prefer string interpolation over concatenation
"Order #{order_id} for #{quantity} shares"

# Use format for complex formatting
format("$%<amount>.2f", amount: 1234.56)

# Use heredocs for multi-line strings
sql = <<~SQL
  SELECT * FROM orders
  WHERE status = 'filled'
  AND created_at > ?
SQL
```

### Array and Hash Syntax
```ruby
# Use %w for string arrays
STATUSES = %w[pending filled cancelled].freeze

# Use %i for symbol arrays
FIELDS = %i[symbol price quantity].freeze

# Use trailing commas in multi-line structures
order = {
  symbol: 'AAPL',
  quantity: 100,
  price: 150.00,
}
```

### Ruby Idioms
```ruby
# Use safe navigation operator
account&.balance&.to_f

# Use case equality for type checking
case value
when String then value.strip
when Numeric then value.to_f
when NilClass then 0.0
end

# Use dig for safe hash access
data.dig(:securities_account, :current_balances, :cash_balance)
```

## Basic Patterns

### Keyword Arguments
```ruby
# Prefer keyword arguments for multiple parameters
def initialize(type:, account_number:, balance: 0.0, active: true)
  @type = type
  @account_number = account_number
  @balance = balance
  @active = active
end

# Use double splat for forwarding keyword arguments
def create_account(**args)
  Account.new(**args)
end
```

### Serialization Pattern
```ruby
def to_h
  {
    type: type,
    quantity: quantity,
    underlying_symbol: underlying_symbol
  }
end

def to_json(*args)
  to_h.to_json(*args)
end
```

### Basic Factory Pattern
```ruby
class << self
  def from_json(json_string)
    data = JSON.parse(json_string, symbolize_names: true)
    from_h(data)
  end

  def from_h(data)
    new(
      attribute: data[:attribute],
      # ... other attributes
    )
  end
end
```

## Method Naming Conventions

### Query Methods
- Use `?` suffix for boolean queries: `filled?`, `working?`, `exited?`
- Use descriptive names: `market_change?`, `paper_accepted?`

### Command Methods
- Use imperative verbs: `send_order`, `check_status`, `find_strategy`
- Use `set_` prefix for setters: `set_quantity`, `set_price`
- Use `clear_` prefix for resetters: `clear_session`, `clear_price`

### Bang Methods
```ruby
# Use ! for destructive methods
def normalize!
  @symbol = @symbol.upcase.strip
  self
end

# Provide both versions
def normalize
  dup.normalize!
end
```

### Conversion Methods
```ruby
# Standard conversion methods
def to_s
  "#<#{self.class.name} symbol=#{symbol} price=#{price}>"
end

def to_i
  price.to_i
end

def to_f
  price.to_f
end
```

## Basic Error Handling

### Parameter Validation
```ruby
def set_quantity(quantity)
  raise ArgumentError, "quantity must be positive" if quantity <= 0
  @quantity = quantity
end

def initialize(type:, account_number:, **options)
  @type = type || raise(ArgumentError, "type is required")
  @account_number = account_number || raise(ArgumentError, "account_number is required")
end
```

### Basic Exception Structure
```ruby
module MyApp
  class Error < StandardError; end
  
  class ValidationError < Error; end
  class NetworkError < Error; end
end
```

## Performance Basics

### Lazy Loading
```ruby
def expiration_date
  @expiration_date ||= put_spread.expiration_date || call_spread.expiration_date
end
```

### Simple Caching
```ruby
def symbols
  @symbols ||= put_spread.symbols + call_spread.symbols
end
```

## Constants and Enums

### State Constants
```ruby
TRADE_STATES = {
  trade_found: 'TRADE_FOUND',
  no_trade_found: 'NO_TRADE_FOUND',
  open_order_sent: 'OPEN_ORDER_SENT'
}.freeze
```

### Enum Constants
```ruby
module Session
  NORMAL = "NORMAL"
  AM = "AM"
  PM = "PM"
  SEAMLESS = "SEAMLESS"
end
```

---

## Advanced Patterns Reference

For more complex patterns, refer to these specialized instruction files:

- **ruby-class-design.instructions.md** - Data objects, builders, advanced factories
- **ruby-logging.instructions.md** - Shared logging, domain-specific logging
- **ruby-error-handling.instructions.md** - Custom errors, retry patterns, rescue strategies
- **ruby-dsl.instructions.md** - DSL creation, builder patterns, fluent interfaces
- **ruby-testing.instructions.md** - RSpec patterns, mocking, shared examples
- **ruby-configuration.instructions.md** - Environment-based config, configuration objects
- **ruby-security.instructions.md** - Data redaction, sensitive information handling
- **ruby-documentation.instructions.md** - Method documentation, inline comments
- **ruby-code-organization.instructions.md** - File naming, module structure, dependency injection