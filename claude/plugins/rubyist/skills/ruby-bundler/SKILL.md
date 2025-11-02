# Ruby Bundler Skill

Intelligent Bundler operations for managing Ruby dependencies.

## When to Activate

This skill activates when:
- User requests to install gems or dependencies
- User mentions Gemfile or bundle commands
- User asks about dependency management
- Gemfile.lock conflicts detected
- Missing gem errors occur

## Core Capabilities

### 1. Install Dependencies

**Basic Installation:**
```bash
bundle install
```

**Install for specific groups:**
```bash
# Development and test only
bundle install --without production

# Production only
bundle install --deployment
```

**Update Bundler first if needed:**
```bash
gem install bundler
bundle install
```

### 2. Add New Gems

**Interactive Gem Addition:**

When user requests: "Add [gem_name] gem"

1. **Check if gem exists:**
   - Search RubyGems.org
   - Show latest version
   - Show brief description

2. **Suggest Gemfile entry:**
```ruby
# For runtime dependency
gem 'gem_name', '~> X.Y'

# For development/test
group :development, :test do
  gem 'gem_name', '~> X.Y'
end

# For test only
group :test do
  gem 'rspec', '~> 3.12'
end
```

3. **Add to appropriate group:**
   - Runtime dependencies → main section
   - Testing tools → :test group
   - Development tools → :development group
   - Code quality → :development (rubocop, etc.)

4. **Install the gem:**
```bash
bundle install
```

5. **Verify installation:**
```bash
bundle list | grep gem_name
```

### 3. Update Dependencies

**Update all gems:**
```bash
bundle update
```

**Update specific gem:**
```bash
bundle update gem_name
```

**Update conservatively (patch versions only):**
```bash
bundle update --patch
```

**Update minor versions:**
```bash
bundle update --minor
```

### 4. Audit for Security

**Check for vulnerabilities:**
```bash
bundle audit
```

**Install bundler-audit if missing:**
```bash
gem install bundler-audit
bundle audit
```

**Update vulnerable gems:**
```bash
bundle audit check --update
```

### 5. Clean Up

**Remove unused gems:**
```bash
bundle clean
```

**Clean with forced removal:**
```bash
bundle clean --force
```

### 6. Troubleshoot Issues

**Common Issues & Solutions:**

**Issue: "Could not find gem 'X'"**
```bash
# Solution 1: Update bundler
gem install bundler
bundle install

# Solution 2: Clear cache
bundle clean --force
bundle install

# Solution 3: Update Gemfile.lock
rm Gemfile.lock
bundle install
```

**Issue: Version conflicts**
```bash
# Show dependency tree
bundle viz --without production

# Or use bundle info
bundle info gem_name
```

**Issue: Platform-specific gems**
```ruby
# In Gemfile
gem 'pg', platforms: :ruby
gem 'sqlite3', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

### 7. Gem Information

**Show gem details:**
```bash
bundle info gem_name
```

**List all gems:**
```bash
bundle list
```

**Show outdated gems:**
```bash
bundle outdated
```

## Interactive Workflows

### Workflow 1: Add New Gem

**User Request:** "Add pry-byebug for debugging"

**Response:**
```
I'll add pry-byebug to your Gemfile.

Gem: pry-byebug
Latest Version: 3.10.1
Description: Combines pry with byebug for debugging

This is a development tool, so I'll add it to the :development group.

Adding to Gemfile:
```ruby
group :development do
  gem 'pry-byebug', '~> 3.10'
end
```

Running bundle install...
✓ Successfully installed pry-byebug 3.10.1

You can now use it by adding `binding.pry` in your code.
```

### Workflow 2: Update Dependencies

**User Request:** "Update all my gems"

**Response:**
```
Before updating, let me check what's outdated:

Outdated gems:
- rspec: 3.11.0 → 3.12.0 (minor update)
- rubocop: 1.45.1 → 1.50.2 (minor update)
- nokogiri: 1.14.2 → 1.14.3 (patch update)

Recommendation:
1. Update patch versions first (safest): bundle update --patch
2. Update minor versions: bundle update --minor
3. Update all: bundle update

Would you like me to:
a) Update patch versions only (safest)
b) Update minor versions
c) Update everything
d) Update specific gems only
```

### Workflow 3: Security Audit

**User Request:** "Check for security issues"

**Response:**
```
Running security audit with bundler-audit...

Found 2 vulnerabilities:

1. HIGH: CVE-2023-XXXX in nokogiri (1.14.2)
   Solution: Update to >= 1.14.3
   
2. MEDIUM: CVE-2023-YYYY in rack (2.2.6)
   Solution: Update to >= 2.2.7

Recommended action:
bundle update nokogiri rack

Would you like me to update these gems now?
```

## Smart Suggestions

### Suggest Missing Gems

When user writes code using common patterns, suggest relevant gems:

**Pattern: API calls**
```ruby
# User writes HTTP client code
"I notice you're making HTTP requests. Consider adding:"
gem 'faraday', '~> 2.7'  # Modern HTTP client
# or
gem 'httparty', '~> 0.21'  # Simple HTTP client
```

**Pattern: JSON parsing**
```ruby
# User parses JSON
"For better JSON handling, consider:"
gem 'oj', '~> 3.14'  # Faster JSON parser
```

**Pattern: Environment variables**
```ruby
# User uses ENV[]
"For environment management, you already have dotenv in common libs!"
gem 'dotenv', '~> 2.8'
```

**Pattern: Background jobs**
```ruby
# User mentions async/background processing
"For background jobs, you commonly use:"
gem 'sidekiq', '~> 7.0'
```

## Version Constraint Guidelines

**Pessimistic versioning (~>):**
```ruby
gem 'rails', '~> 7.0.4'  # >= 7.0.4, < 7.1
gem 'rspec', '~> 3.12'   # >= 3.12, < 4.0
```

**Exact version (avoid unless necessary):**
```ruby
gem 'specific_gem', '1.2.3'  # Only 1.2.3
```

**Greater than or equal:**
```ruby
gem 'compatible_gem', '>= 2.0'  # Any version >= 2.0
```

**Best Practice:** Use pessimistic (~>) for stability

## Gemfile Organization

**Recommended Structure:**
```ruby
source 'https://rubygems.org'

ruby '3.2.0'  # Specify Ruby version

# Core runtime dependencies
gem 'dotenv'
gem 'pg', '~> 1.6'

# Development tools
group :development do
  gem 'pry'
  gem 'rubocop', require: false
end

# Test tools
group :test do
  gem 'rspec', '~> 3.12'
  gem 'factory_bot', '~> 6.5'
  gem 'timecop'
end

# Development & Test
group :development, :test do
  gem 'pry-byebug'
end

# Platform-specific
platforms :ruby do
  gem 'sqlite3', '~> 2.1'
end
```

## Response Format

When performing bundle operations:

**Action Taken:**
- Command executed
- Result summary

**Changes:**
- New gems added
- Gems updated (old → new version)
- Gems removed

**Next Steps:**
- Suggested actions
- Related configuration needed
- Documentation references

## Configuration

Users can customize behavior in `.claude/settings.json`:

```json
{
  "plugins": {
    "rubyist": {
      "bundler": {
        "autoInstall": true,
        "suggestGems": true,
        "securityAudit": true,
        "versionStrategy": "pessimistic"
      }
    }
  }
}
```

## Error Handling

Always wrap bundle commands with error handling:

```bash
if bundle install; then
  echo "✓ Successfully installed dependencies"
else
  echo "✗ Installation failed"
  echo "Trying with bundle update..."
  bundle update
fi
```

## Best Practices

1. **Always review Gemfile changes** before committing
2. **Commit Gemfile.lock** to ensure consistent environments
3. **Use bundle audit regularly** for security
4. **Keep gems updated** but test thoroughly
5. **Group gems appropriately** (development, test, production)
6. **Use pessimistic versioning** for stability
7. **Document why** specific versions are pinned
