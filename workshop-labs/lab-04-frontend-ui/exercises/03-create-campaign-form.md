# Exercise 3: Build the Create Campaign Form

## 🎯 Objective

Wire up the modal form so users can create new campaigns directly from the dashboard — a round trip from browser → API → database → back to the browser.

## ⏱️ Time: ~8 minutes

## Background

You already have a modal shell in your HTML (from Exercise 1) and a function that fetches and displays campaigns (from Exercise 2). Now you need:

1. A form inside the modal with the right fields
2. JavaScript that POSTs the form data to `/api/campaigns`
3. Logic to refresh the campaign list when a new campaign is created

## Steps

### Step 1: Ask Copilot to build the form

With `campaigns.html` open, type this in Copilot Chat:

```
Add a working create-campaign form to the modal in campaigns.html. The form needs fields for:
- Name (required, text)
- Client (required, text)
- Start Date (required, date picker)
- End Date (required, date picker)
- Budget (required, number with step 0.01)
- Location (required, text)

Wire up the "New Campaign" button to open the modal. When the form is submitted:
1. Collect the form data and build a JSON object
2. POST to /api/campaigns with Content-Type: application/json
3. On success (201 status): close the modal, clear the form, and refresh the campaign list
4. On error: display the error message from the API response near the form

Add a close/cancel button on the modal too.
```

### Step 2: Review the code

Check what Copilot generated:

- ✅ **Form fields** — Are all six fields present with proper `type` attributes?
- ✅ **Required validation** — Do fields have `required` attribute for browser-native validation?
- ✅ **Modal open/close** — Does clicking "New Campaign" show the modal? Does cancel/close hide it?
- ✅ **POST request** — Does it send JSON to `/api/campaigns` with the correct `Content-Type` header?
- ✅ **Success handling** — Does it close the modal and refresh the list?
- ✅ **Error handling** — Does it display API error messages (e.g., validation failures)?

> 💡 **Tip:** Copilot might set the default status to `DRAFT` automatically (since new campaigns start as drafts). If it doesn't, that's OK — your API might set the default on the backend.

### Step 3: Accept and test the happy path

Accept the changes, refresh the page, and try creating a campaign:

1. Click **"New Campaign"** — the modal should appear
2. Fill in all fields:
   - Name: `Highway 101 Billboard`
   - Client: `Tesla`
   - Start Date: any future date
   - End Date: after the start date
   - Budget: `75000`
   - Location: `Highway 101, San Jose`
3. Click **Submit** (or whatever the button is labeled)
4. The modal should close and your new campaign should appear in the card grid

> 🎉 **That's a full round trip!** Browser form → JavaScript POST → Spring Boot controller → JPA repository → H2 database → GET request → back to the browser as a card. All tiers working together.

### Step 4: Test validation

Try submitting the form with empty fields. What happens?

- **Browser-native validation** should prevent submission if fields have the `required` attribute
- If you bypass that (e.g., remove `required` in DevTools), the API should return validation errors

Try a few edge cases:
- End date before start date — does the API reject it?
- Very long campaign name — does the card still look OK?

### Step 5: Check the data persisted

Open `http://localhost:8080/swagger-ui.html` and try the GET `/api/campaigns` endpoint. Your new campaign should be in the list — proving it was saved to the database, not just displayed in the UI.

## ✅ Success Criteria

- Clicking "New Campaign" opens a modal form
- Filling out and submitting the form creates a campaign via the API
- The new campaign appears immediately in the card grid (no manual refresh needed)
- The form clears and the modal closes after successful submission
- Validation errors are shown if required fields are missing

## What Just Happened?

Copilot generated form HTML, modal toggle logic, JSON serialization, a POST request with proper headers, response handling for both success and error cases, and a list refresh — all from one prompt. The key insight: Copilot knew the exact fields because it can see your Campaign entity and API from the project context.

---

[← Previous: Fetch & Display](02-fetch-and-display.md) | [Next: Status Updates & Delete →](04-status-updates-and-delete.md)
