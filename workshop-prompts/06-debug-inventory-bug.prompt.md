---
mode: 'agent'
description: 'Debug inventory validation race condition'
---

# Debug Inventory Validation Race Condition

## 📍 Workshop Section
Slide 11: Agent Mode | Part 3 — Debugging Complex Issues

## What This Does
Identifies and fixes a subtle race condition bug in the order confirmation flow where inventory can be oversold if multiple orders are confirmed simultaneously.

## Instructions
**For the AI Agent:**

There is a concurrency bug in the OutFront Media Order Management API. Under load, the system can confirm multiple orders for the same product even when there isn't enough inventory to fulfill all of them.

### Bug Scenario:
1. Two users try to confirm orders for "Digital Screen Unit 96x48" at the same time
2. Order A needs 15 units; Order B needs 15 units
3. Current inventory: 25 units available
4. **Expected behavior:** Only one order should be confirmed; the other should fail with "Insufficient inventory"
5. **Actual behavior:** Both orders get confirmed, resulting in -5 inventory

### Investigation Steps:

1. **Locate the Bug:**
   - Open `src/main/java/com/outfront/workshop/service/OrderService.java`
   - Find the `updateOrderStatus()` method
   - Identify where inventory validation happens

2. **Root Cause Analysis:**
   - The method is marked `@Transactional`, but is that enough?
   - Does the inventory check happen **inside** or **outside** the transaction?
   - Is there a READ → CHECK → WRITE pattern that could allow a race condition?
   - What happens if two transactions read inventory at the same time, both see 25 units, then both try to decrement?

3. **Fix the Bug:**
   - Implement one of these solutions:
     - **Option A:** Use pessimistic locking — `@Lock(LockModeType.PESSIMISTIC_WRITE)` on the inventory query
     - **Option B:** Use optimistic locking — add a `@Version` field to `InventoryItem` entity
     - **Option C:** Use database-level constraint — ensure inventory never goes negative with CHECK constraint
     - **Option D:** Use `SELECT FOR UPDATE` in a native query to lock the inventory row during the transaction

4. **Add a Regression Test:**
   - Write a test that simulates concurrent order confirmations
   - Use `CountDownLatch` or `ExecutorService` to run two threads simultaneously
   - Verify that one order succeeds and one fails
   - Test name: `shouldPreventOverselling_whenConcurrentOrdersConfirmed()`

### Hints:
- Look for any inventory decrement logic — is it atomic?
- Check if `InventoryService` exists and how it's called
- The fix should NOT require changing the database schema if possible
- The solution must maintain `@Transactional` for data consistency

## Expected Outcome
After running this prompt, you should have:
- ✅ Clear explanation of the root cause (race condition in inventory check)
- ✅ Code changes to prevent the race condition (pessimistic locking or optimistic locking)
- ✅ Updated `OrderService.java` or `InventoryService.java`
- ✅ New regression test in `OrderServiceTest.java` or integration test suite
- ✅ Documentation comment explaining the concurrency fix
- ✅ All tests pass: `mvn test`

## Try It
**For Workshop Attendees:**
1. **First, understand the current code:**
   - Open `src/main/java/com/outfront/workshop/service/OrderService.java`
   - Read the `updateOrderStatus()` method carefully
   - Identify the inventory validation logic

2. **Reproduce the bug mentally:**
   - Walk through what happens if two requests arrive at the same millisecond
   - Both read inventory = 25
   - Both check: 15 ≤ 25? Yes!
   - Both decrement: 25 - 15 = 10, then 10 - 15 = -5 💥

3. **Let Copilot fix it:**
   - Open Copilot Chat in Agent mode
   - Paste this prompt
   - Review the proposed solution

4. **Verify the fix:**
   - Run the new concurrency test
   - Manually test with concurrent curl requests (use `&` to background):
     ```bash
     curl -X PUT http://localhost:8080/api/orders/1/status?status=CONFIRMED &
     curl -X PUT http://localhost:8080/api/orders/2/status?status=CONFIRMED &
     wait
     ```
   - Check that inventory never goes negative

**Discussion Questions:**
- Which locking strategy did Copilot choose? Why?
- What are the trade-offs between pessimistic and optimistic locking?
- How would you test this in a real production environment?
