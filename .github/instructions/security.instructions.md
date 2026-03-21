# Security Instructions

## Applies to: `src/**/*.ts`, `src/**/*.js`

When writing or modifying code in the `src/` directory, follow these security guidelines:

### Input Validation
- Validate ALL user inputs at API boundaries using Zod schemas
- Sanitize strings before database insertion
- Reject requests with unexpected fields (strict mode)

### Authentication & Authorization
- Use JWT tokens for API authentication
- Verify token signatures on every request
- Check role-based permissions before data access

### Data Protection
- Encrypt PII at rest using AES-256
- Mask sensitive fields in logs (use `maskSSN()`, `maskEmail()`)
- Never return raw database records — always use DTOs with redaction

### Error Handling
- Never expose stack traces in production responses
- Log full errors server-side, return generic messages to clients
- Use structured error codes (e.g., `AUTH_EXPIRED`, `VALIDATION_FAILED`)

### Dependencies
- Pin exact versions in package.json
- Run `npm audit` before merging PRs
- Prefer well-maintained packages with >1000 weekly downloads
