---
mode: 'agent'
description: 'Write comprehensive JUnit 5 tests for existing code'
---

# Write Comprehensive Tests

You are writing tests for the OutFront Media Order Management API. Generate thorough, well-structured JUnit 5 tests.

## Analyze First

Before writing tests:
1. Read the source code to understand the behavior being tested
2. Identify all code paths — happy path, edge cases, and error conditions
3. Check what HTTP status codes each endpoint can return
4. Look at validation annotations to know what invalid input looks like

## Controller Tests (Integration)

Use `@WebMvcTest` with `MockMvc`:

```java
@WebMvcTest(OrderController.class)
class OrderControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private OrderService orderService;

    @Test
    void shouldReturnOrder_whenValidIdProvided() throws Exception {
        // given — set up mock
        // when — perform request
        // then — assert response status and body
    }
}
```

### What to test for each endpoint:
- **GET** — 200 with valid data, 404 when not found, query parameter filtering
- **POST** — 201 with valid request, 400 with invalid/missing fields
- **PUT** — 200 with valid update, 404 when resource doesn't exist, 400 with invalid data
- **DELETE** — 204 on success, 404 when resource doesn't exist

### Response validation:
- Assert HTTP status code
- Assert response body fields using `jsonPath`
- Assert headers (e.g., `Location` header on 201)
- Assert error response structure on failures

## Service Tests (Unit)

Use `@ExtendWith(MockitoExtension.class)`:

```java
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private OrderRepository orderRepository;

    @InjectMocks
    private OrderService orderService;

    @Test
    void shouldReturnOrder_whenOrderExists() {
        // given — configure mock repository
        // when — call service method
        // then — verify result and interactions
    }
}
```

### What to test:
- Business logic produces correct results
- Custom exceptions are thrown for invalid states
- Repository methods are called with correct arguments (use `verify`)
- Edge cases: empty lists, boundary values, null handling

## Test Naming

Use the pattern: `shouldDoSomething_whenCondition`

Examples:
- `shouldReturnAllOrders_whenOrdersExist`
- `shouldReturnEmptyList_whenNoOrdersExist`
- `shouldThrowOrderNotFoundException_whenInvalidId`
- `shouldCreateOrder_whenRequestIsValid`
- `shouldReturnBadRequest_whenCustomerNameIsBlank`

## Test Structure

Follow the **Given / When / Then** pattern (Arrange / Act / Assert):
- **Given** — set up test data and mock behavior
- **When** — execute the method under test
- **Then** — assert expected outcomes

## Checklist

Before finishing, verify:
- [ ] Every public endpoint has at least one test per status code it can return
- [ ] Happy path and error paths are both covered
- [ ] Tests are independent — no shared mutable state between tests
- [ ] All tests pass: `mvn test`
- [ ] Test method names clearly describe what is being tested
