# OutFront Inventory MCP Server

A custom [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) server that
exposes OutFront Media's inventory data to GitHub Copilot. Built as a **workshop teaching
example** to demonstrate how to create MCP servers with production-grade guardrails.

---

## What This Server Does

| Tool | Purpose |
|------|---------|
| `lookup_inventory` | Search inventory by SKU or keyword — returns product details |
| `check_stock_level` | Check quantity on hand for a SKU and flag low-stock items |
| `get_order_status` | Look up an order by ID and return its current status |

The data is hardcoded to match the Spring Boot app's seed data (`src/main/resources/data.sql`),
so you can compare Copilot's MCP-powered answers against the running application.

---

## Quick Start

```bash
# 1. Install dependencies
cd mcp-server
npm install

# 2. Test the server manually (it communicates over stdio)
node index.js
```

> The server speaks JSON-RPC over **stdin/stdout** — you won't see a web UI.
> VS Code starts it automatically when you open the workspace.

---

## Configuring in VS Code

The `.vscode/mcp.json` file in this repo already registers the server:

```jsonc
{
  "servers": {
    "inventory-lookup": {
      "type": "stdio",
      "command": "node",
      "args": ["${workspaceFolder}/mcp-server/index.js"]
    }
  }
}
```

Once configured, open **Copilot Chat** and the `inventory-lookup` tools will appear
in the tool picker (click the 🔧 icon).

---

## Guardrails — Why They Matter

This server includes four guardrail patterns that every production MCP server should
implement. Each one is clearly marked in `index.js` with comments.

### 1. Rate Limiting
```
⏱  Max 10 requests per 60-second sliding window
```
Prevents a runaway AI loop from hammering your backend. Without this, a single
Copilot prompt could generate hundreds of API calls.

### 2. Input Validation
```
🛡  Reject SQL injection patterns, enforce max length, sanitize strings
```
LLMs generate tool inputs — they can hallucinate dangerous payloads. Always validate
and sanitize before passing inputs to any real data source.

### 3. Audit Logging
```
📋  Every tool call is logged with timestamp, tool name, and arguments
```
Essential for debugging ("what did Copilot actually ask?") and compliance. In
production, send these to your observability stack.

### 4. Response Filtering
```
🔒  Strip internal IDs and sensitive fields before returning data
```
MCP tool responses flow back into the LLM context. Never expose database IDs,
internal URLs, or PII that the model doesn't need.

---

## How to Extend — Adding a New Tool

1. **Define sample data** (or wire up a real API call):
   ```js
   const MY_DATA = new Map([["key1", { ... }]]);
   ```

2. **Register the tool** in the `server.setRequestHandler(ListToolsRequestSchema, ...)`
   handler — add an entry to the `tools` array:
   ```js
   {
     name: "my_new_tool",
     description: "What this tool does — be specific so Copilot picks it correctly",
     inputSchema: {
       type: "object",
       properties: {
         myParam: { type: "string", description: "Describe the parameter" }
       },
       required: ["myParam"]
     }
   }
   ```

3. **Handle the call** in `server.setRequestHandler(CallToolRequestSchema, ...)` —
   add a `case "my_new_tool":` block with validation + response filtering.

4. **Restart the server** — in VS Code, run `MCP: Restart Server` from the Command
   Palette or reload the window.

---

## Adapting for Your Own APIs

This server uses hardcoded data for the workshop. To connect to real systems:

1. **Replace sample data** with `fetch()` calls to your internal APIs
2. **Add authentication** — load API keys from environment variables
   (reference them in `.vscode/mcp.json` via `${env:MY_API_KEY}`)
3. **Add error handling** — wrap API calls in try/catch blocks
4. **Tighten guardrails** — adjust rate limits, add field-level access control,
   integrate with your audit/logging platform

```js
// Example: real API call with auth
const response = await fetch(`${process.env.API_BASE_URL}/inventory/${sku}`, {
  headers: { "Authorization": `Bearer ${process.env.API_TOKEN}` }
});
const data = await response.json();
```

---

## Architecture

```
┌──────────────┐    stdio (JSON-RPC)    ┌──────────────────┐
│  VS Code /   │ ◄────────────────────► │  MCP Server      │
│  Copilot     │                        │  (this project)  │
│  Chat        │                        │                  │
└──────────────┘                        │  ┌────────────┐  │
                                        │  │ Guardrails │  │
                                        │  │ • Rate Lim │  │
                                        │  │ • Validate │  │
                                        │  │ • Audit    │  │
                                        │  │ • Filter   │  │
                                        │  └─────┬──────┘  │
                                        │        │         │
                                        │  ┌─────▼──────┐  │
                                        │  │ Tool Logic │  │
                                        │  │ (data /    │  │
                                        │  │  API call) │  │
                                        │  └────────────┘  │
                                        └──────────────────┘
```

---

## License

Workshop material — use freely within your organization.
