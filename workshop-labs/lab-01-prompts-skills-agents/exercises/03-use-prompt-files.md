# Exercise 3: Use & Create Prompt Files

## 🎯 Objective

Run existing prompt files and create your own reusable template — something any team member can run to get consistent results.

## ⏱️ Time: ~10 minutes

## Background

Instructions tell Copilot *how* to behave. Prompt files tell Copilot *what to do* — on demand.

Think of it this way:
- **Instructions** = "Always use constructor injection" (a rule Copilot follows automatically)
- **Prompt file** = "Here's a step-by-step recipe for adding a new REST endpoint" (a task you run when you need it)

Prompt files live in `.github/prompts/` and have a `.prompt.md` extension. They use YAML front matter (the `---` block at the top) to set the mode, followed by Markdown instructions.

## Steps

### Step 1: Run the "Add Endpoint" prompt

1. Open the VS Code Command Palette: **Ctrl+Shift+P** (or **Cmd+Shift+P** on Mac)
2. Type: **Chat: Run Prompt File**
3. Select `.github/prompts/add-endpoint.prompt.md`
4. When Copilot asks, provide context like: "Add a GET endpoint to find orders by customer name"

Watch what happens. The prompt file guides Copilot through a structured workflow:
- Check the model layer
- Add a repository method
- Add service logic
- Add the controller endpoint
- Write tests

> **Notice:** This isn't random Copilot output. It follows a defined, repeatable process.

### Step 2: Run the "Write Tests" prompt

1. Open a source file like `OrderController.java`
2. Run the prompt file: `.github/prompts/write-tests.prompt.md`
3. Observe how it analyzes the code first, then generates tests

Compare this to Exercise 1 where you just asked "add a test." The prompt file produces more thorough, structured output because it has a multi-step plan built in.

### Step 3: Look inside a prompt file

Open `.github/prompts/add-endpoint.prompt.md` in the editor (don't run it — just read it).

Notice the structure:

```yaml
---
mode: 'agent'
description: 'Add a new REST endpoint to the Spring Boot application'
---
```

- **`mode: 'agent'`** — Copilot can use tools (read files, search code) to complete the task
- **`description`** — A short label shown in the UI

Below the front matter is Markdown — the actual instructions Copilot follows. It reads like a checklist a developer would follow.

### Step 4: Create your own prompt file

Create a new file: `.github/prompts/add-validation.prompt.md`

**Purpose:** Add Bean Validation annotations to a JPA model class.

Start with the front matter:

```yaml
---
mode: 'agent'
description: 'Add Bean Validation annotations to a model class'
---
```

Then write the Markdown body. Your prompt should tell Copilot to:

1. **Read the model class** to understand the fields
2. **Add validation annotations** — choose from:
   - `@NotNull` — field must not be null
   - `@NotBlank` — string must not be null or empty
   - `@Size(min, max)` — string length limits
   - `@Min` / `@Max` — numeric bounds
   - `@Email` — valid email format
   - `@Pattern` — regex validation
3. **Add a custom validation message** for each annotation (not the default)
4. **Check the controller** — make sure `@Valid` is on the `@RequestBody` parameter
5. **Add validation failure tests** — test that invalid input returns 400 Bad Request

Give it your best shot. Check the [solution](../solutions/03-solution.prompt.md) if you want to compare.

### Step 5: Run your prompt file

1. Open `src/main/java/com/outfront/workshop/model/Order.java` (or `InventoryItem.java`)
2. Run your new prompt file via the Command Palette → **Chat: Run Prompt File**
3. Check the output:
   - ✅ Did it add appropriate annotations?
   - ✅ Did it include custom error messages?
   - ✅ Did it check for `@Valid` in the controller?
   - ✅ Did it suggest validation tests?

## ✅ Expected Outcome

You can create prompt files that package up multi-step workflows into a single, repeatable action. Any team member can run the same prompt and get consistent, structured results.

## Solution

Compare your prompt file: [solutions/03-solution.prompt.md](../solutions/03-solution.prompt.md)

## Discussion Questions

1. **Prompts vs instructions — when do you use each?**
   - Instructions: "Always validate `@RequestBody` with `@Valid`" (automatic rule)
   - Prompt: "Here's how to add validation to a model class" (on-demand task)
   - Rule of thumb: If it's a **convention**, use instructions. If it's a **task**, use a prompt.

2. **How would you share prompt files across teams?** These files are just Markdown in your repo. They go through code review like any other file. Could you have a shared library of prompt files across your organization?

3. **What repetitive tasks could become prompts?** Think about things your team does over and over:
   - Adding a new database migration
   - Creating a new microservice
   - Writing a changelog entry
   - Setting up a CI pipeline for a new repo

---

[← Previous: Create Path-Scoped Instructions](02-create-path-scoped.md) | [Next: Build a Reusable Skill →](04-create-skill.md)
