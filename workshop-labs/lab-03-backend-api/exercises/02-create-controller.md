# Exercise 2: Create the Campaign Controller

## 🎯 Objective

Build the REST controller — the "front door" that lets the outside world interact with campaigns over HTTP.

## ⏱️ Time: ~10 minutes

## Background

A controller's job is simple: **translate HTTP requests into service calls, and service responses into HTTP responses.** No business logic. No database queries. Just traffic direction.

Here's what each HTTP method means for campaigns:

| HTTP Method | URL | What It Does |
|---|---|---|
| `GET` | `/api/campaigns` | List all campaigns |
| `GET` | `/api/campaigns/42` | Get campaign #42 |
| `POST` | `/api/campaigns` | Create a new campaign |
| `PUT` | `/api/campaigns/42/status` | Update campaign #42's status |
| `DELETE` | `/api/campaigns/42` | Delete campaign #42 |

Each method maps to exactly one service method. That's the pattern.

## Steps

### Step 1: Open the existing controller for reference

Open `src/main/java/com/outfront/workshop/controller/OrderController.java`.

Notice:
- `@RestController` and `@RequestMapping("/api/orders")` at the top
- Constructor injection for `OrderService`
- Each method returns `ResponseEntity` (which lets you control the HTTP status code)
- `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping` annotations on each method

### Step 2: Ask Copilot to create the controller

In Copilot Chat (Agent Mode), type:

```
Create a CampaignController with REST endpoints for all Campaign CRUD operations.
Follow the same pattern as OrderController. Use @RequestMapping("/api/campaigns").

Endpoints needed:
- GET /api/campaigns — list all campaigns
- GET /api/campaigns/{id} — get one campaign by ID
- POST /api/campaigns — create a new campaign (use @Valid @RequestBody)
- PUT /api/campaigns/{id}/status — update a campaign's status
- DELETE /api/campaigns/{id} — delete a campaign

Return proper HTTP status codes:
- 200 for successful reads and updates
- 201 for successful creation
- 204 for successful deletion
- 404 when a campaign isn't found
- 400 for invalid requests
```

### Step 3: Review the endpoints

Go through each generated method and verify:

**GET /api/campaigns (list all)**
- [ ] Returns a `List<Campaign>` directly (Spring auto-converts to JSON)
- [ ] No special status code needed (200 is the default)

**GET /api/campaigns/{id} (get one)**
- [ ] Uses `@PathVariable Long id`
- [ ] Returns `ResponseEntity.ok(campaign)` when found
- [ ] Returns `ResponseEntity.notFound()` when not found (404)
- [ ] Uses the Optional pattern: `.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build())`

**POST /api/campaigns (create)**
- [ ] Uses `@Valid @RequestBody` to trigger input validation
- [ ] Returns `ResponseEntity.status(HttpStatus.CREATED).body(campaign)` — status 201, not 200
- [ ] The `@Valid` annotation is important — it tells Spring to check validation rules before the method even runs

**PUT /api/campaigns/{id}/status (update status)**
- [ ] Accepts a JSON body with the new status (like `{ "status": "ACTIVE" }`)
- [ ] Calls `campaignService.updateCampaignStatus()`
- [ ] Returns the updated campaign on success
- [ ] Returns a clear error message if the transition is invalid

**DELETE /api/campaigns/{id} (delete)**
- [ ] Returns `204 No Content` on success (deleted, nothing to send back)
- [ ] Returns `404 Not Found` if the campaign doesn't exist

### Step 4: Check for Javadoc

Every public method should have a Javadoc comment explaining what it does. If Copilot didn't add them, ask:

```
Add Javadoc comments to all public methods in CampaignController, including @param, @return, and @throws tags
```

### Step 5: Verify it compiles

```bash
mvn clean compile -q
```

If there are errors, read the error message carefully. Common issues:
- Missing import for `HttpStatus` — ask Copilot to fix imports
- Wrong method name — check that service method names match what you built in Exercise 1
- Type mismatch — make sure the status field matches `CampaignStatus` enum

## ✅ Expected Outcome

You should have a `CampaignController.java` file that:
- Lives in `src/main/java/com/outfront/workshop/controller/`
- Has all five endpoints mapped to the right HTTP methods and URLs
- Delegates all work to `CampaignService` (no business logic in the controller)
- Returns correct HTTP status codes (200, 201, 204, 400, 404)
- Compiles without errors

## Quick Check: How Do You Know It Worked?

Once the app is running (we'll do that in Exercise 4), you should see these endpoints in Swagger UI:

```
GET    /api/campaigns
GET    /api/campaigns/{id}
POST   /api/campaigns
PUT    /api/campaigns/{id}/status
DELETE /api/campaigns/{id}
```

If all five show up, the controller is wired correctly.

---

[← Back to Lab 3 overview](../README.md) | [Next: Add Validation & Error Handling →](03-add-validation.md)
