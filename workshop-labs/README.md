# GitHub Copilot Workshop — Hands-On Labs

## Welcome

This repository contains the hands-on labs for the GitHub Copilot workshop. You'll work with a real Spring Boot application that manages orders and inventory for OutFront Media, an outdoor advertising company. Through these labs, you'll learn how to use GitHub Copilot effectively in your day-to-day work.

---

## Quick Start

Get the app running in three steps:

1. **Install prerequisites** — See [PREREQUISITES.md](PREREQUISITES.md) for Java, Maven, and other requirements
2. **Build the application** — `mvn clean verify -B`
3. **Start the app** — `mvn spring-boot:run` then visit `http://localhost:8080`

The app includes sample data and a web-based API explorer at `/swagger-ui.html`.

---

## What's In This Repo

| Path | What It Contains |
|------|-----------------|
| `src/` | Java source code for the Order Management System (Spring Boot application) |
| `.github/copilot-instructions.md` | Copilot's context about the OutFront Media project — this tells Copilot about architecture, conventions, and best practices |
| `.github/instructions/` | File-specific rules — how Copilot should handle Java files, SQL files, etc. |
| `.github/prompts/` | Reusable prompt templates for common tasks |
| `.github/chatmodes/` | Custom Copilot agents tailored for this project |
| `mcp-server/` | A Node.js server that connects Copilot to real data (Lab 6) |
| `workshop-prompts/` | Extra prompt templates and exercises for the labs |

---

## Labs Overview

You'll progressively build a **Campaign Management** feature — from database to frontend — entirely using agentic AI.

| Lab | Topic | Duration | What You'll Build |
|-----|-------|----------|-------------------|
| [Lab 1: Prompts, Skills & Agents](lab-01-prompts-skills-agents/) | Configure Copilot with custom instructions, prompts, and agents | ~45 min | `.github/` configuration files |
| [Lab 2: Database & Domain Models](lab-02-database-models/) | Create JPA entities, repositories, and seed data | ~30 min | `Campaign.java`, `CampaignRepository.java`, seed SQL |
| [Lab 3: Backend API Development](lab-03-backend-api/) | Build service layer, REST controller, validation, error handling | ~40 min | `CampaignService.java`, `CampaignController.java`, DTOs |
| [Lab 4: Frontend UI](lab-04-frontend-ui/) | Create an HTML/CSS/JS dashboard for campaigns | ~30 min | `campaigns.html` with full CRUD UI |
| [Lab 5: Testing & Quality](lab-05-testing-quality/) | Write integration tests, unit tests, and debug with Copilot | ~30 min | `CampaignControllerTest.java`, `CampaignServiceTest.java` |
| [Lab 6: MCP & Integrations](lab-06-mcp-integrations/) | Connect Copilot to live data with MCP tools | ~25 min | Campaign MCP tool in `mcp-server/` |

**Total workshop time:** ~3.5 hours (including breaks and discussion)

Each lab builds on the previous one. By the end, you'll have a fully working three-tier application — database, API, and frontend — built almost entirely through Copilot Agent Mode.

---

## About the Application

**OutFront Media** manages outdoor advertising — billboards, digital screens, and signage equipment. This workshop app is their Order Management System (OMS).

**Two main domains:**
- **Orders** — Customers place orders for billboard hardware. Orders move through statuses: PENDING → CONFIRMED → SHIPPED
- **Inventory** — Warehouse stock of products (LED panels, digital screens, etc.) tracked by SKU

**Key business rule:** When an order is confirmed, the system checks that enough inventory exists. If stock is low (fewer than 10 units), the order is rejected.

**Run the app and explore:**
- API documentation: `http://localhost:8080/swagger-ui.html`
- H2 database console: `http://localhost:8080/h2-console` (user: `sa`, no password)
- Sample data loads automatically on startup

---

## Workshop Structure

The workshop is organized in four parts:

| Part | Focus | Labs | Duration |
|------|-------|------|----------|
| Part 1: Foundations | How Copilot works and how to configure it | Lab 1 | ~45 min |
| Part 2: Hands-On Coding | Build a full-stack feature with Copilot | Labs 2, 3, 4 | ~100 min |
| Part 3: Testing & Integrations | Test your code and connect Copilot to live data | Labs 5, 6 | ~55 min |
| Part 4: Wrap Up | Questions and discussion | — | ~15 min |

Each lab builds on the previous one. Work through them in order.

---

## Need Help?

- **Setup problems?** Check [PREREQUISITES.md](PREREQUISITES.md)
- **Questions during the workshop?** Raise your hand — the facilitators are here to help
- **Stuck on a lab?** Each lab includes detailed instructions and hints
- **After the workshop?** Refer back to these labs and customize the Copilot configuration for your own projects

---

## Next Steps

Ready to begin? Start with [Lab 1: Prompts, Skills & Agents](lab-01-prompts-skills-agents/).
