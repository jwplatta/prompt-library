# Suggest Tests Hook

This hook triggers after writing a new Ruby file and suggests relevant tests.

## Trigger

- Event: post-write
- Pattern: **/*.rb (excluding *_spec.rb files)

## Action

When a new Ruby file is created or significantly modified, analyze the file and suggest appropriate tests.

## Analysis Process

1. **Read the File**
   - Determine the class/module name
   - Identify public methods
   - Note any dependencies or collaborators
   - Identify edge cases from code structure

2. **Check for Existing Tests**
   - Look for corresponding spec file (e.g., `lib/user.rb` → `spec/user_spec.rb`)
   - If exists, check coverage of new methods
   - If missing, offer to create spec file

3. **Generate Test Suggestions**

Based on the code structure, suggest tests for:

### Public Methods
- Happy path (normal operation)
- Edge cases (boundary conditions)
- Error cases (invalid inputs)
- Null cases (nil/empty values)

### Class Responsibilities
- Single Responsibility compliance
- Interface clarity
- Dependency injection points

### Common Patterns
- Data object serialization (to_h, to_json)
- Factory methods (build, from_json, from_h)
- Validation logic
- Error handling
- State management

## Response Format

**New File Detected: [file_path]**

I noticed you created/modified a Ruby file with:
- Class: [ClassName]
- Public methods: [method1, method2, method3]
- Dependencies: [list]

**Test File Status:**
- [ ] Spec file exists at: [spec_path]
- [ ] No spec file found

**Suggested Tests:**

```ruby
# spec/path/to/class_spec.rb
require 'spec_helper'

RSpec.describe ClassName do
  describe '.build' do
    it 'creates instance from hash attributes' do
      # Test factory method
    end
    
    context 'with missing attributes' do
      it 'handles gracefully' do
        # Test edge case
      end
    end
  end
  
  describe '#public_method' do
    let(:instance) { described_class.new(dependencies) }
    
    it 'performs expected behavior' do
      # Happy path test
    end
    
    context 'when error condition occurs' do
      it 'raises appropriate exception' do
        # Error handling test
      end
    end
  end
  
  describe '#to_h' do
    it 'serializes to hash with expected keys' do
      # Serialization test
    end
  end
end
```

**Additional Considerations:**
- [ ] Test dependency injection
- [ ] Test error handling for [specific method]
- [ ] Test edge case: [description]
- [ ] Add integration test for [interaction]

Would you like me to:
1. Create the spec file with these tests?
2. Add tests for specific methods?
3. Skip test suggestions for this file?

## Configuration

Users can disable this hook in `.claude/settings.json`:
```json
{
  "hooks": {
    "ruby-post-write": {
      "enabled": false
    }
  }
}
```

Or configure per-project patterns to exclude:
```json
{
  "hooks": {
    "ruby-post-write": {
      "excludePattern": ["lib/generated/**", "lib/legacy/**"]
    }
  }
}
```
