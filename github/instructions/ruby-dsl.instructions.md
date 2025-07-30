---
applyTo: **/*.rb
description: Domain-Specific Language (DSL) and builder patterns for Ruby
---

# Ruby DSL and Builder Patterns

## Builder Pattern

### Fluent Interface Builder
```ruby
class OrderBuilder
  def initialize
    @attributes = {}
  end

  def set_quantity(quantity)
    raise ArgumentError, "quantity must be positive" if quantity <= 0
    @quantity = quantity
    self
  end

  def set_price(price)
    raise ArgumentError, "price must be positive" if price <= 0
    @price = price
    self
  end

  def set_symbol(symbol)
    raise ArgumentError, "symbol cannot be empty" if symbol.nil? || symbol.empty?
    @symbol = symbol.upcase.strip
    self
  end

  def set_order_type(type)
    valid_types = %i[market limit stop_loss]
    raise ArgumentError, "invalid order type" unless valid_types.include?(type)
    @order_type = type
    self
  end

  def set_session(session)
    @session = convert_enum(session, SchwabRb::Orders::Session)
    self
  end

  def clear_session
    @session = nil
    self
  end

  def set_duration(duration)
    @duration = convert_enum(duration, SchwabRb::Orders::Duration)
    self
  end

  def clear_duration
    @duration = nil
    self
  end

  def add_option_leg(instruction, symbol, quantity)
    raise ArgumentError, "quantity must be positive" if quantity <= 0

    @order_leg_collection ||= []
    @order_leg_collection << {
      "instruction" => convert_enum(instruction, SchwabRb::Orders::OptionInstructions),
      "instrument" => SchwabRb::Orders::OptionInstrument.new(symbol),
      "quantity" => quantity
    }
    self
  end

  def add_equity_leg(instruction, symbol, quantity)
    raise ArgumentError, "quantity must be positive" if quantity <= 0

    @order_leg_collection ||= []
    @order_leg_collection << {
      "instruction" => convert_enum(instruction, SchwabRb::Orders::EquityInstructions),
      "instrument" => SchwabRb::Orders::EquityInstrument.new(symbol),
      "quantity" => quantity
    }
    self
  end

  def clear_order_legs
    @order_leg_collection = nil
    self
  end

  def build
    validate_required_fields
    Builder.build(self)
  end

  private

  def validate_required_fields
    required_fields = [:symbol, :quantity, :order_type]
    missing_fields = required_fields.select { |field| instance_variable_get("@#{field}").nil? }
    
    unless missing_fields.empty?
      raise ArgumentError, "Missing required fields: #{missing_fields.join(', ')}"
    end
  end

  def convert_enum(value, enum_module)
    # Implementation to validate and convert enum values
    value
  end
end

# Usage
order = OrderBuilder.new
  .set_symbol("AAPL")
  .set_quantity(100)
  .set_price(150.00)
  .set_order_type(:limit)
  .build
```

### Advanced Builder with Nested Configuration
```ruby
class IronCondorBuilder
  def initialize
    @legs = {}
    @configuration = {}
  end

  def put_spread(&block)
    spread_builder = SpreadBuilder.new(:put)
    spread_builder.instance_eval(&block) if block_given?
    @legs[:put_spread] = spread_builder.build
    self
  end

  def call_spread(&block)
    spread_builder = SpreadBuilder.new(:call)
    spread_builder.instance_eval(&block) if block_given?
    @legs[:call_spread] = spread_builder.build
    self
  end

  def set_underlying(symbol)
    @configuration[:underlying_symbol] = symbol
    self
  end

  def set_quantity(quantity)
    @configuration[:quantity] = quantity
    self
  end

  def set_expiration(date)
    @configuration[:expiration_date] = date
    self
  end

  def build
    validate_iron_condor
    IronCondor.new(
      underlying_symbol: @configuration[:underlying_symbol],
      put_spread: @legs[:put_spread],
      call_spread: @legs[:call_spread],
      quantity: @configuration[:quantity] || 1
    )
  end

  private

  def validate_iron_condor
    raise ArgumentError, "Both put and call spreads required" unless @legs[:put_spread] && @legs[:call_spread]
    raise ArgumentError, "Underlying symbol required" unless @configuration[:underlying_symbol]
  end
end

class SpreadBuilder
  def initialize(type)
    @type = type
    @strikes = {}
  end

  def short_strike(strike)
    @strikes[:short] = strike
    self
  end

  def long_strike(strike)
    @strikes[:long] = strike
    self
  end

  def build
    case @type
    when :put
      PutSpread.new(short_strike: @strikes[:short], long_strike: @strikes[:long])
    when :call
      CallSpread.new(short_strike: @strikes[:short], long_strike: @strikes[:long])
    end
  end
end

# Usage
iron_condor = IronCondorBuilder.new
  .set_underlying("SPY")
  .set_quantity(2)
  .put_spread do
    short_strike 400
    long_strike 395
  end
  .call_spread do
    short_strike 420
    long_strike 425
  end
  .build
```

## DSL Pattern

### Block-Based DSL
```ruby
def create_bot(&block)
  builder = BotBuilder.new
  builder.instance_eval(&block)
  builder.build
end

class BotBuilder
  def initialize
    @config = {}
  end

  def set_name(name)
    @config[:name] = name
  end

  def set_mode(mode)
    valid_modes = [:paper, :live]
    raise ArgumentError, "Invalid mode: #{mode}" unless valid_modes.include?(mode)
    @config[:mode] = mode
  end

  def set_interval(interval)
    @config[:sleep_interval] = interval
  end

  def set_account_name(account_name)
    @config[:account_name] = account_name
  end

  def enter_trade_when(timing)
    @config[:enter_timing] = timing
  end

  def use_strategy(strategy_type, &block)
    @config[:strategy_type] = strategy_type

    if block_given?
      strategy_builder = StrategyBuilder.new
      strategy_builder.instance_eval(&block)
      strategy_config = strategy_builder.build
      @config.merge!(strategy_config)
    end
  end

  def exit_when(&block)
    if block_given?
      exit_builder = ExitBuilder.new
      exit_builder.instance_eval(&block)
      exit_config = exit_builder.build
      @config.merge!(exit_config)
    end
  end

  def adjust_strategy_when(&block)
    # TODO: Implement strategy adjustment DSL
    puts "Strategy adjustment DSL not implemented yet"
  end

  def alert_when(&block)
    # TODO: Implement alert DSL
    puts "Alert DSL not implemented yet"
  end

  def build
    OptionsTrader::Automation::Bot.new(
      name: @config[:name],
      mode: @config[:mode] || :paper,
      account_name: @config[:account_name],
      config: @config
    )
  end
end

class StrategyBuilder
  def initialize
    @config = {}
  end

  def set_underlying_symbol(symbol)
    @config[:underlying_symbol] = symbol
  end

  def set_option_root(root)
    @config[:option_root] = root
  end

  def set_settlement_type(type)
    @config[:settlement_type] = type
  end

  def set_days_to_expiration(days)
    @config[:days_to_expiration] = days
  end

  def set_min_credit(amount)
    @config[:min_credit] = amount
  end

  def set_min_open_interest(amount)
    @config[:min_open_interest] = amount
  end

  def set_max_delta(delta)
    @config[:max_delta] = delta
  end

  def set_max_spread(spread)
    @config[:max_spread] = spread
  end

  def set_dist_from_strike(distance)
    @config[:dist_from_strike] = distance
  end

  def set_quantity(quantity)
    @config[:quantity] = quantity
  end

  def set_increment(increment)
    @config[:increment] = increment
  end

  def build
    @config
  end
end

class ExitBuilder
  def initialize
    @config = {}
  end

  def max_loss_threshold(multiplier)
    @config[:max_loss_threshold] = -multiplier.abs # Ensure negative for loss
  end

  def profit_target_threshold(percentage)
    @config[:profit_target_threshold] = percentage
  end

  def build
    @config
  end
end

# Usage:
bot = create_bot do
  set_name "SPX Weekly Bot"
  set_mode :paper
  set_account_name "TRADING_ACCOUNT"
  set_interval 60

  enter_trade_when "market_open + 30.minutes"

  use_strategy :iron_condor do
    set_underlying_symbol "$SPX"
    set_option_root "SPXW"
    set_settlement_type "PM"
    set_days_to_expiration 1
    set_min_credit 1.00
    set_min_open_interest 100
    set_max_delta 0.05
    set_quantity 1
  end

  exit_when do
    max_loss_threshold 2.0
    profit_target_threshold 0.65
  end
end
```

### Method-Missing DSL
```ruby
class ConfigurationDSL
  def initialize
    @config = {}
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('set_')
      key = method_name.to_s.sub(/^set_/, '').to_sym
      @config[key] = args.first
    elsif block_given?
      # Nested configuration
      nested_dsl = ConfigurationDSL.new
      nested_dsl.instance_eval(&block)
      @config[method_name] = nested_dsl.to_h
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('set_') || super
  end

  def to_h
    @config
  end
end

def configure(&block)
  dsl = ConfigurationDSL.new
  dsl.instance_eval(&block)
  dsl.to_h
end

# Usage
config = configure do
  set_name "Trading Bot"
  set_mode :live
  
  database do
    set_host "localhost"
    set_port 5432
    set_name "trading_db"
  end
  
  api do
    set_base_url "https://api.schwab.com"
    set_timeout 30
  end
end
```

### Validation DSL
```ruby
class ValidatorDSL
  def initialize(object)
    @object = object
    @errors = []
  end

  def validate(&block)
    instance_eval(&block)
    @errors.empty? ? nil : @errors
  end

  def required(field, message: nil)
    value = @object.public_send(field)
    if value.nil? || (value.respond_to?(:empty?) && value.empty?)
      @errors << (message || "#{field} is required")
    end
  end

  def positive(field, message: nil)
    value = @object.public_send(field)
    if value && value <= 0
      @errors << (message || "#{field} must be positive")
    end
  end

  def format(field, pattern, message: nil)
    value = @object.public_send(field)
    if value && !value.match?(pattern)
      @errors << (message || "#{field} format is invalid")
    end
  end

  def range(field, min:, max:, message: nil)
    value = @object.public_send(field)
    if value && (value < min || value > max)
      @errors << (message || "#{field} must be between #{min} and #{max}")
    end
  end

  def custom(message = "Validation failed", &block)
    result = block.call(@object)
    @errors << message unless result
  end
end

class Order
  attr_accessor :symbol, :quantity, :price

  def validate
    validator = ValidatorDSL.new(self)
    validator.validate do
      required :symbol, message: "Stock symbol is required"
      required :quantity
      required :price

      positive :quantity, message: "Must order at least 1 share"
      positive :price

      format :symbol, /\A[A-Z]{1,5}\z/, message: "Symbol must be 1-5 uppercase letters"
      
      range :quantity, min: 1, max: 10000
      
      custom "Price must be reasonable" do |order|
        order.price && order.price < 10000
      end
    end
  end
end

# Usage
order = Order.new
order.symbol = "AAPL"
order.quantity = 100
order.price = 150.50

errors = order.validate
puts errors if errors # => nil (no errors)
```

### Query DSL
```ruby
class QueryBuilder
  def initialize(model)
    @model = model
    @conditions = []
    @joins = []
    @orders = []
    @limit_value = nil
  end

  def where(field, operator = :eq, value = nil)
    if field.is_a?(Hash)
      field.each { |k, v| where(k, :eq, v) }
    else
      @conditions << { field: field, operator: operator, value: value }
    end
    self
  end

  def join(table, on: nil)
    @joins << { table: table, on: on }
    self
  end

  def order(field, direction = :asc)
    @orders << { field: field, direction: direction }
    self
  end

  def limit(count)
    @limit_value = count
    self
  end

  def gt(value)
    @last_field_value = { operator: :gt, value: value }
    self
  end

  def lt(value)
    @last_field_value = { operator: :lt, value: value }
    self
  end

  def between(min, max)
    @last_field_value = { operator: :between, value: [min, max] }
    self
  end

  def method_missing(method_name, *args)
    if args.empty?
      # Field reference for chaining
      @last_field = method_name
      self
    else
      # Field with value
      where(method_name, :eq, args.first)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end

  def build
    {
      model: @model,
      conditions: @conditions,
      joins: @joins,
      orders: @orders,
      limit: @limit_value
    }
  end
end

def query(model, &block)
  builder = QueryBuilder.new(model)
  builder.instance_eval(&block) if block_given?
  builder.build
end

# Usage
trade_query = query(:trades) do
  where(:status, :eq, 'open')
  where(symbol: 'AAPL', quantity: 100)
  profit.gt(1000)
  created_at.between(1.week.ago, Time.now)
  join(:orders, on: 'trades.order_id = orders.id')
  order(:created_at, :desc)
  limit(50)
end
```

### State Machine DSL
```ruby
class StateMachineDSL
  def initialize
    @states = {}
    @transitions = {}
    @callbacks = {}
  end

  def state(name, &block)
    state_config = StateConfig.new
    state_config.instance_eval(&block) if block_given?
    @states[name] = state_config.to_h
  end

  def transition(from:, to:, on: nil, if: nil, &block)
    transition_key = [from, on].compact
    @transitions[transition_key] = {
      to: to,
      condition: binding.local_variable_get(:if),
      action: block
    }
  end

  def on_enter(state, &block)
    @callbacks["#{state}_enter"] = block
  end

  def on_exit(state, &block)
    @callbacks["#{state}_exit"] = block
  end

  def build
    {
      states: @states,
      transitions: @transitions,
      callbacks: @callbacks
    }
  end
end

class StateConfig
  def initialize
    @config = {}
  end

  def initial(value = true)
    @config[:initial] = value
  end

  def final(value = true)
    @config[:final] = value
  end

  def timeout(seconds, transition_to:)
    @config[:timeout] = { seconds: seconds, transition_to: transition_to }
  end

  def to_h
    @config
  end
end

def define_state_machine(&block)
  dsl = StateMachineDSL.new
  dsl.instance_eval(&block)
  dsl.build
end

# Usage
trade_machine = define_state_machine do
  state :searching do
    initial true
    timeout 300, transition_to: :timeout
  end

  state :found
  state :order_sent
  state :filled do
    final true
  end

  state :timeout do
    final true
  end

  transition from: :searching, to: :found, on: :strategy_found
  transition from: :found, to: :order_sent, on: :send_order
  transition from: :order_sent, to: :filled, on: :order_filled
  transition from: :any, to: :timeout, on: :timeout

  on_enter :found do |trade|
    puts "Strategy found: #{trade.strategy}"
  end

  on_exit :order_sent do |trade|
    puts "Order completed for #{trade.id}"
  end
end
```

For basic builder patterns, see **ruby-core.instructions.md**. For class design patterns, see **ruby-class-design.instructions.md**.