# Exercise 1: Create the Campaign Dashboard Page

## 🎯 Objective

Use Copilot Agent Mode to scaffold a complete HTML page with professional styling — the shell of your campaign dashboard.

## ⏱️ Time: ~8 minutes

## Background

Spring Boot serves static files from `src/main/resources/static/` automatically. If you put a file called `campaigns.html` in that folder, it's immediately available at `http://localhost:8080/campaigns.html`. No configuration, no build step, no bundler.

You're going to ask Copilot to create this file from scratch. One prompt, one file, a complete page layout.

## Steps

### Step 1: Open Copilot Chat in Agent Mode

In VS Code, open Copilot Chat (Ctrl+Shift+I or Cmd+Shift+I) and make sure you're in **Agent Mode** (look for the agent icon at the top of the chat panel — click it if you're in a different mode).

### Step 2: Ask Copilot to create the page

Type this prompt:

```
Create a static HTML page at src/main/resources/static/campaigns.html for a Campaign Management Dashboard. Include:
- A header with "OutFront Media" branding and a subtitle "Campaign Management"
- A toolbar with a "New Campaign" button
- A main section to display campaigns as cards in a responsive grid
- A modal overlay for creating new campaigns (hidden by default)
- Modern CSS with a clean color scheme, flexbox/grid layout, subtle shadows, and rounded corners
- No external frameworks — vanilla HTML and CSS only
```

### Step 3: Review what Copilot generated

Before accepting, look at the generated code. Check for:

- ✅ **Semantic HTML** — Does it use `<header>`, `<main>`, `<section>`, `<button>` instead of all `<div>`s?
- ✅ **Responsive layout** — Is there a CSS grid or flexbox that will adapt to different screen widths?
- ✅ **Modal structure** — Is there a hidden overlay `<div>` for the form?
- ✅ **Clean styling** — Does the CSS look professional? Colors, spacing, fonts?

> 💡 **Tip:** Copilot may generate slightly different layouts each time. That's fine! The exact styling doesn't matter — what matters is that the structure is there: header, card grid area, and a modal.

### Step 4: Accept the changes

Click **Accept** to let Copilot create the file.

### Step 5: View it in the browser

Make sure your Spring Boot app is running (`mvn spring-boot:run`), then open:

```
http://localhost:8080/campaigns.html
```

You should see a styled page with:
- An OutFront Media header
- A "New Campaign" button
- An empty area where campaigns will go
- Clicking "New Campaign" might open a modal (or it might not have JavaScript wired up yet — that's fine)

> 💡 **Tip:** If you get a 404, double-check that the file was created at `src/main/resources/static/campaigns.html` (not somewhere else). You may also need to restart the Spring Boot app if it was running before the file was created.

## ✅ Success Criteria

- The file `src/main/resources/static/campaigns.html` exists
- Opening `http://localhost:8080/campaigns.html` shows a styled dashboard layout
- The page has a header, a button for creating campaigns, and an area for campaign cards

## What Just Happened?

You went from an empty folder to a professionally styled web page in under two minutes. Copilot understood what "campaign management dashboard" means, knew to include a modal for forms, and generated modern CSS without being told the exact colors or spacing.

This is the scaffold. In the next exercise, you'll bring it to life with real data.

---

[← Back to Lab 4 overview](../README.md) | [Next: Fetch & Display Campaigns →](02-fetch-and-display.md)
