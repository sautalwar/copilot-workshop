# Exercise 1 — Explore the Existing Data Model

⏱️ **Time:** ~8 minutes

🎯 **Objective:** Understand how JPA entities map to database tables and see live data in the H2 console before building anything new.

---

## Steps

### 1. Look at the existing entities

Open these two files side by side in VS Code:

- `src/main/java/com/outfront/workshop/model/Order.java`
- `src/main/java/com/outfront/workshop/model/InventoryItem.java`

Scan through them and notice the pattern:
- `@Entity` and `@Table` at the class level
- `@Id` and `@GeneratedValue` on the primary key
- `@Column(nullable = false)` on required fields
- `@Enumerated(EnumType.STRING)` for enum fields
- A no-arg constructor (required by JPA) plus a convenience constructor
- Standard getters and setters

### 2. Ask Copilot to explain the annotations

Open Copilot Chat and ask:

> "Explain the JPA annotations in Order.java — what does each one do and why is it needed?"

Read through the explanation. Pay attention to:
- How `@Table(name = "orders")` controls the table name
- How `@GeneratedValue(strategy = GenerationType.IDENTITY)` auto-generates IDs
- How `@Enumerated(EnumType.STRING)` stores enum values as text, not numbers

### 3. Ask about the entity-to-database relationship

Ask Copilot:

> "What is the relationship between these JPA entities and the database? How does Spring Boot create the tables?"

Key takeaway: Hibernate's `ddl-auto` setting creates tables automatically from entity classes on startup. The field names map to column names using Spring's naming strategy (camelCase → snake_case).

### 4. Look at the seed data

Open `src/main/resources/data.sql` and notice:
- INSERT statements use **snake_case** column names (e.g., `customer_name`, `order_date`)
- The Java fields are **camelCase** (e.g., `customerName`, `orderDate`)
- Spring/Hibernate handles the mapping automatically
- SQL keywords are UPPER_CASE, values use proper date formats

### 5. Open the H2 console

1. Make sure the app is running: `mvn spring-boot:run` from the `workshop-labs/` directory
2. Open your browser to: **http://localhost:8080/h2-console**
3. Enter the connection details:
   - **JDBC URL:** `jdbc:h2:mem:omsdb`
   - **User Name:** `sa`
   - **Password:** *(leave blank)*
4. Click **Connect**

### 6. Query the existing data

In the SQL input box, run:

```sql
SELECT id, customer_name, product_name, status FROM orders;
```

You should see 5 order rows. Now try:

```sql
SELECT id, sku, name, quantity, location FROM inventory_item;
```

You should see 10 inventory items.

> 💡 **Tip:** Notice how the table names and column names in SQL match the `@Table` and `@Column` annotations (or the auto-generated snake_case versions) — not the Java field names.

---

## ✅ Success Criteria

- You can see 5 orders and 10 inventory items in the H2 console
- You understand how `@Entity` classes map to database tables
- You understand how `data.sql` seeds the database on startup
