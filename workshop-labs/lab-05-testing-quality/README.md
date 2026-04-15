# Lab 5 — Testing & Quality

🎯 **Objective:** Use GitHub Copilot to write comprehensive tests, find bugs, and debug issues in a Spring Boot application.

⏱️ **Duration:** ~30 minutes

## Why This Lab?

**Intent:** Code without tests is just a prototype. This lab teaches you how to use Copilot to build a real test suite — integration tests, unit tests, and bug-hunting — so your Campaign feature is production-ready.

**The value:** Testing is the part developers skip when they're under pressure. That's exactly when bugs sneak in. With a solid test suite, you catch regressions before they reach production, and you refactor with confidence knowing your safety net is in place.

**How agentic AI helps:** Writing tests is tedious and repetitive — set up mocks, call the method, assert the result, repeat for every edge case. Copilot reads your existing test files (`OrderControllerTest`, `InventoryControllerTest`), learns the patterns, and generates a full test suite that matches your conventions. It even knows which test annotations to use (`@SpringBootTest` vs `@ExtendWith(MockitoExtension.class)`) based on what layer you're testing. What takes an hour by hand, Copilot drafts in minutes.

## What You'll Build

In this lab, you'll use Copilot to create a full test suite for the Campaign feature you built in Labs 2–4. By the end, you'll have:

- **Controller tests** — Integration tests that hit real endpoints with MockMvc and an H2 database
- **Service tests** — Unit tests with Mockito mocks for fast, isolated verification
- **Bug-hunting skills** — Experience using Copilot to review code, find bugs, and apply fixes

This is where Copilot really shines: it knows your project conventions from `copilot-instructions.md` and can generate tests that follow the same patterns as `OrderControllerTest` and `InventoryControllerTest`.

## Prerequisites

- **Lab 3 completed** — You have a working `CampaignService` and `CampaignController`
- Java 17 and Maven installed
- The app builds cleanly: `mvn compile` from the project root
- Familiarity with Copilot Chat / Agent Mode in VS Code

## Exercises

| # | Exercise | Time | What You'll Do |
|---|----------|------|----------------|
| 1 | [Write Controller Tests](exercises/01-write-controller-tests.md) | ~10 min | Create integration tests for the Campaign API |
| 2 | [Write Service Tests](exercises/02-write-service-tests.md) | ~10 min | Create unit tests with Mockito mocks |
| 3 | [Debug with Copilot](exercises/03-debug-with-copilot.md) | ~10 min | Find and fix 3 intentional bugs using Copilot |

## Success Criteria

✅ `mvn test` passes with all new Campaign tests included

✅ You can explain the difference between controller tests (integration) and service tests (unit)

✅ You've seen Copilot find bugs using project convention awareness

## Quick Reference

| Resource | Location |
|----------|----------|
| Existing controller tests | `src/test/java/com/outfront/workshop/OrderControllerTest.java` |
| Existing controller tests | `src/test/java/com/outfront/workshop/InventoryControllerTest.java` |
| Campaign entity | `src/main/java/com/outfront/workshop/model/Campaign.java` |
| Campaign service | `src/main/java/com/outfront/workshop/service/CampaignService.java` |
| Campaign controller | `src/main/java/com/outfront/workshop/controller/CampaignController.java` |
| Solutions | [`solutions/`](solutions/) |
