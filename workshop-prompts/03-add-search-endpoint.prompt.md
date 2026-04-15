---
mode: 'agent'
description: 'Add a date range search endpoint for orders'
---

# Add Date Range Search Endpoint

## 📍 Workshop Section
Slide 11: Agent Mode | Part 3 — Full Stack Feature Development

## What This Does
Adds a complete REST endpoint to search for orders placed within a specific date range. This demonstrates Copilot Agent's ability to generate code across multiple layers (Controller → Service → Repository → Tests).

## Instructions
**For the AI Agent:**

Add a new REST endpoint to the OutFront Media Order Management API that allows customers to search for orders by date range.

### Requirements:
1. **Endpoint:** `GET /api/orders/search/by-date-range`
2. **Query Parameters:**
   - `startDate` (required) — format: `yyyy-MM-dd` (e.g., `2024-11-01`)
   - `endDate` (required) — format: `yyyy-MM-dd` (e.g., `2024-11-30`)
3. **Response:** List of orders with `order_date` between `startDate` and `endDate` (inclusive)
4. **HTTP Status Codes:**
   - `200 OK` — successful search (even if results are empty)
   - `400 Bad Request` — if `startDate` or `endDate` is invalid or missing
   - `400 Bad Request` — if `endDate` is before `startDate`

### Implementation Steps:
1. **Repository Layer** (`OrderRepository.java`):
   - Add a query method: `List<Order> findByOrderDateBetween(LocalDate startDate, LocalDate endDate);`

2. **Service Layer** (`OrderService.java`):
   - Add method: `findOrdersByDateRange(LocalDate startDate, LocalDate endDate)`
   - Use `@Transactional(readOnly = true)`
   - Validate that `endDate` is not before `startDate` — throw `IllegalArgumentException` if invalid
   - Call the repository method

3. **Controller Layer** (`OrderController.java`):
   - Add endpoint method `searchOrdersByDateRange(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate, @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate)`
   - Return `ResponseEntity<List<OrderResponse>>`
   - Handle `IllegalArgumentException` and return `400 Bad Request`
   - Add Javadoc explaining the endpoint

4. **Controller Test** (`OrderControllerTest.java`):
   - Test happy path: valid date range returns matching orders
   - Test edge case: same start and end date
   - Test validation: end date before start date returns 400

### Use Realistic OutFront Media Data:
- Refer to `src/main/resources/data.sql` for example order dates
- Test with dates like `2024-11-01` to `2024-11-10` which should return multiple orders

## Expected Outcome
After running this prompt, you should have:
- ✅ New repository method in `OrderRepository.java`
- ✅ New service method in `OrderService.java` with date validation
- ✅ New controller endpoint in `OrderController.java`
- ✅ At least 3 new tests in `OrderControllerTest.java`
- ✅ All tests pass: `mvn test`
- ✅ Code compiles: `mvn compile`

## Try It
**For Workshop Attendees:**
1. Open the Copilot Chat in Agent mode
2. Paste this entire prompt into the chat
3. Let Copilot generate all the code files
4. Review the generated code in each layer
5. Run `mvn test` to verify all tests pass
6. Start the app with `mvn spring-boot:run`
7. Test the endpoint manually:
   ```bash
   curl "http://localhost:8080/api/orders/search/by-date-range?startDate=2024-11-01&endDate=2024-11-10"
   ```

**Expected Response:**
```json
[
  {
    "id": 1,
    "customerName": "Clear Channel NYC",
    "productName": "Digital Screen Unit 96x48",
    "quantity": 4,
    "status": "CONFIRMED",
    "orderDate": "2024-11-01"
  },
  ...
]
```
