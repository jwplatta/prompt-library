---
applyTo: **/*.rb
description: Logging patterns and best practices for Ruby applications
---

# Ruby Logging Patterns

## Shared Logger Module

### Basic Loggable Module
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

  def log_fatal(message)
    logger.fatal(message)
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

### Extended Loggable with Context
```ruby
module Loggable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def logger
      @logger ||= create_logger
    end

    private

    def create_logger
      logger = Logger.new(log_output)
      logger.level = log_level
      logger.formatter = log_formatter
      logger
    end

    def log_output
      ENV['LOG_FILE'] || $stdout
    end

    def log_level
      ENV.fetch('LOG_LEVEL', 'INFO').upcase.to_sym
    end

    def log_formatter
      proc do |severity, datetime, progname, msg|
        "[#{datetime}] #{severity} #{self.name}: #{msg}\n"
      end
    end
  end

  def logger
    self.class.logger
  end

  def log_with_context(level, message, **context)
    context_str = context.any? ? " | #{context.map { |k, v| "#{k}=#{v}" }.join(' ')}" : ""
    logger.public_send(level.downcase, "#{message}#{context_str}")
  end

  def log_debug(message, **context)
    log_with_context(:debug, message, **context)
  end

  def log_info(message, **context)
    log_with_context(:info, message, **context)
  end

  def log_warn(message, **context)
    log_with_context(:warn, message, **context)
  end

  def log_error(message, **context)
    log_with_context(:error, message, **context)
  end
end
```

## Domain-Specific Logging

### Trading Domain Logging
```ruby
module TradingLoggable
  include Loggable

  def log_trade_state(trade_id, state, details = nil)
    msg = "<#{state} | #{Time.now.utc} | #{trade_id}"
    msg += " | #{details}" if details
    msg += ">"

    case state
    when 'TRADE_OPEN'
      logger.info(msg)
    when 'TRADE_FOUND'
      logger.info(msg)
      logger.debug("Strategy: #{details}") if details
    when /ERROR|FAILED/
      logger.error(msg)
    else
      logger.info(msg)
    end
  end

  def log_order(order)
    logger.info("<ORDER | #{Time.now.utc} | #{order.id} | #{order.status}>")
  end

  def log_position_change(symbol, old_qty, new_qty, reason)
    logger.info("POSITION_CHANGE | #{symbol} | #{old_qty} -> #{new_qty} | #{reason}")
  end

  def log_api_call(method, endpoint, duration = nil)
    duration_str = duration ? " (#{duration.round(3)}s)" : ""
    logger.debug("API_CALL | #{method.upcase} #{endpoint}#{duration_str}")
  end
end
```

### Request/Response Logging
```ruby
module RequestLoggable
  include Loggable

  def log_request(method, url, params = nil)
    sanitized_params = sanitize_params(params) if params
    log_info("REQUEST", method: method, url: sanitize_url(url), params: sanitized_params)
  end

  def log_response(status, body_size, duration)
    log_info("RESPONSE", status: status, size: "#{body_size}B", duration: "#{duration.round(3)}s")
  end

  def log_api_error(error, endpoint)
    log_error("API_ERROR", error: error.class.name, message: error.message, endpoint: endpoint)
  end

  private

  def sanitize_url(url)
    # Remove sensitive data from URLs
    url.gsub(/\/accounts\/\d+/, '/accounts/[REDACTED]')
       .gsub(/accountId=\d+/, 'accountId=[REDACTED]')
  end

  def sanitize_params(params)
    sensitive_keys = %w[accountNumber accountId password token]
    params.transform_values do |value|
      sensitive_keys.any? { |key| params.key?(key) } ? '[REDACTED]' : value
    end
  end
end
```

## Performance Logging

### Method Performance Tracking
```ruby
module PerformanceLoggable
  include Loggable

  def log_performance(method_name)
    start_time = Time.now
    result = yield
    duration = Time.now - start_time
    
    log_debug("PERFORMANCE", method: method_name, duration: "#{duration.round(4)}s")
    result
  rescue => e
    duration = Time.now - start_time
    log_error("PERFORMANCE_ERROR", method: method_name, duration: "#{duration.round(4)}s", error: e.message)
    raise
  end

  def with_performance_logging(method_name, &block)
    log_performance(method_name, &block)
  end
end

# Usage
class DataProcessor
  include PerformanceLoggable

  def process_data
    log_performance(__method__) do
      # expensive operation
      heavy_calculation
    end
  end
end
```

### Memory Usage Logging
```ruby
module MemoryLoggable
  include Loggable

  def log_memory_usage(label = nil)
    return unless logger.debug?
    
    require 'objspace'
    
    gc_stat = GC.stat
    object_count = ObjectSpace.count_objects
    
    log_debug("MEMORY_USAGE", 
      label: label,
      heap_used: gc_stat[:heap_used],
      heap_length: gc_stat[:heap_length], 
      total_objects: object_count[:total]
    )
  end

  def with_memory_logging(label, &block)
    log_memory_usage("#{label}_start")
    result = block.call
    log_memory_usage("#{label}_end")
    result
  end
end
```

## Structured Logging

### JSON Logging
```ruby
require 'json'

module JSONLoggable
  include Loggable

  def log_structured(level, event, **data)
    log_entry = {
      timestamp: Time.now.utc.iso8601,
      level: level.to_s.upcase,
      event: event,
      component: self.class.name,
      **data
    }
    
    logger.public_send(level, log_entry.to_json)
  end

  def log_event(event, **data)
    log_structured(:info, event, **data)
  end

  def log_error_event(event, error, **data)
    log_structured(:error, event, 
      error_class: error.class.name,
      error_message: error.message,
      backtrace: error.backtrace&.first(5),
      **data
    )
  end
end

# Usage
class OrderProcessor
  include JSONLoggable

  def process_order(order)
    log_event('order_processing_started', order_id: order.id, symbol: order.symbol)
    
    # process order
    
    log_event('order_processing_completed', order_id: order.id, status: 'filled')
  rescue => e
    log_error_event('order_processing_failed', e, order_id: order.id)
    raise
  end
end
```

## Logger Configuration

### Centralized Logger Factory
```ruby
class LoggerFactory
  class << self
    def create_logger(name, **options)
      logger = Logger.new(output_for(name, options))
      logger.level = level_for(options)
      logger.formatter = formatter_for(options)
      logger
    end

    private

    def output_for(name, options)
      if options[:file]
        options[:file]
      elsif ENV["#{name.upcase}_LOG_FILE"]
        ENV["#{name.upcase}_LOG_FILE"]
      else
        $stdout
      end
    end

    def level_for(options)
      level_name = options[:level] || ENV['LOG_LEVEL'] || 'INFO'
      Logger.const_get(level_name.upcase)
    end

    def formatter_for(options)
      case options[:format]&.to_sym
      when :json
        json_formatter
      when :simple
        simple_formatter
      else
        default_formatter
      end
    end

    def json_formatter
      proc do |severity, datetime, progname, msg|
        {
          timestamp: datetime.iso8601,
          level: severity,
          program: progname,
          message: msg
        }.to_json + "\n"
      end
    end

    def simple_formatter
      proc { |severity, datetime, progname, msg| "#{severity}: #{msg}\n" }
    end

    def default_formatter
      proc do |severity, datetime, progname, msg|
        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} -- #{progname}: #{msg}\n"
      end
    end
  end
end
```

### Application Logger Setup
```ruby
module MyApp
  class Logger
    class << self
      def instance
        @instance ||= create_logger
      end

      def debug(message)
        instance.debug(message)
      end

      def info(message)
        instance.info(message)
      end

      def warn(message)
        instance.warn(message)
      end

      def error(message)
        instance.error(message)
      end

      private

      def create_logger
        LoggerFactory.create_logger('myapp',
          level: ENV.fetch('LOG_LEVEL', 'INFO'),
          format: ENV.fetch('LOG_FORMAT', 'default').to_sym,
          file: log_file_path
        )
      end

      def log_file_path
        return nil unless ENV['LOG_TO_FILE']
        
        if ENV['LOGFILE'] && !ENV['LOGFILE'].empty?
          ENV['LOGFILE']
        else
          File.join(Dir.tmpdir, 'myapp.log')
        end
      end
    end
  end
end
```

## Testing Logging

### Log Capture for Tests
```ruby
require 'stringio'

module LogCapture
  def with_captured_logs
    original_logger = described_class.logger
    log_output = StringIO.new
    test_logger = Logger.new(log_output)
    
    described_class.instance_variable_set(:@logger, test_logger)
    
    yield log_output
  ensure
    described_class.instance_variable_set(:@logger, original_logger)
  end
end

# Usage in RSpec
RSpec.describe OrderProcessor do
  include LogCapture

  it 'logs order processing events' do
    with_captured_logs do |log_output|
      processor.process_order(order)
      
      log_content = log_output.string
      expect(log_content).to include('order_processing_started')
      expect(log_content).to include('order_processing_completed')
    end
  end
end
```

For basic logging patterns, see **ruby-core.instructions.md**. For error-specific logging, see **ruby-error-handling.instructions.md**.