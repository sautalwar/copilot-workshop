# Exercise 3: Add Request Validation & Error Handling

## 🎯 Objective

Make your API reject bad data with clear error messages instead of crashing with a stack trace. Two parts: **input validation** (stop garbage from getting in) and **exception handling** (give helpful messages when something goes wrong).

## ⏱️ Time: ~10 minutes

## Background

Right now, someone could send a POST request to create a campaign with no name, a negative budget, or an end date before the start date. The database might reject it with a cryptic SQL error, or worse — it might save the bad data silently.

We're going to fix that in two ways:

1. **Validation annotations** on the data — tell Spring "this field is required" or "this number must be positive"
2. **A custom exception + global handler** — when a campaign isn't found, return a clean `404 Not Found` instead of a raw stack trace

## Steps

### Step 1: Add validation annotations to the Campaign entity

Ask Copilot:

```
Add Bean Validation annotations to the Campaign entity:
- name is required (not blank)
- client is required (not blank)
- budget must be positive
- startDate is required
- endDate is required
- startDate must be before endDate

Look at the existing Campaign entity and add the appropriate Jakarta validation annotations.
```

Review what Copilot generates. You should see annotations like:

```java
@NotBlank(message = "Campaign name is required")
private String name;

@NotNull(message = "Budget is required")
@Positive(message = "Budget must be positive")
private BigDecimal budget;
```

> 💡 **Tip:** The `message` parameter in each annotation is what the user sees when they send bad data. Make these messages human-readable — "Budget must be positive" is much better than "must be greater than 0".

### Step 2: Create a DTO for campaign creation

A DTO (Data Transfer Object) is a small class that defines exactly what fields the API accepts. It's like a form — the customer fills in only the fields you ask for, nothing more.

Ask Copilot:

```
Create a CreateCampaignRequest as a Java record in the model package.
It should have these fields with validation:
- name (String, required, not blank)
- client (String, required, not blank)
- startDate (LocalDate, required)
- endDate (LocalDate, required)
- budget (BigDecimal, required, must be positive)
- location (String, optional)

The record should NOT include id, status, or createdAt — those are set by the server.
```

Why a record? Java records are perfect for DTOs — they're just data, no behavior. You declare the fields once and Java gives you the constructor, getters, `equals()`, and `toString()` for free.

After Copilot creates it, you'll need to update your `CampaignService.createCampaign()` and `CampaignController.createOrder()` to accept a `CreateCampaignRequest` instead of a raw `Campaign` entity. Ask Copilot:

```
Update CampaignService and CampaignController to use CreateCampaignRequest for creating campaigns.
The service should convert the DTO to a Campaign entity, set the status to DRAFT and createdAt to now, then save it.
```

### Step 3: Create a custom exception

Right now, if you request a campaign that doesn't exist, the service throws a generic `RuntimeException`. That's fine for a prototype, but a real app should have a specific exception that the error handler can recognize.

Ask Copilot:

```
Create a CampaignNotFoundException class in a new 'exception' package.
It should extend RuntimeException and take a Long id in its constructor.
The message should say "Campaign not found with id: " followed by the ID.
```

Then update your `CampaignService` to use it:

```
Update CampaignService to throw CampaignNotFoundException instead of RuntimeException when a campaign is not found
```

### Step 4: Add a global exception handler

A `@ControllerAdvice` class catches exceptions from any controller and turns them into clean HTTP responses. Instead of a 500 error with a stack trace, the client gets a structured JSON error.

Ask Copilot:

```
Create a GlobalExceptionHandler class with @ControllerAdvice that handles:
1. CampaignNotFoundException → returns 404 with a JSON body containing "message" and "timestamp"
2. MethodArgumentNotValidException → returns 400 with a list of field errors
3. IllegalArgumentException → returns 400 with the error message

Follow the project's error handling conventions. Put it in the controller package or a new exception package.
```

The response for a missing campaign should look like:

```json
{
  "message": "Campaign not found with id: 99",
  "timestamp": "2024-11-15T10:30:00"
}
```

And a validation failure should look like:

```json
{
  "message": "Validation failed",
  "errors": [
    "name: Campaign name is required",
    "budget: Budget must be positive"
  ],
  "timestamp": "2024-11-15T10:30:00"
}
```

### Step 5: Verify it compiles

```bash
mvn clean compile -q
```

Fix any compilation errors with Copilot's help before moving on.

## ✅ Expected Outcome

You should now have:

| File | What It Does |
|------|-------------|
| `Campaign.java` (updated) | Validation annotations on entity fields |
| `CreateCampaignRequest.java` (new) | Java record DTO with validation rules |
| `CampaignNotFoundException.java` (new) | Custom exception for missing campaigns |
| `GlobalExceptionHandler.java` (new) | Catches exceptions and returns clean JSON errors |

When you test these in the next exercise:
- Sending a campaign with no name → `400 Bad Request` with "Campaign name is required"
- Sending a negative budget → `400 Bad Request` with "Budget must be positive"
- Requesting campaign ID 9999 → `404 Not Found` with "Campaign not found with id: 9999"

## Why This Matters

Without validation and error handling, your API has two problems:
1. **Bad data sneaks in** — and corrupts your database
2. **Error messages are useless** — a raw stack trace tells the client nothing about what they did wrong

Good APIs are polite. They tell you exactly what's wrong and how to fix it.

---

[← Back to Lab 3 overview](../README.md) | [Next: Test the API End-to-End →](04-test-the-api.md)
