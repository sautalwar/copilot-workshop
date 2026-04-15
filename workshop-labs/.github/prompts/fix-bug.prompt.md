---
mode: 'agent'
description: 'Analyze and fix a bug in the application'
---

# Analyze and Fix a Bug

You are debugging the OutFront Media Order Management API. Follow a systematic approach to find and fix the issue.

## Step 1: Understand the Bug

- Read the bug description carefully
- Identify the **expected behavior** vs. the **actual behavior**
- Determine which layer is most likely affected (Controller, Service, Repository, or Model)
- Reproduce the issue mentally by tracing the code path

## Step 2: Identify Affected Files

- Start from the entry point (the controller endpoint) and trace through:
  - Controller method — is the request being mapped correctly?
  - Service method — is the business logic correct?
  - Repository query — is the data being fetched/persisted correctly?
  - Entity/Model — are the field mappings and validations correct?
- Check related configuration files (`application.properties`, `data.sql`)
- Look at exception handlers in `@ControllerAdvice` for swallowed errors

## Step 3: Root Cause Analysis

- Identify the exact line(s) of code causing the issue
- Understand **why** the bug exists, not just **where**
- Check for common issues:
  - Null pointer access on Optional values
  - Missing `@Transactional` causing lazy-loading exceptions
  - Incorrect query logic or missing WHERE clauses
  - Validation annotations not triggering (missing `@Valid`)
  - Wrong HTTP status codes being returned
  - Case sensitivity issues in comparisons or queries

## Step 4: Implement the Fix

- Make the **minimal change** needed to fix the bug
- Do not refactor unrelated code in the same change
- Ensure the fix follows project conventions:
  - Constructor injection
  - `ResponseEntity` return types
  - SLF4J logging
  - Javadoc on public methods

## Step 5: Add a Regression Test

- Write a test that **fails without the fix** and **passes with it**
- Name it descriptively: `shouldDoCorrectThing_whenBugCondition`
- Place it in the appropriate test class (controller test or service test)
- Cover the specific scenario that triggered the bug

## Step 6: Verify

Run the full test suite to ensure nothing is broken:

```bash
mvn test
```

## Checklist

- [ ] Root cause is identified and documented (in a code comment if subtle)
- [ ] Fix is minimal and targeted
- [ ] Regression test is added
- [ ] All existing tests still pass
- [ ] No `System.out.println` debugging left in the code
- [ ] Commit message follows format: `fix(scope): description of what was fixed`
