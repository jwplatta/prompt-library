# Test Analyzer Scripts

Executable shell scripts for running and analyzing RSpec tests.

## Scripts

### run_tests.sh
Run RSpec tests with intelligent filtering.

```bash
# Run all tests
./run_tests.sh all

# Run only fast tests (exclude slow)
./run_tests.sh fast

# Run only previously failed tests
./run_tests.sh failures

# Run tests for changed files
./run_tests.sh changed

# Profile slowest tests
./run_tests.sh profile

# Run specific file
./run_tests.sh spec/models/user_spec.rb
```

**Modes:**
- `all` - All tests with documentation format
- `fast` - Exclude tests tagged with :slow
- `failures` - Only re-run failed tests (uses .rspec_status)
- `changed` - Auto-detect changed files via git diff
- `profile` - Show 10 slowest examples
- `<file_path>` - Run specific test file

**Features:**
- Auto-detects RSpec availability
- Helpful error messages
- Smart test file detection from lib/ files
- Documentation format for readability

### analyze_failures.sh
Analyze test failures and provide debugging hints.

```bash
./analyze_failures.sh
```

**Output:**
```
Results: 3 failures out of 47 tests

Failed examples:

User#full_name returns first and last name
  File: spec/user_spec.rb:23
  Error: RSpec::Expectations::ExpectationNotMetError
  Message: Expected "John Doe" but got "John"

...

Common fixes:
  - Check for typos in method names
  - Verify test data setup (factories, fixtures)
  - Check for nil objects
  - Review recent code changes
```

**Features:**
- Parses JSON test results
- Groups failures by type
- Provides file:line references
- Suggests common fixes
- Shows debugging commands

**Requires:**
- jq (JSON processor)
- RSpec with JSON formatter

## Usage Examples

### Quick Test Run
```bash
# Run changed tests
./run_tests.sh changed

# If failures, analyze
./analyze_failures.sh
```

### TDD Workflow
```bash
# Run all tests
./run_tests.sh all

# Profile to find slow tests
./run_tests.sh profile

# Tag slow tests, then run fast
./run_tests.sh fast
```

### CI/CD
```bash
# In CI pipeline
./run_tests.sh all || ./analyze_failures.sh
```

## RSpec Configuration

For best results, add to `.rspec`:
```
--format progress
--require spec_helper
--example-status-persistence-file-path .rspec_status
```

And in `spec/spec_helper.rb`:
```ruby
RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
end
```

## Requirements

- RSpec gem
- jq (for analyze_failures.sh)
- git (for changed mode)
