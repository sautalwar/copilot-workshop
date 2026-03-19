## Description
<!-- What does this PR do? Provide a brief summary of the changes. -->

## Type of Change
- [ ] 🐛 Bug fix (non-breaking change that fixes an issue)
- [ ] ✨ New feature (non-breaking change that adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to change)
- [ ] ♻️ Refactor (code change that neither fixes a bug nor adds a feature)
- [ ] 📝 Documentation (changes to docs, README, or comments only)
- [ ] 🔧 Configuration (CI/CD, build, or tooling changes)
- [ ] 🔒 Security fix (vulnerability patch or security improvement)

## Checklist
<!-- Check all that apply. Remove items that don't apply to your change. -->

- [ ] My code follows the project's coding standards (Google Java Style)
- [ ] I have written tests for my changes
- [ ] All existing tests pass (`mvn test`)
- [ ] I have updated documentation if needed
- [ ] No secrets or credentials in the code
- [ ] I have considered the security implications of my changes

## Automated Checks (runs automatically)
The following GitHub Actions will run on this PR — no action needed from you:

| Check | What It Does | Blocks Merge? |
|-------|-------------|---------------|
| 🏗️ **CI Pipeline** | Build, test, OWASP dependency check | ✅ Yes |
| 🔍 **CodeQL** | Security vulnerability scanning | ✅ Yes |
| 🔐 **Secret Scanning** | Checks for exposed credentials | ✅ Yes |
| 📏 **Lint & Format** | Checkstyle + SpotBugs code quality | ✅ Yes |
| 📊 **Test Coverage** | JaCoCo coverage report (min 70% overall) | ✅ Yes |
| 🏷️ **Auto-Label** | Labels based on changed files | No |
| 🐳 **Docker Build** | Image build + Trivy security scan | Optional |
| 🤖 **Copilot Config** | Validates Copilot config files | ✅ Yes |

## Screenshots / Evidence
<!-- If applicable, add screenshots or test output to help reviewers. -->

## Related Issues
<!-- Link related issues: Fixes #123, Relates to #456 -->
