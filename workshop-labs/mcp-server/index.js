// =============================================================================
// OutFront Media — Custom MCP Server (Workshop Example)
// =============================================================================
//
// This server exposes inventory and order data to GitHub Copilot via the
// Model Context Protocol (MCP). It is a TEACHING EXAMPLE that demonstrates
// how to build an MCP server with production-grade guardrails.
//
// Transport: stdio (JSON-RPC over stdin/stdout)
// SDK:       @modelcontextprotocol/sdk
//
// Run:       node index.js
// Configure: .vscode/mcp.json registers this server for VS Code
// =============================================================================

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// =============================================================================
// 📦  SAMPLE DATA — mirrors the Spring Boot app's seed data (data.sql)
// =============================================================================
// In production, replace these with real API calls to your inventory system.

const INVENTORY = new Map([
  ["DSU-9648", {
    sku: "DSU-9648",
    name: "Digital Screen Unit 96x48",
    description: "High-brightness 96x48 inch digital billboard screen, weatherproof",
    quantity: 25,
    location: "Warehouse A — Newark, NJ",
    lastUpdated: "2024-11-01"
  }],
  ["LED-7236", {
    sku: "LED-7236",
    name: "LED Panel 72x36",
    description: "Full-color LED panel for urban signage, 72x36 inches",
    quantity: 50,
    location: "Warehouse A — Newark, NJ",
    lastUpdated: "2024-11-03"
  }],
  ["TDM-2412", {
    sku: "TDM-2412",
    name: "Transit Display Module",
    description: "Compact transit shelter display, 24x12 inches, anti-glare",
    quantity: 30,
    location: "Warehouse B — Los Angeles, CA",
    lastUpdated: "2024-10-28"
  }],
  ["SKD-3220", {
    sku: "SKD-3220",
    name: "Smart Kiosk Display",
    description: "Interactive touch kiosk with 32-inch screen, built-in sensors",
    quantity: 12,
    location: "Warehouse A — Newark, NJ",
    lastUpdated: "2024-11-05"
  }],
  ["SBC-001", {
    sku: "SBC-001",
    name: "Solar Billboard Controller",
    description: "Solar-powered controller unit for remote billboard sites",
    quantity: 40,
    location: "Warehouse C — Dallas, TX",
    lastUpdated: "2024-11-02"
  }],
  ["MNT-UNI", {
    sku: "MNT-UNI",
    name: "Universal Mounting Bracket",
    description: "Adjustable steel mounting bracket for panels up to 96 inches",
    quantity: 100,
    location: "Warehouse A — Newark, NJ",
    lastUpdated: "2024-10-15"
  }],
  ["CAB-HDMI50", {
    sku: "CAB-HDMI50",
    name: "HDMI Cable 50ft",
    description: "Industrial-grade 50-foot HDMI cable, weatherproof connectors",
    quantity: 200,
    location: "Warehouse B — Los Angeles, CA",
    lastUpdated: "2024-10-20"
  }],
  ["PSU-500W", {
    sku: "PSU-500W",
    name: "Power Supply Unit 500W",
    description: "500W weatherproof power supply for outdoor digital displays",
    quantity: 75,
    location: "Warehouse C — Dallas, TX",
    lastUpdated: "2024-11-01"
  }],
  ["CTL-MEDIA", {
    sku: "CTL-MEDIA",
    name: "Media Player Controller",
    description: "ARM-based media player for content scheduling and playback",
    quantity: 35,
    location: "Warehouse A — Newark, NJ",
    lastUpdated: "2024-11-07"
  }],
  ["SEN-AMB", {
    sku: "SEN-AMB",
    name: "Ambient Light Sensor",
    description: "Auto-brightness ambient light sensor for dynamic display adjustment",
    quantity: 60,
    location: "Warehouse B — Los Angeles, CA",
    lastUpdated: "2024-11-04"
  }]
]);

const ORDERS = new Map([
  ["ORD-1001", {
    orderId: "ORD-1001",
    customerName: "Clear Channel NYC",
    productName: "Digital Screen Unit 96x48",
    quantity: 4,
    status: "CONFIRMED",
    orderDate: "2024-11-01",
    notes: "Install at Times Square locations"
  }],
  ["ORD-1002", {
    orderId: "ORD-1002",
    customerName: "JCDecaux Transit",
    productName: "LED Panel 72x36",
    quantity: 10,
    status: "PENDING",
    orderDate: "2024-11-05",
    notes: "Awaiting site survey approval"
  }],
  ["ORD-1003", {
    orderId: "ORD-1003",
    customerName: "Lamar Advertising",
    productName: "Transit Display Module",
    quantity: 6,
    status: "SHIPPED",
    orderDate: "2024-10-20",
    notes: "Shipped via freight — ETA Nov 15"
  }],
  ["ORD-1004", {
    orderId: "ORD-1004",
    customerName: "Outfront Media HQ",
    productName: "Smart Kiosk Display",
    quantity: 2,
    status: "PENDING",
    orderDate: "2024-11-10",
    notes: "Internal demo units for trade show"
  }],
  ["ORD-1005", {
    orderId: "ORD-1005",
    customerName: "Adams Outdoor",
    productName: "Solar Billboard Controller",
    quantity: 8,
    status: "CONFIRMED",
    orderDate: "2024-11-08",
    notes: "Rural highway deployment — Phase 1"
  }]
]);

// =============================================================================
// 🛡️  GUARDRAIL 1 — Rate Limiting
// =============================================================================
// Prevents runaway AI loops from flooding your backend with requests.
// Uses a sliding-window counter: max 10 requests per 60-second window.
// In production, use a proper rate limiter (e.g., token bucket per user).

const RATE_LIMIT_MAX = 10;        // max requests allowed in the window
const RATE_LIMIT_WINDOW_MS = 60_000; // 60-second sliding window
const requestTimestamps = [];      // timestamps of recent requests

function checkRateLimit() {
  const now = Date.now();

  // Remove timestamps older than the window
  while (requestTimestamps.length > 0 && requestTimestamps[0] <= now - RATE_LIMIT_WINDOW_MS) {
    requestTimestamps.shift();
  }

  if (requestTimestamps.length >= RATE_LIMIT_MAX) {
    const retryAfterSec = Math.ceil((requestTimestamps[0] + RATE_LIMIT_WINDOW_MS - now) / 1000);
    throw new Error(
      `Rate limit exceeded — max ${RATE_LIMIT_MAX} requests per minute. ` +
      `Try again in ${retryAfterSec} seconds.`
    );
  }

  requestTimestamps.push(now);
}

// =============================================================================
// 🛡️  GUARDRAIL 2 — Input Validation
// =============================================================================
// LLMs generate tool inputs and can hallucinate dangerous payloads.
// Always validate and sanitize before using inputs in queries or API calls.
//
// Rules enforced here:
//   • Max length: 100 characters (prevents prompt-stuffing)
//   • No SQL injection patterns (DROP, DELETE, INSERT, UPDATE, --, ;)
//   • Strip leading/trailing whitespace

const SQL_INJECTION_PATTERN = /(\b(DROP|DELETE|INSERT|UPDATE|ALTER|EXEC|UNION)\b|--|;|')/i;
const MAX_INPUT_LENGTH = 100;

function validateInput(value, fieldName) {
  if (typeof value !== "string") {
    throw new Error(`${fieldName} must be a string.`);
  }

  const trimmed = value.trim();

  if (trimmed.length === 0) {
    throw new Error(`${fieldName} cannot be empty.`);
  }

  if (trimmed.length > MAX_INPUT_LENGTH) {
    throw new Error(`${fieldName} exceeds max length of ${MAX_INPUT_LENGTH} characters.`);
  }

  if (SQL_INJECTION_PATTERN.test(trimmed)) {
    throw new Error(`${fieldName} contains disallowed characters or patterns.`);
  }

  return trimmed;
}

// =============================================================================
// 🛡️  GUARDRAIL 3 — Audit Logging
// =============================================================================
// Logs every tool invocation to stderr (stdout is reserved for MCP protocol).
// In production, send these to your observability stack (Datadog, Splunk, etc.).

function auditLog(toolName, args) {
  const entry = {
    timestamp: new Date().toISOString(),
    tool: toolName,
    arguments: args
  };
  console.error(`[AUDIT] ${JSON.stringify(entry)}`);
}

// =============================================================================
// 🛡️  GUARDRAIL 4 — Response Filtering
// =============================================================================
// Strips internal fields (like database IDs) before returning data to the LLM.
// The model should only see what it needs — never internal identifiers or PII.

function filterInventoryItem(item) {
  // Return only the fields Copilot needs — omit internal "id" if present
  return {
    sku: item.sku,
    name: item.name,
    description: item.description,
    quantity: item.quantity,
    location: item.location,
    lastUpdated: item.lastUpdated
  };
}

function filterOrder(order) {
  // Expose order details but strip any internal database identifiers
  return {
    orderId: order.orderId,
    customerName: order.customerName,
    productName: order.productName,
    quantity: order.quantity,
    status: order.status,
    orderDate: order.orderDate
    // NOTE: "notes" deliberately omitted — may contain internal info.
    // Add it back if your use case requires it.
  };
}

// =============================================================================
// 🚀  MCP SERVER SETUP
// =============================================================================

const server = new McpServer({
  name: "outfront-inventory",
  version: "1.0.0"
});

// -----------------------------------------------------------------------------
// Tool 1: lookup_inventory
// -----------------------------------------------------------------------------
// Searches inventory by exact SKU or keyword match on name/description.
// Returns matching items with quantities and warehouse locations.

server.tool(
  "lookup_inventory",
  "Search OutFront Media inventory by SKU or keyword. Returns product details, stock levels, and warehouse locations.",
  {
    query: z.string().describe("A SKU (e.g. 'LED-7236') or search keyword (e.g. 'solar')")
  },
  async ({ query }) => {
    // --- Guardrails ---
    checkRateLimit();
    const sanitizedQuery = validateInput(query, "query");
    auditLog("lookup_inventory", { query: sanitizedQuery });

    // --- Search logic ---
    const upperQuery = sanitizedQuery.toUpperCase();
    const results = [];

    for (const item of INVENTORY.values()) {
      const matchesSku = item.sku.toUpperCase() === upperQuery;
      const matchesName = item.name.toUpperCase().includes(upperQuery);
      const matchesDesc = item.description.toUpperCase().includes(upperQuery);

      if (matchesSku || matchesName || matchesDesc) {
        results.push(filterInventoryItem(item)); // Guardrail 4: filter response
      }
    }

    if (results.length === 0) {
      return {
        content: [{
          type: "text",
          text: `No inventory items found matching "${sanitizedQuery}".`
        }]
      };
    }

    return {
      content: [{
        type: "text",
        text: JSON.stringify(results, null, 2)
      }]
    };
  }
);

// -----------------------------------------------------------------------------
// Tool 2: check_stock_level
// -----------------------------------------------------------------------------
// Checks the stock level for a specific SKU and flags low-stock items.
// "Low stock" threshold: 20 units (configurable for your business rules).

const LOW_STOCK_THRESHOLD = 20;

server.tool(
  "check_stock_level",
  "Check stock level for a specific SKU. Returns quantity on hand and a low-stock warning if applicable.",
  {
    sku: z.string().describe("The product SKU to check (e.g. 'SKD-3220')")
  },
  async ({ sku }) => {
    // --- Guardrails ---
    checkRateLimit();
    const sanitizedSku = validateInput(sku, "sku");
    auditLog("check_stock_level", { sku: sanitizedSku });

    // --- Lookup ---
    const item = INVENTORY.get(sanitizedSku.toUpperCase());

    if (!item) {
      return {
        content: [{
          type: "text",
          text: `SKU "${sanitizedSku}" not found in inventory.`
        }]
      };
    }

    const isLowStock = item.quantity < LOW_STOCK_THRESHOLD;

    // Guardrail 4: only return what the model needs
    const response = {
      sku: item.sku,
      name: item.name,
      quantity: item.quantity,
      location: item.location,
      isLowStock,
      ...(isLowStock && {
        warning: `⚠️ Low stock — only ${item.quantity} units remaining (threshold: ${LOW_STOCK_THRESHOLD})`
      })
    };

    return {
      content: [{
        type: "text",
        text: JSON.stringify(response, null, 2)
      }]
    };
  }
);

// -----------------------------------------------------------------------------
// Tool 3: get_order_status
// -----------------------------------------------------------------------------
// Retrieves the status of an order by its ID. Useful for customer inquiries
// or tracking shipments through Copilot Chat.

server.tool(
  "get_order_status",
  "Look up an order by ID and return its current status (PENDING, CONFIRMED, or SHIPPED).",
  {
    orderId: z.string().describe("The order ID to look up (e.g. 'ORD-1001')")
  },
  async ({ orderId }) => {
    // --- Guardrails ---
    checkRateLimit();
    const sanitizedId = validateInput(orderId, "orderId");
    auditLog("get_order_status", { orderId: sanitizedId });

    // --- Lookup ---
    const order = ORDERS.get(sanitizedId.toUpperCase());

    if (!order) {
      return {
        content: [{
          type: "text",
          text: `Order "${sanitizedId}" not found. Valid order IDs are in the format ORD-XXXX.`
        }]
      };
    }

    return {
      content: [{
        type: "text",
        text: JSON.stringify(filterOrder(order), null, 2) // Guardrail 4: filter response
      }]
    };
  }
);

// =============================================================================
// 🔌  START THE SERVER
// =============================================================================
// Connect via stdio transport — VS Code launches this process and communicates
// over stdin/stdout using the JSON-RPC protocol.

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("[MCP] OutFront Inventory server running on stdio");
}

main().catch((error) => {
  console.error("[MCP] Fatal error:", error);
  process.exit(1);
});
