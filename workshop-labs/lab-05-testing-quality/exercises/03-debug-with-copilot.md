# Exercise 3 — Find and Fix Bugs with Copilot

⏱️ **Time:** ~10 minutes

🎯 **Objective:** Use Copilot's code review capabilities to find 3 intentional bugs in a "buggy" service file, and understand how Copilot leverages project conventions to catch issues.

---

## Context

This exercise uses a deliberately buggy version of CampaignService. You'll copy it into your project, ask Copilot to review it, and watch it find the bugs — using knowledge of your project's conventions from `copilot-instructions.md`.

---

## Steps

### 1. Copy the buggy file into your project

Copy the starter file into your service package:

- **From:** `workshop-labs/lab-05-testing-quality/starter-files/BuggyCampaignService.java`
- **To:** `src/main/java/com/outfront/workshop/service/BuggyCampaignService.java`

You can do this manually or ask Copilot:

> "Copy the file `workshop-labs/lab-05-testing-quality/starter-files/BuggyCampaignService.java` into `src/main/java/com/outfront/workshop/service/`"

### 2. Read through the file yourself first

Open `BuggyCampaignService.java` and try to spot the issues. There are **3 intentional bugs** hiding in this file. Don't worry if you don't catch them all — that's what Copilot is for.

> 💡 **Hint:** Think about: default values, state transitions, and Spring annotations.

### 3. Ask Copilot to review the file

Open `BuggyCampaignService.java` in your editor, then ask Copilot:

> "Review BuggyCampaignService.java for bugs and issues. Compare it against the project conventions in copilot-instructions.md and the patterns used in OrderService.java."

Watch Copilot's response carefully. It should identify:

#### 🐛 Bug 1: NullPointerException on campaign creation

The `createCampaign` method doesn't set a default status. If a campaign is created without explicitly setting a status, it will be `null` — causing a `NullPointerException` downstream.

**The fix:** Default the status to `DRAFT` before saving, just like `OrderService` defaults orders to `PENDING`.

#### 🐛 Bug 2: Invalid status transition allowed

The `updateStatus` method allows `COMPLETED → ACTIVE`, which shouldn't be possible. Once a campaign is completed, it can't go back to active.

**The fix:** Add validation that rejects invalid transitions. Valid transitions should be: `DRAFT → ACTIVE`, `ACTIVE → COMPLETED`, `ACTIVE → CANCELLED`, `DRAFT → CANCELLED`.

#### 🐛 Bug 3: Missing @Transactional annotation

The `createCampaign` method modifies data but is missing the `@Transactional` annotation. This means the operation isn't wrapped in a database transaction — if something fails partway through, you could end up with inconsistent data.

**The fix:** Add `@Transactional` to write methods, and `@Transactional(readOnly = true)` to read methods, following the project conventions.

### 4. Ask Copilot to fix each bug

For each bug Copilot identified, ask it to apply the fix:

> "Fix all 3 bugs in BuggyCampaignService.java. Add the default status, fix the status transition validation, and add the missing @Transactional annotations."

Review each fix to make sure it makes sense.

### 5. Verify the app still compiles

```bash
mvn compile
```

### 6. Clean up (optional)

Once you've finished the exercise, you can remove `BuggyCampaignService.java` — it was just for learning:

```bash
# Remove the buggy file (your real CampaignService.java is untouched)
del src\main\java\com\outfront\workshop\service\BuggyCampaignService.java
```

---

## The "Aha Moment" 💡

This exercise demonstrates Copilot's most powerful quality feature: **convention-aware code review**.

Copilot didn't just find generic Java issues — it found bugs by comparing the code against:
- Your `copilot-instructions.md` (which says to use `@Transactional` on write methods)
- The existing `OrderService.java` pattern (which defaults status on creation)
- The `.github/instructions/*.md` files (which define Java coding standards)

This is why investing in good Copilot configuration (Lab 1) pays dividends throughout the project.

---

## ✅ Success Criteria

- All 3 bugs identified: missing default status, invalid transition, missing `@Transactional`
- Each bug fixed with Copilot's help
- `mvn compile` passes after fixes
- You understand how Copilot uses project context for code review

## 📄 Solution

If you get stuck, compare your work with:
- [`solutions/BuggyCampaignService-fixed.java`](../solutions/BuggyCampaignService-fixed.java)
