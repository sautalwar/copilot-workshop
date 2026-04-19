---
mode: agent
description: Implement all 6 performance fixes identified by the performance audit of the OMS Spring Boot application.
---

# Implement Performance Fixes

You are implementing performance optimizations for the OutFront Media OMS Spring Boot application. A performance audit identified 6 issues ranked by priority.

## Fixes to Implement (in priority order)

### 1. Fix PurchaseOrder Eager Fetch (HIGH)
**File:** `src/main/java/com/outfront/oms/model/PurchaseOrder.java`
- Change `@ManyToOne(fetch = FetchType.EAGER)` to `FetchType.LAZY` on both `supplier` and `inventoryItem`
- Add `@EntityGraph` to `PurchaseOrderRepository` for list queries

### 2. Add Pagination to All List Endpoints (HIGH)
**Files:** All 4 controllers + all 4 services + all 4 repositories
- Convert `findAll()` methods to accept `Pageable` parameter
- Return `Page<T>` instead of `List<T>`
- Add `@RequestParam(defaultValue = "0") int page` and `@RequestParam(defaultValue = "20") int size`

### 3. Add @Transactional(readOnly = true) to Read Methods (MEDIUM)
**Files:** All 4 service classes
- All `get*`, `find*`, and read-only methods should have `@Transactional(readOnly = true)`
- Write methods already have `@Transactional` — don't touch those

### 4. Add Caching to Reference Data (MEDIUM)
**Files:** `InventoryService.java`, `SupplierService.java`, `OrderService.java`
- Add `@Cacheable("inventoryCategories")` to `getAllCategories()`
- Add `@Cacheable("activeSuppliers")` to `getActiveSuppliers()`
- Add `@Cacheable("orderSummary")` to `getOrderSummary()`
- Add `@CacheEvict` on corresponding write methods
- Enable caching in `Application.java` with `@EnableCaching`

### 5. Add Database Indexes (MEDIUM)
**Files:** All 4 model/entity classes
- `Order`: index on `status`, `order_date`, composite on `status + customer_name`
- `PurchaseOrder`: index on `status`, `supplier_id`, `inventory_item_id`
- `InventoryItem`: index on `category`
- `Supplier`: index on `active`

### 6. Tune Connection Pool Settings (LOW)
**File:** `src/main/resources/application.properties`
- Add HikariCP settings: `maximum-pool-size=10`, `minimum-idle=5`
- Disable `show-sql` for non-dev profiles

## Constraints
- Follow Google Java Style Guide
- Constructor injection only
- Methods under 30 lines
- Javadoc on all public methods
- Standard SQL compatible with H2 and SQL Server
- Run `mvn test` after each fix to verify nothing breaks
