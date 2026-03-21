---
mode: agent
description: "Generate comprehensive unit tests for the selected code"
tools:
  - filesystem
---

# Generate Unit Tests

Write thorough unit tests for the currently selected code or file.

## Test Structure
- Use **Vitest** as the test framework
- Group related tests with `describe()` blocks
- Use descriptive test names: `it('should return 400 when email is missing')`

## Coverage Requirements
1. **Happy path** — normal expected inputs produce correct outputs
2. **Edge cases** — empty strings, null values, boundary numbers
3. **Error cases** — invalid inputs throw appropriate errors
4. **Async behavior** — promises resolve/reject correctly

## Patterns
```typescript
import { describe, it, expect, vi } from 'vitest';

describe('functionName', () => {
  it('should handle normal input correctly', () => {
    const result = functionName(validInput);
    expect(result).toEqual(expectedOutput);
  });

  it('should throw when input is invalid', () => {
    expect(() => functionName(null)).toThrow('Input required');
  });
});
```

## Rules
- Mock external dependencies (databases, APIs) with `vi.mock()`
- Don't test implementation details — test behavior
- Each test should be independent (no shared mutable state)
