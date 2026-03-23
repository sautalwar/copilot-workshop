---
applyTo: "**/*.sql"
---

# SQL Code Instructions

## Compatibility

- Write **standard SQL** that is compatible with both **H2** (development) and **SQL Server** (production)
- Avoid database-specific functions or syntax unless absolutely necessary
- Do not use H2-only features like `AUTO_INCREMENT` — use `GENERATED ALWAYS AS IDENTITY` or `IDENTITY(1,1)`
- For SQL Server-specific scripts, use `IF NOT EXISTS` guards for idempotent execution
- Prefer `NVARCHAR` over `VARCHAR` in SQL Server DDL for Unicode support

## Query Style

- Use **UPPER_CASE** for all SQL keywords:
  ```sql
  SELECT order_id, customer_name, status
  FROM orders
  WHERE status = 'ACTIVE'
  ORDER BY created_at DESC;
  ```
- Always use **explicit column names** — never use `SELECT *`
- Use **meaningful aliases** when joining tables:
  ```sql
  SELECT o.order_id, o.customer_name, li.product_name, li.quantity
  FROM orders o
  INNER JOIN line_items li ON o.order_id = li.order_id
  WHERE o.status = 'ACTIVE';
  ```

## Naming Conventions

- Use **snake_case** for table and column names: `order_id`, `customer_name`, `created_at`
- Use singular nouns for table names where practical: `order`, `line_item`, `customer`
  - Plural is acceptable if the team already uses it (e.g., `orders`, `line_items`)
- Prefix boolean columns with `is_` or `has_`: `is_active`, `has_shipped`

## Schema Design

- Always define a **primary key** on every table
- Use **foreign key constraints** to enforce referential integrity
- Include `created_at` and `updated_at` timestamp columns on transactional tables
- Add **NOT NULL** constraints on columns that should always have a value

## Comments

- Add comments for complex queries explaining the business logic:
  ```sql
  -- Retrieve all active orders placed in the last 30 days
  -- that have at least one line item with quantity > 10.
  SELECT o.order_id, o.customer_name
  FROM orders o
  INNER JOIN line_items li ON o.order_id = li.order_id
  WHERE o.status = 'ACTIVE'
    AND o.created_at >= CURRENT_DATE - 30
  GROUP BY o.order_id, o.customer_name
  HAVING MAX(li.quantity) > 10;
  ```

## Seed Data (data.sql)

- Include realistic sample data that reflects OutFront Media's business domain (orders, campaigns, billboard locations)
- Add comments grouping related seed data
- Use consistent date formats: `'YYYY-MM-DD'` or `'YYYY-MM-DD HH:MM:SS'`
