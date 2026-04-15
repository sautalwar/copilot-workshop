# Exercise 3 — Create the Campaign Repository

⏱️ **Time:** ~5 minutes

🎯 **Objective:** Use Copilot to generate a Spring Data JPA repository for the Campaign entity with custom query methods.

---

## Steps

### 1. Prompt Copilot to create the repository

In Copilot Chat, ask:

> "Create a Spring Data JPA repository for the Campaign entity with custom query methods for finding campaigns by status, by client, and by date range."

Copilot should create the file at:
`src/main/java/com/outfront/workshop/repository/CampaignRepository.java`

### 2. Review the generated repository

Check that it includes:

- [ ] `@Repository` annotation
- [ ] Extends `JpaRepository<Campaign, Long>`
- [ ] `findByStatus(CampaignStatus status)` — returns `List<Campaign>`
- [ ] `findByClient(String client)` or `findByClientContainingIgnoreCase(String client)` — returns `List<Campaign>`
- [ ] A date-based query like `findByStartDateBetween(LocalDate start, LocalDate end)` — returns `List<Campaign>`

> 💡 **Tip:** Spring Data JPA generates the SQL automatically from method names. `findByStatus` becomes `SELECT ... WHERE status = ?` — no query code needed.

### 3. Compare with the existing repositories

Open `OrderRepository.java` and `InventoryRepository.java` for reference:

| Pattern | OrderRepository | InventoryRepository | CampaignRepository |
|---------|----------------|--------------------|--------------------|
| Extends | `JpaRepository<Order, Long>` | `JpaRepository<InventoryItem, Long>` | Should extend `JpaRepository<Campaign, Long>` |
| Find by enum | `findByStatus(OrderStatus)` | — | Should have `findByStatus(CampaignStatus)` |
| Find by text | `findByCustomerNameContainingIgnoreCase` | `findByNameContainingIgnoreCase` | Should have similar for `client` |
| `@Repository` | ✅ | ✅ | Should have |

### 4. Verify it compiles

Run:

```bash
mvn compile
```

If there are import errors, ask Copilot to fix them. Common issues:
- Missing import for `CampaignStatus`
- Missing import for `LocalDate`
- Wrong package name

---

## ✅ Success Criteria

- `CampaignRepository.java` exists in `src/main/java/com/outfront/workshop/repository/`
- It extends `JpaRepository<Campaign, Long>`
- It has at least 3 custom query methods (by status, by client, by date range)
- `mvn compile` succeeds

## 📄 Solution

If you get stuck, compare with: [`solutions/CampaignRepository.java`](../solutions/CampaignRepository.java)
