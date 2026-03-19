# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly.

### How to Report

1. **DO NOT** create a public GitHub issue for security vulnerabilities
2. Email the security team at: **[security contact — update with your team's email]**
3. Or use GitHub's private vulnerability reporting:
   - Go to the repository's **Security** tab
   - Click **"Report a vulnerability"**
   - Fill out the advisory form

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Affected versions
- Potential impact
- Suggested fix (if any)

### Response Timeline

| Action | Timeline |
|--------|----------|
| Acknowledgment of report | Within 2 business days |
| Initial assessment | Within 5 business days |
| Fix development | Within 30 days for critical/high severity |
| Public disclosure | After fix is released and deployed |

## Supported Versions

| Version | Supported |
|---------|-----------|
| Latest (main branch) | ✅ Active support |
| Previous releases | ⚠️ Security fixes only |

## Security Update Policy

- **Critical vulnerabilities (CVSS 9.0+):** Patched within 72 hours
- **High vulnerabilities (CVSS 7.0-8.9):** Patched within 2 weeks
- **Medium vulnerabilities (CVSS 4.0-6.9):** Patched within 30 days
- **Low vulnerabilities (CVSS 0.1-3.9):** Patched in next scheduled release

## Security Practices

This project follows these security practices:

- **Static Analysis:** CodeQL scans on every PR and weekly
- **Dependency Scanning:** Dependabot alerts and automated updates
- **Secret Scanning:** GitHub native + Gitleaks on every push
- **OWASP Dependency Check:** NVD vulnerability scanning in CI
- **Code Review:** All changes require PR review before merge
- **Branch Protection:** Direct pushes to main are blocked

## Disclosure Policy

We follow [coordinated vulnerability disclosure](https://en.wikipedia.org/wiki/Coordinated_vulnerability_disclosure). We ask that you:

1. Give us reasonable time to fix the issue before public disclosure
2. Do not exploit the vulnerability beyond what's necessary to demonstrate it
3. Do not access or modify data belonging to other users

We commit to:

1. Acknowledging your report promptly
2. Keeping you informed of our progress
3. Crediting you (if desired) when we disclose the fix
