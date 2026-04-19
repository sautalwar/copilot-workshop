# GitHub Copilot Instructions — OutFront Media Order Management API

## Business Domain

OutFront Media is an outdoor advertising company. This app is an **Order Management System (OMS)** for billboard and digital signage equipment. Two core domains:

- **Orders** — Customer orders for display hardware (e.g., LED panels, digital screens). Statuses: `PENDING` → `CONFIRMED` → `SHIPPED`.
- **Inventory** — Warehouse stock of billboard components tracked by SKU. Low-stock threshold is 10 units.

**Key business rule:** When confirming an order, the service verifies sufficient inventory exists for the product. This cross-domain check lives in `OrderService.updateOrderStatus()`.

## Tech Stack

- **Language:** Java 17
- **Framework:** Spring Boot 3.2.5
- **Build Tool:** Maven
- **Database:** H2 (development), SQL Server 2022 (production via `sqlserver` profile)
- **API Docs:** SpringDoc OpenAPI — Swagger UI at `/swagger-ui.html`
- **Testing:** JUnit 5 with `@SpringBootTest` + `@AutoConfigureMockMvc`
- **MCP Server:** Node.js server in `mcp-server/` exposing inventory/order data to Copilot via stdio

## Build, Test & Run

```bash
# Build and run tests
mvn clean verify -B

# Run tests only
mvn test

# Run a single test class
mvn test -Dtest=OrderControllerTest

# Run a single test method
mvn test -Dtest=OrderControllerTest#shouldReturnAllOrders

# Start the app (H2 in-memory, auto-seeded)
mvn spring-boot:run

# Start with SQL Server profile
mvn spring-boot:run -Dspring-boot.run.profiles=sqlserver

# Start with Docker Compose (SQL Server + app)
docker compose up --build
```

The app starts on `http://localhost:8080`. H2 console at `/h2-console` (JDBC URL: `jdbc:h2:mem:omsdb`, user: `sa`, no password).

## Architecture

```
Controller (HTTP layer — request/response mapping only)
    ↓
Service (business logic, @Transactional)
    ↓
Repository (data access — extends JpaRepository)
```

- **Never skip the service layer** — controllers must not call repositories directly
- Two parallel stacks: `Order*` and `Inventory*` (controller, service, repository, model each)
- Entities are JPA classes in `model/` — use Java records for DTOs
- Seed data in `src/main/resources/data.sql` auto-loads on startup

### MCP Server (`mcp-server/`)

A Node.js MCP server that mirrors the Spring Boot app's seed data and exposes three tools (`lookup_inventory`, `check_stock_level`, `get_order_status`) over stdio. Includes guardrails for rate limiting, input validation, audit logging, and response filtering. Configured in `.vscode/mcp.json`.

## Code Conventions

- Follow the [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- **Constructor injection** only — never `@Autowired` on fields
- Use `Optional<T>` instead of returning `null`
- Use `final` on parameters and local variables that don't change
- Use `@Valid` on all `@RequestBody` parameters
- Controllers return `ResponseEntity<T>` with correct HTTP status codes
- Methods under **30 lines** — extract helpers for clarity
- **SLF4J** for logging — never `System.out.println`
- **Javadoc** on all public methods with `@param`, `@return`, `@throws`

## Database

- Write **standard SQL** compatible with both H2 and SQL Server
- Use **UPPER_CASE** SQL keywords, **snake_case** for table/column names
- Hibernate manages schema via `ddl-auto` — no manual migrations
- SQL Server init script in `scripts/init-db.sql` (creates the database only; Hibernate handles tables)

## Testing

- Test names follow: `shouldDoSomething_whenCondition`
- Controller tests: `@SpringBootTest` + `@AutoConfigureMockMvc` with full H2 context
- Service tests: `@ExtendWith(MockitoExtension.class)` with `@Mock` / `@InjectMocks`
- Cover happy path, edge cases, and error scenarios per endpoint
- Tests in `src/test/java/com/outfront/workshop/`

## Error Handling

- Use `@ControllerAdvice` with a global exception handler
- Define custom exceptions (e.g., `OrderNotFoundException`)
- Return consistent error bodies with message and timestamp

## Git Commit Messages

```
type(scope): description
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

## File-Specific Instructions

Additional conventions for Java and SQL files are in `.github/instructions/` and are applied automatically by file pattern.
