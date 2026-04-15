# Exercise 2: Explore the Existing MCP Server

## 🎯 Objective

Walk through the MCP server code, understand how each tool works, and use all 3 tools through Copilot Chat.

## ⏱️ Time: ~8 minutes

## Steps

### Step 1: Open the MCP Server Code

Open `mcp-server/index.js` in VS Code.

This file has four sections — scroll through each one:

| Section | What It Does |
|---------|-------------|
| **Sample Data** (lines ~25–155) | Hardcoded inventory and order data in `Map` objects |
| **Guardrails** (lines ~157–267) | Rate limiting, input validation, audit logging, response filtering |
| **Tool Definitions** (lines ~270–420) | The 3 tools Copilot can call |
| **Server Startup** (lines ~425–437) | Connects to VS Code over stdio |

### Step 2: Understand the Tool Pattern

Every tool in this server follows the same pattern. Look at `lookup_inventory` (around line 284):

```js
server.tool(
  "lookup_inventory",                    // 1. Tool name — what Copilot sees
  "Search OutFront Media inventory...",  // 2. Description — helps Copilot decide when to use it
  {
    query: z.string().describe("...")    // 3. Input schema — what parameters the tool accepts
  },
  async ({ query }) => {                 // 4. Handler — the actual logic
    checkRateLimit();                    //    → Guardrail: rate limit
    const sanitized = validateInput(...); //   → Guardrail: validate input
    auditLog("lookup_inventory", ...);   //    → Guardrail: log the call
    // ... search logic ...
    return {
      content: [{                        // 5. Response — always this format
        type: "text",
        text: JSON.stringify(results)
      }]
    };
  }
);
```

The key insight: **every tool is just a function with a name, a description, a schema, and a handler**. Copilot reads the name and description to decide when to call it, and uses the schema to know what parameters to pass.

### Step 3: Try the Inventory Lookup Tool

In **Copilot Chat**, type:

```
What inventory do we have for LED panels?
```

Watch what happens:
- Copilot recognizes this is an inventory question
- It calls the `lookup_inventory` tool with something like `{ query: "LED" }`
- The tool searches the inventory data and returns matching items
- Copilot formats the result into a natural-language answer

You should see information about the **LED Panel 72x36** — 50 units in Warehouse A, Newark, NJ.

> 💡 **Tip:** MCP tools show up automatically when Copilot detects they can answer your question. You don't need to explicitly select them — Copilot matches your question to the tool's description.

### Step 4: Try the Stock Level Check

In Copilot Chat, type:

```
Is the stock level for SKD-3220 low?
```

This triggers the `check_stock_level` tool. The **Smart Kiosk Display** has only 12 units — below the 20-unit threshold — so you should see a low-stock warning.

Now try one that's well-stocked:

```
Check the stock level for MNT-UNI
```

The **Universal Mounting Bracket** has 100 units — no warning this time.

### Step 5: Try the Order Status Tool

In Copilot Chat, type:

```
What's the status of order ORD-1003?
```

This triggers `get_order_status`. You should see that order ORD-1003 (Lamar Advertising, Transit Display Modules) has status **SHIPPED**.

Try another:

```
What's happening with order ORD-1002?
```

This one should show **PENDING** — JCDecaux Transit is waiting for site survey approval.

### Step 6: Examine the Guardrails

Now that you've used the tools, let's look at what's protecting them. In `index.js`, find each guardrail section:

**Rate Limiting** (~line 163):
```js
const RATE_LIMIT_MAX = 10;        // max 10 requests per minute
const RATE_LIMIT_WINDOW_MS = 60_000;
```
> Without this, a single Copilot prompt could trigger hundreds of tool calls if it enters a reasoning loop.

**Input Validation** (~line 200):
```js
const SQL_INJECTION_PATTERN = /(\b(DROP|DELETE|INSERT|UPDATE|ALTER|EXEC|UNION)\b|--|;|')/i;
const MAX_INPUT_LENGTH = 100;
```
> LLMs generate tool inputs — they can hallucinate dangerous payloads. This catches common attack patterns.

**Audit Logging** (~line 228):
```js
function auditLog(toolName, args) {
  console.error(`[AUDIT] ${JSON.stringify(entry)}`);
}
```
> Logs to stderr (stdout is reserved for MCP protocol). In production, route these to Datadog, Splunk, etc.

**Response Filtering** (~line 243):
```js
function filterOrder(order) {
  return {
    orderId: order.orderId,
    // ... only public fields
    // NOTE: "notes" deliberately omitted
  };
}
```
> The `notes` field on orders is stripped out — it might contain internal information. Only expose what Copilot needs.

## ✅ Expected Outcome

You've:
- Read the MCP server code and understand the tool pattern (name + description + schema + handler)
- Used all 3 MCP tools through Copilot Chat
- Examined the 4 guardrail patterns that protect the server
- Seen the "wow moment" — Copilot answering business questions using YOUR data

## Discussion Questions

1. **How does Copilot decide which tool to call?** It reads the tool name and description. What happens if two tools have similar descriptions? How specific should descriptions be?

2. **Why is the `notes` field filtered out of order responses?** What kinds of data should you never send back to an LLM?

3. **What would happen without rate limiting?** Imagine asking Copilot "Give me a full report of all inventory and all orders." How many tool calls might that generate?

---

[← Back to Lab 6 overview](../README.md) | [Previous: Understand MCP ←](01-understand-mcp.md) | [Next: Create a Campaign Tool →](03-create-campaign-tool.md)
