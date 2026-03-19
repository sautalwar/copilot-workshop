# Copilot Coding Agent Instructions — OutFront Media Order Management API

## Project Overview

This is a **Java Spring Boot 3.x** REST API for managing orders at OutFront Media. It follows a layered architecture with Controller → Service → Repository separation.

## Build & Run

```bash
# Build the project (compile + run tests)
mvn clean install

# Run tests only
mvn test

# Start the application locally
mvn spring-boot:run
```

The application starts on `http://localhost:8080` by default. H2 console is available at `/h2-console` in dev mode.

## Architecture

```
Controller (HTTP layer)
    ↓
Service (business logic)
    ↓
Repository (data access via Spring Data JPA)
```

- **Controllers** handle request/response mapping only — no business logic
- **Services** contain business logic, annotated with `@Service` and `@Transactional`
- **Repositories** extend `JpaRepository` for data access

## Key Conventions

| Convention | Rule |
|---|---|
| Java version | 17+ |
| Style guide | Google Java Style Guide |
| Dependency injection | Constructor injection only (no `@Autowired` on fields) |
| Controller returns | `ResponseEntity<T>` with proper HTTP status codes |
| Null handling | Use `Optional<T>` — never return null |
| Logging | SLF4J (`LoggerFactory.getLogger`) — no `System.out.println` |
| DTOs | Use Java records |
| Validation | `@Valid` on all `@RequestBody` parameters |
| Documentation | Javadoc on all public methods |
| Test naming | `shouldDoSomething_whenCondition` |
| Commit format | `type(scope): description` |

## Testing Requirements

- **Every feature must have tests** — no exceptions
- Use `@WebMvcTest` + `MockMvc` for controller tests
- Use `@ExtendWith(MockitoExtension.class)` + Mockito for service tests
- Cover: happy path, edge cases, error scenarios, and each HTTP status code

Run the full test suite before committing:

```bash
mvn test
```

## Database

- **Development:** H2 (in-memory)
- **Production:** DB2
- Write **standard SQL** that works on both — avoid database-specific syntax
- Seed data lives in `src/main/resources/data.sql`

## What NOT to Do

- ❌ **Don't modify `pom.xml` dependencies** without clearly explaining why in the commit message
- ❌ **Don't use field injection** (`@Autowired` on fields) — use constructor injection
- ❌ **Don't bypass the service layer** — controllers must not call repositories directly
- ❌ **Don't use `System.out.println`** — use SLF4J logging
- ❌ **Don't use `SELECT *`** in SQL queries — always list explicit columns
- ❌ **Don't return `null`** from methods — use `Optional<T>`
- ❌ **Don't leave code without tests** — every change needs corresponding test coverage
- ❌ **Don't commit commented-out code** — delete it; Git has history
