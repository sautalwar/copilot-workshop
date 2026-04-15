---
mode: 'agent'
description: 'Generate a method to find orders placed today'
---

# Find Orders Placed Today

## 📍 Workshop Section
Slide 9: Code Completions | Part 1 — Comment-Driven Development

## What This Does
Generates a new service method `findOrdersPlacedToday()` in `OrderService.java` by writing a descriptive comment and letting Copilot suggest the implementation.

## Instructions
**For the AI Agent:**

1. Open `src/main/java/com/outfront/workshop/service/OrderService.java`
2. After the existing `findByStatus()` method, add the following comment:
   ```java
   /**
    * Retrieves all orders placed today (based on order_date).
    *
    * @return list of orders with today's date
    */
   ```
3. Let Copilot suggest the method signature and implementation
4. The method should:
   - Be named `findOrdersPlacedToday()`
   - Return `List<Order>`
   - Use `@Transactional(readOnly = true)`
   - Call a new repository method `findByOrderDate(LocalDate date)`
5. Add the corresponding repository method to `OrderRepository.java`:
   ```java
   List<Order> findByOrderDate(LocalDate orderDate);
   ```

## Expected Outcome
You should see:
- A new method in `OrderService.java` that gets today's date using `LocalDate.now()` and calls the repository
- A new derived query method in `OrderRepository.java` that finds orders by exact date
- Both methods follow the project's coding conventions (constructor injection, `@Transactional(readOnly=true)`)

## Try It
**For Workshop Attendees:**
1. Open `src/main/java/com/outfront/workshop/service/OrderService.java` in VS Code
2. Position your cursor after the last method in the class
3. Type the Javadoc comment shown above
4. Press `Enter` and wait for Copilot to suggest the method implementation
5. Press `Tab` to accept the suggestion
6. Repeat for the repository method in `OrderRepository.java`
7. Run `mvn compile` to verify the code compiles
