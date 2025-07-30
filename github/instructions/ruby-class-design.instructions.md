---
applyTo: **/*.rb
description: Advanced class design patterns for Ruby - data objects, builders, factories
---

# Ruby Class Design Patterns

## Data Object Pattern

### Build Pattern for API Responses
```ruby
class Account
  class << self
    def build(data)
      data = data[:securitiesAccount] if data.key?(:securitiesAccount)
      new(
        type: data.fetch(:type),
        account_number: data.fetch(:accountNumber),
        # ... other attributes
      )
    end
  end

  def initialize(type:, account_number:, **options)
    @type = type
    @account_number = account_number
  end

  attr_reader :type, :account_number
end
```

### Standard Library Patterns

#### Struct Usage
```ruby
# Use Struct for simple data containers
Position = Struct.new(:symbol, :quantity, :price, keyword_init: true) do
  def market_value
    quantity * price
  end
end
```

#### Data Class (Ruby 3.2+)
```ruby
# Use Data class for immutable objects
class Quote < Data.define(:symbol, :price, :volume)
  def formatted_price
    "$%.2f" % price
  end
end
```

#### Comparable Module
```ruby
class Price
  include Comparable
  
  attr_reader :amount
  
  def initialize(amount)
    @amount = amount.to_f
  end
  
  def <=>(other)
    amount <=> other.amount
  end
end
```

#### Forwardable Pattern
```ruby
require 'forwardable'

class Portfolio
  extend Forwardable
  
  def_delegators :@positions, :each, :size, :empty?
  
  def initialize
    @positions = []
  end
end
```

## Factory Patterns

### Advanced Factory Methods
```ruby
class OrderFactory
  class << self
    # Use build for object construction from data
    def build_from_api(api_data)
      new(
        symbol: api_data[:instrument][:symbol],
        quantity: api_data[:quantity],
        price: api_data[:price]
      )
    end

    # Use create for object instantiation with business logic
    def create_market_order(symbol, quantity)
      new(
        symbol: symbol,
        quantity: quantity,
        order_type: :market,
        created_at: Time.now
      )
    end

    # Use from_ prefix for format conversion
    def from_json(json_string)
      data = JSON.parse(json_string, symbolize_names: true)
      from_h(data)
    end

    def from_h(data)
      new(
        symbol: data[:symbol],
        quantity: data[:quantity],
        price: data[:price]
      )
    end
  end
end
```

## Enumerable Patterns

### Effective Use of Enumerable Methods
```ruby
class PositionCollection
  include Enumerable
  
  def initialize(positions)
    @positions = positions
  end
  
  def each(&block)
    @positions.each(&block)
  end
end
```

### Common Enumerable Patterns
```ruby
# Filter and transform
positions.filter_map { |pos| pos.symbol if pos.profitable? }

# Group operations
orders.group_by(&:status)

# Aggregate calculations
prices.sum(&:amount) / prices.size

# Find operations
positions.find { |pos| pos.symbol == 'AAPL' }
positions.select(&:profitable?)
```

## Module Patterns

### Module Callbacks
```ruby
module Trackable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      attr_accessor :created_at
      after_initialize :set_timestamp
    end
  end
  
  module ClassMethods
    def tracked_instances
      @tracked_instances ||= []
    end
  end
  
  private
  
  def set_timestamp
    self.created_at = Time.now
  end
end
```

### Module Extension Pattern
```ruby
module Calculable
  def self.extended(base)
    base.class_eval do
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def calculate_profit
      current_value - cost_basis
    end
  end
  
  def profit_margin(positions)
    positions.sum(&:calculate_profit)
  end
end
```

## Inheritance and Composition

### Template Method Pattern
```ruby
class StrategyBase
  def execute
    validate_inputs
    perform_calculation
    format_output
  end
  
  private
  
  def validate_inputs
    raise NotImplementedError, "Subclasses must implement validate_inputs"
  end
  
  def perform_calculation
    raise NotImplementedError, "Subclasses must implement perform_calculation"
  end
  
  def format_output
    # Default implementation
    nearest_increment(@result)
  end
  
  def nearest_increment(value)
    return 0.0 if value.nil?
    (value / @increment).round * @increment
  end
end
```

### Composition over Inheritance
```ruby
class Trade
  def initialize(strategy:, order_manager:, risk_monitor:)
    @strategy = strategy
    @order_manager = order_manager
    @risk_monitor = risk_monitor
  end
  
  def execute
    return unless @strategy.valid?
    
    @order_manager.place_order(@strategy.to_order)
    @risk_monitor.track(@strategy)
  end
  
  private
  
  attr_reader :strategy, :order_manager, :risk_monitor
end
```

## State Management

### State Machine Pattern
```ruby
class TradeStateMachine
  STATES = {
    no_trade_found: 'NO_TRADE_FOUND',
    trade_found: 'TRADE_FOUND',
    order_sent: 'ORDER_SENT',
    trade_filled: 'TRADE_FILLED'
  }.freeze
  
  def initialize(initial_state: STATES[:no_trade_found])
    @current_state = initial_state
  end
  
  def transition_to(new_state)
    return false unless valid_transition?(new_state)
    
    @current_state = new_state
    execute_state_callbacks
    true
  end
  
  private
  
  def valid_transition?(new_state)
    VALID_TRANSITIONS[@current_state]&.include?(new_state)
  end
  
  VALID_TRANSITIONS = {
    STATES[:no_trade_found] => [STATES[:trade_found]],
    STATES[:trade_found] => [STATES[:order_sent], STATES[:no_trade_found]],
    STATES[:order_sent] => [STATES[:trade_filled], STATES[:no_trade_found]]
  }.freeze
end
```

## Value Objects

### Immutable Value Objects
```ruby
class Money
  include Comparable
  
  attr_reader :amount, :currency
  
  def initialize(amount, currency = 'USD')
    @amount = amount.to_f.freeze
    @currency = currency.to_s.upcase.freeze
    freeze
  end
  
  def +(other)
    validate_same_currency(other)
    self.class.new(amount + other.amount, currency)
  end
  
  def -(other)
    validate_same_currency(other)
    self.class.new(amount - other.amount, currency)
  end
  
  def <=>(other)
    validate_same_currency(other)
    amount <=> other.amount
  end
  
  def to_s
    format("%.2f %s", amount, currency)
  end
  
  private
  
  def validate_same_currency(other)
    return if currency == other.currency
    
    raise ArgumentError, "Cannot operate on different currencies: #{currency} vs #{other.currency}"
  end
end
```

## Data Transformation

### Conversion Protocols
```ruby
class Position
  def to_h
    {
      symbol: symbol,
      quantity: quantity,
      price: price,
      market_value: market_value
    }
  end
  
  def to_json(*args)
    to_h.to_json(*args)
  end
  
  def to_s
    "#<Position #{symbol}: #{quantity}@#{price}>"
  end
  
  def to_csv_row
    [symbol, quantity, price, market_value]
  end
end
```

### Coercion Methods
```ruby
class Price
  def coerce(other)
    case other
    when Numeric
      [self.class.new(other), self]
    else
      raise TypeError, "Cannot coerce #{other.class} with #{self.class}"
    end
  end
end
```

For core patterns, see **ruby-core.instructions.md**. For related patterns, see **ruby-dsl.instructions.md** for builders.