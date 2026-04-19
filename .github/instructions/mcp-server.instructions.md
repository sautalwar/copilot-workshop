---
applyTo: "mcp-server/**/*.js"
---

# MCP Server Code Instructions

## Context

This is an MCP (Model Context Protocol) server that exposes OutFront Media's inventory and order
data to GitHub Copilot via stdio transport. It uses the `@modelcontextprotocol/sdk` package and
`zod` for schema validation. The server mirrors seed data from the Spring Boot OMS application
(`src/main/resources/data.sql`).

## Architecture

- **Transport:** stdio (JSON-RPC over stdin/stdout) — never HTTP
- **SDK:** `@modelcontextprotocol/sdk` with `McpServer` and `StdioServerTransport`
- **Validation:** All tool inputs validated with `zod` schemas before processing
- **Structure:** Data layer (Maps) → Guardrails layer (validation + filtering) → Tool handlers
- Register each tool with `server.tool(name, description, schema, handler)`
- Keep tool handlers under 30 lines — extract helpers for complex logic
- Use ES module syntax (`import`/`export`), not CommonJS (`require`)

## Security

- **Input validation is mandatory.** Every tool parameter MUST have a zod schema with constraints:
  ```javascript
  // Good — constrained
  { sku: z.string().regex(/^[A-Z]{2,4}-[A-Z0-9]{2,6}$/i).describe("Product SKU") }

  // Bad — unconstrained
  { sku: z.string() }
  ```
- **Never expose raw data dumps.** Tools must filter to specific records, never return entire collections
- **Rate limiting:** Maintain a per-tool call counter. Reject with a clear message after threshold
- **Response filtering:** Strip internal fields (cost prices, supplier contacts, internal notes) before returning
- **Audit logging:** Log every tool invocation to stderr with timestamp, tool name, and parameters
- **No filesystem access.** MCP tools must only read from in-memory data or the Spring Boot API — never `fs.readFile`
- **No shell execution.** Never use `child_process`, `exec`, or `spawn` in tool handlers

## Patterns

### Tool Registration Pattern

```javascript
server.tool(
  "tool_name",
  "Clear one-line description of what this tool does",
  {
    paramName: z.string().describe("What this parameter means")
  },
  async ({ paramName }) => {
    // 1. Validate / normalize input
    // 2. Look up data
    // 3. Filter sensitive fields
    // 4. Return formatted response
    return {
      content: [{ type: "text", text: JSON.stringify(result, null, 2) }]
    };
  }
);
```

### Error Response Pattern

Always return errors as content (not exceptions) so the LLM can recover:

```javascript
if (!record) {
  return {
    content: [{ type: "text", text: `No record found for ID: ${id}` }]
  };
}
```

### Audit Logging Pattern

```javascript
console.error(`[${new Date().toISOString()}] tool=${toolName} params=${JSON.stringify(params)}`);
```

Use `console.error` (stderr) for logging — `console.log` (stdout) is reserved for MCP protocol messages.

## Data Alignment

- Inventory SKUs must match those in `src/main/resources/data.sql` and the Spring Boot app
- Order IDs follow the pattern `ORD-NNNN` (e.g., ORD-1001, ORD-1002)
- Order statuses are: `PENDING`, `CONFIRMED`, `SHIPPED` — use these exact strings
- Low-stock threshold is **10 units** (same business rule as the Spring Boot service)
- When adding new sample data, keep it realistic to OutFront Media's billboard/signage domain

## Testing

- Test locally with: `node mcp-server/index.js` (reads from stdin, writes to stdout)
- Use MCP Inspector for interactive testing: `npx @modelcontextprotocol/inspector`
- Verify tool responses are valid JSON with `content` array containing `type: "text"` objects
- Test edge cases: empty strings, non-existent SKUs/order IDs, SQL injection attempts
- VS Code integration configured in `.vscode/mcp.json` — test via Copilot chat with `#tool`

## Examples

### Complete Tool Handler (Reference)

```javascript
server.tool(
  "check_stock_level",
  "Check if a product has sufficient stock by SKU. Returns quantity and low-stock warning.",
  {
    sku: z.string()
      .regex(/^[A-Z]{2,4}-[A-Z0-9]{2,6}$/i)
      .describe("Product SKU code (e.g., DSU-9648, LED-7236)")
  },
  async ({ sku }) => {
    console.error(`[${new Date().toISOString()}] tool=check_stock_level sku=${sku}`);

    const item = INVENTORY.get(sku.toUpperCase());
    if (!item) {
      return {
        content: [{ type: "text", text: `Unknown SKU: ${sku}. Use lookup_inventory to search.` }]
      };
    }

    const LOW_STOCK_THRESHOLD = 10;
    const isLow = item.quantity < LOW_STOCK_THRESHOLD;

    return {
      content: [{
        type: "text",
        text: JSON.stringify({
          sku: item.sku,
          name: item.name,
          quantity: item.quantity,
          location: item.location,
          lowStock: isLow,
          warning: isLow ? `LOW STOCK: Only ${item.quantity} units remaining` : null
        }, null, 2)
      }]
    };
  }
);
```

## Memory

- The MCP server's INVENTORY and ORDERS Maps must stay in sync with `src/main/resources/data.sql` — any new seed data added to the Spring Boot app must be mirrored here
- `console.log` writes to stdout which is the MCP protocol transport — NEVER use it for debugging; always use `console.error` for logging
- The `z.string().regex()` pattern for SKU validation (`/^[A-Z]{2,4}-[A-Z0-9]{2,6}$/i`) is the project-wide standard — reuse it in any new tool that accepts SKU input
- Rate limiting is implemented per-tool with a simple counter object — reset counters on server restart, not per-connection
- Order IDs follow `ORD-NNNN` format; inventory SKUs follow `XXX-YYYY` format (2-4 letter prefix, hyphen, 2-6 alphanumeric suffix)
- The low-stock threshold of 10 units is a business rule shared with `InventoryService.java` — if it changes there, update it here too
