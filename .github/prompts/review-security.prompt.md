---
mode: ask
description: "Review code for security vulnerabilities and suggest fixes"
---

# Security Code Review

Review the selected code for security vulnerabilities. Check for:

## Critical Issues (must fix)
- [ ] **SQL Injection** — Any string concatenation in SQL queries?
- [ ] **XSS** — Any unescaped user input rendered in HTML?
- [ ] **Hardcoded Secrets** — Any API keys, passwords, or tokens in code?
- [ ] **Path Traversal** — Any file operations using unsanitized user input?
- [ ] **Command Injection** — Any `exec()` or `spawn()` with user input?

## High Priority
- [ ] **Missing Authentication** — Are endpoints properly protected?
- [ ] **Missing Authorization** — Are role checks in place?
- [ ] **PII Exposure** — Is sensitive data being logged or returned unmasked?
- [ ] **Insecure Dependencies** — Are there known vulnerable packages?

## Medium Priority
- [ ] **Missing Input Validation** — Are all inputs validated with schemas?
- [ ] **Error Information Leakage** — Do error responses expose internals?
- [ ] **Missing Rate Limiting** — Are public endpoints rate-limited?
- [ ] **CORS Misconfiguration** — Is CORS overly permissive?

For each issue found, provide:
1. **Severity** (Critical / High / Medium)
2. **Location** (file and line)
3. **Description** of the vulnerability
4. **Fix** with corrected code
