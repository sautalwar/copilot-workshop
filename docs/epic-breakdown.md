# EPIC: Campaign Management — Full CRUD with SQL Server

## Summary

| Metric | Value |
|---|---|
| **Total Story Points** | 34 |
| **Stories** | 6 |
| **Tasks** | 22 |
| **Critical Path** | Story 1 → Story 2 → Story 3 → Story 4 |
| **Estimated Effort** | 3–4 sprints (assuming 2-week sprints, 1 developer) |
| **P0 Stories** | 3 (Entity/Repo, Service, API) — 21 points |
| **P1 Stories** | 1 (Testing) — 5 points |
| **P2 Stories** | 1 (MCP Integration) — 5 points |
| **P3 Stories** | 1 (Frontend Dashboard) — 3 points |

### Critical Path

```
Story 1 (Entity & Repo) ──► Story 2 (Service) ──► Story 3 (REST API) ──► Story 4 (Testing)
                                                        │
                                                        ├──► Story 5 (MCP Integration)
                                                        └──► Story 6 (Frontend Dashboard)
```

### Patterns Reference (from existing codebase)

These patterns were extracted from the `outfront-oms` repo and **must** be followed:

| Concern | Existing Pattern | Source File |
|---|---|---|
| Entity structure | JPA `@Entity` + `@Table`, `@Id` + `@GeneratedValue(IDENTITY)`, `@NotBlank`/`@Positive` validation, inner enum for status, `@PreUpdate` hook | `Order.java`, `PurchaseOrder.java` |
| Repository | Interface extending `JpaRepository<T, Long>`, Spring Data derived queries + `@Query` JPQL | `OrderRepository.java` |
| Service | `@Service`, constructor injection, `@Transactional` on writes, SLF4J `LoggerFactory`, `ResourceNotFoundException` for missing entities | `OrderService.java` |
| Controller | `@RestController` + `@RequestMapping("/api/...")`, constructor injection, `@Valid @RequestBody`, `ResponseEntity<T>` returns, `HttpStatus.CREATED` for POST | `OrderController.java` |
| Exception handling | `@RestControllerAdvice` with structured error bodies (`timestamp`, `status`, `error`, `message`), custom `RuntimeException` subclasses | `GlobalExceptionHandler.java` |
| Status enum | Inner enum inside entity class, `@Enumerated(EnumType.STRING)` | `Order.OrderStatus`, `PurchaseOrder.PurchaseOrderStatus` |
| Seed data | Plain `INSERT INTO` statements in `data.sql`, grouped by entity with comments | `data.sql` |

---

## Story 1: Campaign Entity & Repository

**Priority:** P0 (foundational — everything depends on this)
**Story Points:** 5
**Labels:** `backend`, `database`, `model`
**Assignee:** Fenster (backend)

> As a developer, I need a Campaign JPA entity and repository so that campaign data can be persisted and queried.

### Task 1.1: Create Campaign JPA Entity

**File:** `src/main/java/com/outfront/oms/model/Campaign.java`
**Package:** `com.outfront.oms.model`

Create a JPA entity class following the exact pattern of `Order.java` and `PurchaseOrder.java`:

```java
@Entity
@Table(name = "campaigns")
public class Campaign {
```

**Fields:**

| Field | Type | Annotations | Notes |
|---|---|---|---|
| `id` | `Long` | `@Id @GeneratedValue(strategy = GenerationType.IDENTITY)` | Auto-generated PK |
| `name` | `String` | `@NotBlank(message = "Campaign name is required") @Column(nullable = false)` | Required |
| `description` | `String` | none | Optional |
| `startDate` | `LocalDate` | `@Column(nullable = false)` | Maps to `start_date` |
| `endDate` | `LocalDate` | `@Column(nullable = false)` | Maps to `end_date` |
| `status` | `CampaignStatus` | `@Enumerated(EnumType.STRING) @Column(nullable = false)` | Default: `DRAFT` |
| `budget` | `BigDecimal` | `@PositiveOrZero(message = "Budget cannot be negative") @Column(nullable = false, precision = 12, scale = 2)` | Use `BigDecimal` for money, NOT `double` |
| `createdAt` | `LocalDate` | `@Column(nullable = false, updatable = false)` | Set in constructor |
| `updatedAt` | `LocalDate` | none | Updated via `@PreUpdate` |

**Implementation notes:**
- Follow the same constructor pattern as `Order.java`: no-arg constructor sets `createdAt`/`updatedAt` to `LocalDate.now()`, convenience constructor calls `this()`
- Add `@PreUpdate` method `onUpdate()` identical to `Order.java`
- Inner enum `CampaignStatus` (see Task 1.2) — same pattern as `Order.OrderStatus`
- Standard getters/setters (no Lombok — project doesn't use it, see `pom.xml`)
- Javadoc on the class describing campaigns in the OutFront billboard advertising context

### Task 1.2: Create CampaignStatus Enum

**Location:** Inner enum inside `Campaign.java` (follows `Order.OrderStatus` pattern)

```java
public enum CampaignStatus {
    DRAFT, ACTIVE, PAUSED, COMPLETED
}
```

**Valid state transitions (to be enforced in Task 2.2):**
```
DRAFT → ACTIVE
ACTIVE → PAUSED
ACTIVE → COMPLETED
PAUSED → ACTIVE
PAUSED → COMPLETED
```

Note: No transition out of `COMPLETED` — it is a terminal state. `DRAFT` can only become `ACTIVE`.

### Task 1.3: Create CampaignRepository

**File:** `src/main/java/com/outfront/oms/repository/CampaignRepository.java`
**Package:** `com.outfront.oms.repository`

Follow the `OrderRepository.java` pattern — interface extending `JpaRepository<Campaign, Long>`:

```java
public interface CampaignRepository extends JpaRepository<Campaign, Long> {

    List<Campaign> findByStatus(CampaignStatus status);

    List<Campaign> findByNameContainingIgnoreCase(String name);

    @Query("SELECT c FROM Campaign c WHERE c.startDate <= :date AND c.endDate >= :date AND c.status = 'ACTIVE'")
    List<Campaign> findActiveCampaigns(@Param("date") LocalDate date);

    @Query("SELECT c FROM Campaign c WHERE c.startDate >= :startDate AND c.endDate <= :endDate")
    List<Campaign> findByDateRange(@Param("startDate") LocalDate startDate,
                                    @Param("endDate") LocalDate endDate);

    long countByStatus(CampaignStatus status);
}
```

Add Javadoc: `/** Data access layer for advertising campaigns. */`

### Task 1.4: Add Campaign Seed Data

**File:** `src/main/resources/data.sql`
**Append** to the existing file — follow the same comment-group pattern:

```sql
-- Campaigns
INSERT INTO campaigns (name, description, start_date, end_date, status, budget, created_at, updated_at) VALUES
    ('Times Square Q4 Blitz', 'High-impact digital campaign across 5 Times Square billboard locations', '2024-10-01', '2024-12-31', 'ACTIVE', 150000.00, '2024-09-15', '2024-10-01'),
    ('LA Transit Spring Push', 'Transit shelter displays across LA Metro routes', '2025-03-01', '2025-05-31', 'DRAFT', 75000.00, '2024-11-10', '2024-11-10'),
    ('Highway Corridor Solar', 'Solar-powered billboard campaign along I-95 corridor', '2024-08-01', '2024-10-31', 'COMPLETED', 200000.00, '2024-07-01', '2024-11-01'),
    ('NYC Kiosk Interactive', 'Interactive kiosk campaign at 20 high-traffic NYC locations', '2024-11-15', '2025-02-28', 'ACTIVE', 95000.00, '2024-11-01', '2024-11-15'),
    ('Dallas Digital Refresh', 'Refresh of 12 digital billboard units in DFW metro area', '2025-01-15', '2025-04-15', 'DRAFT', 60000.00, '2024-11-12', '2024-11-12');
```

### Acceptance Criteria

- [ ] `Campaign` entity maps to `campaigns` table via Hibernate DDL auto-generation
- [ ] `CampaignStatus` enum stores as STRING in database (not ordinal)
- [ ] All 5 repository query methods work correctly against H2
- [ ] Seed data loads on startup without errors
- [ ] `@NotBlank` and `@PositiveOrZero` validation annotations present and functional
- [ ] `BigDecimal` used for budget (not `double` — monetary precision)

---

## Story 2: Campaign Service Layer

**Priority:** P0 (core business logic)
**Story Points:** 8
**Labels:** `backend`, `service`, `business-logic`
**Assignee:** Fenster (backend)
**Depends on:** Story 1

> As a developer, I need a CampaignService that encapsulates all campaign business rules so that controllers remain thin.

### Task 2.1: Create CampaignService with CRUD Operations

**File:** `src/main/java/com/outfront/oms/service/CampaignService.java`
**Package:** `com.outfront.oms.service`

Follow the `OrderService.java` pattern exactly:

```java
@Service
public class CampaignService {

    private static final Logger log = LoggerFactory.getLogger(CampaignService.class);

    private final CampaignRepository campaignRepository;

    public CampaignService(CampaignRepository campaignRepository) {
        this.campaignRepository = campaignRepository;
    }
```

**Methods to implement:**

| Method | Annotation | Returns | Notes |
|---|---|---|---|
| `getAllCampaigns()` | `@Transactional(readOnly = true)` | `List<Campaign>` | Delegates to `findAll()` |
| `getCampaignById(Long id)` | `@Transactional(readOnly = true)` | `Campaign` | Throws `ResourceNotFoundException("Campaign", id)` — same pattern as `OrderService.getOrderById()` |
| `getCampaignsByStatus(CampaignStatus status)` | `@Transactional(readOnly = true)` | `List<Campaign>` | Delegates to `findByStatus()` |
| `getActiveCampaigns()` | `@Transactional(readOnly = true)` | `List<Campaign>` | Calls `findActiveCampaigns(LocalDate.now())` |
| `createCampaign(Campaign campaign)` | `@Transactional` | `Campaign` | Sets status to `DRAFT`, validates dates, saves |
| `updateCampaign(Long id, Campaign updated)` | `@Transactional` | `Campaign` | Full update — merge fields onto existing entity |
| `updateCampaignStatus(Long id, CampaignStatus newStatus)` | `@Transactional` | `Campaign` | Validates transitions (Task 2.2), enforces budget rule |
| `deleteCampaign(Long id)` | `@Transactional` | `void` | Only DRAFT campaigns can be deleted — throw `IllegalStateException` otherwise (same as `OrderService.deleteOrder()`) |
| `getCampaignSummary()` | `@Transactional(readOnly = true)` | `CampaignSummary` | Record with counts per status (follow `OrderService.OrderSummary` pattern) |

**Add inner record:**
```java
public record CampaignSummary(long total, long draft, long active, long paused, long completed) {}
```

### Task 2.2: Implement Business Rules

Implement inside `CampaignService`:

**1. Status transition validation** — private method `validateStatusTransition(CampaignStatus current, CampaignStatus next)`:
```java
private void validateStatusTransition(CampaignStatus current, CampaignStatus next) {
    boolean valid = switch (current) {
        case DRAFT -> next == CampaignStatus.ACTIVE;
        case ACTIVE -> next == CampaignStatus.PAUSED || next == CampaignStatus.COMPLETED;
        case PAUSED -> next == CampaignStatus.ACTIVE || next == CampaignStatus.COMPLETED;
        case COMPLETED -> false;  // terminal state
    };
    if (!valid) {
        throw new IllegalStateException(
                "Invalid campaign status transition: " + current + " -> " + next);
    }
}
```
Follow the exact `switch` expression pattern from `OrderService.validateStatusTransition()`.

**2. Budget activation rule** — in `updateCampaignStatus()`, before allowing `DRAFT → ACTIVE`:
```java
if (newStatus == CampaignStatus.ACTIVE && campaign.getBudget().compareTo(BigDecimal.ZERO) <= 0) {
    throw new IllegalStateException("Cannot activate campaign without a positive budget");
}
```

**3. Date validation** — in `createCampaign()` and `updateCampaign()`:
- `endDate` must be after `startDate` — throw `IllegalArgumentException("End date must be after start date")`
- `startDate` should not be in the past for new campaigns (warn via log, don't block)

### Task 2.3: Cross-Domain Integration (Campaign ↔ Orders)

**Architecture Decision:** For the initial implementation, campaigns reference orders by a **campaign_id foreign key on the orders table** (optional, nullable). This is a future Story 2 enhancement — for now, implement a read-only method:

```java
/**
 * Placeholder for future campaign-order linkage.
 * Currently returns an empty list until the Order entity gets a campaignId field.
 */
public List<Order> getOrdersForCampaign(Long campaignId) {
    // TODO: Implement when Order entity gains campaignId FK
    log.info("Campaign-order linkage requested for campaign {}", campaignId);
    return List.of();
}
```

> **Decision rationale:** Adding a FK to `orders` is a schema migration that affects the Order domain. This should be a separate story to avoid scope creep. Documented in decisions inbox.

### Task 2.4: Transactional Annotations

Ensure every method has the correct annotation:

| Method | Annotation | Reason |
|---|---|---|
| `getAllCampaigns()` | `@Transactional(readOnly = true)` | Read-only optimization |
| `getCampaignById()` | `@Transactional(readOnly = true)` | Read-only |
| `getCampaignsByStatus()` | `@Transactional(readOnly = true)` | Read-only |
| `getActiveCampaigns()` | `@Transactional(readOnly = true)` | Read-only |
| `getCampaignSummary()` | `@Transactional(readOnly = true)` | Read-only |
| `createCampaign()` | `@Transactional` | Write |
| `updateCampaign()` | `@Transactional` | Write |
| `updateCampaignStatus()` | `@Transactional` | Write |
| `deleteCampaign()` | `@Transactional` | Write |

### Acceptance Criteria

- [ ] All CRUD operations work correctly
- [ ] Status transition validation rejects invalid transitions with `IllegalStateException`
- [ ] `DRAFT → ACTIVE` blocked when budget is zero or negative
- [ ] `endDate` before `startDate` rejected on create/update
- [ ] Only `DRAFT` campaigns can be deleted
- [ ] `CampaignSummary` record returns correct counts
- [ ] All write methods use `@Transactional`, all reads use `@Transactional(readOnly = true)`
- [ ] SLF4J logging on create, update, status change, and delete (follow `OrderService` log patterns)

---

## Story 3: Campaign REST API

**Priority:** P0 (expose functionality)
**Story Points:** 8
**Labels:** `backend`, `api`, `controller`
**Assignee:** Fenster (backend)
**Depends on:** Story 2

> As an API consumer, I need Campaign REST endpoints so that I can manage campaigns over HTTP.

**File:** `src/main/java/com/outfront/oms/controller/CampaignController.java`
**Package:** `com.outfront.oms.controller`

Follow `OrderController.java` exactly — `@RestController`, `@RequestMapping("/api/campaigns")`, constructor injection:

```java
@RestController
@RequestMapping("/api/campaigns")
public class CampaignController {

    private final CampaignService campaignService;

    public CampaignController(CampaignService campaignService) {
        this.campaignService = campaignService;
    }
```

### Task 3.1: GET /api/campaigns — List All Campaigns

```java
@GetMapping
public ResponseEntity<List<Campaign>> getAllCampaigns() {
    return ResponseEntity.ok(campaignService.getAllCampaigns());
}
```

**HTTP 200** — Returns full list. Add Javadoc: `/** GET /api/campaigns — List all campaigns. */`

### Task 3.2: GET /api/campaigns/{id} — Get Campaign by ID

```java
@GetMapping("/{id}")
public ResponseEntity<Campaign> getCampaignById(@PathVariable Long id) {
    return ResponseEntity.ok(campaignService.getCampaignById(id));
}
```

**HTTP 200** on success, **HTTP 404** via `ResourceNotFoundException` (handled by `GlobalExceptionHandler`).

### Task 3.3: GET /api/campaigns/status/{status} — Filter by Status

```java
@GetMapping("/status/{status}")
public ResponseEntity<List<Campaign>> getCampaignsByStatus(@PathVariable CampaignStatus status) {
    return ResponseEntity.ok(campaignService.getCampaignsByStatus(status));
}
```

**HTTP 200** — Returns filtered list. Spring auto-converts the path variable to the enum.

### Task 3.4: GET /api/campaigns/active — Convenience Endpoint

```java
@GetMapping("/active")
public ResponseEntity<List<Campaign>> getActiveCampaigns() {
    return ResponseEntity.ok(campaignService.getActiveCampaigns());
}
```

**HTTP 200** — Returns campaigns that are `ACTIVE` and within their date range.

### Task 3.5: POST /api/campaigns — Create Campaign

```java
@PostMapping
public ResponseEntity<Campaign> createCampaign(@Valid @RequestBody Campaign campaign) {
    Campaign created = campaignService.createCampaign(campaign);
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
}
```

**HTTP 201** on success, **HTTP 400** on validation failure (via `GlobalExceptionHandler.handleValidation`).
Note: `@Valid @RequestBody` — same pattern as `OrderController.createOrder()`.

### Task 3.6: PUT /api/campaigns/{id} — Full Update

```java
@PutMapping("/{id}")
public ResponseEntity<Campaign> updateCampaign(@PathVariable Long id,
                                                @Valid @RequestBody Campaign campaign) {
    return ResponseEntity.ok(campaignService.updateCampaign(id, campaign));
}
```

**HTTP 200** on success, **HTTP 404** if not found, **HTTP 400** on validation failure.

### Task 3.7: PATCH /api/campaigns/{id}/status — Status Transition

```java
@PatchMapping("/{id}/status")
public ResponseEntity<Campaign> updateCampaignStatus(
        @PathVariable Long id,
        @RequestBody Map<String, String> body) {
    CampaignStatus newStatus = CampaignStatus.valueOf(body.get("status"));
    return ResponseEntity.ok(campaignService.updateCampaignStatus(id, newStatus));
}
```

**HTTP 200** on success, **HTTP 400** on invalid transition (via `GlobalExceptionHandler.handleIllegalState`).

Note: Uses `PATCH` (not `PUT`) since this is a partial update — different from `OrderController.updateOrderStatus()` which uses `PUT`. This is a deliberate improvement; status-only changes are semantically a patch.

### Task 3.8: DELETE /api/campaigns/{id}

```java
@DeleteMapping("/{id}")
public ResponseEntity<Void> deleteCampaign(@PathVariable Long id) {
    campaignService.deleteCampaign(id);
    return ResponseEntity.noContent().build();
}
```

**HTTP 204** on success, **HTTP 400** if campaign is not in `DRAFT` status, **HTTP 404** if not found.
Same `noContent().build()` pattern as `OrderController.deleteOrder()`.

### Acceptance Criteria

- [ ] All 8 endpoints respond with correct HTTP status codes
- [ ] `@Valid` on `POST` and `PUT` request bodies triggers Bean Validation
- [ ] `ResourceNotFoundException` returns structured 404 via `GlobalExceptionHandler`
- [ ] `IllegalStateException` returns structured 400 via `GlobalExceptionHandler`
- [ ] Endpoints appear in Swagger UI at `/swagger-ui.html` (SpringDoc auto-discovers `@RestController`)
- [ ] No business logic in controller — all delegated to `CampaignService`

---

## Story 4: Campaign Testing

**Priority:** P1 (quality gate)
**Story Points:** 5
**Labels:** `testing`, `backend`
**Assignee:** Hockney (testing)
**Depends on:** Story 3

> As a team, we need comprehensive test coverage for the Campaign feature to prevent regressions.

### Task 4.1: CampaignServiceTest

**File:** `src/test/java/com/outfront/oms/service/CampaignServiceTest.java`

Use `@ExtendWith(MockitoExtension.class)` with `@Mock CampaignRepository` and `@InjectMocks CampaignService`:

**Test methods (name pattern: `shouldDoSomething_whenCondition`):**

| Test | Scenario |
|---|---|
| `shouldReturnAllCampaigns_whenCampaignsExist` | Mock `findAll()` returning list, verify response |
| `shouldReturnCampaign_whenValidIdProvided` | Mock `findById()` returning Optional.of(), verify response |
| `shouldThrowResourceNotFoundException_whenCampaignNotFound` | Mock `findById()` returning empty, assert exception |
| `shouldCreateCampaign_whenValidDataProvided` | Verify status set to DRAFT, dates validated, save called |
| `shouldRejectCreation_whenEndDateBeforeStartDate` | Assert `IllegalArgumentException` thrown |
| `shouldTransitionToActive_whenDraftWithBudget` | Happy path DRAFT → ACTIVE |
| `shouldRejectActivation_whenBudgetIsZero` | Assert `IllegalStateException` for zero-budget activation |
| `shouldRejectInvalidTransition_whenCompletedToActive` | Assert `IllegalStateException` for terminal state |
| `shouldTransitionToPaused_whenActive` | Happy path ACTIVE → PAUSED |
| `shouldTransitionToCompleted_whenActiveOrPaused` | Both paths to COMPLETED |
| `shouldDeleteCampaign_whenDraftStatus` | Verify `delete()` called |
| `shouldRejectDeletion_whenNotDraft` | Assert `IllegalStateException` for ACTIVE campaign delete |
| `shouldReturnSummary_whenCampaignsExist` | Verify `CampaignSummary` record populated correctly |

### Task 4.2: CampaignControllerTest

**File:** `src/test/java/com/outfront/oms/controller/CampaignControllerTest.java`

Use `@SpringBootTest` + `@AutoConfigureMockMvc` (full integration with H2 — same as existing controller tests):

**Test methods:**

| Test | HTTP | Assertion |
|---|---|---|
| `shouldReturnAllCampaigns` | `GET /api/campaigns` | Status 200, JSON array with seed data |
| `shouldReturnCampaignById` | `GET /api/campaigns/1` | Status 200, JSON object with expected fields |
| `shouldReturn404_whenCampaignNotFound` | `GET /api/campaigns/999` | Status 404, structured error body |
| `shouldReturnCampaignsByStatus` | `GET /api/campaigns/status/ACTIVE` | Status 200, filtered results |
| `shouldReturnActiveCampaigns` | `GET /api/campaigns/active` | Status 200, only currently active campaigns |
| `shouldCreateCampaign` | `POST /api/campaigns` | Status 201, response body has generated ID |
| `shouldReturn400_whenCreatingInvalidCampaign` | `POST /api/campaigns` (missing name) | Status 400, validation error message |
| `shouldUpdateCampaign` | `PUT /api/campaigns/1` | Status 200, updated fields reflected |
| `shouldUpdateCampaignStatus` | `PATCH /api/campaigns/{id}/status` | Status 200, status changed |
| `shouldReturn400_whenInvalidStatusTransition` | `PATCH /api/campaigns/{id}/status` (COMPLETED→ACTIVE) | Status 400 |
| `shouldDeleteDraftCampaign` | `DELETE /api/campaigns/{id}` (DRAFT) | Status 204 |
| `shouldReturn400_whenDeletingActiveCampaign` | `DELETE /api/campaigns/{id}` (ACTIVE) | Status 400 |

Use `MockMvc` with `perform()`, `andExpect()`, `jsonPath()` — standard Spring Boot test patterns.

### Task 4.3: Test Status Transitions Exhaustively

Add a parameterized test in `CampaignServiceTest` that covers ALL transition combinations:

```java
@ParameterizedTest
@CsvSource({
    "DRAFT, ACTIVE, true",
    "DRAFT, PAUSED, false",
    "DRAFT, COMPLETED, false",
    "ACTIVE, PAUSED, true",
    "ACTIVE, COMPLETED, true",
    "ACTIVE, DRAFT, false",
    "PAUSED, ACTIVE, true",
    "PAUSED, COMPLETED, true",
    "PAUSED, DRAFT, false",
    "COMPLETED, DRAFT, false",
    "COMPLETED, ACTIVE, false",
    "COMPLETED, PAUSED, false"
})
void shouldEnforceStatusTransitions(CampaignStatus from, CampaignStatus to, boolean valid)
```

### Task 4.4: Test Validation Failures

In `CampaignControllerTest`, add tests for every validation constraint:

| Test | Scenario |
|---|---|
| `shouldReturn400_whenNameIsBlank` | Empty `name` field |
| `shouldReturn400_whenBudgetIsNegative` | Negative `budget` value |
| `shouldReturn400_whenStartDateMissing` | Null `startDate` |
| `shouldReturn400_whenEndDateMissing` | Null `endDate` |

### Acceptance Criteria

- [ ] `CampaignServiceTest` — 13+ test methods, all passing
- [ ] `CampaignControllerTest` — 12+ test methods, all passing
- [ ] Parameterized status transition test covers all 12 combinations
- [ ] Validation failure tests cover all `@NotBlank` / `@PositiveOrZero` constraints
- [ ] All tests use correct naming convention: `shouldDoSomething_whenCondition`
- [ ] >90% line coverage on `CampaignService` and `CampaignController`
- [ ] Tests run green with `mvn test`

---

## Story 5: Campaign MCP Integration

**Priority:** P2 (AI tooling — enhances Copilot experience)
**Story Points:** 5
**Labels:** `mcp`, `tooling`, `integration`
**Assignee:** Fenster (backend) or Verbal (if MCP is Node.js)
**Depends on:** Story 3

> As a Copilot user, I need MCP tools for campaigns so I can query campaign data conversationally.

### Task 5.1: Add Campaign Tools to MCP Server

**Directory:** `mcp-server/`

Add two new tools following the existing tool patterns (`lookup_inventory`, `check_stock_level`, `get_order_status`):

**Tool 1: `lookup_campaign`**
- **Input:** `{ campaignId?: number, name?: string }`
- **Output:** Campaign details (id, name, description, status, dates, budget)
- **Behavior:** Lookup by ID or fuzzy name match. Return structured JSON.
- **Guardrails:** Input validation, rate limiting (follow existing patterns)

**Tool 2: `list_active_campaigns`**
- **Input:** `{}` (no required params)
- **Output:** Array of active campaigns with summary info
- **Behavior:** Returns campaigns where status is ACTIVE and current date is within start/end range
- **Guardrails:** Response filtering (exclude internal fields), audit logging

**Implementation notes:**
- Mirror the seed data from `data.sql` into the MCP server's static data (same pattern as existing tools)
- Follow existing rate limiting, input validation, and audit logging patterns in `mcp-server/`
- Register tools in the MCP tool manifest

### Task 5.2: Update MCP Server Documentation

**File:** `mcp-server/README.md` (or equivalent docs)

- Add `lookup_campaign` and `list_active_campaigns` to the tool reference table
- Include example prompts: "What campaigns are currently active?", "Show me the Times Square campaign details"
- Document input/output schemas

### Acceptance Criteria

- [ ] `lookup_campaign` returns correct data for valid IDs and names
- [ ] `list_active_campaigns` returns only campaigns that are ACTIVE within date range
- [ ] Input validation rejects invalid campaign IDs (negative, non-numeric)
- [ ] Rate limiting applied (consistent with existing tools)
- [ ] Audit logging records tool invocations
- [ ] MCP server starts without errors: `node mcp-server/index.js`
- [ ] Documentation updated with examples

---

## Story 6: Campaign Frontend Dashboard

**Priority:** P3 (stretch goal)
**Story Points:** 3
**Labels:** `frontend`, `ui`, `dashboard`
**Assignee:** Verbal (frontend)
**Depends on:** Story 3

> As an operations user, I need a web dashboard to view and manage campaigns without using the API directly.

### Task 6.1: Campaign List Dashboard

**File:** `src/main/resources/static/campaigns.html` (or equivalent location)

- HTML table listing all campaigns (name, status, dates, budget)
- Status badges with color coding: DRAFT (gray), ACTIVE (green), PAUSED (yellow), COMPLETED (blue)
- Fetch data from `GET /api/campaigns` via `fetch()` API
- Auto-refresh or manual reload button
- Follow any existing frontend patterns in the project (check `src/main/resources/static/`)

### Task 6.2: Create/Edit Campaign Form

- Modal or separate page with form fields for all Campaign properties
- Client-side validation (required fields, date ordering)
- Submits via `POST /api/campaigns` (create) or `PUT /api/campaigns/{id}` (update)
- Success/error feedback messages

### Task 6.3: Status Management UI

- Dropdown or button group showing only valid next statuses (based on transition rules)
- Calls `PATCH /api/campaigns/{id}/status` on selection
- Confirmation dialog before status changes
- Disable controls for `COMPLETED` campaigns (terminal state)

### Acceptance Criteria

- [ ] Campaign list loads and displays all campaigns from the API
- [ ] Create form successfully submits a new campaign
- [ ] Edit form pre-populates with existing campaign data
- [ ] Status buttons only show valid transitions
- [ ] Error messages display for validation failures
- [ ] Dashboard is accessible from a nav link or direct URL

---

## Dependency Graph

```
                    ┌─────────────┐
                    │   Story 1   │
                    │ Entity/Repo │
                    │   P0 · 5pts │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   Story 2   │
                    │   Service   │
                    │   P0 · 8pts │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   Story 3   │
                    │   REST API  │
                    │   P0 · 8pts │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
       ┌──────▼──────┐ ┌──▼──────┐ ┌──▼──────────┐
       │   Story 4   │ │ Story 5 │ │   Story 6   │
       │   Testing   │ │   MCP   │ │  Frontend   │
       │   P1 · 5pts │ │ P2·5pts │ │   P3 · 3pts │
       └─────────────┘ └─────────┘ └─────────────┘
```

**Sprint Plan Recommendation:**

| Sprint | Stories | Points | Focus |
|---|---|---|---|
| Sprint 1 | Story 1 + Story 2 | 13 | Foundation + business logic |
| Sprint 2 | Story 3 + Story 4 | 13 | API + quality gate |
| Sprint 3 | Story 5 + Story 6 | 8 | Integration + polish |

---

## Architecture Decisions

1. **`BigDecimal` for budget** — Monetary values must not use `double`/`float` due to precision issues. This is a departure from `InventoryItem.unitPrice` (which uses `double`) — consider migrating that field in a future story.

2. **`PATCH` for status transitions** — Using `PATCH /api/campaigns/{id}/status` instead of `PUT` (as `OrderController` does). PATCH is semantically correct for partial updates. Consider aligning `OrderController` in a future refactor.

3. **Campaign-Order linkage deferred** — Adding `campaignId` FK to `orders` table is a schema change that touches the Order domain. Implemented as a placeholder in Task 2.3, to be completed in a follow-up story.

4. **Inner enum pattern preserved** — `CampaignStatus` is an inner enum of `Campaign`, consistent with `Order.OrderStatus` and `PurchaseOrder.PurchaseOrderStatus`.

5. **No new exceptions needed** — Reuse `ResourceNotFoundException` and `IllegalStateException`, both already handled by `GlobalExceptionHandler`. No new custom exception classes required.
