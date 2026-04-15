# Exercise 2: Fetch & Display Campaigns

## 🎯 Objective

Add JavaScript that calls your REST API and renders campaign data as styled cards — the moment your three-tier app comes to life.

## ⏱️ Time: ~8 minutes

## Background

Your API is running at `/api/campaigns` and returns JSON like this:

```json
[
  {
    "id": 1,
    "name": "Times Square Digital",
    "client": "Nike",
    "startDate": "2025-01-15",
    "endDate": "2025-06-30",
    "budget": 250000.00,
    "status": "ACTIVE",
    "location": "Times Square, NYC",
    "createdAt": "2025-01-10T10:00:00"
  }
]
```

Now you need JavaScript that fetches this data and turns it into something visual.

## Steps

### Step 1: Ask Copilot to add the data fetching

With `campaigns.html` open in your editor, open Copilot Chat and type:

```
Add JavaScript to campaigns.html that fetches campaigns from /api/campaigns on page load and displays them as cards in the campaign grid. Each card should show:
- Campaign name as the card title
- Client name
- Status badge with color coding: green for ACTIVE, yellow/amber for DRAFT, gray for COMPLETED, red for CANCELLED
- Date range (start date — end date) formatted nicely
- Budget formatted as US currency ($XXX,XXX.XX)
- Location
If there are no campaigns, show a friendly "No campaigns yet" message.
```

### Step 2: Review the JavaScript

Before accepting, look at what Copilot generated:

- ✅ **`fetch()` call** — Does it use `fetch('/api/campaigns')` with proper error handling?
- ✅ **DOM manipulation** — Does it create card elements and insert them into the grid?
- ✅ **Status colors** — Is there logic mapping ACTIVE→green, DRAFT→yellow, etc.?
- ✅ **Currency formatting** — Does it use `Intl.NumberFormat` or `toLocaleString()` for the budget?
- ✅ **Date formatting** — Are dates displayed in a human-readable format?
- ✅ **Page load trigger** — Does it call the fetch function on `DOMContentLoaded` or at the bottom of the page?

> 💡 **Tip:** If the JavaScript is in a separate `<script>` tag at the bottom of the HTML, that's the right pattern. Inline scripts in static HTML files are perfectly fine for this kind of dashboard.

### Step 3: Accept and refresh

Accept Copilot's changes, then refresh `http://localhost:8080/campaigns.html` in your browser.

### Step 4: See your data come alive

If everything is working, you should see campaign cards with:
- Real campaign names and clients from your database
- Color-coded status badges
- Formatted budgets and dates

**This is the wow moment.** Your database → your API → your browser. Three tiers, working together.

> 💡 **No data showing up?** Check these things:
> 1. Is the Spring Boot app running? (`mvn spring-boot:run`)
> 2. Does `http://localhost:8080/api/campaigns` return JSON in your browser?
> 3. Open the browser's Developer Tools (F12) → Console tab. Are there JavaScript errors?
> 4. If the API returns an empty `[]`, you may need seed data from Lab 2. Check `data.sql` for campaign INSERT statements.

### Step 5: Try the browser's Developer Tools

Open Developer Tools (F12) and go to the **Network** tab. Refresh the page. You should see:
- A request to `/campaigns.html` (the page itself)
- A request to `/api/campaigns` (the AJAX call to your API)

Click on the `/api/campaigns` request to see the response body — that's the same JSON your JavaScript is rendering.

## ✅ Success Criteria

- Campaign cards appear on the page with real data from the API
- Status badges are color-coded (ACTIVE=green, DRAFT=yellow, COMPLETED=gray, CANCELLED=red)
- Budgets display as formatted currency
- The browser console shows no JavaScript errors

## What Just Happened?

With one prompt, Copilot wrote a complete data-fetching layer: an async API call, JSON parsing, DOM construction, conditional styling, and currency formatting. That's a lot of JavaScript to write by hand — and Copilot nailed the context because it knows your API shape from the project instructions.

---

[← Previous: Create HTML Page](01-create-html-page.md) | [Next: Create Campaign Form →](03-create-campaign-form.md)
