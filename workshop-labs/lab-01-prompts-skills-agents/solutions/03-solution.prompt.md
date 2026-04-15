---
mode: 'agent'
description: 'Add Bean Validation annotations to a model class'
---

# Add Bean Validation to a Model Class

You are adding validation annotations to a JPA entity in the OutFront Media Order Management API. The goal is to make sure invalid data gets caught at the API boundary — before it reaches the service layer or database.

## Step 1: Read the Model Class

- Open the target model class and read every field
- Understand the data types, nullable requirements, and business constraints
- Check existing annotations — don't duplicate what's already there

## Step 2: Add Validation Annotations

For each field, choose the right annotation:

| Annotation | Use When |
|---|---|
| `@NotNull` | The field must not be null |
| `@NotBlank` | String must not be null, empty, or whitespace-only |
| `@Size(min = X, max = Y)` | String length must be within a range |
| `@Min(value)` / `@Max(value)` | Numeric value must be within bounds |
| `@Positive` | Number must be greater than 0 |
| `@Email` | Must be a valid email format |
| `@Pattern(regexp = "...")` | Must match a regex pattern |

**Always add a custom message:**

```java
@NotBlank(message = "Customer name is required")
private String customerName;

@Positive(message = "Quantity must be greater than zero")
private Integer quantity;
```

## Step 3: Check the Controller

Open the corresponding controller class and verify:

- The `@RequestBody` parameter has `@Valid`:
  ```java
  @PostMapping
  public ResponseEntity<Order> createOrder(@Valid @RequestBody Order order) { ... }
  ```
- If `@Valid` is missing, add it — without it, the annotations won't do anything

## Step 4: Add Validation Tests

Create tests that send invalid data and expect a `400 Bad Request` response:

```java
@Test
void shouldReturnBadRequest_whenCustomerNameIsBlank() throws Exception {
    String invalidOrder = """
        {"customerName": "", "productName": "LED Panel", "quantity": 5}
        """;

    mockMvc.perform(post("/api/orders")
            .contentType(MediaType.APPLICATION_JSON)
            .content(invalidOrder))
        .andExpect(status().isBadRequest());
}
```

Test at least:
- A required field left blank or null
- A numeric field with a value out of range
- A string field that exceeds the max length

## Checklist

- [ ] Every non-nullable field has `@NotNull` or `@NotBlank`
- [ ] String fields have `@Size` constraints where appropriate
- [ ] Numeric fields have `@Min`, `@Max`, or `@Positive` where appropriate
- [ ] Every annotation has a custom `message`
- [ ] Controller uses `@Valid` on the request body
- [ ] Tests verify that invalid input returns 400
