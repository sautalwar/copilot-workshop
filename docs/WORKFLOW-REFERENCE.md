# 📋 Workflow Reference Guide

> **Quick reference for all GitHub Actions workflows in this repository.**
> Each workflow is part of the "workflow wall" — layers of automated checks that
> catch issues at every stage of the development lifecycle.

---

## Workflow Summary Table

| Workflow | File | Trigger | What It Does | Required? |
|----------|------|---------|-------------|-----------|
| CI Pipeline | `ci.yml` | push, PR | Build, test, OWASP dependency check | ✅ Yes |
| CodeQL Analysis | `codeql.yml` | push/PR to main, weekly | Semantic security analysis for Java code | ✅ Yes |
| Secret Scanning | `secret-scanning.yml` | push/PR to main | Detect leaked secrets with Gitleaks | ✅ Yes |
| Dependabot | `dependabot.yml` | weekly (config) | Auto-update Maven & Actions dependencies | ✅ Yes |
| Dependabot Auto-Merge | `dependabot-auto-merge.yml` | PR | Auto-merge safe patch/minor updates | Optional |
| MCP Security | `mcp-security.yml` | push/PR to mcp-server/ | Validate MCP server security | ✅ Yes |
| Lint & Format | `lint-and-format.yml` | push, PR | Checkstyle + SpotBugs code quality | ✅ Yes |
| Test Coverage | `test-coverage.yml` | PR to main | JaCoCo coverage check (min 70%) | ✅ Yes |
| PR Automation | `pr-automation.yml` | PR opened/updated | Auto-label PRs by file paths | Optional |
| API Docs | `api-docs.yml` | push to main (controllers) | Generate OpenAPI spec from app | Optional |
| Release | `release.yml` | tag push (v*) | Build JAR + create GitHub Release | Optional |
| Copilot Config | `copilot-config-validation.yml` | PR changing .github/ | Validate Copilot config files | ✅ Yes |
| Docker Build | `docker-build.yml` | push to main, PR | Build image + Trivy security scan | Optional |

---

## Workflow Details

### 🏗️ CI Pipeline (`ci.yml`)

**Trigger:** Every push and every PR

The core continuous integration workflow. Builds the project with Maven, runs the
full test suite, and performs OWASP dependency vulnerability checking. This is the
foundation — if CI fails, nothing else matters.

---

### 🔍 CodeQL Analysis (`codeql.yml`)

**Trigger:** Push to main, PRs targeting main, weekly schedule (Monday 6:00 AM UTC)

CodeQL is GitHub's semantic code analysis engine. Unlike simple pattern matching,
it builds a database of your code's structure and queries it for security vulnerabilities.
It finds issues like SQL injection, XSS, path traversal, and insecure deserialization
that simpler tools miss.

The weekly schedule catches newly-discovered vulnerability patterns in existing code.

---

### 🔐 Secret Scanning (`secret-scanning.yml`)

**Trigger:** Push to main, PRs targeting main

Runs [Gitleaks](https://github.com/gitleaks/gitleaks) to scan the entire Git history
for accidentally committed secrets — API keys, database passwords, private keys, tokens.
Even if you delete a secret from your code, it's still in Git history unless you rewrite it.

---

### 📦 Dependabot (`dependabot.yml`)

**Trigger:** Automated weekly checks (Mondays)

A configuration file (not a workflow) that tells GitHub's Dependabot to:
- Check Maven dependencies for updates weekly
- Check GitHub Actions versions for updates
- Group related updates (Spring Boot, testing libraries)
- Limit to 10 open PRs at a time to avoid PR flood

---

### 🤝 Dependabot Auto-Merge (`dependabot-auto-merge.yml`)

**Trigger:** Any PR (filters to Dependabot PRs only)

Automatically approves and merges Dependabot PRs for **patch** and **minor** version
updates after CI passes. Major version updates require manual review because they
may contain breaking changes.

---

### 🛡️ MCP Security (`mcp-security.yml`)

**Trigger:** Push/PR changing files in `mcp-server/`

Validates the MCP (Model Context Protocol) server for security best practices.
Checks for dependency vulnerabilities, validates configuration, and ensures the
MCP server follows secure coding patterns.

---

### 📏 Lint & Format (`lint-and-format.yml`)

**Trigger:** Every push and every PR

Two-layer code quality check:
1. **Checkstyle** — Enforces Google Java Style Guide (indentation, naming, imports).
   Fails the build if style is violated.
2. **SpotBugs** — Finds common bug patterns (null pointers, resource leaks).
   Advisory only (doesn't fail the build) — findings are uploaded as artifacts.

---

### 📊 Test Coverage (`test-coverage.yml`)

**Trigger:** PRs targeting main

Runs the full test suite with JaCoCo coverage instrumentation and posts a formatted
coverage report directly on the PR as a comment. Enforces:
- **70% overall** coverage minimum
- **80% coverage** for files changed in the PR

---

### 🏷️ PR Automation (`pr-automation.yml`)

**Trigger:** PR opened, updated, or marked ready for review

Automatically labels PRs based on which files changed:
- `java` for Java source changes
- `tests` for test changes
- `api` for controller changes
- `mcp` for MCP server changes
- `docs` for documentation changes
- And more (see `.github/labeler.yml`)

---

### 📖 API Docs (`api-docs.yml`)

**Trigger:** Push to main that changes controllers, models, or pom.xml

Starts the Spring Boot app temporarily, fetches the auto-generated OpenAPI spec
from `/v3/api-docs`, and saves it as a downloadable artifact in both JSON and YAML
formats. Always up-to-date API documentation with zero manual effort.

---

### 🚀 Release (`release.yml`)

**Trigger:** Pushing a Git tag starting with `v` (e.g., `v1.0.0`)

Fully automated release process:
1. Builds the production JAR
2. Generates release notes from commit history
3. Creates a GitHub Release with the JAR attached

Trigger with: `git tag v1.0.0 && git push origin v1.0.0`

---

### 🤖 Copilot Config Validation (`copilot-config-validation.yml`)

**Trigger:** PRs that change any Copilot configuration file

Validates the structure of GitHub Copilot configuration files:
- Checks `.github/copilot-instructions.md` exists and isn't too large
- Verifies `*.instructions.md` files have required `applyTo:` frontmatter
- Checks `*.prompt.md` files have `mode:` and `description:`
- Validates `*.chatmode.md` files have `description:`

Broken frontmatter means Copilot silently ignores the file — this catches that.

---

### 🐳 Docker Build (`docker-build.yml`)

**Trigger:** Push to main (source/config/Dockerfile changes), PR (Dockerfile changes)

Builds the Docker image using a multi-stage Dockerfile and scans it with
[Trivy](https://github.com/aquasecurity/trivy) for known vulnerabilities.
Fails if CRITICAL or HIGH severity CVEs are found in the image.

---

## 🧱 The Workflow Wall

These workflows aren't isolated — they form **layers of protection** that catch
issues at every stage of the development lifecycle:

```
┌─────────────────────────────────────────────────────────────────┐
│                     DEVELOPER PUSHES CODE                       │
└─────────────────┬───────────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 1: CODE QUALITY                                          │
│  ├── Lint & Format (Checkstyle) — Is it readable?               │
│  ├── Lint & Format (SpotBugs) — Are there obvious bugs?         │
│  └── Copilot Config — Are AI instructions valid?                │
└─────────────────┬───────────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 2: CORRECTNESS                                           │
│  ├── Test Coverage (JaCoCo) — Does the code work?               │
│  └── Test Coverage Report — Is enough code tested?              │
└─────────────────┬───────────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 3: SECURITY                                              │
│  ├── CodeQL — Semantic vulnerability analysis                   │
│  ├── Secret Scanning — No leaked credentials?                   │
│  ├── Dependabot — Are dependencies up-to-date?                  │
│  └── Docker (Trivy) — Is the container image secure?            │
└─────────────────┬───────────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 4: PROCESS                                               │
│  ├── PR Automation — Labeled and categorized                    │
│  ├── PR Template — Developer checklist                          │
│  └── Dependabot Auto-Merge — Safe updates merged automatically  │
└─────────────────┬───────────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 5: DELIVERY                                              │
│  ├── API Docs — Documentation always current                    │
│  ├── Docker Build — Container always buildable                  │
│  └── Release — Tag it and ship it                               │
└─────────────────────────────────────────────────────────────────┘
```

### Why Layers Matter

No single check catches everything. The workflow wall works because:

1. **Redundancy** — Multiple tools look for security issues (CodeQL + Secret Scanning
   + Trivy + Dependabot). Each has different strengths.
2. **Speed** — Fast checks (linting) run on every push. Slow checks (CodeQL) run on
   PRs and schedules. This keeps the feedback loop tight.
3. **Progressive strictness** — Style checks are enforced immediately. SpotBugs is
   advisory. Coverage thresholds start reasonable (70%) and can be raised over time.
4. **Automation over process** — Auto-labeling, auto-merging safe updates, and
   auto-generating docs eliminate manual steps that get forgotten.
5. **Visibility** — Coverage reports on PRs, SpotBugs artifacts, and labeled PRs
   make quality visible to the whole team, not hidden in build logs.

### Adding Your Own Workflows

When you identify a new repeatable task, ask yourself:
- Do developers do this manually more than twice a week? → **Automate it**
- Could forgetting this step cause a bug or outage? → **Make it a required check**
- Is this informational but not blocking? → **Use `continue-on-error: true`**

Create a new `.yml` file in `.github/workflows/` and add it to this reference table.

---

## Related Files

| File | Purpose |
|------|---------|
| `.github/labeler.yml` | Auto-label rules for PR Automation workflow |
| `.github/pull_request_template.md` | PR template with automated check reminders |
| `.github/dependabot.yml` | Dependabot configuration for dependency updates |
| `.github/copilot-instructions.md` | Project-wide Copilot instructions |
| `Dockerfile` | Multi-stage Docker build for Spring Boot |
| `docs/api/README.md` | API documentation guide |
