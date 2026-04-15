# Exercise 2: Create Path-Scoped Instructions

## 🎯 Objective

Create instructions that only apply to certain files — so your Java rules don't interfere with your SQL rules, and your test rules don't interfere with your production code.

## ⏱️ Time: ~10 minutes

## Background

The repo-level `copilot-instructions.md` applies to everything. But sometimes you need different rules for different files:
- Java files should follow constructor injection patterns
- SQL files should use UPPER_CASE keywords
- Test files should use specific naming patterns and test frameworks

That's what **path-scoped instructions** do. Each file lives in `.github/instructions/` and has a header that says "only apply me when the user is editing files that match this pattern."

## Steps

### Step 1: Examine the existing Java instructions

Open `.github/instructions/java.instructions.md`.

Notice the header at the top:

```yaml
---
applyTo: "**/*.java"
---
```

This means: "Apply these instructions whenever someone is editing **any** `.java` file, anywhere in the project."

Skim the content. It covers Java-specific rules like:
- Use `final` on variables that don't change
- Use Java records for DTOs
- Constructor injection, never `@Autowired`

### Step 2: Examine the SQL instructions

Open `.github/instructions/sql.instructions.md`.

Notice its header targets `**/*.sql` files. It has completely different rules:
- UPPER_CASE SQL keywords
- snake_case table names
- Compatibility with both H2 and SQL Server

> **The key idea:** Each instruction file has its own scope. Java rules stay with Java files. SQL rules stay with SQL files.

### Step 3: Create test-specific instructions

Now it's your turn. Create a new file:

**File:** `.github/instructions/test.instructions.md`

Start with the `applyTo` header:

```yaml
---
applyTo: "**/*Test.java"
---
```

This targets only files ending in `Test.java` — your test classes.

### Step 4: Write the instructions

Below the header, add rules that tell Copilot how your team writes tests. Think about:

- **Test method names:** `shouldDoSomething_whenCondition` (not `test1`, not `testOrder`)
- **Controller tests:** Use `@SpringBootTest` with `@AutoConfigureMockMvc` and `MockMvc`
- **Service tests:** Use `@ExtendWith(MockitoExtension.class)` with `@Mock` and `@InjectMocks`
- **Coverage:** Always include a happy-path test, an error/not-found test, and a validation failure test
- **Assertions:** Verify both the HTTP status code and the response body content

Give it your best shot. If you need a hint, check the [solution file](../solutions/02-solution.instructions.md).

### Step 5: Test your instructions

Open one of the existing test files, like `src/test/java/com/outfront/workshop/controller/OrderControllerTest.java`.

In Copilot Chat, ask:

```
Add a test for the delete endpoint
```

Check the generated code:
- ✅ Does the method name follow `shouldDoX_whenY`?
- ✅ Does it use `MockMvc` for the HTTP call?
- ✅ Does it test both the success case (204) and the not-found case (404)?

### Step 6: Compare with a non-test file

Open a regular Java file (like `OrderController.java`) and ask Copilot to generate something. Notice that your test-specific instructions **don't** interfere — they only activate for `*Test.java` files.

## ✅ Expected Outcome

You've created a path-scoped instruction file that changes how Copilot writes test code — without affecting anything else. The Java instructions and test instructions work together: Java rules handle the language basics, test rules add testing-specific patterns on top.

## Solution

If you want to compare your version: [solutions/02-solution.instructions.md](../solutions/02-solution.instructions.md)

## Discussion Questions

1. **Path-scoped vs repo-level — when do you use each?** Repo-level is for things that apply everywhere (business domain, architecture). Path-scoped is for things that only matter for certain file types. What about things like "use camelCase" — where do those go?

2. **Can path-scoped instructions override repo-level ones?** What happens if `copilot-instructions.md` says "use `@WebMvcTest`" but `test.instructions.md` says "use `@SpringBootTest`"? Try it and see.

3. **What patterns would your team use?** Think about your real codebase. Would you have instructions for:
   - `**/*.tsx` — React component conventions?
   - `**/migrations/*.sql` — Database migration rules?
   - `**/*.config.*` — Configuration file patterns?
   - `**/docs/**` — Documentation style?

---

[← Previous: Explore Custom Instructions](01-explore-instructions.md) | [Next: Use & Create Prompt Files →](03-use-prompt-files.md)
