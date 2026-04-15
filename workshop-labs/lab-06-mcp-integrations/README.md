# Lab 6: MCP & Integrations

## 🎯 Objective

Understand the **Model Context Protocol (MCP)**, explore a working MCP server, and create your own custom tool that extends GitHub Copilot with real business data. By the end of this lab, Copilot will answer questions about advertising campaigns using a tool **you** built.

## ⏱️ Duration

~25 minutes (3 exercises)

## Prerequisites

- VS Code with GitHub Copilot and Copilot Chat installed
- **Node.js 18+** installed (`node --version` to check)
- The `workshop-labs/` folder open as your workspace root
- The MCP server dependencies installed: `cd mcp-server && npm install`

## What You'll Build

A new MCP tool called `get_campaign_info` that lets Copilot look up advertising campaign data — clients, budgets, locations, and dates. This is the capstone exercise: you'll take everything you've learned about Copilot and combine it with a custom integration.

## Why This Matters

Without MCP, Copilot can only see your code files. That's useful, but limited. **With MCP**, Copilot can:

- Query your inventory database
- Check order statuses
- Look up campaign details
- Call any internal API your team uses

MCP turns Copilot from a code assistant into a **business operations assistant**.

**How agentic AI helps here:** MCP is the ultimate example of agentic AI — Copilot doesn't just suggest code, it actively calls YOUR tools to get real answers. Ask "What campaigns do we have for Coca-Cola?" and Copilot decides which tool to call, formats the request, and presents the answer. You're not writing queries or switching tabs — the AI agent does the work for you, using tools you defined.

## Exercises

| # | Exercise | Time | What You'll Do |
|---|----------|------|----------------|
| 1 | [Understand MCP](exercises/01-understand-mcp.md) | ~5 min | Learn what MCP is and how it's configured |
| 2 | [Explore Existing Tools](exercises/02-explore-existing-tools.md) | ~8 min | Use the 3 built-in MCP tools through Copilot Chat |
| 3 | [Create a Campaign Tool](exercises/03-create-campaign-tool.md) | ~12 min | Build your own MCP tool and test it in Copilot |

## Folder Structure

```
workshop-labs/
├── .vscode/
│   └── mcp.json                    ← MCP server configuration (Exercise 1)
├── mcp-server/
│   ├── index.js                    ← The MCP server code (Exercises 2 & 3)
│   ├── package.json
│   └── README.md                   ← Server documentation
└── lab-06-mcp-integrations/
    ├── README.md                   ← You are here
    ├── exercises/
    │   ├── 01-understand-mcp.md
    │   ├── 02-explore-existing-tools.md
    │   └── 03-create-campaign-tool.md
    └── solutions/
        ├── index-with-campaign-tool.js   ← Complete solution
        └── mcp.json                      ← Reference config
```

## Going Further

Finished early? Here are ways to take MCP further:

### Enterprise MCP Scenarios

- **Jira Integration** — Look up tickets, sprint status, and blockers directly from Copilot Chat. The repo's `.vscode/mcp.json` already has a Jira server configured — just add your credentials.
- **Azure DevOps** — Query work items, pipeline status, and pull requests.
- **Slack Notifications** — Build an MCP tool that posts deployment updates to a Slack channel.
- **Database Queries** — Connect MCP to a read-only database replica for live data lookups.

### Security Best Practices

- **Authentication** — Load API keys from environment variables (`${env:MY_KEY}` in `mcp.json`)
- **Rate Limiting** — The workshop server limits to 10 req/min; production servers should use token-bucket algorithms per user
- **Data Filtering** — Never expose database IDs, internal URLs, or PII in tool responses
- **Input Validation** — Always sanitize LLM-generated inputs before passing to APIs or databases

### MCP in Production

- **Deployment** — Package MCP servers as Docker containers or npm packages
- **Monitoring** — Route audit logs to your observability stack (Datadog, Splunk, Application Insights)
- **Versioning** — Use semantic versioning for tool schemas; breaking changes need coordination with Copilot prompts

> **Key takeaway:** MCP is the bridge between Copilot and your organization's systems. The pattern you learned today — define a tool, validate inputs, filter outputs — scales to any API or data source.

---

[← Back to Workshop Overview](../README.md)
