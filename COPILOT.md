# Copilot Coding Agent Instructions

## Project Context
This is a workshop repository for teaching GitHub Copilot capabilities. It contains:
- HTML presentations (workshop.html, presentation.html)
- A TypeScript MCP server example (src/mcp-server/)
- Example API code (src/api/)
- An interactive demo (demo/)
- GitHub Copilot configuration examples (.github/prompts, agents, skills, instructions)

## When Working on This Repository

### Code Changes
- Run `npm run build` after TypeScript changes
- Run `npm test` before committing
- Update the README if adding new features or examples

### HTML Presentations
- These are self-contained single-file HTML presentations
- Do not split them into multiple files
- Test in a browser after changes (check all slides render)

### Security
- Never commit real API keys or tokens
- Use fake PII data only (SSN: 000-00-0000, Email: jane@example.com)
- The MCP server examples intentionally show safe vs unsafe patterns — keep both

### MCP Server
- The safe server (index.ts) MUST always redact PII before returning
- The unsafe server (unsafe-example.ts) exists as a cautionary example — mark it clearly

### Testing
- MCP server tests are in src/mcp-server/__tests__/
- API tests are in src/api/__tests__/
- Run all tests: `npm test`
