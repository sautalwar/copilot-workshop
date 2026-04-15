# Exercise 2 — Write Service Tests with Mockito

⏱️ **Time:** ~10 minutes

🎯 **Objective:** Use Copilot to generate unit tests for CampaignService using Mockito mocks, and understand the difference between integration tests and unit tests.

---

## Steps

### 1. Understand why service tests are different

In Exercise 1, your controller tests loaded the entire Spring context — database, services, repositories, everything. That's great for end-to-end confidence, but it's slow.

**Service tests** take a different approach:
- They test the service class **in isolation** — no Spring context, no database
- Dependencies (like `CampaignRepository`) are replaced with **Mockito mocks**
- They run in milliseconds instead of seconds
- They verify **business logic** without worrying about HTTP or database concerns

### 2. Prompt Copilot to generate Campaign service tests

Open Copilot Chat in **Agent Mode** and enter this prompt:

> "Create a CampaignServiceTest class in `src/test/java/com/outfront/workshop/`. Use `@ExtendWith(MockitoExtension.class)` with `@Mock` for CampaignRepository and `@InjectMocks` for CampaignService. Write tests for:
> 1. Creating a campaign sets status to DRAFT
> 2. Getting a campaign by valid ID returns the campaign
> 3. Getting all campaigns returns the full list
> 4. Updating campaign status with a valid transition succeeds
> 5. Updating status with an invalid transition (e.g., COMPLETED → ACTIVE) throws an exception
> 6. Deleting a campaign calls the repository
> 7. Getting a non-existent campaign by ID throws an exception
>
> Each test should test ONE behavior. Use descriptive method names like shouldSetStatusToDraft_whenCreatingCampaign."

### 3. Review the generated tests

Check that Copilot's output includes:

- [ ] `@ExtendWith(MockitoExtension.class)` on the class (not `@SpringBootTest`)
- [ ] `@Mock CampaignRepository campaignRepository`
- [ ] `@InjectMocks CampaignService campaignService`
- [ ] `when(...).thenReturn(...)` for stubbing repository methods
- [ ] `verify(...)` to confirm repository methods were called
- [ ] `assertThrows(...)` for error scenarios
- [ ] Each test method tests exactly **one behavior**

> 💡 **Tip:** If Copilot generates tests that don't match your actual CampaignService methods, open `CampaignService.java` alongside the test file and ask Copilot to regenerate. It works best when it can see both files.

### 4. Compare the two test styles

Take a moment to appreciate the difference:

| Aspect | Controller Tests (Ex. 1) | Service Tests (Ex. 2) |
|--------|--------------------------|----------------------|
| Annotation | `@SpringBootTest` | `@ExtendWith(MockitoExtension.class)` |
| Spring context | Full (slow) | None (fast) |
| Database | Real H2 | Mocked |
| What's tested | HTTP → Controller → Service → DB | Service logic only |
| Dependencies | Real beans | Mockito mocks |
| Speed | Seconds | Milliseconds |

Both are valuable. Controller tests catch integration issues (wrong URL mappings, serialization bugs). Service tests catch business logic bugs quickly.

### 5. Run the service tests

```bash
mvn test -Dtest=CampaignServiceTest
```

Then run everything together:

```bash
mvn test
```

---

## What You Learned

- **Unit tests with Mockito** isolate business logic from infrastructure
- `@Mock` creates fake dependencies; `@InjectMocks` wires them into the class under test
- `when().thenReturn()` stubs behavior; `verify()` confirms interactions
- Copilot generates both test styles fluently when given clear instructions

---

## ✅ Success Criteria

- `CampaignServiceTest.java` exists in `src/test/java/com/outfront/workshop/`
- All 7+ service tests pass when running `mvn test -Dtest=CampaignServiceTest`
- You can explain the difference between controller tests (integration) and service tests (unit)

## 📄 Solution

If you get stuck, compare your work with:
- [`solutions/CampaignServiceTest.java`](../solutions/CampaignServiceTest.java)
