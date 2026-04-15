---
mode: 'agent'
description: 'Scaffold a complete domain entity with model, repository, service, controller, and seed data'
---

# Scaffold a New Domain Entity

You are creating a brand-new domain entity for the OutFront Media Order Management API. This is a full-stack scaffold — you'll create everything from the database entity to the REST endpoints.

Follow each step in order. Make sure every file follows the project's existing conventions.

## Step 1: Create the Entity Class

**Location:** `src/main/java/com/outfront/workshop/model/`

Create a JPA entity class:

- Add `@Entity` and `@Table(name = "table_name")` (use snake_case for the table name)
- Add `@Id` and `@GeneratedValue(strategy = GenerationType.IDENTITY)` for the primary key
- Add fields with appropriate Java types
- Add Bean Validation annotations (`@NotBlank`, `@NotNull`, `@Size`, `@Positive`, etc.) with custom messages
- Include `createdAt` and `updatedAt` timestamp fields
- Generate a no-arg constructor (required by JPA) and an all-args constructor
- Generate getters and setters
- Add Javadoc on the class explaining what this entity represents in the OutFront Media domain

## Step 2: Create the Repository Interface

**Location:** `src/main/java/com/outfront/workshop/repository/`

Create a Spring Data JPA repository:

- Extend `JpaRepository<EntityName, Long>`
- Add derived query methods for common lookups:
  - `findByStatus(String status)` — if the entity has a status field
  - `findByNameContainingIgnoreCase(String name)` — for search
- Use `List<T>` return types for methods that return multiple results
- Use `Optional<T>` for methods that return zero or one result
- Add Javadoc on the interface

## Step 3: Create the Service Class

**Location:** `src/main/java/com/outfront/workshop/service/`

Create a service class with business logic:

- Annotate with `@Service`
- Use **constructor injection** for the repository (no `@Autowired` on fields)
- Add these methods:
  - `findAll()` — `@Transactional(readOnly = true)`, returns `List<T>`
  - `findById(Long id)` — `@Transactional(readOnly = true)`, returns `Optional<T>`
  - `create(T entity)` — `@Transactional`, returns the saved entity
  - `update(Long id, T entity)` — `@Transactional`, throws a custom NotFoundException if not found
  - `delete(Long id)` — `@Transactional`, throws a custom NotFoundException if not found
- Create a custom `EntityNameNotFoundException` exception class
- Add Javadoc on every public method with `@param`, `@return`, `@throws`

## Step 4: Create the Controller

**Location:** `src/main/java/com/outfront/workshop/controller/`

Create a REST controller:

- Annotate with `@RestController` and `@RequestMapping("/api/{plural-entity-name}")`
- Use **constructor injection** for the service
- Map CRUD operations:
  - `GET /` → `findAll()` → 200 OK
  - `GET /{id}` → `findById()` → 200 OK or 404 Not Found
  - `POST /` → `create()` → 201 Created (include `Location` header)
  - `PUT /{id}` → `update()` → 200 OK or 404 Not Found
  - `DELETE /{id}` → `delete()` → 204 No Content or 404 Not Found
- Add `@Valid` on all `@RequestBody` parameters
- Return `ResponseEntity<T>` with correct HTTP status codes
- Add Javadoc on every endpoint

## Step 5: Add Seed Data

**Location:** `src/main/resources/data.sql`

Append INSERT statements for the new entity:

- Add a comment block: `-- Seed data for {EntityName}`
- Insert 3-5 realistic rows using OutFront Media domain data
- Use standard SQL compatible with both H2 and SQL Server
- Use UPPER_CASE SQL keywords and snake_case column names
- Use realistic dates in `'YYYY-MM-DD'` format

## Checklist

Before finishing, verify:

- [ ] Entity has JPA annotations, validation annotations, and Javadoc
- [ ] Repository extends `JpaRepository` with useful query methods
- [ ] Service uses constructor injection, `@Transactional`, and `Optional<T>`
- [ ] Controller returns `ResponseEntity` with correct status codes
- [ ] All `@RequestBody` parameters have `@Valid`
- [ ] Seed data uses standard SQL with realistic OutFront Media data
- [ ] No `@Autowired` on fields — constructor injection only
- [ ] No `System.out.println` — use SLF4J if logging is needed
- [ ] Code compiles: `mvn compile`
