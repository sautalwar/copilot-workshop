---
mode: 'agent'
description: 'Security review of OrderController for OWASP Top 10'
---

# Security Review — OWASP Top 10

## 📍 Workshop Section
Slide 17: DevSecOps | Part 5 — Proactive Security Analysis

## What This Does
Uses Copilot to perform a security review of the `OrderController` against the OWASP Top 10 vulnerabilities. This demonstrates how AI can help identify security issues before they reach production.

## Instructions
**For the AI Agent:**

Perform a comprehensive security review of `OrderController.java` in the OutFront Media Order Management API. Focus on identifying vulnerabilities from the OWASP Top 10 (2021).

### Security Checklist:

**1. A01:2021 – Broken Access Control**
- Are there any endpoints that don't verify user authorization?
- Can a user access or modify orders they don't own?
- Are there missing role-based access controls (e.g., only admins can delete orders)?

**2. A02:2021 – Cryptographic Failures**
- Are sensitive fields (e.g., customer data, payment info) properly encrypted?
- Are any credentials or API keys hardcoded in the controller?
- Is HTTPS enforced for sensitive endpoints?

**3. A03:2021 – Injection**
- Is user input properly validated and sanitized?
- Are there SQL injection risks in any query parameters?
- Are `@RequestParam` and `@PathVariable` values validated?
- Is there any use of `@Query` with concatenated strings?

**4. A04:2021 – Insecure Design**
- Is there proper rate limiting on bulk operations?
- Are there safeguards against denial-of-service (e.g., max file upload size)?
- Is there audit logging for sensitive operations (order creation, status changes)?

**5. A05:2021 – Security Misconfiguration**
- Are detailed error messages or stack traces exposed to clients?
- Is the Spring Boot actuator secured (if enabled)?
- Are CORS settings properly configured?

**6. A08:2021 – Software and Data Integrity Failures**
- Is there validation on deserialized objects (`@RequestBody`)?
- Are `@Valid` annotations present on all input DTOs?
- Is there protection against mass assignment vulnerabilities?

**7. A10:2021 – Server-Side Request Forgery (SSRF)**
- Does the controller accept URLs or make external requests based on user input?
- If so, is there allowlist validation?

### Deliverables:

1. **Findings Report:**
   - List each vulnerability found with:
     - **Severity:** Critical / High / Medium / Low
     - **Location:** File name and line number
     - **Description:** What the issue is
     - **Risk:** What could an attacker do?
     - **Recommendation:** How to fix it

2. **Code Fixes:**
   - For each HIGH or CRITICAL finding, provide the fix
   - Add input validation, sanitization, or security annotations as needed
   - Add comments explaining the security measures

3. **Test Coverage:**
   - Write security-focused tests for:
     - Invalid input injection attempts
     - Boundary value attacks (e.g., integer overflow)
     - Missing required fields
     - Malformed data

### Example Findings to Look For:
- Missing `@Valid` on `@RequestBody` parameters
- No max size limits on `quantity` field (could order 999999999 units)
- No rate limiting on order creation (could spam orders)
- Error responses that leak internal implementation details
- Accepting unvalidated enum values for `status` updates
- Missing authentication/authorization checks
- Potential SQL injection in custom queries

## Expected Outcome
After running this prompt, you should receive:
- ✅ A detailed security findings report with at least 3-5 vulnerabilities identified
- ✅ Code fixes for all HIGH/CRITICAL issues
- ✅ New validation annotations on DTOs
- ✅ Security-focused unit tests
- ✅ Documentation comments explaining security measures
- ✅ All tests pass after fixes: `mvn test`

## Try It
**For Workshop Attendees:**
1. **Before the review:**
   - Open `src/main/java/com/outfront/workshop/controller/OrderController.java`
   - Skim the code and try to spot security issues yourself

2. **Run the security review:**
   - Open Copilot Chat in Agent mode
   - Paste this prompt
   - Wait for the comprehensive analysis

3. **Review the findings:**
   - Read each vulnerability description carefully
   - Compare with your own findings
   - Understand the risk and recommended fix

4. **Apply the fixes:**
   - Let Copilot apply the recommended changes
   - Review the diff for each file
   - Run tests to ensure nothing broke

5. **Verify the fixes:**
   - Try to exploit the vulnerability after the fix (it should fail)
   - Example: Try sending a negative `quantity` in an order creation request:
     ```bash
     curl -X POST http://localhost:8080/api/orders \
       -H "Content-Type: application/json" \
       -d '{"customerName":"Hacker","productName":"LED Panel","quantity":-1,"status":"PENDING"}'
     ```
   - Expected: `400 Bad Request` with validation error

**Discussion Questions:**
- Which vulnerability type is most common in this codebase?
- Are there any findings that surprised you?
- What additional security measures could be added (authentication, authorization, audit logging)?
- How would you integrate this security review into your CI/CD pipeline?

**Bonus Challenge:**
Ask Copilot to generate a security test suite that verifies all the fixes are working correctly.
