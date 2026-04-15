# Exercise 1: Create the Campaign Service

## 🎯 Objective

Build the business logic layer for campaigns. This is the "brain" of the Campaign feature — it decides what's allowed and what's not.

## ⏱️ Time: ~10 minutes

## Background

In this project, controllers never talk to the database directly. Every request goes through a **service** first:

```
Controller  →  Service  →  Repository
(waiter)       (chef)      (pantry)
```

The service is where the rules live. For campaigns, the main rule is about **status transitions** — a campaign moves through stages in a specific order:

```
DRAFT  →  ACTIVE  →  COMPLETED
  ↓         ↓          ↓
  └─────────┴──────────┴──→  CANCELLED
```

In plain English:
- A new campaign starts as a **DRAFT** (just an idea)
- It can move to **ACTIVE** (running on billboards right now)
- An active campaign can be marked **COMPLETED** (finished its run)
- **Any** campaign can be **CANCELLED** at any time (client pulled out, weather emergency, etc.)
- But you can't skip steps — a DRAFT can't jump straight to COMPLETED

## Steps

### Step 1: Open an existing service for reference

Open `src/main/java/com/outfront/workshop/service/OrderService.java` in VS Code.

Take 30 seconds to notice the pattern:
- It's annotated with `@Service`
- It uses **constructor injection** (the dependency is passed in through the constructor, not with `@Autowired`)
- Each method is straightforward — get, create, update, delete
- Business rules live in `updateOrderStatus()` (the inventory check)

This is the pattern Copilot will follow when you ask it to build the Campaign service.

### Step 2: Ask Copilot to create the service

Open Copilot Chat in **Agent Mode** (look for the agent icon or use `@workspace`).

Type this prompt:

```
Create a CampaignService class that provides CRUD operations for campaigns.
Follow the same pattern as OrderService. Include these methods:
- getAllCampaigns
- getCampaignById (returns Optional)
- createCampaign (new campaigns always start as DRAFT)
- updateCampaignStatus (with transition validation)
- deleteCampaign

Business rule for status transitions:
- DRAFT → ACTIVE (only valid next step)
- ACTIVE → COMPLETED (only valid next step)
- Any status → CANCELLED (always allowed)
- All other transitions are rejected with a clear error message
```

Let Copilot generate the file. It should create `CampaignService.java` in the `service/` package.

### Step 3: Review what Copilot wrote

Before you accept, check these things:

**The basics:**
- [ ] Is the class annotated with `@Service`?
- [ ] Does it use constructor injection (not `@Autowired` on a field)?
- [ ] Does `createCampaign()` force the status to `DRAFT`?
- [ ] Does `getCampaignById()` return `Optional<Campaign>`?

**The status transition logic:**
- [ ] Does `updateCampaignStatus()` check if the transition is valid?
- [ ] Can you go DRAFT → ACTIVE? ✅
- [ ] Can you go ACTIVE → COMPLETED? ✅
- [ ] Can you go from anything → CANCELLED? ✅
- [ ] Does it reject DRAFT → COMPLETED? ❌ (should throw an error)
- [ ] Does it reject COMPLETED → ACTIVE? ❌ (can't go backwards)

**The error handling:**
- [ ] When a campaign isn't found, does it throw an exception with the ID in the message?
- [ ] When a transition is invalid, does the error message explain what was attempted?

> 💡 **Tip:** Notice how Copilot read the `copilot-instructions.md` file and followed the project's service layer conventions automatically. It knows about constructor injection, `Optional`, and the layered architecture because those rules are defined in the instructions file you explored in Lab 1.

### Step 4: Compare with OrderService

Open both files side by side (`OrderService.java` and your new `CampaignService.java`).

Notice the parallel structure:
| OrderService | CampaignService |
|---|---|
| `getAllOrders()` | `getAllCampaigns()` |
| `getOrderById()` | `getCampaignById()` |
| `createOrder()` | `createCampaign()` |
| `updateOrderStatus()` | `updateCampaignStatus()` |
| `deleteOrder()` | `deleteCampaign()` |

The shape is the same, but the business rules are different. Orders check inventory before confirming; campaigns check if a status transition is valid. Same pattern, different logic.

### Step 5: Verify it compiles

Run a quick compilation check:

```bash
mvn clean compile -q
```

If there are errors, ask Copilot to fix them:

```
Fix the compilation errors in CampaignService.java
```

## ✅ Expected Outcome

You should have a `CampaignService.java` file that:
- Lives in `src/main/java/com/outfront/workshop/service/`
- Has all five CRUD methods
- Enforces the DRAFT → ACTIVE → COMPLETED status flow
- Allows cancellation from any status
- Compiles without errors

## Why This Matters

The service layer is the most important layer in the app. It's where you protect your business rules. Without it, any controller could write any data to the database — campaigns could jump from DRAFT to COMPLETED, or get deleted mid-flight.

By putting the rules in one place (the service), every part of the app that touches campaigns goes through the same checks.

---

[← Back to Lab 3 overview](../README.md) | [Next: Create the Campaign Controller →](02-create-controller.md)
