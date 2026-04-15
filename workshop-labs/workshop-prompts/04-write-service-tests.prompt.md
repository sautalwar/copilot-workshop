---
mode: 'agent'
description: 'Generate comprehensive JUnit 5 tests for OrderService'
---

# Write Comprehensive OrderService Tests

## 📍 Workshop Section
Slide 11: Agent Mode | Part 3 — Test Generation

## What This Does
Generates a complete suite of unit tests for `OrderService.java` using Mockito to mock dependencies. This demonstrates Copilot's ability to understand existing code and generate thorough test coverage.

## Instructions
**For the AI Agent:**

Write comprehensive JUnit 5 unit tests for the `OrderService` class in the OutFront Media Order Management API.

### Test Requirements:

**Test Class Setup:**
- Use `@ExtendWith(MockitoExtension.class)`
- Mock `OrderRepository` with `@Mock`
- Inject mocks into `OrderService` with `@InjectMocks`
- Follow the naming pattern: `shouldDoSomething_whenCondition`

**Tests to Write:**

1. **`findAll()` method:**
   - `shouldReturnAllOrders_whenOrdersExist()`
   - `shouldReturnEmptyList_whenNoOrdersExist()`

2. **`findById()` method:**
   - `shouldReturnOrder_whenValidIdProvided()`
   - `shouldReturnEmpty_whenOrderDoesNotExist()`

3. **`createOrder()` method:**
   - `shouldCreateOrder_whenRequestIsValid()`
   - `shouldSaveOrderWithPendingStatus_whenCreated()`

4. **`findByStatus()` method:**
   - `shouldReturnMatchingOrders_whenStatusProvided()`
   - `shouldReturnEmptyList_whenNoOrdersMatchStatus()`

5. **`updateOrderStatus()` method:**
   - `shouldUpdateStatus_whenOrderExists()`
   - `shouldThrowException_whenOrderNotFound()`
   - **Important:** This method also validates inventory — if `InventoryService` exists, mock it and test:
     - `shouldConfirmOrder_whenSufficientInventoryExists()`
     - `shouldThrowException_whenInsufficientInventory()`

### Test Data:
Use realistic OutFront Media domain data:
- Customer: "Clear Channel NYC", "JCDecaux Transit", "Lamar Advertising"
- Products: "Digital Screen Unit 96x48", "LED Panel 72x36", "Transit Display Module"
- Statuses: `PENDING`, `CONFIRMED`, `SHIPPED`

### Verification:
- Use `verify()` to ensure repository methods are called with correct arguments
- Use `ArgumentCaptor` to verify complex object arguments when needed
- Assert all relevant fields on returned objects

### Code Quality:
- Follow the **Given / When / Then** pattern (Arrange / Act / Assert)
- Add comments separating each section: `// given`, `// when`, `// then`
- Keep each test focused on one behavior

## Expected Outcome
After running this prompt, you should have:
- ✅ New test file: `src/test/java/com/outfront/workshop/service/OrderServiceTest.java`
- ✅ At least 8-10 comprehensive unit tests covering all public methods
- ✅ All tests use Mockito for mocking dependencies
- ✅ All tests pass: `mvn test -Dtest=OrderServiceTest`
- ✅ Test coverage for both happy paths and error scenarios

## Try It
**For Workshop Attendees:**
1. Open Copilot Chat in Agent mode
2. Paste this prompt
3. Review the generated test file
4. Run the tests:
   ```bash
   mvn test -Dtest=OrderServiceTest
   ```
5. Check the test output for any failures
6. Review the test code to understand the mocking patterns
7. **Challenge:** Ask Copilot to add one more test for an edge case you think of

**Bonus Exercise:**
After the tests are generated, ask Copilot:
- "Add a test for concurrent updates to the same order"
- "Add parameterized tests for all valid order status transitions"
