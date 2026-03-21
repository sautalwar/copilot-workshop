# Mastering GitHub Copilot — Developer Workshop

A comprehensive 1-hour hands-on workshop covering **all** GitHub Copilot capabilities in VS Code — from chat commands to custom agents, MCP servers, GitHub Actions, and enterprise security patterns.

## 🎯 What's in This Repo

### Presentations (open in browser)
| File | Content | Slides |
|------|---------|--------|
| **`copilot-capabilities.html`** | Complete capabilities workshop (NEW) | ~34 |
| `workshop.html` | Copilot configuration deep-dive | 33 |
| `presentation.html` | Hackathon overview + extensibility | 48 |

### Working Code Examples
| Path | What It Demonstrates |
|------|---------------------|
| `src/mcp-server/index.ts` | ✅ **Safe** MCP server with PII redaction |
| `src/mcp-server/unsafe-example.ts` | ⚠️ **Unsafe** MCP server (cautionary example) |
| `src/api/example.ts` | Express API with Zod validation |
| `.vscode/mcp.json` | MCP server configuration for VS Code |

### The Four Primitives (real examples)
| File | Primitive |
|------|-----------|
| `.github/copilot-instructions.md` | 📖 Global instructions |
| `.github/instructions/security.instructions.md` | 📖 Path-specific instructions |
| `.github/prompts/create-api-endpoint.prompt.md` | 📋 Reusable prompt |
| `.github/prompts/generate-tests.prompt.md` | 📋 Reusable prompt |
| `.github/prompts/review-security.prompt.md` | 📋 Reusable prompt |
| `.github/agents/security-reviewer.agent.md` | 🤖 Custom agent |
| `.github/agents/api-builder.agent.md` | 🤖 Custom agent |
| `.github/skills/azure-deploy/SKILL.md` | 🧠 Skill definition |
| `COPILOT.md` | 🤖 Coding agent instructions |

### GitHub Actions Workflows
| File | Purpose |
|------|---------|
| `.github/workflows/ci.yml` | Build, test, security audit |
| `.github/workflows/codeql.yml` | CodeQL security analysis |
| `.github/workflows/deploy.yml` | Deploy to Azure |

### Interactive Demo
| File | Description |
|------|-------------|
| `demo/interactive-demo.html` | VS Code simulation with 18-step walkthrough |

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/sautalwar/copilot-workshop.git
cd copilot-workshop

# Install dependencies
npm install

# Open the capabilities presentation
start copilot-capabilities.html

# Or run the MCP server
npm run start:mcp-safe
```

## 📚 Workshop Modules (1 hour)

| # | Module | Duration | Topics |
|---|--------|----------|--------|
| 1 | **Chat Basics** | 10 min | @ commands, / commands, # commands, Chat Modes |
| 2 | **Four Primitives** | 15 min | Prompts, Instructions, Skills, Agents |
| 3 | **MCP Servers** | 10 min | Build from scratch, safe vs unsafe, cross-repo bridges |
| 4 | **GitHub Actions** | 10 min | CI pipeline, CodeQL, secret scanning |
| 5 | **Enterprise Patterns** | 10 min | Memory, multi-repo, governance |
| 6 | **Security & Data** | 5 min | Prompt journey, data retention, residency |

## 🔧 Available Scripts

```bash
npm run start:mcp-safe      # Run safe MCP server (PII redacted)
npm run start:mcp-unsafe     # Run unsafe MCP server (demo only!)
npm run start:api            # Run example API server
npm run build                # Compile TypeScript
npm test                     # Run tests
```

## 📖 Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Microsoft Learn — Copilot Prompt Engineering](https://learn.microsoft.com/training/modules/introduction-prompt-engineering-with-github-copilot/)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)
- [Hackathon Repo](https://github.com/sautalwar/ghcp-hackathon-custom)

## Author

**Saurabh Talwar** — GitHub AI Developer

---

Questions? [Open an issue](https://github.com/sautalwar/copilot-workshop/issues) · [Submit a PR](https://github.com/sautalwar/copilot-workshop/pulls)

**Happy learning! 🚀**
