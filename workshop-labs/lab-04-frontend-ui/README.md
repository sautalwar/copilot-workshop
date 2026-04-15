# Lab 4: Frontend UI Development

## 🎯 Objective

Use GitHub Copilot to build a working web dashboard that displays and manages campaigns — all from a single HTML file served by your Spring Boot app. By the end of this lab, you'll have a complete three-tier application: database → backend API → frontend UI.

## ⏱️ Duration

~30 minutes (4 exercises)

## Prerequisites

- **Lab 3 completed** — the Campaign REST API is working at `/api/campaigns`
- The Spring Boot app is running: `mvn spring-boot:run`
- You can verify your API works: open `http://localhost:8080/swagger-ui.html` and try the Campaign endpoints
- VS Code with GitHub Copilot Chat enabled

> **Don't have Lab 3 done?** Copy the solution files from `workshop-labs/lab-03-backend-api/solutions/` into your `src/` directory, rebuild with `mvn clean verify -B`, and start the app.

## What You'll Build

A campaign management dashboard with:
- 📋 **List view** — All campaigns displayed as styled cards
- ➕ **Create form** — A modal form to add new campaigns
- 🔄 **Status updates** — Buttons for valid status transitions (DRAFT → ACTIVE → COMPLETED)
- 🗑️ **Delete** — Remove campaigns with a confirmation prompt

All of this in a single `campaigns.html` file, using plain HTML, CSS, and JavaScript — no React, no Angular, no build tools. This is a workshop about using Copilot effectively, not learning a frontend framework.

## Why This Matters

This is the "wow moment" of the workshop. You've built a database layer, a REST API, and now you'll see it all come alive in a browser. In about 30 minutes, Copilot will help you go from an empty file to a fully interactive dashboard — the kind of thing that used to take a full day of frontend work.

**How agentic AI helps:** You don't need to be a frontend expert. Describe what you want — "a dashboard with campaign cards, a create form, and status buttons" — and Copilot Agent Mode generates the HTML, CSS, and JavaScript in one go. It even wires up the API calls to your backend because it can read your controller endpoints. What used to require a frontend specialist and a full day of work, Copilot handles in 30 minutes.

## Exercises

| # | Exercise | Time | What You'll Do |
|---|----------|------|----------------|
| 1 | [Create the HTML Page](exercises/01-create-html-page.md) | ~8 min | Scaffold the dashboard layout with Copilot |
| 2 | [Fetch & Display Campaigns](exercises/02-fetch-and-display.md) | ~8 min | Load campaign data from your API and render cards |
| 3 | [Create Campaign Form](exercises/03-create-campaign-form.md) | ~8 min | Build a modal form that POSTs to your API |
| 4 | [Status Updates & Delete](exercises/04-status-updates-and-delete.md) | ~6 min | Add action buttons for the full CRUD lifecycle |

## Folder Structure

```
src/main/resources/static/
└── campaigns.html          ← The file you'll create (served at /campaigns.html)
```

Spring Boot automatically serves any file in `src/main/resources/static/` as a static resource. No configuration needed — just drop the file in and it's live.

## ✅ Success Criteria

When you're done with all four exercises:

1. Open `http://localhost:8080/campaigns.html`
2. You see campaign cards with real data from the database
3. You can create a new campaign through the form
4. You can change a campaign's status with action buttons
5. You can delete a campaign with a confirmation prompt

**Congratulations — you've built a full three-tier application with GitHub Copilot!** 🎉

> **Tip:** If you get stuck on any exercise, solution files are available in the `solutions/` folder.

---

[← Back to Workshop Overview](../README.md) | [Next: Lab 5 — Testing & Quality →](../lab-05-testing-quality/)
