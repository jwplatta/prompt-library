---
applyTo: **/*.rb
description: Error handling, exception patterns, and resilience strategies for Ruby
---

# Ruby Error Handling Patterns

## Custom Exception Classes

### Basic Exception Hierarchy
```ruby
module MyApp
  class Error < StandardError; end
  
  class ValidationError < Error; end
  class NetworkError < Error; end
  class ConfigurationError < Error; end
  class AuthenticationError < Error; end
end
```

### Exception with Context
```ruby
class ValidationError < StandardError
  attr_reader :field, :value, :context
  
  def initialize(message, field: nil, value: nil, context: {})
    super(message)
    @field = field
    @value = value
    @context = context
  end

  def to_h
    {
      error: self.class.name,
      message: message,
      field: field,
      value: value,
      context: context
    }
  end
end

# Usage
raise ValidationError.new(
  "Quantity must be positive", 
  field: :quantity, 
  value: -5,
  context: { order_id: "12345", symbol: "AAPL" }
)
```

### Domain-Specific Exceptions
```ruby
module Trading
  class TradingError < StandardError; end
  
  class InsufficientFundsError < TradingError
    attr_reader :required_amount, :available_amount
    
    def initialize(required:, available:)
      @required_amount = required
      @available_amount = available
      super("Insufficient funds: need $#{required}, have $#{available}")
    end
  end
  
  class MarketClosedError < TradingError
    attr_reader :market, :current_time
    
    def initialize(market:, current_time: Time.now)
      @market = market
      @current_time = current_time
      super("Market #{market} is closed at #{current_time}")
    end
  end
  
  class InvalidOrderError < TradingError
    attr_reader :order, :violations
    
    def initialize(order:, violations:)
      @order = order
      @violations = violations
      super("Invalid order: #{violations.join(', ')}")
    end
  end
end
```

## Proper Exception Handling Patterns

### Input Validation with Specific Exceptions
```ruby
def validate_quantity(quantity)
  raise ArgumentError, "quantity must be provided" if quantity.nil?
  raise TypeError, "quantity must be numeric" unless quantity.is_a?(Numeric)
  raise ArgumentError, "quantity must be positive" if quantity <= 0
  raise ArgumentError, "quantity must be finite" unless quantity.finite?
end

def validate_symbol(symbol)
  raise ArgumentError, "symbol must be provided" if symbol.nil?
  raise TypeError, "symbol must be a string" unless symbol.is_a?(String)
  raise ArgumentError, "symbol cannot be empty" if symbol.strip.empty?
  raise ArgumentError, "symbol format invalid" unless symbol.match?(/\A[A-Z]{1,5}\z/)
end
```

### Resource Management with Ensure
```ruby
def process_with_cleanup
  resource = acquire_resource
  setup_temporary_state
  process_data
ensure
  cleanup_temporary_state
  release_resource(resource) if resource
end

def with_file_lock(file_path)
  lock_file = File.open("#{file_path}.lock", 'w')
  lock_file.flock(File::LOCK_EX)
  
  yield
ensure
  lock_file.flock(File::LOCK_UN) if lock_file
  lock_file.close if lock_file
end
```

### Exception Translation
```ruby
def fetch_account_data(account_id)
  api_client.get_account(account_id)
rescue Net::TimeoutError => e
  raise NetworkError, "Request timed out: #{e.message}"
rescue Net::HTTPError => e
  case e.response.code
  when '401'
    raise AuthenticationError, "Invalid credentials"
  when '404'
    raise ValidationError, "Account not found: #{account_id}"
  when '500'
    raise NetworkError, "Server error: #{e.message}"
  else
    raise NetworkError, "HTTP error #{e.response.code}: #{e.message}"
  end
rescue JSON::ParserError => e
  raise NetworkError, "Invalid response format: #{e.message}"
end
```

## Retry Patterns

### Basic Retry with Backoff
```ruby
def fetch_data_with_retry(retries: 3, backoff: 1.0)
  attempt = 0
  
  begin
    attempt += 1
    fetch_data
  rescue NetworkError, TimeoutError => e
    if attempt < retries
      sleep(backoff * attempt)
      retry
    else
      raise e
    end
  end
end
```

### Advanced Retry with Jitter
```ruby
require 'securerandom'

class RetryHandler
  def self.with_retry(
    max_attempts: 3,
    base_delay: 1.0,
    max_delay: 60.0,
    backoff_factor: 2.0,
    jitter: true,
    retriable_exceptions: [StandardError]
  )
    attempt = 0
    
    begin
      attempt += 1
      yield
    rescue *retriable_exceptions => e
      if attempt < max_attempts
        delay = calculate_delay(attempt, base_delay, max_delay, backoff_factor, jitter)
        sleep(delay)
        retry
      else
        raise e
      end
    end
  end
  
  private
  
  def self.calculate_delay(attempt, base_delay, max_delay, backoff_factor, jitter)
    delay = base_delay * (backoff_factor ** (attempt - 1))
    delay = [delay, max_delay].min
    
    if jitter
      # Add random jitter ±25%
      jitter_range = delay * 0.25
      delay += (SecureRandom.random_number * 2 - 1) * jitter_range
    end
    
    [delay, 0.1].max # Minimum 100ms delay
  end
end

# Usage
def robust_api_call
  RetryHandler.with_retry(
    max_attempts: 5,
    base_delay: 0.5,
    retriable_exceptions: [NetworkError, TimeoutError]
  ) do
    api_client.fetch_data
  end
end
```

### Conditional Retry
```ruby
def fetch_with_conditional_retry
  attempt = 0
  
  begin
    attempt += 1
    result = api_call
    
    # Retry on specific conditions
    if should_retry?(result, attempt)
      sleep(calculate_backoff(attempt))
      retry
    end
    
    result
  rescue => e
    if retriable_error?(e) && attempt < 3
      sleep(calculate_backoff(attempt))
      retry
    else
      raise
    end
  end
end

private

def should_retry?(result, attempt)
  return false if attempt >= 3
  
  # Retry on empty results or rate limiting
  result.nil? || result.dig(:error, :code) == 'RATE_LIMITED'
end

def retriable_error?(error)
  case error
  when NetworkError, TimeoutError
    true
  when APIError
    # Only retry on server errors, not client errors
    error.status >= 500
  else
    false
  end
end
```

## Circuit Breaker Pattern

### Simple Circuit Breaker
```ruby
class CircuitBreaker
  CLOSED = :closed
  OPEN = :open
  HALF_OPEN = :half_open
  
  def initialize(failure_threshold: 5, timeout: 60)
    @failure_threshold = failure_threshold
    @timeout = timeout
    @failure_count = 0
    @last_failure_time = nil
    @state = CLOSED
  end
  
  def call
    case @state
    when OPEN
      if Time.now - @last_failure_time > @timeout
        @state = HALF_OPEN
        attempt_call { yield }
      else
        raise CircuitBreakerOpenError, "Circuit breaker is open"
      end
    when HALF_OPEN, CLOSED
      attempt_call { yield }
    end
  end
  
  private
  
  def attempt_call
    result = yield
    on_success
    result
  rescue => e
    on_failure
    raise e
  end
  
  def on_success
    @failure_count = 0
    @state = CLOSED
  end
  
  def on_failure
    @failure_count += 1
    @last_failure_time = Time.now
    
    if @failure_count >= @failure_threshold
      @state = OPEN
    end
  end
end

# Usage
circuit_breaker = CircuitBreaker.new(failure_threshold: 3, timeout: 30)

def protected_api_call
  circuit_breaker.call do
    api_client.fetch_data
  end
end
```

## Error Reporting and Logging

### Structured Error Logging
```ruby
module ErrorReporter
  include Loggable
  
  def report_error(error, context = {})
    error_data = {
      error_class: error.class.name,
      error_message: error.message,
      backtrace: error.backtrace&.first(10),
      context: context,
      timestamp: Time.now.utc.iso8601,
      process_id: Process.pid,
      thread_id: Thread.current.object_id
    }
    
    log_error("ERROR_OCCURRED", **error_data)
    
    # Send to external service if configured
    send_to_external_service(error_data) if should_report_externally?
  end
  
  def report_and_reraise(error, context = {})
    report_error(error, context)
    raise error
  end
  
  private
  
  def should_report_externally?
    !error.is_a?(ValidationError) && ENV['ERROR_REPORTING_ENABLED'] == 'true'
  end
  
  def send_to_external_service(error_data)
    # Implementation for external error service
  end
end
```

### Error Context Capture
```ruby
class ErrorContext
  def self.with_context(**context)
    old_context = Thread.current[:error_context] || {}
    Thread.current[:error_context] = old_context.merge(context)
    
    yield
  rescue => e
    # Enhance error with context
    context_info = Thread.current[:error_context] || {}
    enhanced_error = ErrorWithContext.new(e, context_info)
    raise enhanced_error
  ensure
    Thread.current[:error_context] = old_context
  end
  
  def self.current_context
    Thread.current[:error_context] || {}
  end
end

class ErrorWithContext < StandardError
  attr_reader :original_error, :context
  
  def initialize(original_error, context = {})
    @original_error = original_error
    @context = context
    super("#{original_error.message} | Context: #{context}")
  end
  
  def backtrace
    original_error.backtrace
  end
end

# Usage
def process_order(order)
  ErrorContext.with_context(order_id: order.id, symbol: order.symbol) do
    validate_order(order)
    submit_order(order)
  end
end
```

## Graceful Degradation

### Fallback Patterns
```ruby
def get_market_data(symbol)
  primary_source.get_data(symbol)
rescue PrimarySourceError => e
  log_warn("Primary source failed, using fallback", symbol: symbol, error: e.message)
  fallback_source.get_data(symbol)
rescue FallbackSourceError => e
  log_warn("Fallback source failed, using cached data", symbol: symbol, error: e.message)
  cached_data.get(symbol) || default_market_data(symbol)
end

def with_fallback(*methods, default: nil)
  methods.each do |method|
    begin
      return public_send(method)
    rescue => e
      log_debug("Method #{method} failed: #{e.message}")
      next
    end
  end
  
  default
end

# Usage
price = with_fallback(:real_time_price, :delayed_price, :cached_price, default: 0.0)
```

### Safe Execution
```ruby
def safely(default_value = nil, log_errors: true)
  yield
rescue => e
  log_error("Safe execution failed: #{e.message}") if log_errors
  default_value
end

# Usage
account_balance = safely(0.0) { fetch_account_balance(account_id) }
positions = safely([]) { fetch_positions(account_id) }
```

## Validation Patterns

### Comprehensive Input Validation
```ruby
class OrderValidator
  include ErrorReporter
  
  def validate!(order)
    errors = []
    
    errors << "Symbol is required" if order.symbol.nil? || order.symbol.empty?
    errors << "Quantity must be positive" if order.quantity.nil? || order.quantity <= 0
    errors << "Price must be positive" if order.price.nil? || order.price <= 0
    errors << "Order type is invalid" unless valid_order_types.include?(order.type)
    
    # Business rule validations
    errors << "Market is closed" unless market_open?
    errors << "Insufficient buying power" unless sufficient_funds?(order)
    
    return if errors.empty?
    
    validation_error = ValidationError.new(
      "Order validation failed: #{errors.join(', ')}",
      context: { order_id: order.id, symbol: order.symbol, errors: errors }
    )
    
    report_error(validation_error)
    raise validation_error
  end
  
  private
  
  def valid_order_types
    %w[market limit stop_loss]
  end
  
  def market_open?
    # Market hours validation
    true
  end
  
  def sufficient_funds?(order)
    # Buying power validation
    true
  end
end
```

For basic error handling, see **ruby-core.instructions.md**. For logging errors, see **ruby-logging.instructions.md**.