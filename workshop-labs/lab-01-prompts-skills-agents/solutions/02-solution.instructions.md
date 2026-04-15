---
applyTo: "**/*Test.java"
---

# Test File Instructions

## Test Structure

- Use the **Given / When / Then** pattern (also called Arrange / Act / Assert)
- Each test should verify **one behavior** — don't combine multiple assertions for different behaviors

## Naming

- Name test methods: `shouldDoSomething_whenCondition`
- Examples:
  - `shouldReturnOrder_whenValidIdProvided`
  - `shouldReturnNotFound_whenOrderDoesNotExist`
  - `shouldReturnBadRequest_whenCustomerNameIsBlank`

## Controller Tests

- Use `@SpringBootTest` with `@AutoConfigureMockMvc` for full integration tests
- Use `MockMvc` for HTTP request/response assertions
- Verify both the **status code** and the **response body**:
  ```java
  mockMvc.perform(get("/api/orders/1"))
      .andExpect(status().isOk())
      .andExpect(jsonPath("$.customerName").value("OutFront Media"));
  ```

## Service Tests

- Use `@ExtendWith(MockitoExtension.class)` for unit tests
- Use `@Mock` for dependencies and `@InjectMocks` for the service under test
- Use `verify()` to confirm repository methods are called with correct arguments

## Coverage Requirements

For every endpoint, always test:
1. ✅ **Happy path** — the request succeeds with valid input
2. ❌ **Not found** — the resource doesn't exist (expect 404)
3. 🚫 **Validation failure** — invalid input is rejected (expect 400)

## Assertions

- Use `jsonPath` for JSON response body assertions
- Check `Location` header on 201 Created responses
- Check error response structure (message field) on failures
