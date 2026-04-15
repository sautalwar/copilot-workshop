# Exercise 4: Test the API End-to-End

## 🎯 Objective

Start the app, open Swagger UI, and verify that every endpoint works — happy paths, error cases, and business rules.

## ⏱️ Time: ~10 minutes

## Background

You've built three layers in this lab:
- **Service** — business logic and status transition rules
- **Controller** — HTTP endpoints
- **Validation & Errors** — input checking and clean error messages

Now it's time to see it all work together. You'll use **Swagger UI**, a built-in tool that gives you a web page to test every endpoint without writing any code.

## Steps

### Step 1: Build the project

Make sure everything compiles cleanly:

```bash
mvn clean compile
```

If there are errors, fix them before continuing. Ask Copilot if you need help:

```
Fix the compilation errors in my project
```

### Step 2: Start the application

```bash
mvn spring-boot:run
```

Wait for the startup message:

```
Started Application in X.XXX seconds
```

> The app starts with an **H2 in-memory database** that's pre-loaded with sample orders and inventory from `data.sql`. Your campaigns table will be empty — you'll create your first campaign in the next step.

### Step 3: Open Swagger UI

Open your browser and go to:

**http://localhost:8080/swagger-ui.html**

You should see three groups of endpoints:
- **order-controller** — the existing order endpoints
- **inventory-controller** — the existing inventory endpoints
- **campaign-controller** — your new campaign endpoints ✨

Click on **campaign-controller** to expand it. You should see all five endpoints:

```
GET    /api/campaigns
GET    /api/campaigns/{id}
POST   /api/campaigns
PUT    /api/campaigns/{id}/status
DELETE /api/campaigns/{id}
```

If they're all there, your controller is wired up correctly.

### Step 4: Create a campaign (POST)

Click on **POST /api/campaigns**, then click **Try it out**.

Paste this JSON into the request body:

```json
{
  "name": "Times Square Holiday 2024",
  "client": "Clear Channel NYC",
  "startDate": "2024-12-01",
  "endDate": "2025-01-15",
  "budget": 150000.00,
  "location": "Times Square, Manhattan"
}
```

Click **Execute**.

**Expected:** Status `201 Created` with the campaign in the response body. Notice that:
- The `id` was auto-generated
- The `status` is `DRAFT` (your service forced that)
- The `createdAt` timestamp was set automatically

> 📝 **Write down the `id`** from the response — you'll need it for the next steps.

### Step 5: List all campaigns (GET)

Click on **GET /api/campaigns**, then **Try it out**, then **Execute**.

**Expected:** Status `200 OK` with a JSON array containing the campaign you just created.

### Step 6: Get a single campaign (GET by ID)

Click on **GET /api/campaigns/{id}**, then **Try it out**.

Enter the `id` from Step 4 and click **Execute**.

**Expected:** Status `200 OK` with that one campaign.

Now try an ID that doesn't exist — like `9999`.

**Expected:** Status `404 Not Found` with a message like:

```json
{
  "message": "Campaign not found with id: 9999",
  "timestamp": "2024-11-15T10:30:00"
}
```

### Step 7: Test status transitions (PUT)

This is where the business rules get exercised.

Click on **PUT /api/campaigns/{id}/status**, then **Try it out**.

**Test 1: DRAFT → ACTIVE (should work)**

Enter the `id` from Step 4, and this body:

```json
{
  "status": "ACTIVE"
}
```

Click **Execute**.

**Expected:** Status `200 OK`. The campaign's status is now `ACTIVE`.

**Test 2: ACTIVE → COMPLETED (should work)**

Same endpoint, same `id`, new body:

```json
{
  "status": "COMPLETED"
}
```

**Expected:** Status `200 OK`. The campaign's status is now `COMPLETED`.

**Test 3: Create another campaign and try an invalid transition**

Go back to POST, create a second campaign (use different details). Then try to update it directly from DRAFT to COMPLETED:

```json
{
  "status": "COMPLETED"
}
```

**Expected:** Status `400 Bad Request` with an error message explaining that DRAFT → COMPLETED isn't allowed.

**Test 4: CANCELLED from any status**

Try setting that second campaign (still in DRAFT) to CANCELLED:

```json
{
  "status": "CANCELLED"
}
```

**Expected:** Status `200 OK`. Cancellation always works, regardless of current status.

### Step 8: Test validation (POST with bad data)

Go back to **POST /api/campaigns** and send this intentionally broken request:

```json
{
  "name": "",
  "client": "",
  "startDate": "2025-01-15",
  "endDate": "2024-12-01",
  "budget": -500
}
```

**Expected:** Status `400 Bad Request` with errors like:
- "Campaign name is required"
- "Client name is required"
- "Budget must be positive"

(The start/end date validation may or may not be caught depending on how you implemented it — that's okay.)

### Step 9: Delete a campaign (DELETE)

Click on **DELETE /api/campaigns/{id}**, enter a valid campaign `id`, and click **Execute**.

**Expected:** Status `204 No Content` (success, nothing to send back).

Now try to GET that same campaign by ID.

**Expected:** Status `404 Not Found` — it's gone.

### Step 10: Stop the application

Go back to your terminal and press `Ctrl+C` to stop the app.

## ✅ Expected Outcome

You've verified that:

| Test | Expected Result | ✅ |
|------|----------------|---|
| Create campaign | 201, status is DRAFT | |
| List campaigns | 200, array with your campaigns | |
| Get by ID (exists) | 200, single campaign | |
| Get by ID (missing) | 404, clear error message | |
| DRAFT → ACTIVE | 200, status updated | |
| ACTIVE → COMPLETED | 200, status updated | |
| DRAFT → COMPLETED | 400, invalid transition error | |
| Any → CANCELLED | 200, always allowed | |
| Empty name / negative budget | 400, validation errors | |
| Delete campaign | 204, campaign is gone | |

If all of these pass, congratulations — you've built a complete, production-quality REST API using GitHub Copilot! 🎉

## What You Learned

In this lab, you used Copilot to build an API from scratch by following the patterns already in your codebase. Here's the key insight:

**Copilot works best when it has patterns to follow.**

Because your project had `OrderService`, `OrderController`, and clear instructions in `copilot-instructions.md`, Copilot could generate the Campaign stack in the same style — right down to constructor injection, `Optional` returns, and `ResponseEntity` status codes.

The more consistent your codebase, the better Copilot gets at extending it.

---

[← Back to Lab 3 overview](../README.md)
