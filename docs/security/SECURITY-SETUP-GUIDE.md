# Security Guardrails — Complete Setup Guide

> **For the OutFront Media Development Team**
> A step-by-step guide to implementing security at every stage of your development workflow — from repository creation to production deployment.

---

## Table of Contents

1. [Repository Security Setup](#1-repository-security-setup)
2. [CodeQL Setup — Static Analysis](#2-codeql-setup--static-analysis)
3. [Dependabot Setup — Dependency Management](#3-dependabot-setup--dependency-management)
4. [Secret Scanning Setup](#4-secret-scanning-setup)
5. [MCP Server Security](#5-mcp-server-security)
6. [Unit Test Security](#6-unit-test-security)
7. [End-to-End Security Workflow](#7-end-to-end-security-workflow)
8. [Quick Reference Checklists](#8-quick-reference-checklists)

---

## 1. Repository Security Setup

> **When:** Every time you create a new repository
> **Time:** 15 minutes
> **Who:** Repo creator or admin

### 1.1 Enable Branch Protection Rules

**Where:** Repository → `Settings` → `Branches` → `Add branch protection rule`

**What it does:** Prevents direct pushes to main. All changes must go through a pull request with reviews and passing CI checks.

**Why it matters:** Without branch protection, any developer can push directly to main — bypassing code review, tests, and security scans. One bad push can take down production.

**Setup steps:**
1. Navigate to your repository on GitHub
2. Click `Settings` → `Branches` (left sidebar)
3. Click `Add branch protection rule`
4. Set "Branch name pattern" to `main`
5. Enable these settings:
   - ✅ **Require a pull request before merging**
     - ✅ Require approvals: `1` (minimum)
     - ✅ Dismiss stale pull request approvals when new commits are pushed
   - ✅ **Require status checks to pass before merging**
     - Search and add: `Build & Test`, `OWASP Dependency Check`
     - ✅ Require branches to be up to date before merging
   - ✅ **Require conversation resolution before merging**
   - ✅ **Do not allow bypassing the above settings**
     - Even admins must follow the rules
6. Click `Create`

**How to verify:** Try pushing directly to main — it should be rejected.

---

### 1.2 Set Up CODEOWNERS File

**Where:** `.github/CODEOWNERS` in the repository

**What it does:** Automatically assigns reviewers based on which files are changed. Security-sensitive files get additional reviewers.

**Why it matters:** Ensures security-critical code (CI workflows, MCP server, security policies) is always reviewed by the right people.

**Setup:** See the `.github/CODEOWNERS` file in this repository.

**How to verify:** Create a PR that modifies a workflow file — the CODEOWNERS should be automatically requested as reviewers.

---

### 1.3 Enable Secret Scanning

**Where:** Repository → `Settings` → `Code security and analysis`

**What it does:** Automatically scans your repository for accidentally committed secrets (API keys, passwords, tokens).

**Why it matters:** A leaked AWS access key can be exploited within minutes. GitHub partners with service providers to automatically revoke detected secrets.

**Setup steps:**
1. Navigate to `Settings` → `Code security and analysis`
2. Under "Secret scanning":
   - Click `Enable` for "Secret scanning"
3. Enable push protection (if available):
   - This **blocks pushes** that contain secrets BEFORE they enter the repo
   - This is the most powerful prevention mechanism

**How to verify:** Try committing a file with a test secret pattern — push protection should block it.

---

### 1.4 Enable Dependabot Alerts

**Where:** Repository → `Settings` → `Code security and analysis`

**What it does:** Monitors your dependencies for known vulnerabilities (CVEs) and alerts you immediately.

**Why it matters:** ~80% of application code comes from dependencies. A vulnerability in a popular library (like Log4Shell) affects thousands of applications.

**Setup steps:**
1. Navigate to `Settings` → `Code security and analysis`
2. Under "Dependabot":
   - Click `Enable` for "Dependabot alerts"
   - Click `Enable` for "Dependabot security updates" (auto-creates fix PRs)
3. Add `.github/dependabot.yml` for version updates (see [Section 3](#3-dependabot-setup--dependency-management))

**How to verify:** Go to `Security` → `Dependabot alerts` — you should see any existing vulnerability alerts.

---

### 1.5 Add CI/CD Workflows

**Where:** `.github/workflows/` directory

**What it does:** Automated build, test, and security checks on every push and PR.

**Why it matters:** Without automated checks, security depends entirely on manual review — which is inconsistent, slow, and error-prone.

**Files to add:**
| File | Purpose |
|------|---------|
| `ci.yml` | Build, test, OWASP dependency check |
| `codeql.yml` | Static analysis for security vulnerabilities |
| `secret-scanning.yml` | Gitleaks secret detection |
| `mcp-security.yml` | MCP server validation |
| `dependabot-auto-merge.yml` | Auto-merge safe dependency updates |

All of these files are provided in this repository's `.github/workflows/` directory.

---

### 1.6 Add a SECURITY.md Policy

**Where:** `SECURITY.md` in the repository root

**What it does:** Tells security researchers how to responsibly report vulnerabilities.

**Why it matters:** Without a security policy, vulnerability reporters might go public instead of contacting you privately.

**Setup:** See the `SECURITY.md` file in this repository.

---

### 1.7 Repository Setup Checklist

Use this checklist every time you create a new repository:

- [ ] Branch protection enabled on `main`
- [ ] CODEOWNERS file created
- [ ] Secret scanning enabled
- [ ] Push protection enabled
- [ ] Dependabot alerts enabled
- [ ] Dependabot security updates enabled
- [ ] `dependabot.yml` configured
- [ ] CI workflow added (`ci.yml`)
- [ ] CodeQL workflow added (`codeql.yml`)
- [ ] Secret scanning workflow added (`secret-scanning.yml`)
- [ ] `SECURITY.md` added
- [ ] `.gitignore` includes sensitive file patterns

---

## 2. CodeQL Setup — Static Analysis

### 2.1 What Is CodeQL?

CodeQL is GitHub's **semantic code analysis engine**. Unlike simple pattern matching (grep for "password"), CodeQL understands your code's structure:

- It traces **data flow** from user input to dangerous functions (sinks)
- It understands **call chains** across multiple methods and files
- It knows **Java/Spring Boot patterns** and their security implications
- It can find vulnerabilities that no amount of manual review would catch

### 2.2 Prerequisites

- GitHub repository with Actions enabled
- Java 17+ project with Maven build
- For private repos: GitHub Advanced Security (GHAS) license

### 2.3 Step-by-Step Setup

#### Option A: Default Setup (Easiest)

1. Navigate to your repository → `Settings` → `Code security and analysis`
2. Scroll to "Code scanning"
3. Click `Set up` → `Default`
4. Select language: **Java/Kotlin**
5. Select query suite: **Extended** (recommended — catches more issues)
6. Click `Enable CodeQL`
7. CodeQL will now run automatically on PRs and pushes

#### Option B: Advanced Setup (Our Approach)

1. Copy `.github/workflows/codeql.yml` from this repository
2. Commit and push to your repo
3. The workflow runs on the next push/PR

**Why Advanced?** More control over:
- Query suites (`security-extended` + `security-and-quality`)
- Build configuration (Maven options, environment variables)
- Schedule (weekly full scans)
- Multi-language support (Java + JavaScript for MCP server)

### 2.4 Understanding Results

**Where to see alerts:**
1. Go to your repository on GitHub
2. Click the `Security` tab
3. Click `Code scanning alerts` in the left sidebar

**Each alert shows:**
| Field | Description |
|-------|-------------|
| **Severity** | Critical, High, Medium, Low |
| **CWE** | Common Weakness Enumeration identifier (e.g., CWE-89: SQL Injection) |
| **Data flow** | Step-by-step path showing how tainted data reaches a dangerous function |
| **Location** | Exact file, line, and method where the vulnerability exists |
| **Suggested fix** | How to remediate the vulnerability |

### 2.5 Triaging Alerts

| Action | When |
|--------|------|
| **Fix immediately** | Critical/High severity, confirmed vulnerability |
| **Fix this sprint** | Medium severity, confirmed vulnerability |
| **Track in backlog** | Low severity, confirmed vulnerability |
| **Dismiss — false positive** | CodeQL is wrong (document why) |
| **Dismiss — used in tests** | Vulnerable code is only in test files |
| **Dismiss — won't fix** | Accepted risk with documented justification |

### 2.6 Copilot Autofix

If GHAS is available, Copilot can **automatically fix** CodeQL alerts:

1. Open a Code scanning alert
2. Look for the **"Autofix"** button (or "Generate fix" suggestion from Copilot)
3. Copilot analyzes the vulnerability and generates a fix
4. Review the suggested fix — Copilot creates a PR with the changes
5. Review, test, and merge

**This is one of the most powerful features of GHAS** — it turns security alerts from "problems to investigate" into "fixes to review."

### 2.7 Java/Spring Boot — Common Vulnerabilities CodeQL Catches

| Vulnerability | Description | CodeQL Detection |
|---------------|-------------|------------------|
| **SQL Injection** | String concatenation in SQL queries | Traces user input → query string |
| **XSS** | Unescaped user input in responses | Traces input → response body |
| **Path Traversal** | User input in file paths | Traces input → `new File()` |
| **SSRF** | User input in HTTP requests | Traces input → HTTP client URL |
| **Hardcoded Credentials** | Passwords/keys in source code | Pattern matching + data flow |
| **Insecure Deserialization** | Deserializing untrusted data | `ObjectInputStream.readObject()` |
| **CSRF** | Missing CSRF protection | Spring Security config analysis |
| **Actuator Exposure** | Unsecured Spring Boot actuator | Configuration analysis |
| **JDBC Injection** | String-concatenated JDBC queries | Traces input → `executeQuery()` |

#### Spring Boot Specific: Parameterized Queries

```java
// ❌ VULNERABLE — SQL Injection
String query = "SELECT * FROM users WHERE name = '" + userName + "'";
jdbcTemplate.queryForList(query);

// ✅ SAFE — Parameterized query
String query = "SELECT * FROM users WHERE name = ?";
jdbcTemplate.queryForList(query, userName);
```

CodeQL traces `userName` from a controller parameter through to the JDBC call and flags the vulnerable version.

---

## 3. Dependabot Setup — Dependency Management

### 3.1 What Is Dependabot?

Dependabot is GitHub's automated dependency management tool with **two distinct functions**:

| Feature | Purpose | How It Works |
|---------|---------|--------------|
| **Dependabot Alerts** | Security | Monitors dependencies for known CVEs. Creates security update PRs. |
| **Dependabot Version Updates** | Freshness | Proactively updates dependencies to latest versions (even without CVEs). |

### 3.2 Why Both Matter

- **Alerts** fix *known* vulnerabilities (reactive — something bad was discovered)
- **Version Updates** prevent *future* vulnerabilities (proactive — staying current reduces risk)
- Staying current means smaller, less risky upgrades

### 3.3 Step-by-Step: Dependabot Alerts

1. Navigate to `Settings` → `Code security and analysis`
2. Enable **"Dependabot alerts"**
   - You'll now see alerts in `Security` → `Dependabot alerts`
3. Enable **"Dependabot security updates"**
   - Dependabot automatically creates PRs to fix vulnerable dependencies
   - These PRs update the minimum number of packages needed to resolve the vulnerability

### 3.4 Step-by-Step: Dependabot Version Updates

1. Create `.github/dependabot.yml` (see this repo's file for a complete example)
2. Configure for your ecosystems:

```yaml
version: 2
updates:
  - package-ecosystem: "maven"    # Java dependencies
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
  
  - package-ecosystem: "github-actions"  # CI/CD actions
    directory: "/"
    schedule:
      interval: "weekly"
```

3. **Grouping Strategy** — Why group Spring Boot dependencies together:
   - Spring Boot uses a BOM (Bill of Materials) for version coordination
   - Updating `spring-boot-starter-web` without `spring-boot-starter-data-jpa` can cause version conflicts
   - Grouping ensures all Spring dependencies update in a single PR

4. **Auto-merge** — Automatically merge safe updates:
   - Add the `dependabot-auto-merge.yml` workflow
   - It merges patch/minor updates after CI passes
   - Major updates require manual review

### 3.5 Reviewing Dependabot PRs

| Update Type | Action | Why |
|-------------|--------|-----|
| **Patch** (1.2.3 → 1.2.4) | Auto-merge or quick review | Bug fixes only, backward compatible |
| **Minor** (1.2.3 → 1.3.0) | Review changelog briefly | New features, should be backward compatible |
| **Major** (1.2.3 → 2.0.0) | Thorough review + testing | Breaking changes likely |

**What to check on major updates:**
- Read the changelog for breaking changes
- Check Spring Boot migration guides (if Spring Boot major update)
- Run the full test suite locally before merging
- Check for deprecated API usage

**Using Copilot to review Dependabot PRs:**
- In the PR, ask Copilot: *"What are the breaking changes in this dependency update?"*
- Copilot can summarize changelogs and highlight potential issues

### 3.6 Java/Maven Specific Tips

**Analyzing your dependency tree:**
```bash
# See all dependencies (direct + transitive)
mvn dependency:tree

# Find specific vulnerable dependency
mvn dependency:tree -Dincludes=com.fasterxml.jackson.core

# Check for version conflicts
mvn enforcer:enforce
```

**Spring Boot BOM management:**
```xml
<!-- In pom.xml — let Spring Boot manage dependency versions -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.2.0</version>
</parent>
<!-- Individual Spring dependencies inherit the version from the parent BOM -->
```

---

## 4. Secret Scanning Setup

### 4.1 What Is Secret Scanning?

Secret scanning detects exposed secrets in your code and Git history:
- API keys, access tokens, passwords
- JDBC connection strings with credentials
- Private keys (SSH, RSA, PGP)
- OAuth client secrets
- Cloud provider credentials (AWS, Azure, GCP)

### 4.2 Native GitHub Secret Scanning

**Enable:**
1. Navigate to `Settings` → `Code security and analysis`
2. Enable **"Secret scanning"**
3. Enable **"Push protection"** (blocks pushes containing secrets)

**Push Protection** is the most important feature — it prevents secrets from entering the repo in the first place, rather than detecting them after the fact.

**Custom Patterns (Enterprise):**
If you're on GitHub Enterprise (EMU), you can add organization-wide custom patterns:
1. Go to Organization → `Settings` → `Code security and analysis`
2. Under "Secret scanning" → "Custom patterns"
3. Add patterns for internal secret formats (e.g., internal API key prefixes)

### 4.3 Gitleaks (Open-Source Complement)

We use Gitleaks in addition to GitHub's native scanning because:

| Feature | GitHub Secret Scanning | Gitleaks |
|---------|----------------------|----------|
| Known patterns | ✅ 200+ partner patterns | ✅ 100+ regex patterns |
| Custom patterns | ✅ (Enterprise) | ✅ (`.gitleaks.toml`) |
| Git history scan | ✅ | ✅ |
| Push protection | ✅ | ❌ (pre-commit hook) |
| Free for private repos | Requires GHAS | ✅ Always free |
| Auto-revocation | ✅ (partner program) | ❌ |

**Our workflow:** `.github/workflows/secret-scanning.yml` runs Gitleaks on every push and PR.

**Custom rules:** `.gitleaks.toml` in the repo root defines custom patterns for Java/Spring Boot secrets (JDBC strings, Spring properties, etc.).

### 4.4 What to Do When a Secret Is Leaked

**🚨 IMMEDIATE ACTIONS (within minutes, not hours):**

1. **ROTATE THE SECRET** — Generate a new one immediately
2. **REVOKE THE OLD SECRET** — Disable/delete the compromised credential
3. **CHECK AUDIT LOGS** — Look for unauthorized use during the exposure window:
   - AWS: Check CloudTrail
   - GitHub: Check audit log
   - Databases: Check access logs
4. **UPDATE REFERENCES** — Update all systems using the new secret

**PREVENTIVE ACTIONS:**

5. **Add to `.gitignore`:**
   ```
   # Never commit these
   .env
   .env.local
   *.pem
   *.key
   application-secrets.properties
   ```

6. **Use a secrets manager:**
   - AWS Secrets Manager for production credentials
   - GitHub Actions secrets for CI/CD (`Settings` → `Secrets and variables` → `Actions`)
   - Local `.env` files for development (in `.gitignore`)

7. **Install pre-commit hooks:**
   ```bash
   # Install gitleaks
   brew install gitleaks  # macOS
   # Add pre-commit hook
   echo '#!/bin/sh\ngitleaks protect --staged' > .git/hooks/pre-commit
   chmod +x .git/hooks/pre-commit
   ```

---

## 5. MCP Server Security

### 5.1 Why MCP Servers Need Guardrails

MCP servers bridge AI assistants with real systems. In your case, the MCP server connects Copilot to Jira. This means:

| Risk | Description | Impact |
|------|-------------|--------|
| **Data exfiltration** | AI extracts sensitive Jira data | Confidential project details leaked |
| **Unauthorized access** | Prompt injection triggers admin operations | Jira issues modified/deleted |
| **Credential exposure** | Hardcoded API tokens in MCP code | Jira account compromised |
| **Cost explosion** | Unbounded API calls | Jira API rate limits hit, service disruption |
| **Injection attacks** | Malicious JQL or input | Unauthorized data access |

### 5.2 Security Patterns

#### Input Validation
```javascript
// ✅ GOOD — Validate and sanitize inputs
function searchJira(query) {
  // Reject JQL injection patterns
  if (query.includes(';') || query.includes('--') || query.length > 500) {
    throw new Error('Invalid query');
  }
  // Allow only safe JQL operators
  const safeQuery = query.replace(/[^\w\s=<>!AND OR NOT"()-]/gi, '');
  return jiraClient.search(safeQuery);
}

// ❌ BAD — Passing unsanitized input directly
function searchJira(query) {
  return jiraClient.search(query);  // Prompt injection risk!
}
```

#### Rate Limiting
```javascript
// Simple rate limiter — max 30 requests per minute
const requestCounts = new Map();
const RATE_LIMIT = 30;
const WINDOW_MS = 60_000;

function checkRateLimit(toolName) {
  const now = Date.now();
  const key = toolName;
  const history = requestCounts.get(key) || [];
  const recent = history.filter(t => now - t < WINDOW_MS);

  if (recent.length >= RATE_LIMIT) {
    throw new Error(`Rate limit exceeded for ${toolName}. Max ${RATE_LIMIT}/minute.`);
  }

  recent.push(now);
  requestCounts.set(key, recent);
}
```

#### Audit Logging
```javascript
// Log every MCP tool call for security audit trail
function logToolCall(toolName, input, output) {
  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    tool: toolName,
    input: sanitizeForLog(input),  // Strip sensitive data
    outputSize: JSON.stringify(output).length,
    success: true
  }));
}
```

#### Response Filtering
```javascript
// Strip sensitive fields from Jira responses
function filterResponse(jiraIssue) {
  const { reporter, assignee, ...safe } = jiraIssue;
  return {
    ...safe,
    reporter: reporter?.displayName,  // Only return name, not email
    assignee: assignee?.displayName,
    // Remove internal fields
    fields: undefined,
    self: undefined  // Don't expose internal Jira URLs
  };
}
```

### 5.3 MCP Security Workflow

Our `.github/workflows/mcp-security.yml` runs three checks:
1. **npm audit** — Dependency vulnerabilities
2. **Hardcoded secret detection** — Grep-based scanning
3. **Server startup validation** — Smoke test

### 5.4 MCP Security Checklist

- [ ] All secrets stored in environment variables (never hardcoded)
- [ ] `.env` file in `.gitignore`
- [ ] Input validation on every tool parameter
- [ ] Rate limiting configured (30 requests/minute recommended)
- [ ] Audit logging enabled for all tool calls
- [ ] Response filtering strips sensitive data (PII, internal IDs, credentials)
- [ ] `npm audit` passes with no high/critical vulnerabilities
- [ ] Jira API token has minimum required permissions (read-only if possible)
- [ ] MCP server runs with non-root user in production
- [ ] Error messages don't expose internal details

---

## 6. Unit Test Security

### 6.1 Security-Focused Testing

Security tests verify that your application **handles malicious input correctly**. They're different from functional tests — instead of testing what works, you test what should be rejected.

#### SQL Injection Tests

```java
@Test
void shouldPreventSqlInjection() {
    // These inputs should NOT cause SQL errors or data leaks
    String[] maliciousInputs = {
        "'; DROP TABLE users; --",
        "1 OR 1=1",
        "1' UNION SELECT * FROM credentials --",
        "Robert'); DROP TABLE students;--"
    };

    for (String input : maliciousInputs) {
        // Should either return empty results or throw a validation error
        // Should NEVER execute the injected SQL
        assertDoesNotThrow(() -> repository.findByName(input));
    }
}
```

#### Input Validation Tests

```java
@Test
void shouldRejectInvalidInput() {
    // Test boundary values
    assertThrows(ValidationException.class,
        () -> service.process(null));
    assertThrows(ValidationException.class,
        () -> service.process(""));
    assertThrows(ValidationException.class,
        () -> service.process("a".repeat(10001)));  // Exceeds max length

    // Test special characters
    assertThrows(ValidationException.class,
        () -> service.process("<script>alert('xss')</script>"));
}
```

#### Error Handling Tests

```java
@Test
void shouldNotLeakInternalDetailsInErrors() {
    // Trigger an error condition
    ResponseEntity<?> response = controller.getUser("nonexistent-id");

    // Verify error response doesn't contain:
    assertFalse(response.getBody().toString().contains("jdbc:"));    // No connection strings
    assertFalse(response.getBody().toString().contains("at com.")); // No stack traces
    assertFalse(response.getBody().toString().contains("password"));// No credentials
}
```

### 6.2 Using Copilot to Generate Security Tests

Effective prompts for Copilot:

| Prompt | What It Generates |
|--------|------------------|
| *"Write SQL injection test cases for this repository method"* | Tests with malicious SQL strings |
| *"Generate XSS test cases for this REST controller"* | Tests with script injection payloads |
| *"Write tests that verify input validation and error handling"* | Boundary value and negative tests |
| *"Write security-focused tests for this REST endpoint"* | Comprehensive security test suite |
| *"Generate tests to verify no sensitive data leaks in error responses"* | Error response validation tests |

**Copilot Custom Instructions for Security Tests:**

Add to your `.github/copilot-instructions.md`:
```
When generating tests, always include:
- SQL injection test cases with common payloads
- Input validation tests for null, empty, and boundary values
- XSS test cases for any endpoint accepting user input
- Error handling tests that verify no internal details leak
- Authentication/authorization tests for protected endpoints
```

### 6.3 OWASP Dependency Check in CI

The `dependency-check` job in `ci.yml` scans all Maven dependencies against the National Vulnerability Database (NVD).

**Understanding the report:**
| Field | Description |
|-------|-------------|
| **CVE ID** | Unique vulnerability identifier (e.g., CVE-2023-44487) |
| **CVSS Score** | Severity: 0-3.9 Low, 4-6.9 Medium, 7-8.9 High, 9-10 Critical |
| **Affected Version** | The version range containing the vulnerability |
| **Fix Version** | The minimum version that fixes the vulnerability |
| **Evidence** | How the dependency was identified (GAV coordinates, file hash) |

**Common actions:**
1. **Direct dependency is vulnerable:** Update the version in `pom.xml`
2. **Transitive dependency is vulnerable:** Add a `<dependencyManagement>` override
3. **False positive:** Add a suppression in `dependency-check-suppression.xml`

```xml
<!-- Example: Override a transitive dependency version -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.16.0</version> <!-- Fixed version -->
        </dependency>
    </dependencies>
</dependencyManagement>
```

---

## 7. End-to-End Security Workflow

Here's how all the security pieces connect in your development workflow:

```
┌─────────────────────────────────────────────────────────────────────┐
│                     DEVELOPMENT LIFECYCLE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. WRITE CODE                                                      │
│     └── Copilot suggests code (with custom instructions             │
│         enforcing security patterns: parameterized queries,         │
│         input validation, no hardcoded secrets)                     │
│                                                                     │
│  2. LOCAL CHECKS (pre-commit)                                       │
│     ├── gitleaks protect --staged (blocks secret commits)           │
│     └── mvn test (run security-focused unit tests)                  │
│                                                                     │
│  3. PUSH TO BRANCH                                                  │
│     └── Push protection blocks commits with detected secrets        │
│                                                                     │
│  4. GITHUB ACTIONS CI (automatic on push/PR)                        │
│     ├── Build & Test (Maven compile + unit tests)                   │
│     ├── CodeQL Analysis (semantic security scanning)                │
│     ├── Secret Scanning — Gitleaks (credential detection)           │
│     ├── OWASP Dependency Check (vulnerable dependencies)            │
│     └── MCP Security Check (if MCP files changed)                   │
│                                                                     │
│  5. PULL REQUEST                                                    │
│     ├── All CI checks must pass (branch protection)                 │
│     ├── CODEOWNERS auto-assigned for security-sensitive files       │
│     ├── Copilot Code Review (if enabled)                            │
│     ├── Dependabot checks dependency compatibility                  │
│     └── Human review (at least 1 approval required)                 │
│                                                                     │
│  6. MERGE TO MAIN                                                   │
│     ├── Full CI pipeline runs again on main                         │
│     └── CodeQL weekly scan catches new vulnerability patterns       │
│                                                                     │
│  7. CONTINUOUS MONITORING                                           │
│     ├── Dependabot alerts for new CVEs in existing dependencies     │
│     ├── Dependabot version updates (weekly PRs)                     │
│     ├── Secret scanning monitors for newly exposed secrets          │
│     └── CodeQL weekly full-repo scan with updated queries           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### How Each Tool Fits

| Tool | What It Catches | When It Runs |
|------|----------------|--------------|
| **Copilot + Custom Instructions** | Prevents insecure code from being written | During development |
| **Pre-commit hooks (gitleaks)** | Secrets before they're committed | Local, before push |
| **Push Protection** | Secrets in the push | On push attempt |
| **CI — Build & Test** | Broken code, failing security tests | Every push/PR |
| **CI — CodeQL** | Vulnerabilities in your code (SQL injection, XSS, etc.) | Every push/PR + weekly |
| **CI — Gitleaks** | Secrets in code and Git history | Every push/PR |
| **CI — OWASP Check** | Vulnerable dependencies (CVEs) | Every push/PR |
| **CI — MCP Security** | MCP server vulnerabilities | When MCP files change |
| **Dependabot Alerts** | New CVEs in your current dependencies | Continuous monitoring |
| **Dependabot Updates** | Outdated dependencies | Weekly PRs |
| **Branch Protection** | Unreviewed code reaching main | On every merge attempt |
| **CODEOWNERS** | Security files reviewed by right people | On PR creation |

---

## 8. Quick Reference Checklists

### New Repository Checklist

```
□ Branch protection on main (require PRs, reviews, status checks)
□ CODEOWNERS file created
□ Secret scanning enabled
□ Push protection enabled
□ Dependabot alerts enabled
□ Dependabot security updates enabled
□ dependabot.yml configured (Maven + GitHub Actions)
□ CI workflow (ci.yml) — build, test, OWASP
□ CodeQL workflow (codeql.yml) — static analysis
□ Secret scanning workflow (secret-scanning.yml) — gitleaks
□ SECURITY.md policy file
□ .gitignore includes sensitive patterns (.env, *.key, *.pem)
```

### New MCP Server Checklist

```
□ All credentials in environment variables
□ .env file in .gitignore
□ Input validation on all tool parameters
□ Rate limiting configured
□ Audit logging enabled
□ Response filtering for sensitive data
□ npm audit clean
□ MCP security workflow added
□ Least-privilege API credentials
```

### Pre-PR Security Review

```
□ No hardcoded secrets in code
□ SQL queries use parameterized statements
□ User input is validated and sanitized
□ Error responses don't leak internal details
□ New endpoints have authentication/authorization
□ Security-focused unit tests added for new code
□ Dependencies are current (no known CVEs)
```

### Incident Response — Secret Leaked

```
□ ROTATE the secret immediately (generate new one)
□ REVOKE the old secret (disable/delete)
□ CHECK audit logs for unauthorized usage
□ UPDATE all systems with the new secret
□ ADD pattern to .gitignore
□ INSTALL pre-commit hooks if not already present
□ REVIEW how the secret was committed (process improvement)
```

---

## Appendix: GitHub Enterprise (EMU) Considerations

For organizations using GitHub EMU (Enterprise Managed Users):

1. **Organization-level policies** override repository settings. Work with your GitHub admin to ensure security features are enabled at the org level.

2. **Custom secret scanning patterns** can be defined at the org level — covering all repositories automatically.

3. **Required workflows** can be enforced at the org level — ensuring every repo runs security scans without individual configuration.

4. **Audit log streaming** sends all security events to your SIEM (Splunk, etc.) for centralized monitoring.

5. **IP allow lists** restrict where code can be accessed from.

---

*Last updated: 2025 | OutFront Media — GitHub Copilot Workshop*
