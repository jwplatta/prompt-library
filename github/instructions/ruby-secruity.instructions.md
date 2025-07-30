---
applyTo: **/*.rb
description: Security patterns and data redaction for Ruby applications
---

# Ruby Security Patterns

## Data Redaction

### Basic Data Redaction
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

For basic security practices, see **ruby-core.instructions.md**. For secure logging, see **ruby-logging.instructions.md**.