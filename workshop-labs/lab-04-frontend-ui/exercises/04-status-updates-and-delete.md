# Exercise 4: Status Transitions & Delete

## 🎯 Objective

Add action buttons to each campaign card so users can manage the full lifecycle: change status and delete campaigns — completing the CRUD story.

## ⏱️ Time: ~6 minutes

## Background

Campaigns have a lifecycle with specific valid transitions:

```
DRAFT → ACTIVE → COMPLETED
  ↓         ↓
CANCELLED  CANCELLED
```

Your API enforces these transitions:
- **PUT** `/api/campaigns/{id}/status` — with JSON body like `{"status": "ACTIVE"}`
- **DELETE** `/api/campaigns/{id}` — removes the campaign

The UI needs to be smart about which buttons to show. A COMPLETED campaign shouldn't have an "Activate" button.

## Steps

### Step 1: Ask Copilot to add the action buttons

With `campaigns.html` open, type this in Copilot Chat:

```
Add action buttons to each campaign card in campaigns.html for status transitions and delete.

Status transition rules:
- DRAFT campaigns can go to ACTIVE or CANCELLED
- ACTIVE campaigns can go to COMPLETED or CANCELLED
- COMPLETED and CANCELLED campaigns have no further transitions

Each card should show only the valid transition buttons for its current status. Use:
- PUT /api/campaigns/{id}/status with body {"status": "NEW_STATUS"} for status changes
- DELETE /api/campaigns/{id} for deletion

Delete should show a confirmation dialog before proceeding. After any action (status change or delete), refresh the campaign list. Style the buttons to match the status colors.
```

### Step 2: Review the generated code

Check what Copilot produced:

- ✅ **Conditional buttons** — Does a DRAFT card show "Activate" and "Cancel" but not "Complete"?
- ✅ **No buttons on terminal states** — Do COMPLETED and CANCELLED cards have only a delete button (or no status buttons)?
- ✅ **PUT request** — Is the status update sending JSON to the right endpoint?
- ✅ **DELETE with confirmation** — Is there a `confirm()` dialog before the DELETE request?
- ✅ **List refresh** — Does the campaign list reload after every action?
- ✅ **Button styling** — Do buttons have colors that match their meaning?

### Step 3: Accept and test the transitions

Accept the changes, refresh the page, and walk through the full lifecycle:

1. **Find a DRAFT campaign** — you should see "Activate" and "Cancel" buttons
2. Click **"Activate"** — the card should update to show ACTIVE status (green badge)
3. The buttons should now change to "Complete" and "Cancel"
4. Click **"Complete"** — the status should update to COMPLETED (gray badge)
5. The status transition buttons should disappear (COMPLETED is a terminal state)

### Step 4: Test delete

1. Find a campaign you don't need
2. Click **"Delete"**
3. A confirmation dialog should appear ("Are you sure?")
4. Click **OK** — the campaign should disappear from the list
5. Click **Cancel** on another delete — nothing should happen

### Step 5: Test edge cases

- Create a new campaign (Exercise 3) — does it appear as DRAFT with the right buttons?
- Try the DRAFT → CANCELLED path — does it work?
- After all status changes, check Swagger UI (`/swagger-ui.html`) — does the API data match what you see in the UI?

## ✅ Success Criteria

- Campaign cards show only valid status transition buttons
- Clicking a status button updates the campaign via the API
- The card's status badge and available buttons update after each transition
- Delete shows a confirmation prompt and removes the campaign
- The full lifecycle works: Create → DRAFT → ACTIVE → COMPLETED → Delete

## What Just Happened?

You now have a fully functional CRUD dashboard:

| Operation | UI Action | API Call |
|-----------|-----------|----------|
| **Create** | Modal form → Submit | POST /api/campaigns |
| **Read** | Page loads cards | GET /api/campaigns |
| **Update** | Status button click | PUT /api/campaigns/{id}/status |
| **Delete** | Delete button → Confirm | DELETE /api/campaigns/{id} |

**Your three-tier application is complete.** Database → REST API → Web UI, all built with GitHub Copilot in about 30 minutes.

> 🎉 **Take a moment to appreciate this.** You built a Java backend, a relational database schema, and a working web frontend — all in a single workshop, all guided by AI. This is what modern development with Copilot looks like.

---

[← Previous: Create Campaign Form](03-create-campaign-form.md) | [Back to Lab 4 overview →](../README.md)
