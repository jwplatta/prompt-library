# Ruby Test Analyzer Skill

Intelligently analyze RSpec test failures and provide actionable debugging guidance.

## When to Activate

This skill activates when:
- RSpec tests fail
- User runs test commands
- User asks about test failures or debugging
- Working with test files

## Core Capabilities

### 1. Failure Pattern Recognition

Automatically identify common failure patterns:

**NoMethodError Patterns:**
- Nil object errors → Check object initialization
- Missing method → Check for typos or missing implementation
- Wrong receiver → Check factory setup or test doubles

**Expectation Failures:**
- Off-by-one errors → Check loop boundaries
- Wrong values → Check business logic implementation
- Type mismatches → Check data transformation

**Database/State Issues:**
- Transactional rollback problems
- Factory/fixture conflicts
- Test interdependencies

### 2. Provide Debugging Steps

For each failure, suggest:

1. **Immediate Checks:**
   - Verify object is not nil
   - Check method spelling
   - Confirm proper setup in before blocks

2. **Investigation Steps:**
   - Add `puts` or `binding.pry` at strategic points
   - Check factory definitions
   - Verify database state

3. **Likely Fixes:**
   - Code examples showing the fix
   - References to related files
   - Design improvements to prevent recurrence

### 3. Test Quality Analysis

Evaluate test quality:

**Good Signs:**
- Clear describe/context structure
- Single responsibility per test
- Proper use of let/let!/before
- Descriptive test names
- Good isolation

**Warning Signs:**
- Tests with multiple expectations
- Tests depending on execution order
- Overuse of let! (eager evaluation)
- Brittle tests (too coupled to implementation)
- Missing edge cases

### 4. Suggest Missing Tests

Identify untested scenarios:
- Edge cases
- Error conditions
- Boundary values
- Integration points
- State transitions

## Example Analysis

**Failure Detected:**
```
Failure/Error: expect(user.full_name).to eq("John Doe")
  expected: "John Doe"
       got: "John"
```

**Analysis Response:**

**Failure: User#full_name incomplete**
- **Location:** spec/user_spec.rb:23
- **Error Type:** Expectation mismatch

**Immediate Cause:**
The `full_name` method is only returning the first name.

**Investigation Steps:**
1. Check the implementation at lib/user.rb:15
   ```ruby
   # Current implementation (likely):
   def full_name
     first_name
   end
   ```

2. Verify test data:
   ```ruby
   # Check that your factory/test setup has both names
   user = User.new(first_name: "John", last_name: "Doe")
   ```

**Suggested Fix:**
```ruby
# lib/user.rb:15
def full_name
  [first_name, last_name].compact.join(' ')
end
```

**Additional Considerations:**
- Handle nil values gracefully (using `compact`)
- Consider edge cases: missing last name, middle names
- Add test for user with only first name

**Suggested Additional Tests:**
```ruby
context 'when last_name is missing' do
  it 'returns only first_name' do
    user = User.new(first_name: "John", last_name: nil)
    expect(user.full_name).to eq("John")
  end
end
```

## Performance Analysis

When tests are slow:

**Identify Bottlenecks:**
1. Run with profiling: `bundle exec rspec --profile`
2. Find slowest examples
3. Categorize delays:
   - Database operations
   - External service calls
   - Complex computations
   - Factory creation

**Optimization Suggestions:**

**Database-Heavy Tests:**
- Use `build_stubbed` instead of `create`
- Use `let` instead of `let!` where possible
- Consider using transactions or database_cleaner strategies

**External Services:**
- Stub external API calls
- Use VCR for HTTP interactions
- Mock time-consuming operations

**Factory Optimization:**
- Minimize associated records
- Use traits for specific scenarios
- Consider using `build` instead of `create`

## Interactive Debugging

Offer to:
1. Add debugging output to specific lines
2. Insert `binding.pry` at failure point
3. Show related code context
4. Run specific tests in isolation
5. Check factory definitions
6. Verify test data setup

## Test Coverage Suggestions

Suggest tests for:
- **Happy path**: Normal expected usage
- **Edge cases**: Boundary conditions
- **Error cases**: Invalid inputs
- **Null cases**: Nil/empty values
- **Integration**: Cross-object interactions

## Guidelines

- Focus on actionable next steps
- Provide specific line numbers and file paths
- Show concrete code examples
- Explain the "why" behind failures
- Suggest preventive measures
- Balance speed of fix with quality of solution
