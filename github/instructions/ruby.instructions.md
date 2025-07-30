---
applyTo: **/*.rb
description: Ruby coding guidelines and patterns based on schwab_mcp, schwab_rb, and options_trader codebases
---

# Ruby Coding Guidelines

Based on analysis of the schwab_mcp, schwab_rb, and options_trader codebases, this document outlines comprehensive Ruby coding guidelines and patterns established across these projects.

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

### Ruby Style Guidelines

#### String Formatting
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

#### Array and Hash Syntax
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

#### Ruby Idioms
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

## Class Design Patterns

### Data Object Pattern
Use the build pattern for creating objects from API responses:

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

### Serialization Pattern
Implement consistent serialization methods:

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

### Factory Pattern
Use class methods for object creation:

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

### Keyword Arguments Best Practices
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

### Standard Library Patterns

#### Struct and Data Usage
```ruby
# Use Struct for simple data containers
Position = Struct.new(:symbol, :quantity, :price, keyword_init: true) do
  def market_value
    quantity * price
  end
end

# Use Data class for immutable objects (Ruby 3.2+)
class Quote < Data.define(:symbol, :price, :volume)
  def formatted_price
    "$%.2f" % price
  end
end
```

#### Enumerable Patterns
```ruby
# Use Enumerable methods effectively
positions.filter_map { |pos| pos.symbol if pos.profitable? }
orders.group_by(&:status)
prices.sum(&:amount) / prices.size
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

#### Module Callbacks
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

## Logging Patterns

### Shared Logger Module
Implement consistent logging across all classes:

```ruby
module Loggable
  def logger
    MyApp::Logger
  end

  def log_debug(message)
    logger.debug(message)
  end

  def log_info(message)
    logger.info(message)
  end

  def log_warn(message)
    logger.warn(message)
  end

  def log_error(message)
    logger.error(message)
  end
end

# Usage in classes
class MyClass
  include Loggable

  def some_method
    log_info("Processing started")
  end
end
```

### Domain-Specific Logging
Create specialized logging methods for business logic:

```ruby
def log_trade_state(trade_id, state, details = nil)
  msg = "<#{state} | #{Time.now.utc} | #{trade_id}"
  msg += " | #{details}" if details
  msg += ">"

  case state
  when 'TRADE_OPEN'
    logger.info(msg)
  when /ERROR|FAILED/
    logger.error(msg)
  else
    logger.info(msg)
  end
end
```

## Error Handling

### Custom Exception Classes
```ruby
module MyApp
  class Error < StandardError; end

  class ValidationError < Error; end
  class NetworkError < Error; end
end
```

### Proper Exception Handling Patterns
```ruby
# Use specific exception types
def validate_quantity(quantity)
  raise ArgumentError, "quantity must be positive" if quantity <= 0
  raise TypeError, "quantity must be numeric" unless quantity.is_a?(Numeric)
end

# Use ensure for cleanup
def process_with_cleanup
  setup_resources
  process_data
ensure
  cleanup_resources
end
```

### Custom Error with Context
```ruby
class ValidationError < StandardError
  attr_reader :field, :value

  def initialize(message, field: nil, value: nil)
    super(message)
    @field = field
    @value = value
  end
end
```

### Rescue Patterns
```ruby
# Specific rescue with fallback
begin
  process_data
rescue JSON::ParserError => e
  log_error("JSON parsing error: #{e.message}")
  return default_response
rescue => e
  log_error("Unexpected error: #{e.message}")
  log_debug("Backtrace: #{e.backtrace.first(3).join('\n')}")
  raise
end
```

### Retry Patterns
```ruby
def fetch_data(retries: 3)
  attempt = 0
  begin
    api_call
  rescue NetworkError => e
    attempt += 1
    retry if attempt < retries
    raise
  end
end
```

## Builder Pattern

### Fluent Interface
```ruby
class OrderBuilder
  def initialize
    @attributes = {}
  end

  def set_quantity(quantity)
    raise "quantity must be positive" if quantity <= 0
    @quantity = quantity
    self
  end

  def set_price(price)
    @price = price
    self
  end

  def build
    # Convert to final object
  end
end
```

### DSL Pattern
```ruby
def create_bot(&block)
  builder = BotBuilder.new
  builder.instance_eval(&block)
  builder.build
end

# Usage:
bot = create_bot do
  set_name "SPX Weekly"
  set_mode :paper
  use_strategy :iron_condor do
    set_underlying_symbol "$SPX"
    set_days_to_expiration 1
  end
end
```

## State Management

### State Constants
```ruby
TRADE_STATES = {
  trade_found: 'TRADE_FOUND',
  no_trade_found: 'NO_TRADE_FOUND',
  open_order_sent: 'OPEN_ORDER_SENT'
}.freeze
```

### State Machine Pattern
```ruby
def next
  case current_state
  when TRADE_STATES[:no_trade_found]
    find_strategy
  when TRADE_STATES[:trade_found]
    send_open_order
  when TRADE_STATES[:open_order_sent]
    check_open_order
  else
    raise "Unknown state: #{current_state}"
  end
ensure
  @timestamp = Time.now.utc
  save_state
end
```

## Enumeration Patterns

### Enum Constants
```ruby
module Session
  NORMAL = "NORMAL"
  AM = "AM"
  PM = "PM"
  SEAMLESS = "SEAMLESS"
end
```

### Enum Enforcement
```ruby
def convert_enum(value, enum_module)
  # Implementation to validate and convert enum values
end

def set_session(session)
  @session = convert_enum(session, Session)
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

### Factory Methods
- Use `build` for object construction from data
- Use `create` for object instantiation with business logic
- Use `from_` prefix for format conversion: `from_json`, `from_h`

## Data Validation

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

### Data Transformation
```ruby
def format_currency(amount)
  return "0.00" if amount.nil?
  "%.2f" % amount.to_f
end

def nearest_increment(value)
  return 0.0 if value.nil?
  (value / @increment).round * @increment
end
```

## Configuration Patterns

### Environment-Based Configuration
```ruby
def configure_schwab_rb_logging
  SchwabRb.configure do |config|
    config.logger = MyApp::Logger.instance
    config.log_level = ENV.fetch('LOG_LEVEL', 'INFO').upcase
  end
end

def log_file_path
  if ENV['LOGFILE'] && !ENV['LOGFILE'].empty?
    ENV['LOGFILE']
  else
    File.join(Dir.tmpdir, 'myapp.log')
  end
end
```

### Configuration Objects
```ruby
class Configuration
  attr_accessor :logger, :log_level, :api_key

  def initialize
    @log_level = 'INFO'
    # ... other defaults
  end
end

def self.configure
  yield(configuration)
end

def self.configuration
  @configuration ||= Configuration.new
end
```

## Security Patterns

### Data Redaction
```ruby
class Redactor
  ACCOUNT_NUMBER_PATTERN = /\b\d{8,12}\b/.freeze
  SENSITIVE_KEYS = %w[accountNumber accountId].freeze

  def self.redact_data(data)
    case data
    when Hash
      redact_hash(data)
    when String
      redact_string(data)
    else
      data
    end
  end

  private

  def self.redact_hash(hash)
    hash.each_with_object({}) do |(key, value), redacted|
      redacted[key] = if SENSITIVE_KEYS.include?(key.to_s)
        "[REDACTED]"
      else
        redact_data(value)
      end
    end
  end
end
```

## Testing Patterns

### RSpec Structure
```ruby
RSpec.describe MyClass do
  describe '.build' do
    it 'creates instance from hash data' do
      data = { type: 'CASH', account_number: '12345' }
      instance = described_class.build(data)

      expect(instance.type).to eq('CASH')
      expect(instance.account_number).to eq('12345')
    end
  end

  describe '#method_name' do
    subject { described_class.new(required_params) }

    context 'when condition is met' do
      it 'returns expected result' do
        expect(subject.method_name).to eq(expected_value)
      end
    end
  end
end
```

### Shared Examples
```ruby
RSpec.shared_examples "a tradeable instrument" do
  it "has a symbol" do
    expect(subject.symbol).to be_present
  end

  it "has a price" do
    expect(subject.price).to be_a(Numeric)
  end
end

RSpec.describe Stock do
  it_behaves_like "a tradeable instrument"
end
```

### Custom Matchers
```ruby
RSpec::Matchers.define :be_profitable do
  match do |position|
    position.current_value > position.cost_basis
  end

  failure_message do |position|
    "expected #{position} to be profitable"
  end
end
```

### Mock Objects
```ruby
let(:mock_client) { instance_double(Client) }
let(:mock_response) { instance_double(Response, body: response_data) }

before do
  allow(ClientFactory).to receive(:create_client).and_return(mock_client)
  allow(mock_client).to receive(:get_account).and_return(mock_response)
end
```

## Performance Considerations

### Lazy Loading
```ruby
def expiration_date
  @expiration_date ||= put_spread.expiration_date || call_spread.expiration_date
end
```

### Method Memoization
```ruby
# Better memoization pattern
def expensive_calculation
  return @expensive_calculation if defined?(@expensive_calculation)
  @expensive_calculation = perform_calculation
end

# Thread-safe memoization
def thread_safe_calculation
  @calculation_mutex ||= Mutex.new
  @calculation_mutex.synchronize do
    @calculation ||= perform_calculation
  end
end
```

### Caching
```ruby
def symbols
  @symbols ||= put_spread.symbols + call_spread.symbols
end
```

### Memory Management
```ruby
def clear_cache
  @symbols = nil
  @expiration_date = nil
end
```

## Documentation

### Method Documentation
```ruby
# Helper class to create arbitrarily complex orders. Note this class simply
# implements the order schema defined in the documentation, with no attempts
# to validate the result. Orders created using this class may be rejected or
# may never fill. Use at your own risk.
class OrderBuilder
  # ...
end
```

### Inline Comments
```ruby
# NOTE: trade management components
@progress = TradeProgress.new(profit_thresh: profit_thresh, loss_thresh: loss_thresh)

# NOTE: processing attrs
@find_trade_attempts = 0

# NOTE: only adjust if we have an adjuster
if strategy_adjuster && risk_monitor.danger?(strategy)
  find_adjustment_and_send_close_order
end
```

## Code Organization

### File Naming
- Use snake_case for file names
- Match file names to class names: `iron_condor.rb` → `IronCondor`
- Use descriptive directory names: `tools/`, `strategies/`, `data_objects/`

### Module Structure
```ruby
module MyApp
  module SubModule
    class MyClass
      # Implementation
    end
  end
end
```

### Dependency Injection
```ruby
class OrderManager
  def initialize(client: nil)
    @client = client || ClientFactory.create_client
  end
end
```

This document captures the established patterns across the three codebases and should serve as a comprehensive guide for maintaining consistency in Ruby development across these projects.