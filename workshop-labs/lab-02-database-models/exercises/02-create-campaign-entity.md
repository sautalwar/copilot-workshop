# Exercise 2 — Create the Campaign Entity with Copilot

⏱️ **Time:** ~10 minutes

🎯 **Objective:** Use Copilot Agent Mode to generate a new JPA entity for billboard advertising campaigns, following the same patterns as the existing entities.

---

## Steps

### 1. Prompt Copilot to create the entity

Open Copilot Chat in **Agent Mode** (look for the agent icon or use `@workspace`). Enter this prompt:

> "Create a new JPA entity called Campaign for billboard advertising campaigns. It should have: id (auto-generated Long), name (String, not null), client (String, company name), startDate and endDate (LocalDate), budget (BigDecimal), status (enum: DRAFT, ACTIVE, COMPLETED, CANCELLED), location (String, billboard location), createdAt (LocalDateTime, auto-set on creation). Follow the same pattern as Order.java in the model package."

Let Copilot generate the file(s). It should create the entity in:
`src/main/java/com/outfront/workshop/model/Campaign.java`

### 2. Review the generated entity

Check that Copilot's output includes:

- [ ] `@Entity` and `@Table(name = "campaign")` annotations
- [ ] `@Id` and `@GeneratedValue(strategy = GenerationType.IDENTITY)` on the `id` field
- [ ] `@Column(nullable = false)` on required fields (`name`, `client`)
- [ ] `@Enumerated(EnumType.STRING)` on the `status` field
- [ ] `BigDecimal` for the `budget` field (not `double` — precision matters for money)
- [ ] `LocalDate` for `startDate` and `endDate`
- [ ] `LocalDateTime` for `createdAt`
- [ ] A no-arg constructor and a convenience constructor
- [ ] Getters and setters for all fields

> 💡 **Tip:** If anything looks off, ask Copilot to fix it: "The budget field should be BigDecimal, not double" or "Add @Column(nullable = false) to the name field."

### 3. Check for the CampaignStatus enum

Copilot may have created the status enum in one of two ways:
- **Inline** inside `Campaign.java` (like `OrderStatus` is inside `Order.java`)
- **Separate file** as `CampaignStatus.java`

Either approach works. If Copilot didn't create the enum at all, ask:

> "Create a CampaignStatus enum with values DRAFT, ACTIVE, COMPLETED, CANCELLED in the model package."

### 4. Verify the conventions

Compare your new `Campaign.java` with `Order.java`. The patterns should match:

| Convention | Order.java | Campaign.java |
|-----------|------------|---------------|
| `@Entity` annotation | ✅ | Should have |
| `@Table` with name | `@Table(name = "orders")` | `@Table(name = "campaign")` |
| ID generation | `GenerationType.IDENTITY` | Should match |
| Enum storage | `EnumType.STRING` | Should match |
| No-arg constructor | ✅ | Should have |

> 💡 **Tip:** Copilot follows the conventions defined in `copilot-instructions.md` and the `.github/instructions/` files. This is why the generated code should already match the project style.

---

## ✅ Success Criteria

- `Campaign.java` exists in `src/main/java/com/outfront/workshop/model/`
- `CampaignStatus` enum exists (either inline or as a separate file)
- The entity follows the same JPA annotation pattern as `Order.java`
- The project still compiles: `mvn compile` runs without errors

## 📄 Solution

If you get stuck, compare your work with:
- [`solutions/Campaign.java`](../solutions/Campaign.java)
- [`solutions/CampaignStatus.java`](../solutions/CampaignStatus.java)
