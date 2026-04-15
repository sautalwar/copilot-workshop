# Lab 3: Backend API Development

## 🎯 Objective

Use GitHub Copilot to build a complete REST API — from business logic to HTTP endpoints — for managing advertising campaigns. You'll create a service layer, a controller, request validation, and custom error handling, all by asking Copilot and reviewing what it generates.

## ⏱️ Duration

~40 minutes (4 exercises)

## Why This Lab?

**Intent:** This is where your application comes alive. You'll build the REST API that lets the outside world interact with your campaign data — creating, reading, updating, and managing campaigns through HTTP endpoints.

**The value:** A well-structured API with proper validation, error handling, and layered architecture is the backbone of any production application. Getting the service → controller → DTO pattern right from the start saves weeks of refactoring later.

**How agentic AI helps:** Building a full CRUD API by hand means writing repetitive boilerplate — service methods, controller endpoints, DTOs, exception classes, validation annotations. Copilot Agent Mode reads your existing `OrderService` and `OrderController` patterns and generates a matching `CampaignService` and `CampaignController` that already follow your project's conventions. What normally takes a full afternoon of copy-paste-modify, Copilot delivers in minutes — and it's consistent because it learned from YOUR code, not a generic template.

## Prerequisites

- **Lab 2 completed** — The `Campaign` entity, `CampaignStatus` enum, and `CampaignRepository` must already exist in your project
- Project builds: `mvn clean compile`
- VS Code with GitHub Copilot Chat open

## What You'll Build

Right now, the Campaign table exists in the database, but there's no way to interact with it from the outside world. By the end of this lab, you'll have:

| Layer | What It Does | File |
|-------|-------------|------|
| **Service** | Business rules — who can do what, when | `CampaignService.java` |
| **Controller** | HTTP endpoints — the front door for API requests | `CampaignController.java` |
| **DTO** | Request validation — rejects bad data before it reaches your service | `CreateCampaignRequest.java` |
| **Exception** | Error handling — clear messages when things go wrong | `CampaignNotFoundException.java` |

Think of it like building a restaurant:
- The **entity** (Lab 2) is the kitchen's pantry — raw ingredients, stored in the fridge.
- The **service** is the chef — decides what to cook and follows recipes.
- The **controller** is the waiter — takes orders from customers and brings back food.
- The **DTO** is the menu — customers can only order what's on it.

## ✅ Success Criteria

You're done when:
1. All five Campaign endpoints are visible in Swagger UI at `http://localhost:8080/swagger-ui.html`
2. You can create, read, update status, and delete campaigns through the API
3. Invalid requests return `400 Bad Request` with helpful error messages
4. Status transitions follow the rules: DRAFT → ACTIVE → COMPLETED (or any status → CANCELLED)

## Exercises

| # | Exercise | Time | What You'll Do |
|---|----------|------|----------------|
| 1 | [Create the Campaign Service](exercises/01-create-service.md) | ~10 min | Build the business logic layer with status transition rules |
| 2 | [Create the Campaign Controller](exercises/02-create-controller.md) | ~10 min | Wire up REST endpoints for all CRUD operations |
| 3 | [Add Validation & Error Handling](exercises/03-add-validation.md) | ~10 min | Reject bad input and return clear error messages |
| 4 | [Test the API End-to-End](exercises/04-test-the-api.md) | ~10 min | Run the app and verify everything works in Swagger UI |

## Folder Structure

After completing this lab, your project will look like this:

```
src/main/java/com/outfront/workshop/
├── controller/
│   ├── OrderController.java          ← Already exists
│   ├── InventoryController.java      ← Already exists
│   └── CampaignController.java       ← You'll create this
├── service/
│   ├── OrderService.java             ← Already exists (your reference)
│   ├── InventoryService.java         ← Already exists
│   └── CampaignService.java          ← You'll create this
├── model/
│   ├── Order.java                    ← Already exists
│   ├── InventoryItem.java            ← Already exists
│   └── Campaign.java                 ← Created in Lab 2
├── repository/
│   └── CampaignRepository.java       ← Created in Lab 2
└── exception/
    └── CampaignNotFoundException.java ← You'll create this
```

> **Tip:** If you get stuck on any exercise, check the `solutions/` folder for working reference code.

---

[← Back to Workshop Home](../README.md) | [Next: Lab 4 — Frontend UI →](../lab-04-frontend-ui/README.md)
