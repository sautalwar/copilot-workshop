---
mode: 'agent'
description: 'Automate complete PR workflow from code changes to merge'
---

# Automated PR Workflow — Create, Review, Test, and Merge

## 📍 Workshop Section
Advanced Automation | GitHub Integration with Copilot

## What This Does
Automates the complete pull request lifecycle for code changes: creates a feature branch, opens a PR, assigns Copilot for review, runs code review, executes tests, and merges changes. This demonstrates end-to-end CI/CD automation with GitHub Copilot integration.

## Instructions
**For the AI Agent:**

Automate the complete pull request workflow for code changes in the OutFront Media Order Management API repository.

### Workflow Steps:

**1. Prepare Code Changes**
- Ensure all code changes are committed locally
- Verify the working directory is clean (no uncommitted changes)
- Identify the current branch name (should be a feature branch, not `main`)
- If on `main`, create a new feature branch: `feature/automated-pr-{timestamp}`

**2. Create Pull Request**
- Push the feature branch to remote origin
- Create a pull request using the GitHub PR API
  - **Title:** Auto-generated based on commit messages (use the most recent commit title)
  - **Body:** Include:
    - Summary of changes
    - List of modified files
    - Test coverage status
    - Related issue numbers (if found in commit messages)
  - **Base branch:** `main`
  - **Head branch:** Current feature branch
  - **Draft:** Start as draft PR for initial checks
- Capture the PR number for subsequent steps

**3. Assign Copilot for Code Review**
- Use GitHub Copilot review API to request automated code review
- Assign PR to `@github-copilot` reviewer
- Wait for Copilot review completion (poll every 10 seconds, max 2 minutes)

**4. Perform Code Review Analysis**
- Review Copilot's feedback comments
- Categorize findings:
  - 🔴 **Critical:** Security issues, bugs, breaking changes
  - 🟡 **Warnings:** Code quality, best practices violations
  - 🟢 **Suggestions:** Optimizations, style improvements
- If critical issues exist:
  - Comment on PR with summary of blocking issues
  - Mark PR as "Changes Requested"
  - **STOP WORKFLOW** — manual intervention required
- If only warnings/suggestions:
  - Add comment acknowledging review
  - Proceed to testing

**5. Run All Tests**
- Execute test suite in a clean environment:
  ```bash
  mvn clean verify -B
  ```
- Capture test results:
  - Total tests run
  - Passed tests
  - Failed tests (with details)
  - Code coverage percentage
- If tests fail:
  - Comment on PR with failure details and stack traces
  - Mark PR as "Changes Requested"
  - **STOP WORKFLOW** — manual intervention required
- If all tests pass:
  - Add success comment with test summary
  - Update PR status to "Ready for Review" (remove draft status)

**6. Merge Pull Request**
- Verify all checks passed:
  - ✅ Copilot review completed without critical issues
  - ✅ All tests passing
  - ✅ No merge conflicts with base branch
- If all checks pass:
  - Merge PR using **squash and merge** strategy
  - **Commit message:** Use PR title
  - **Commit body:** Include PR number and summary
  - Delete the feature branch after merge
- If checks fail:
  - Comment explaining which check failed
  - Keep PR open for manual review

**7. Post-Merge Validation**
- Switch to `main` branch locally
- Pull latest changes from remote
- Run quick smoke test:
  ```bash
  mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=0" &
  sleep 10
  curl -f http://localhost:8080/actuator/health || echo "Health check failed"
  pkill -f spring-boot:run
  ```
- If smoke test fails:
  - Create urgent issue in GitHub
  - Tag as `critical` and `production`
  - Notify team via PR comment

### Output Report
Generate a comprehensive markdown report with:

```markdown
# PR Workflow Summary

## Pull Request Details
- **PR #:** {number}
- **Title:** {title}
- **Branch:** {feature-branch} → main
- **URL:** {pr-url}

## Review Results
- **Copilot Review:** ✅ Completed
- **Critical Issues:** {count}
- **Warnings:** {count}
- **Suggestions:** {count}

## Test Results
- **Tests Run:** {total}
- **Passed:** {passed}
- **Failed:** {failed}
- **Coverage:** {percentage}%
- **Duration:** {seconds}s

## Merge Status
- **Merged:** ✅ Yes / ❌ No
- **Merge Method:** Squash and merge
- **Commit SHA:** {sha}
- **Merged At:** {timestamp}

## Post-Merge Validation
- **Health Check:** ✅ Passed / ❌ Failed
- **Smoke Test:** ✅ Passed / ❌ Failed

## Actions Taken
1. Created PR #{number}
2. Requested Copilot review
3. Analyzed {count} review comments
4. Executed test suite ({total} tests)
5. Merged to main branch
6. Deleted feature branch
7. Validated deployment health

## Next Steps
- Monitor production logs for anomalies
- Update documentation if API changes were made
- Close related issues: #{issues}
```

### Error Handling
- **PR Creation Fails:** Check branch is pushed to remote, verify GitHub token permissions
- **Copilot Review Timeout:** Proceed with manual review request, notify user
- **Test Failures:** Provide detailed failure output, do NOT merge
- **Merge Conflicts:** Comment on PR with conflict files, request manual resolution
- **Post-Merge Failures:** Create rollback PR immediately, notify team

### Prerequisites
- GitHub CLI (`gh`) installed and authenticated
- Maven wrapper (`mvnw`) available
- Clean working directory (all changes committed)
- Feature branch pushed to remote
- GitHub repository has Copilot enabled

### Example Usage
```bash
# After making code changes and committing:
git checkout -b feature/add-search-endpoint
git add .
git commit -m "Add date range search endpoint for orders"

# Then invoke this prompt:
# The agent will handle: push, PR creation, review, testing, and merge
```

## Expected Behavior
- **Success case:** Full automation from code commit to merged PR (3-5 minutes)
- **Review issues:** Workflow stops, comments added, manual review required
- **Test failures:** Workflow stops, detailed failure report provided
- **Merge conflicts:** Workflow stops, conflict resolution guidance provided

## Success Criteria
- ✅ PR created and visible in GitHub
- ✅ Copilot review completed with feedback
- ✅ All tests pass (100% success rate)
- ✅ PR merged to main branch using squash merge
- ✅ Feature branch deleted
- ✅ Post-merge health check passes
- ✅ Comprehensive workflow report generated

## Related Prompts
- `07-review-security.prompt.md` — Security-focused code review
- `04-write-service-tests.prompt.md` — Test generation for new code
- `03-add-search-endpoint.prompt.md` — Feature development workflow
