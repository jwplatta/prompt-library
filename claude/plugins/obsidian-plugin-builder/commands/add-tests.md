You are helping the user add Jest tests to their Obsidian plugin.

1. Set up Jest if not already configured:
   - Add jest, ts-jest, @types/jest to devDependencies
   - Create jest.config.js with TypeScript support
   - Add test script to package.json
   - Create __tests__ directory

2. Ask the user what to test:
   - Utility functions (pure logic)
   - Settings management
   - Data processing
   - Modal logic
   - Command handlers (if testable)

3. Create test files:
   - Name files *.test.ts or *.spec.ts
   - Import functions/classes to test
   - Mock Obsidian API where needed
   - Write describe/it blocks

4. Write basic tests covering:
   - Happy path scenarios
   - Edge cases
   - Error handling
   - State management

Example test structure:
```typescript
import { describe, it, expect } from '@jest/globals';

describe('MyUtility', () => {
  it('should process data correctly', () => {
    const result = myFunction(input);
    expect(result).toBe(expected);
  });
});
```

Keep tests simple and focused. Don't aim for comprehensive coverage, just basic validation.
