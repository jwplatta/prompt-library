---
applyTo: **/*.rb
description: Documentation patterns and commenting conventions for Ruby
---

# Ruby Documentation Patterns

## Method Documentation

### Class and Method Documentation
```ruby
# Helper class to create arbitrarily complex orders. Note this class simply
# implements the order schema defined in the documentation, with no attempts 
# to validate the result. Orders created using this class may be rejected or 
# may never fill. Use at your own risk.
class OrderBuilder
  # ...
end
```

## Inline Comments

### Inline Comment Patterns
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

For basic documentation practices, see **ruby-core.instructions.md**.