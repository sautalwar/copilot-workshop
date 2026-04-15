# Exercise 1 — Write Controller Tests with Copilot

⏱️ **Time:** ~10 minutes

🎯 **Objective:** Use Copilot to generate integration tests for the Campaign REST API, following the same patterns as the existing Order and Inventory tests.

---

## Steps

### 1. Study the existing test pattern

Before asking Copilot to generate tests, take a quick look at how the existing tests work. Open:

- `src/test/java/com/outfront/workshop/OrderControllerTest.java`
- `src/test/java/com/outfront/workshop/InventoryControllerTest.java`

Notice the pattern:
- `@SpringBootTest` loads the full Spring context with H2
- `@AutoConfigureMockMvc` provides a `MockMvc` instance
- Each test method tests **one behavior** and follows `shouldDoSomething` naming
- Tests use `mockMvc.perform(...)` with `status()` and `jsonPath()` assertions

### 2. Prompt Copilot to generate Campaign controller tests

Open Copilot Chat in **Agent Mode** and enter this prompt:

> "Create a CampaignControllerTest class in `src/test/java/com/outfront/workshop/`. Use `@SpringBootTest` and `@AutoConfigureMockMvc` like the existing OrderControllerTest. Write tests for:
> 1. GET /api/campaigns returns all campaigns
> 2. GET /api/campaigns/{id} returns a specific campaign
> 3. POST /api/campaigns creates a new campaign
> 4. PUT /api/campaigns/{id}/status updates the campaign status
> 5. GET /api/campaigns/{id} returns 404 for a non-existent campaign
>
> Use realistic OutFront Media data — billboard campaign names, real client names, NYC locations."

### 3. Review the generated tests

Check that Copilot's output includes:

- [ ] `@SpringBootTest` and `@AutoConfigureMockMvc` annotations on the class
- [ ] `@Autowired MockMvc mockMvc` and `@Autowired ObjectMapper objectMapper`
- [ ] Descriptive test names like `shouldReturnAllCampaigns`, `shouldReturn404ForMissingCampaign`
- [ ] `mockMvc.perform(get(...))` with proper `status()` and `jsonPath()` assertions
- [ ] `MediaType.APPLICATION_JSON` on POST/PUT requests
- [ ] JSON body content created via `objectMapper.writeValueAsString(...)` or raw JSON strings

> 💡 **Tip:** If Copilot generates a test that uses `@WebMvcTest` instead, ask it to switch to `@SpringBootTest` + `@AutoConfigureMockMvc` to match the project convention. The difference matters — `@SpringBootTest` loads the full context including the database, while `@WebMvcTest` only loads the web layer.

### 4. Run the tests

```bash
mvn test -Dtest=CampaignControllerTest
```

If any tests fail, share the error with Copilot:

> "This test is failing with: [paste error]. Can you fix it?"

Copilot is great at debugging test failures — it can see the expected vs. actual values and adjust assertions accordingly.

### 5. Run all tests together

Make sure your new tests don't break anything:

```bash
mvn test
```

All tests (Order, Inventory, and Campaign) should pass.

---

## What You Learned

- **Integration tests** use a real Spring context and H2 database — they test the full request/response cycle
- Copilot can generate tests that follow your existing project patterns when it has good examples to reference
- The `@SpringBootTest` + `@AutoConfigureMockMvc` combination is the project standard for controller tests

---

## ✅ Success Criteria

- `CampaignControllerTest.java` exists in `src/test/java/com/outfront/workshop/`
- All 5+ controller tests pass when running `mvn test -Dtest=CampaignControllerTest`
- Test names follow the `shouldDoSomething` convention

## 📄 Solution

If you get stuck, compare your work with:
- [`solutions/CampaignControllerTest.java`](../solutions/CampaignControllerTest.java)
