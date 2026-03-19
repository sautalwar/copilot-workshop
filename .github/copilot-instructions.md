# GitHub Copilot Instructions — OutFront Media Order Management API

## Tech Stack

- **Language:** Java 17+
- **Framework:** Spring Boot 3.x
- **Build Tool:** Maven
- **Database:** H2 (development), DB2 (production) — write standard SQL compatible with both
- **Testing:** JUnit 5, MockMvc, Mockito

## Code Style & Conventions

- Follow the [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- Use **constructor injection** for all Spring beans — never use `@Autowired` on fields
- Keep methods under **30 lines** where possible; extract helper methods for clarity
- Use `Optional<T>` instead of returning `null`
- Use `final` on parameters and local variables where the value doesn't change

## REST API Standards

- All controller methods must return `ResponseEntity<T>` with the appropriate HTTP status code
- Use `@Valid` on all `@RequestBody` parameters
- Follow standard HTTP semantics:
  - `200 OK` — successful retrieval or update
  - `201 Created` — successful resource creation
  - `204 No Content` — successful deletion
  - `400 Bad Request` — validation failures
  - `404 Not Found` — resource does not exist
  - `500 Internal Server Error` — unexpected failures

## Architecture

- Follow the **Controller → Service → Repository** layered pattern
- Controllers handle HTTP concerns only (request/response mapping)
- Services contain business logic and are annotated with `@Transactional` when modifying data
- Repositories extend `JpaRepository` or `CrudRepository`
- Never call a repository directly from a controller — always go through the service layer

## Error Handling

- Use `@ControllerAdvice` with a global exception handler class
- Define custom exception classes (e.g., `OrderNotFoundException`, `InvalidOrderStatusException`)
- Return consistent error response bodies with a message and timestamp

## Logging

- Use **SLF4J** (`org.slf4j.Logger` / `org.slf4j.LoggerFactory`) for all logging
- Never use `System.out.println` or `System.err.println`
- Log at appropriate levels: `debug` for flow tracing, `info` for key operations, `warn` for recoverable issues, `error` for failures

## Documentation

- All public methods must have **Javadoc** comments
- Include `@param`, `@return`, and `@throws` tags where applicable

## Testing

- Use **JUnit 5** (`org.junit.jupiter`) for all tests
- Use **MockMvc** for controller/integration tests
- Use **Mockito** for unit-testing service classes
- Name test methods with the pattern: `shouldDoSomething_whenCondition`
- Cover happy path, edge cases, and error scenarios

## Git Commit Messages

Use conventional commit format:

```
type(scope): description
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

Examples:
- `feat(orders): add status filter endpoint`
- `fix(inventory): correct stock calculation on cancel`
- `test(orders): add edge case tests for bulk create`
