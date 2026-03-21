---
mode: agent
description: "Create a new REST API endpoint with validation, error handling, and tests"
tools:
  - filesystem
  - terminal
---

# Create API Endpoint

Create a new REST API endpoint following our project conventions:

## Requirements
1. **Router file** in `src/api/routes/` with Express router
2. **Zod schema** for request validation (body, params, query)
3. **Controller function** with proper error handling (try/catch, structured errors)
4. **Service layer** function in `src/api/services/` for business logic
5. **Unit tests** in `src/api/__tests__/` using Vitest

## Conventions
- Use `async/await` for all async operations
- Return consistent response shape: `{ success: boolean, data?: T, error?: string }`
- HTTP status codes: 200 (success), 201 (created), 400 (validation), 401 (auth), 500 (server)
- Add JSDoc comments to the controller function
- Register the route in `src/api/index.ts`

## Example Response Shape
```typescript
// Success
{ success: true, data: { id: "123", name: "Example" } }

// Error
{ success: false, error: "Validation failed: name is required" }
```
