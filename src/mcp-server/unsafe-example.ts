/**
 * ⚠️  UNSAFE MCP Server — DO NOT USE IN PRODUCTION ⚠️
 * 
 * This server exists ONLY as a cautionary example to show what happens
 * when you DON'T redact PII. Compare this with index.ts (the safe version)
 * to see that the fix is only ~3 lines of code.
 * 
 * DANGER: This server returns raw SSNs, emails, and phone numbers
 * directly to the AI model, where they could appear in:
 * - Chat responses shown to other users
 * - Model training data (if data sharing is enabled)
 * - Log files and telemetry
 * - Copilot suggestions in other files
 */

import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';

// Same fake database
const citizens = [
  { id: 1, name: 'Jane Smith',    ssn: '000-00-0000', email: 'jane@example.com',  phone: '555-0101', city: 'Seattle',  status: 'active' },
  { id: 2, name: 'John Doe',      ssn: '000-00-0000', email: 'john@example.com',  phone: '555-0102', city: 'Portland', status: 'active' },
  { id: 3, name: 'Alice Johnson', ssn: '000-00-0000', email: 'alice@example.com', phone: '555-0103', city: 'Denver',   status: 'pending' },
  { id: 4, name: 'Bob Williams',  ssn: '000-00-0000', email: 'bob@example.com',   phone: '555-0104', city: 'Austin',   status: 'active' },
  { id: 5, name: 'Carol Davis',   ssn: '000-00-0000', email: 'carol@example.com', phone: '555-0105', city: 'Chicago',  status: 'inactive' },
];

const server = new McpServer({
  name: 'citizen-data-unsafe',
  version: '1.0.0',
});

// ⚠️  UNSAFE: Returns raw PII without redaction!
server.tool(
  'list_citizens',
  'List all citizens',
  {},
  async () => {
    // 🚨 NO REDACTION — raw PII goes straight to the model!
    return {
      content: [{
        type: 'text',
        text: JSON.stringify(citizens, null, 2),
      }],
    };
  }
);

// ⚠️  UNSAFE: No audit logging either!
server.tool(
  'search_citizens',
  'Search citizens by city',
  { city: z.string() },
  async ({ city }) => {
    const matches = citizens.filter(c =>
      c.city.toLowerCase().includes(city.toLowerCase())
    );
    // 🚨 Raw PII returned!
    return {
      content: [{
        type: 'text',
        text: JSON.stringify(matches, null, 2),
      }],
    };
  }
);

server.tool(
  'get_citizen',
  'Get citizen by ID',
  { id: z.number() },
  async ({ id }) => {
    const citizen = citizens.find(c => c.id === id);
    // 🚨 Raw PII returned!
    return {
      content: [{
        type: 'text',
        text: citizen ? JSON.stringify(citizen, null, 2) : 'Not found',
      }],
    };
  }
);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('⚠️  UNSAFE MCP Server running (NO PII redaction!)');
}

main().catch(console.error);
