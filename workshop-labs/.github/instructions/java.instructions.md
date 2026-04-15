---
applyTo: "**/*.java"
---

# Java Code Instructions

## Language Features

- Use `final` for method parameters and local variables wherever the value is not reassigned
- Prefer **streams and lambdas** over traditional for-loops for collection processing
- Use **Java records** for DTOs and value objects (Java 16+):
  ```java
  public record OrderResponse(Long id, String customerName, OrderStatus status) {}
  ```
- Use `Optional<T>` as a return type instead of returning `null` — never use `Optional` as a method parameter

## Spring Boot Patterns

- Use **constructor injection** exclusively — do not use `@Autowired` on fields:
  ```java
  // ✅ Correct
  private final OrderService orderService;

  public OrderController(OrderService orderService) {
      this.orderService = orderService;
  }

  // ❌ Incorrect
  @Autowired
  private OrderService orderService;
  ```
- Add `@Valid` on all `@RequestBody` parameters to trigger Bean Validation:
  ```java
  @PostMapping
  public ResponseEntity<OrderResponse> createOrder(@Valid @RequestBody CreateOrderRequest request) { ... }
  ```
- Use `@Transactional` on service methods that modify data (create, update, delete)
- Use `@Transactional(readOnly = true)` on service methods that only read data

## Layered Architecture

Follow the **Controller → Service → Repository** pattern strictly:

- **Controller** — Handles HTTP request/response mapping. No business logic. Returns `ResponseEntity`.
- **Service** — Contains business logic, validation, and orchestration. Annotated with `@Service`.
- **Repository** — Data access only. Extends `JpaRepository` or `CrudRepository`.

Never skip the service layer. Controllers must not call repositories directly.

## Naming Conventions

- **Classes:** `PascalCase` — `OrderService`, `OrderController`, `OrderNotFoundException`
- **Methods:** `camelCase` — `findByStatus`, `createOrder`, `calculateTotal`
- **Constants:** `UPPER_SNAKE_CASE` — `MAX_ORDER_QUANTITY`, `DEFAULT_PAGE_SIZE`
- **Packages:** `lowercase` — `com.outfront.ordermanagement.service`

## Testing

- Name test methods with the pattern: `shouldDoSomething_whenCondition`
  ```java
  @Test
  void shouldReturnOrder_whenValidIdProvided() { ... }

  @Test
  void shouldThrowException_whenOrderNotFound() { ... }
  ```
- Use `@WebMvcTest` with `MockMvc` for controller tests
- Use `@ExtendWith(MockitoExtension.class)` with `@Mock` and `@InjectMocks` for service tests
- Each test should test **one behavior** — keep tests focused and readable

## Documentation

- Add Javadoc to all public classes, methods, and constructors
- Include `@param`, `@return`, and `@throws` tags:
  ```java
  /**
   * Retrieves an order by its unique identifier.
   *
   * @param orderId the ID of the order to retrieve
   * @return the order details wrapped in a ResponseEntity
   * @throws OrderNotFoundException if no order exists with the given ID
   */
  ```
