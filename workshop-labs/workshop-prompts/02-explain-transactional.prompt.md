---
mode: 'agent'
description: 'Ask Copilot to explain @Transactional annotation in context'
---

# Explain @Transactional Annotation

## 📍 Workshop Section
Slide 10: Chat & Inline Edit | Part 2 — Understanding Code with Copilot Chat

## What This Does
Uses Copilot Chat to get a contextual explanation of the `@Transactional` annotation and why it's used on service methods in this Spring Boot application.

## Instructions
**For the AI Agent:**

1. Open `src/main/java/com/outfront/workshop/service/OrderService.java`
2. Locate the `updateOrderStatus()` method which has `@Transactional` annotation
3. Select the entire method (including the annotation)
4. Ask Copilot Chat:
   ```
   Explain why @Transactional is used on this method. What would happen if we removed it?
   ```

## Expected Outcome
Copilot should explain:
- **Database Transaction Management:** Ensures all database operations in the method succeed or fail together (atomicity)
- **Inventory Check Logic:** The method updates order status AND checks inventory — both must happen in one transaction
- **Rollback Behavior:** If inventory check fails, the order status change is rolled back automatically
- **Without @Transactional:** 
  - Order status might be updated even if inventory validation fails
  - No automatic rollback on exceptions
  - Potential data inconsistency between orders and inventory

## Try It
**For Workshop Attendees:**
1. Open `src/main/java/com/outfront/workshop/service/OrderService.java` in VS Code
2. Find the `updateOrderStatus()` method (around line 60)
3. Highlight the entire method including the `@Transactional` annotation
4. Open Copilot Chat (`Ctrl+Shift+I` or `Cmd+Shift+I`)
5. Type: "Explain why @Transactional is used on this method. What would happen if we removed it?"
6. Read the explanation and compare it with the business rule about inventory validation

**Bonus:** Ask a follow-up question: "Should updateOrderStatus use @Transactional(readOnly = true)? Why or why not?"
