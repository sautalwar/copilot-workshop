# Lab 2 — Database & Domain Models

🎯 **Objective:** Use GitHub Copilot to create a complete database layer — JPA entity, repository, and seed data — for a new `Campaign` domain in the OutFront Media OMS.

⏱️ **Duration:** ~30 minutes

## What You'll Build

A new **Campaign** entity representing billboard advertising campaigns. By the end of this lab, you'll have:

- A `Campaign` JPA entity with fields for name, client, dates, budget, status, and location
- A `CampaignStatus` enum (DRAFT, ACTIVE, COMPLETED, CANCELLED)
- A `CampaignRepository` with custom query methods
- Seed data with 5 realistic campaigns visible in the H2 console

This entity will be extended in Labs 3–4 with a service layer, REST API, and frontend dashboard.

## Why This Lab?

**Intent:** Every application starts with data. This lab teaches you how to use Copilot to design and build your database layer — entities, repositories, and sample data — in minutes instead of hours.

**The value:** Creating JPA entities by hand means remembering annotations, naming conventions, and SQL compatibility rules. One mistake and your app won't start. With Copilot, you describe what you want in plain English, and it generates entity classes that follow your project's exact conventions.

**How agentic AI helps:** Copilot Agent Mode doesn't just auto-complete — it reads your existing entities (Order, InventoryItem), understands the patterns, and generates a new Campaign entity that matches perfectly. It's like pair-programming with someone who's already memorized every file in your project.

## Prerequisites

- **Lab 1 completed** OR the `workshop-labs/` app builds and runs successfully
- Java 17 and Maven installed
- The app running locally: `mvn spring-boot:run` from the `workshop-labs/` directory
- Familiarity with opening files and using Copilot Chat / Agent Mode in VS Code

## Exercises

| # | Exercise | Time | What You'll Do |
|---|----------|------|----------------|
| 1 | [Explore Existing Models](exercises/01-explore-existing-models.md) | ~8 min | Understand the JPA pattern and H2 console |
| 2 | [Create Campaign Entity](exercises/02-create-campaign-entity.md) | ~10 min | Build a new JPA entity with Copilot |
| 3 | [Create Repository](exercises/03-create-repository.md) | ~5 min | Add a Spring Data repository with custom queries |
| 4 | [Add Seed Data](exercises/04-add-seed-data.md) | ~7 min | Insert realistic campaign data into `data.sql` |

## Success Criteria

✅ Campaign data is visible in the H2 console at `localhost:8080/h2-console`

✅ Running `SELECT * FROM campaign` returns 5 rows with different statuses

✅ The app starts without errors after all changes

## Quick Reference

| Resource | Location |
|----------|----------|
| H2 Console | `http://localhost:8080/h2-console` |
| JDBC URL | `jdbc:h2:mem:omsdb` |
| Username | `sa` |
| Password | *(leave blank)* |
| Existing entities | `src/main/java/com/outfront/workshop/model/` |
| Seed data | `src/main/resources/data.sql` |
| Solutions | [`solutions/`](solutions/) |
