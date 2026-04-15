# Exercise 4: Build a Reusable Skill

## 🎯 Objective

Create a prompt file that acts as a **multi-step skill** — instead of doing one thing, it guides Copilot through a complete workflow that creates multiple files in one go.

## ⏱️ Time: ~8 minutes

## Background

In Exercise 3, you created a prompt that does one thing (add validation). That's great for focused tasks. But sometimes you need Copilot to do a **whole sequence** of things — like scaffolding an entire new domain entity from scratch.

Think about what it takes to add a new "thing" to this project. If you wanted to add a `Campaign` entity to track billboard advertising campaigns, you'd need to:

1. Create a JPA entity class (`Campaign.java`)
2. Create a repository interface (`CampaignRepository.java`)
3. Create a service class (`CampaignService.java`)
4. Create a controller with CRUD endpoints (`CampaignController.java`)
5. Add seed data to `data.sql`

That's 5 files across 4 packages. A prompt that handles all of this at once? That's a **skill** — a prompt file with a bigger scope.

## Steps

### Step 1: Review existing prompts

Open the three prompt files in `.github/prompts/`:

- `add-endpoint.prompt.md` — Adds one endpoint (model → repo → service → controller → tests)
- `write-tests.prompt.md` — Writes tests for existing code
- `fix-bug.prompt.md` — Systematic bug fix workflow

Notice they're each focused on a single task. Your skill will combine multiple tasks into one workflow.

### Step 2: Create the skill file

Create: `.github/prompts/new-domain-entity.prompt.md`

Start with the front matter:

```yaml
---
mode: 'agent'
description: 'Scaffold a complete domain entity with model, repository, service, controller, and seed data'
---
```

### Step 3: Write the multi-step workflow

Your prompt body should guide Copilot through each layer. Here's the structure to follow — fill in the details:

**Part 1: The Entity Class**
- Create in `src/main/java/com/outfront/workshop/model/`
- Include JPA annotations (`@Entity`, `@Table`, `@Id`, `@GeneratedValue`)
- Add fields with proper types and validation annotations
- Include `created_at` and `updated_at` timestamps
- Generate getters, setters, and constructors

**Part 2: The Repository**
- Create in `src/main/java/com/outfront/workshop/repository/`
- Extend `JpaRepository`
- Add useful finder methods (e.g., `findByStatus`, `findByName`)

**Part 3: The Service**
- Create in `src/main/java/com/outfront/workshop/service/`
- Use constructor injection
- Add `@Transactional` and `@Transactional(readOnly = true)` appropriately
- Include create, read (by ID, list all), update, and delete methods
- Use `Optional<T>` for methods that might not find a result
- Create a custom "not found" exception

**Part 4: The Controller**
- Create in `src/main/java/com/outfront/workshop/controller/`
- Map CRUD operations to REST endpoints:
  - `GET /api/{entities}` — list all
  - `GET /api/{entities}/{id}` — get by ID
  - `POST /api/{entities}` — create new
  - `PUT /api/{entities}/{id}` — update
  - `DELETE /api/{entities}/{id}` — delete
- Return correct HTTP status codes (200, 201, 204, 404)
- Add `@Valid` on request bodies

**Part 5: Seed Data**
- Add INSERT statements to `src/main/resources/data.sql`
- Use realistic OutFront Media data (billboard campaigns, locations, equipment)

> **Tip:** Use descriptive headings in your prompt (like `## Step 1: Create the Entity`). Copilot follows the structure you give it.

Check the [solution](../solutions/04-solution.prompt.md) if you want to compare your approach.

### Step 4: Run your skill

1. Open the Command Palette → **Chat: Run Prompt File**
2. Select your new `new-domain-entity.prompt.md`
3. When prompted, tell Copilot: "Create a Campaign entity that tracks billboard advertising campaigns with fields for campaign name, client name, start date, end date, status, and budget"
4. Watch as Copilot generates the complete stack

### Step 5: Review the output

Check that Copilot generated:
- ✅ An entity class with JPA annotations and validation
- ✅ A repository with custom query methods
- ✅ A service with proper transaction annotations
- ✅ A controller with all CRUD endpoints
- ✅ Seed data in data.sql format

## ✅ Expected Outcome

You've created a reusable skill that scaffolds an entire domain entity stack from a single prompt. Any team member can run it with a different entity name (Campaign, Location, Billboard) and get consistent, well-structured code every time.

## Solution

Compare your skill file: [solutions/04-solution.prompt.md](../solutions/04-solution.prompt.md)

## Discussion Questions

1. **What's the boundary between a prompt file and a custom agent?** A prompt file is a task you run once — it produces output and you're done. An agent is a conversational partner you talk to back and forth. When does a prompt get complex enough that it should be an agent instead?

2. **How would you version and review skill files?** These are code that generates code. Should they be tested? How would you validate that a skill still produces good output after someone edits it?

3. **What complex workflows could become skills?** Think about:
   - Setting up a new microservice from a template
   - Adding authentication to an existing endpoint
   - Creating a database migration with rollback
   - Generating an API client from an OpenAPI spec

---

[← Previous: Use & Create Prompt Files](03-use-prompt-files.md) | [Next: Create a Custom Agent →](05-create-custom-agent.md)
