# GitHub Copilot Instructions

## Project Overview
This is the **Copilot Workshop** repository — a training resource for developers learning GitHub Copilot capabilities in VS Code.

## Code Style
- Use TypeScript for all server-side code
- Use ES modules (`import/export`) not CommonJS (`require`)
- Prefer `async/await` over raw Promises
- Use descriptive variable names (no single-letter variables except loop counters)
- Add JSDoc comments to all exported functions

## Security Rules
- **Never output raw PII** (SSNs, emails, phone numbers) in suggestions
- Always use parameterized queries for SQL — never concatenate user input
- Use environment variables for secrets — never hardcode credentials
- When generating test data, use obviously fake values (e.g., SSN: 000-00-0000)

## Architecture Preferences
- Express.js for HTTP servers
- Zod for input validation
- Winston for structured logging
- Follow REST conventions for API endpoints

## Testing
- Write unit tests with Vitest
- Aim for >80% code coverage on business logic
- Test both happy path and error cases

## MCP Servers
- All MCP tool outputs must go through a redaction layer before returning to the model
- Log every tool invocation for audit purposes
- Use `@modelcontextprotocol/sdk` for MCP server implementations
