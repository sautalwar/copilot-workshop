# Exercise 1: What is MCP and Why Does It Matter?

## 🎯 Objective

Understand the Model Context Protocol (MCP) — what it does, why it exists, and how it's configured in this project.

## ⏱️ Time: ~5 minutes

## Background

Here's the problem: Copilot is great at reading your code, but your code isn't your whole business. What about your inventory data? Your order statuses? Your campaign budgets?

**Without MCP**, Copilot only sees your source files. Ask it "how many LED panels do we have in stock?" and it can only guess based on seed data in your SQL files.

**With MCP**, Copilot can actually call a tool that checks your inventory system and give you a real answer.

### The Analogy

Think of MCP like giving Copilot a **phone**:

- Without MCP: Copilot is a very smart coworker sitting next to you, but they can only see what's on your screen.
- With MCP: That same coworker now has a phone and a contact list. They can call your warehouse, check your order system, and look up client information — all while you're chatting.

### How It Works (30-Second Version)

```
You (in Copilot Chat)          VS Code               MCP Server
        │                         │                       │
        │  "How many LED panels   │                       │
        │   do we have?"          │                       │
        │────────────────────────►│                       │
        │                         │  Call lookup_inventory │
        │                         │  { query: "LED" }     │
        │                         │──────────────────────►│
        │                         │                       │  Search
        │                         │                       │  data...
        │                         │  [{ sku: "LED-7236",  │
        │                         │     quantity: 50 }]   │
        │                         │◄──────────────────────│
        │  "We have 50 LED Panel  │                       │
        │   72x36 units in stock" │                       │
        │◄────────────────────────│                       │
```

1. You ask a natural-language question
2. Copilot recognizes that an MCP tool can answer it
3. VS Code calls the MCP server over **stdio** (stdin/stdout)
4. The server processes the request and returns data
5. Copilot formats the data into a human-readable answer

## Steps

### Step 1: Read the MCP Server README

Open `mcp-server/README.md` in VS Code.

Skim the sections. Notice:
- **What tools exist** — There are 3 tools, each with a clear purpose
- **How it's configured** — A single JSON file tells VS Code about the server
- **The guardrails** — Rate limiting, input validation, audit logging, response filtering

> 💡 **Key insight:** An MCP server is just a Node.js program that speaks JSON-RPC over stdin/stdout. There's no web server, no port, no HTTP. VS Code starts the process and talks to it directly.

### Step 2: Look at the MCP Configuration

Open `.vscode/mcp.json` in VS Code.

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

This tiny file does a lot:
- **`"type": "stdio"`** — Tells VS Code to communicate over stdin/stdout (not HTTP)
- **`"command": "node"`** — The program to run
- **`"args"`** — Points to your MCP server script
- **`"inventory-lookup"`** — The name that appears in Copilot's tool picker

When VS Code opens your workspace, it reads this file and starts the MCP server automatically. The server's tools then show up in Copilot Chat.

### Step 3: Verify the MCP Server Is Running

1. Open **Copilot Chat** in VS Code (Ctrl+Shift+I or Cmd+Shift+I)
2. Click the **🔧 tools icon** in the chat input area
3. Look for tools prefixed with **inventory-lookup** — you should see:
   - `lookup_inventory`
   - `check_stock_level`
   - `get_order_status`

If you see them, the MCP server is running and Copilot knows about its tools.

> **Troubleshooting:** If the tools don't appear, try:
> 1. Make sure you ran `cd mcp-server && npm install`
> 2. Open the Command Palette (Ctrl+Shift+P) → "MCP: List Servers"
> 3. Check that the server status is "running"
> 4. If it shows an error, run `node mcp-server/index.js` in a terminal to see the error message

## ✅ Expected Outcome

You understand that:
- MCP gives Copilot access to tools beyond your source code
- An MCP server is a process that VS Code launches and communicates with over stdio
- `.vscode/mcp.json` is the configuration that connects VS Code to the server
- The server's tools appear automatically in Copilot Chat

> **Key takeaway:** MCP is simple in concept — it's a way to register tools that Copilot can call. The magic is in what those tools connect to: databases, APIs, monitoring systems, anything your team uses.

---

[← Back to Lab 6 overview](../README.md) | [Next: Explore Existing Tools →](02-explore-existing-tools.md)
