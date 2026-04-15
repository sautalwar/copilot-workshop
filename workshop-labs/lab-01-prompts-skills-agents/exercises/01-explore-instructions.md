# Exercise 1: Explore Custom Instructions

## 🎯 Objective

See how a single file — `.github/copilot-instructions.md` — changes everything Copilot says about your project.

## ⏱️ Time: ~10 minutes

## Background

When you open a project in VS Code, Copilot looks for a file called `.github/copilot-instructions.md`. If it finds one, it reads it before answering any of your questions. It's like giving a new team member a one-page briefing on your project before their first day.

Without instructions, Copilot knows Java and Spring Boot in general. **With** instructions, it knows that:
- This app is an Order Management System for OutFront Media (a billboard company)
- Orders go through PENDING → CONFIRMED → SHIPPED
- The team uses constructor injection, never `@Autowired` on fields
- Tests are named `shouldDoX_whenY`

## Steps

### Step 1: Read the instructions file

Open `.github/copilot-instructions.md` in VS Code.

Skim through each section. Notice how it covers:
- **Business Domain** — What the app does, in plain English
- **Tech Stack** — Java 17, Spring Boot, H2/SQL Server
- **Architecture** — The Controller → Service → Repository rule
- **Code Conventions** — Constructor injection, `Optional<T>`, `final` variables
- **Testing** — Test naming patterns, what tools to use

> **Think about it:** This file is teaching Copilot the same things you'd teach a new developer on day one.

### Step 2: Ask Copilot about a file

Open `src/main/java/com/outfront/workshop/controller/OrderController.java` in VS Code.

In Copilot Chat, ask:

```
Explain what this file does
```

Look at the response. Notice how Copilot:
- Mentions OutFront Media by name
- Describes orders in business terms (not just "REST endpoint")
- References the layered architecture (controller delegates to service)

### Step 3: Ask Copilot to write code

In the same chat, ask:

```
Add a new endpoint to get orders by status
```

Watch what Copilot generates. Check for:
- ✅ Does it follow Controller → Service → Repository? (It shouldn't put database logic in the controller)
- ✅ Does it use constructor injection?
- ✅ Does it return `ResponseEntity<T>`?
- ✅ Does it suggest a service method and repository query too?

### Step 4: See the difference without instructions

Now let's prove the instructions matter:

1. In your file explorer, rename `.github/copilot-instructions.md` to `.github/copilot-instructions.md.bak`
2. Reload VS Code (Ctrl+Shift+P → "Developer: Reload Window")
3. Open `OrderController.java` again
4. Ask the same question: "Add a new endpoint to get orders by status"
5. Compare this response to the earlier one

You'll likely notice:
- Less specific to OutFront Media's domain
- May not follow all the team's conventions
- More "generic Spring Boot" and less "our project"

### Step 5: Restore the file

**Important!** Rename it back:

1. Rename `.github/copilot-instructions.md.bak` → `.github/copilot-instructions.md`
2. Reload VS Code again

## ✅ Expected Outcome

You've seen that `copilot-instructions.md` is the single biggest lever for making Copilot useful on your project. One file, always active, shaping every interaction.

## Discussion Questions

1. **What if instructions say one thing but the code does another?** For example, the instructions say "use constructor injection" but some files use `@Autowired` on fields. Which does Copilot follow? (Try it!)

2. **How specific should instructions be?** If you write 10 pages of instructions, does Copilot follow them better — or does it get confused? What's the sweet spot?

3. **Who maintains this file?** Should it be one person? Reviewed like code? Updated every sprint?

> **Key takeaway:** Instructions are the foundation. Everything else in this lab builds on top of them.

---

[← Back to Lab 1 overview](../README.md) | [Next: Create Path-Scoped Instructions →](02-create-path-scoped.md)
