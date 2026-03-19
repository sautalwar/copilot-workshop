---
mode: 'agent'
description: 'Add a new REST endpoint to the Spring Boot application'
---

# Add a New REST Endpoint

You are adding a new REST endpoint to the OutFront Media Order Management API. Follow the full stack from model to test.

## Steps

### 1. Model / Entity

- Check if an existing entity can be reused or needs modification
- If a new entity is needed, create it in the `model` package with JPA annotations
- Use Java records for request/response DTOs
- Add Bean Validation annotations (`@NotNull`, `@NotBlank`, `@Size`, etc.) on request DTOs

### 2. Repository

- Add a new method to the relevant `JpaRepository` interface
- Use Spring Data derived query methods when possible (e.g., `findByStatus`)
- For complex queries, use `@Query` with standard SQL (compatible with H2 and DB2)

### 3. Service

- Add the business logic in the service class (annotated with `@Service`)
- Use `@Transactional` for methods that modify data
- Use `@Transactional(readOnly = true)` for read-only methods
- Throw custom exceptions (e.g., `OrderNotFoundException`) for error cases
- Return `Optional<T>` where a result might not exist
- Use constructor injection for dependencies

### 4. Controller

- Add the endpoint method in the appropriate `@RestController`
- Use the correct HTTP method: `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`
- Return `ResponseEntity<T>` with the proper status code:
  - `200 OK` for successful reads/updates
  - `201 Created` for successful creation (include `Location` header)
  - `204 No Content` for successful deletion
  - `404 Not Found` when a resource doesn't exist
- Add `@Valid` on `@RequestBody` parameters
- Add Javadoc describing the endpoint's purpose

### 5. Tests

- **Controller test** using `@WebMvcTest` and `MockMvc`:
  - Test the happy path
  - Test validation errors (400)
  - Test not-found scenarios (404)
- **Service test** using `@ExtendWith(MockitoExtension.class)`:
  - Test business logic
  - Test exception handling
- Name tests with the pattern: `shouldDoSomething_whenCondition`

### 6. Seed Data

- If the new endpoint needs sample data, update `src/main/resources/data.sql`
- Use realistic OutFront Media domain data (orders, campaigns, locations)

## Checklist

Before finishing, verify:
- [ ] Code compiles: `mvn compile`
- [ ] All tests pass: `mvn test`
- [ ] New endpoint follows the Controller → Service → Repository pattern
- [ ] Javadoc is present on all public methods
- [ ] No `System.out.println` — use SLF4J logging
- [ ] Constructor injection is used (no `@Autowired` on fields)
