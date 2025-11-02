# Ruby Pattern Detector Skill

Automatically detect and suggest common Ruby patterns when working with Ruby code.

## When to Activate

This skill activates when:
- Reading or editing Ruby files
- User asks about Ruby patterns or best practices
- Refactoring Ruby code
- Reviewing Ruby code

## Patterns to Detect

### 1. Data Object Pattern

**Detect:**
- Classes with many attr_reader/attr_accessor declarations
- Classes that primarily hold data
- Classes with `to_h` or `to_json` methods

**Suggest:**
```ruby
class DataObject
  # Add .build class method for construction
  def self.build(attributes)
    new(
      name: attributes[:name],
      email: attributes[:email]
    )
  end
  
  # Add serialization
  def to_h
    {
      name: name,
      email: email
    }
  end
  
  # Add factory methods
  def self.from_json(json)
    build(JSON.parse(json, symbolize_names: true))
  end
  
  def self.from_h(hash)
    build(hash)
  end
end
```

### 2. Loggable Module Pattern

**Detect:**
- Classes with logging statements
- Multiple classes that need logging
- Direct Logger instantiation in classes

**Suggest:**
```ruby
# Create shared Loggable module
module Loggable
  def logger
    @logger ||= Logger.new(STDOUT).tap do |log|
      log.progname = self.class.name
      log.level = ENV.fetch('LOG_LEVEL', 'INFO')
    end
  end
end

# Include in classes
class MyClass
  include Loggable
  
  def process
    logger.info "Processing started"
    # ...
    logger.debug "Details: #{details}"
  end
end
```

### 3. Custom Exception Pattern

**Detect:**
- Raising generic exceptions (RuntimeError, StandardError)
- Classes with domain-specific errors
- Rescue blocks catching broad exceptions

**Suggest:**
```ruby
# Define custom exceptions
module MyApp
  class Error < StandardError; end
  class NotFoundError < Error; end
  class ValidationError < Error; end
  class AuthenticationError < Error; end
end

# Use specific exceptions
class UserService
  def find(id)
    user = repository.find(id)
    raise MyApp::NotFoundError, "User #{id} not found" unless user
    user
  end
  
  def authenticate(credentials)
    raise MyApp::ValidationError, "Invalid credentials" if invalid?(credentials)
    # ...
  rescue SomeExternalError => e
    raise MyApp::AuthenticationError, "Auth failed: #{e.message}"
  end
end
```

### 4. Dependency Injection Pattern

**Detect:**
- Classes instantiating other classes directly
- Hard-coded dependencies
- Difficult to test classes
- Use of global state or singletons

**Suggest:**
```ruby
# Before - hard-coded dependency
class OrderProcessor
  def process(order)
    mailer = EmailMailer.new
    mailer.send_confirmation(order)
  end
end

# After - injected dependency
class OrderProcessor
  def initialize(mailer: EmailMailer.new)
    @mailer = mailer
  end
  
  def process(order)
    @mailer.send_confirmation(order)
  end
end

# Easy to test with mock
processor = OrderProcessor.new(mailer: MockMailer.new)
```

### 5. Null Object Pattern

**Detect:**
- Frequent nil checks
- Conditional logic checking for nil
- `try` or `&.` operators used extensively

**Suggest:**
```ruby
# Create Null Object
class NullUser
  def name
    "Guest"
  end
  
  def email
    nil
  end
  
  def admin?
    false
  end
  
  def null?
    true
  end
end

# Use in code
class Session
  def current_user
    @current_user || NullUser.new
  end
end

# No more nil checks needed
session.current_user.name  # Returns "Guest" instead of raising error
```

### 6. Value Object Pattern

**Detect:**
- Primitive obsession (lots of strings/integers used as domain concepts)
- Data validation scattered throughout code
- Lack of encapsulation for related data

**Suggest:**
```ruby
# Before - primitive obsession
def send_email(email_string)
  raise "Invalid email" unless email_string =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # ...
end

# After - Value Object
class Email
  attr_reader :value
  
  def initialize(value)
    @value = value.to_s.downcase.strip
    validate!
  end
  
  def ==(other)
    value == other.value
  end
  
  def to_s
    value
  end
  
  private
  
  def validate!
    raise ArgumentError, "Invalid email: #{value}" unless valid?
  end
  
  def valid?
    value =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end
end

def send_email(email)
  # Email already validated
  mailer.send(to: email.to_s)
end
```

### 7. Query Object Pattern

**Detect:**
- Complex ActiveRecord scopes
- Long chains of where clauses
- Business logic in controllers or models

**Suggest:**
```ruby
# Extract to Query Object
class ActiveUsersQuery
  def initialize(relation = User.all)
    @relation = relation
  end
  
  def call
    @relation
      .where(active: true)
      .where('last_login_at > ?', 30.days.ago)
      .order(created_at: :desc)
  end
end

# Usage
active_users = ActiveUsersQuery.new.call
recent_active_users = ActiveUsersQuery.new(User.where('created_at > ?', 1.week.ago)).call
```

### 8. Service Object Pattern

**Detect:**
- Fat controllers or models
- Complex multi-step operations
- Methods that orchestrate multiple objects

**Suggest:**
```ruby
class CreateOrderService
  def initialize(user:, items:, payment_method:)
    @user = user
    @items = items
    @payment_method = payment_method
  end
  
  def call
    ActiveRecord::Base.transaction do
      order = create_order
      process_payment(order)
      send_confirmation(order)
      order
    end
  rescue PaymentError => e
    handle_payment_failure(e)
  end
  
  private
  
  attr_reader :user, :items, :payment_method
  
  def create_order
    # ...
  end
  
  def process_payment(order)
    # ...
  end
  
  def send_confirmation(order)
    # ...
  end
end

# Usage
result = CreateOrderService.new(
  user: current_user,
  items: cart.items,
  payment_method: params[:payment_method]
).call
```

## Activation Response

When a pattern is detected, respond with:

**Pattern Detected: [Pattern Name]**

I noticed [specific code smell or opportunity].

This is a good opportunity to use the **[Pattern Name]** pattern, which:
- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

Would you like me to refactor this code to use this pattern?

[Show brief before/after example]

## Guidelines

- Only suggest patterns when clearly beneficial
- Don't over-engineer simple code
- Explain the "why" behind each pattern suggestion
- Provide concrete code examples
- Consider the context and project size
- Balance between pattern purity and pragmatism
