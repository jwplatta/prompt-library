---
applyTo: **/*.rb
description: Configuration patterns and environment management for Ruby applications
---

# Ruby Configuration Patterns

## Environment-Based Configuration

### Environment Variable Configuration
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

## Configuration Objects

### Configuration Class Pattern
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

For basic configuration patterns, see **ruby-core.instructions.md**. For logging configuration, see **ruby-logging.instructions.md**.