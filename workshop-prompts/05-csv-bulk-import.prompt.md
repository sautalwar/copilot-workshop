---
mode: 'agent'
description: 'Add CSV bulk import endpoint for inventory items'
---

# CSV Bulk Import for Inventory

## 📍 Workshop Section
Slide 11: Agent Mode | Part 3 — Advanced Multi-File Feature

## What This Does
Adds a production-ready CSV bulk import endpoint to the Inventory API. This is a more complex feature requiring file upload handling, CSV parsing, validation, and transactional batch processing. Great for advanced attendees.

## Instructions
**For the AI Agent:**

Add a CSV bulk import feature to the OutFront Media Order Management API that allows warehouse managers to upload inventory items in bulk via CSV file.

### Requirements:

1. **Endpoint:** `POST /api/inventory/import/csv`
2. **Request:** Multipart file upload with CSV file
3. **CSV Format:**
   ```csv
   sku,name,description,quantity,location
   DSU-9648,Digital Screen Unit 96x48,High-brightness digital billboard screen,25,Warehouse A — Newark NJ
   LED-7236,LED Panel 72x36,Full-color LED panel,50,Warehouse A — Newark NJ
   ```
   - Header row is required
   - All fields are required (reject row if any field is empty)
   - `sku` must be unique (update existing items if SKU already exists)

4. **Response:**
   - `200 OK` with import summary: `{ "imported": 10, "updated": 3, "failed": 0, "errors": [] }`
   - `400 Bad Request` if file is empty, wrong format, or missing required fields

5. **Business Rules:**
   - Import is **transactional** — if any row fails validation, roll back entire import
   - Update `last_updated` timestamp to current time for all imported items
   - Log successful imports and errors

### Implementation Steps:

1. **DTO for Import Results:**
   - Create a Java record `InventoryImportResult` with fields: `imported`, `updated`, `failed`, `errors` (List<String>)

2. **Service Layer** (`InventoryService.java`):
   - Add method: `importFromCsv(MultipartFile file)`
   - Use Apache Commons CSV or OpenCSV library for parsing (add to `pom.xml` if needed)
   - Use `@Transactional` — entire import must succeed or fail atomically
   - For each CSV row:
     - Check if SKU exists: if yes, update; if no, create new
     - Validate all required fields are non-empty
     - Validate quantity is a positive integer
   - Return `InventoryImportResult` with summary statistics

3. **Controller Layer** (`InventoryController.java`):
   - Add endpoint: `importInventoryCsv(@RequestParam("file") MultipartFile file)`
   - Validate file is not empty and is CSV (check content type or extension)
   - Return `ResponseEntity<InventoryImportResult>` with 200 on success
   - Handle exceptions and return 400 with error details

4. **Dependencies** (`pom.xml`):
   - Add Apache Commons CSV:
     ```xml
     <dependency>
         <groupId>org.apache.commons</groupId>
         <artifactId>commons-csv</artifactId>
         <version>1.10.0</version>
     </dependency>
     ```

5. **Tests** (`InventoryControllerTest.java`):
   - Test successful import with valid CSV
   - Test update of existing items (SKU collision)
   - Test validation: empty file returns 400
   - Test validation: missing required field returns 400
   - Test transactional behavior: partial failure rolls back all changes

### Sample CSV for Testing:
Create `src/test/resources/test-inventory.csv`:
```csv
sku,name,description,quantity,location
TEST-001,Test Item 1,Test description,100,Warehouse Test
TEST-002,Test Item 2,Another test,50,Warehouse Test
```

## Expected Outcome
After running this prompt, you should have:
- ✅ New dependency in `pom.xml` for CSV parsing
- ✅ New DTO: `InventoryImportResult` record
- ✅ New service method in `InventoryService.java` with CSV parsing logic
- ✅ New controller endpoint in `InventoryController.java`
- ✅ Test CSV file in `src/test/resources/`
- ✅ At least 5 tests in `InventoryControllerTest.java`
- ✅ All tests pass: `mvn test`

## Try It
**For Workshop Attendees:**
1. Open Copilot Chat in Agent mode
2. Paste this prompt
3. Review the generated code — it should span multiple files
4. Run `mvn clean install` to download the CSV dependency
5. Run the tests: `mvn test -Dtest=InventoryControllerTest`
6. Start the app: `mvn spring-boot:run`
7. Test the endpoint with curl:
   ```bash
   curl -X POST http://localhost:8080/api/inventory/import/csv \
     -F "file=@src/test/resources/test-inventory.csv"
   ```

**Expected Response:**
```json
{
  "imported": 2,
  "updated": 0,
  "failed": 0,
  "errors": []
}
```

**Challenge:** Modify the CSV to include an invalid row (e.g., negative quantity) and verify the entire import is rolled back due to `@Transactional`.
