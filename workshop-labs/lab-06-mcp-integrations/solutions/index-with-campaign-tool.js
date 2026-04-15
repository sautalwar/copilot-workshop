// =============================================================================
// OutFront Media — Custom MCP Server (Workshop Solution — with Campaign Tool)
// =============================================================================
//
// This is the SOLUTION for Lab 6, Exercise 3. It includes all original tools
// plus the new `get_campaign_info` tool for the Campaign domain.
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
// 📦  CAMPAIGN DATA — advertising campaigns for OutFront Media clients
// =============================================================================

const CAMPAIGNS = new Map([
  ["summer-spectacular", {
    id: "summer-spectacular",
    name: "Summer Spectacular",
    client: "Coca-Cola",
    status: "ACTIVE",
    startDate: "2024-06-01",
    endDate: "2024-08-31",
    budget: 250000,
    location: "Times Square, NYC",
    description: "High-impact summer campaign across Times Square digital billboards"
  }],
  ["back-to-school", {
    id: "back-to-school",
    name: "Back to School",
    client: "Nike",
    status: "ACTIVE",
    startDate: "2024-08-01",
    endDate: "2024-09-30",
    budget: 180000,
    location: "LA Metro Transit",
    description: "Transit shelter and bus wrap campaign targeting students"
  }],
  ["holiday-sounds", {
    id: "holiday-sounds",
    name: "Holiday Sounds",
    client: "Spotify",
    status: "PLANNED",
    startDate: "2024-11-15",
    endDate: "2024-12-31",
    budget: 320000,
    location: "Chicago Loop",
    description: "Holiday music-themed interactive billboard experience"
  }],
  ["spring-forward", {
    id: "spring-forward",
    name: "Spring Forward",
    client: "Toyota",
    status: "COMPLETED",
    startDate: "2024-03-01",
    endDate: "2024-05-31",
    budget: 200000,
    location: "Dallas Highway I-35",
    description: "Highway billboard campaign for new vehicle launch"
  }],
  ["game-day", {
    id: "game-day",
    name: "Game Day",
    client: "Pepsi",
    status: "ACTIVE",
    startDate: "2024-09-01",
    endDate: "2025-02-28",
    budget: 400000,
    location: "Multiple Cities",
    description: "Multi-city sports season campaign near stadiums and arenas"
  }]
]);

// =============================================================================
// 🛡️  GUARDRAIL 1 — Rate Limiting
// =============================================================================

const RATE_LIMIT_MAX = 10;
const RATE_LIMIT_WINDOW_MS = 60_000;
const requestTimestamps = [];

function checkRateLimit() {
  const now = Date.now();
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

function filterInventoryItem(item) {
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
  return {
    orderId: order.orderId,
    customerName: order.customerName,
    productName: order.productName,
    quantity: order.quantity,
    status: order.status,
    orderDate: order.orderDate
  };
}

function filterCampaign(campaign) {
  return {
    name: campaign.name,
    client: campaign.client,
    status: campaign.status,
    startDate: campaign.startDate,
    endDate: campaign.endDate,
    budget: campaign.budget,
    location: campaign.location
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

server.tool(
  "lookup_inventory",
  "Search OutFront Media inventory by SKU or keyword. Returns product details, stock levels, and warehouse locations.",
  {
    query: z.string().describe("A SKU (e.g. 'LED-7236') or search keyword (e.g. 'solar')")
  },
  async ({ query }) => {
    checkRateLimit();
    const sanitizedQuery = validateInput(query, "query");
    auditLog("lookup_inventory", { query: sanitizedQuery });

    const upperQuery = sanitizedQuery.toUpperCase();
    const results = [];

    for (const item of INVENTORY.values()) {
      const matchesSku = item.sku.toUpperCase() === upperQuery;
      const matchesName = item.name.toUpperCase().includes(upperQuery);
      const matchesDesc = item.description.toUpperCase().includes(upperQuery);

      if (matchesSku || matchesName || matchesDesc) {
        results.push(filterInventoryItem(item));
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

const LOW_STOCK_THRESHOLD = 20;

server.tool(
  "check_stock_level",
  "Check stock level for a specific SKU. Returns quantity on hand and a low-stock warning if applicable.",
  {
    sku: z.string().describe("The product SKU to check (e.g. 'SKD-3220')")
  },
  async ({ sku }) => {
    checkRateLimit();
    const sanitizedSku = validateInput(sku, "sku");
    auditLog("check_stock_level", { sku: sanitizedSku });

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

server.tool(
  "get_order_status",
  "Look up an order by ID and return its current status (PENDING, CONFIRMED, or SHIPPED).",
  {
    orderId: z.string().describe("The order ID to look up (e.g. 'ORD-1001')")
  },
  async ({ orderId }) => {
    checkRateLimit();
    const sanitizedId = validateInput(orderId, "orderId");
    auditLog("get_order_status", { orderId: sanitizedId });

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
        text: JSON.stringify(filterOrder(order), null, 2)
      }]
    };
  }
);

// -----------------------------------------------------------------------------
// Tool 4: get_campaign_info (Lab 6 — Exercise 3)
// -----------------------------------------------------------------------------
// Searches campaigns by name or client. Returns campaign details including
// budget, status, dates, and location.

server.tool(
  "get_campaign_info",
  "Search OutFront Media advertising campaigns by campaign name or client name. Returns campaign details including status, dates, budget, and location.",
  {
    query: z.string().describe("A campaign name (e.g. 'Summer Spectacular') or client name (e.g. 'Coca-Cola')")
  },
  async ({ query }) => {
    checkRateLimit();
    const sanitizedQuery = validateInput(query, "query");
    auditLog("get_campaign_info", { query: sanitizedQuery });

    const upperQuery = sanitizedQuery.toUpperCase();
    const results = [];

    for (const campaign of CAMPAIGNS.values()) {
      const matchesName = campaign.name.toUpperCase().includes(upperQuery);
      const matchesClient = campaign.client.toUpperCase().includes(upperQuery);
      const matchesLocation = campaign.location.toUpperCase().includes(upperQuery);

      if (matchesName || matchesClient || matchesLocation) {
        results.push(filterCampaign(campaign));
      }
    }

    if (results.length === 0) {
      return {
        content: [{
          type: "text",
          text: `No campaigns found matching "${sanitizedQuery}".`
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

// =============================================================================
// 🔌  START THE SERVER
// =============================================================================

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("[MCP] OutFront Inventory server running on stdio");
}

main().catch((error) => {
  console.error("[MCP] Fatal error:", error);
  process.exit(1);
});
