/**
 * SAFE MCP Server — Citizen Data with PII Redaction
 * 
 * This MCP server demonstrates the CORRECT way to expose sensitive data
 * through a Copilot tool. All PII is redacted before being returned to
 * the AI model, so it never sees real SSNs, emails, or phone numbers.
 * 
 * Think of it like a security guard who checks every package leaving
 * the building — nothing sensitive gets out.
 */

import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';

// ──────────────────────────────────────────────
// Simulated Database (fake data for demo)
// ──────────────────────────────────────────────
const citizens = [
  { id: 1, name: 'Jane Smith',    ssn: '000-00-0000', email: 'jane@example.com',  phone: '555-0101', city: 'Seattle',  status: 'active' },
  { id: 2, name: 'John Doe',      ssn: '000-00-0000', email: 'john@example.com',  phone: '555-0102', city: 'Portland', status: 'active' },
  { id: 3, name: 'Alice Johnson', ssn: '000-00-0000', email: 'alice@example.com', phone: '555-0103', city: 'Denver',   status: 'pending' },
  { id: 4, name: 'Bob Williams',  ssn: '000-00-0000', email: 'bob@example.com',   phone: '555-0104', city: 'Austin',   status: 'active' },
  { id: 5, name: 'Carol Davis',   ssn: '000-00-0000', email: 'carol@example.com', phone: '555-0105', city: 'Chicago',  status: 'inactive' },
];

// ──────────────────────────────────────────────
// Redaction Functions (the security layer)
// ──────────────────────────────────────────────
function maskSSN(ssn: string): string {
  return `***-**-${ssn.slice(-4)}`;
}

function maskEmail(email: string): string {
  const [user, domain] = email.split('@');
  return `${user[0]}${'*'.repeat(user.length - 1)}@${domain}`;
}

function maskPhone(phone: string): string {
  return `***-${phone.slice(-4)}`;
}

function redactCitizen(citizen: typeof citizens[0]) {
  return {
    id: citizen.id,
    name: citizen.name,           // Names are OK — not classified as restricted PII here
    ssn: maskSSN(citizen.ssn),    // SSN is ALWAYS masked
    email: maskEmail(citizen.email), // Email is masked
    phone: maskPhone(citizen.phone), // Phone is masked
    city: citizen.city,           // City is OK
    status: citizen.status,       // Status is OK
  };
}

// ──────────────────────────────────────────────
// Audit Logger
// ──────────────────────────────────────────────
function auditLog(action: string, details: Record<string, unknown>) {
  const entry = {
    timestamp: new Date().toISOString(),
    action,
    ...details,
    redacted: true,
  };
  console.error(`[AUDIT] ${JSON.stringify(entry)}`);
}

// ──────────────────────────────────────────────
// MCP Server Setup
// ──────────────────────────────────────────────
const server = new McpServer({
  name: 'citizen-data-safe',
  version: '1.0.0',
});

// Tool: List all citizens (redacted)
server.tool(
  'list_citizens',
  'List all citizens with PII redacted for safety',
  {},
  async () => {
    auditLog('list_citizens', { count: citizens.length });
    
    const redacted = citizens.map(redactCitizen);
    return {
      content: [{
        type: 'text',
        text: JSON.stringify(redacted, null, 2),
      }],
    };
  }
);

// Tool: Search citizens by city (redacted)
server.tool(
  'search_citizens',
  'Search citizens by city name. Results are PII-redacted.',
  { city: z.string().describe('City name to search for') },
  async ({ city }) => {
    auditLog('search_citizens', { city });
    
    const matches = citizens
      .filter(c => c.city.toLowerCase().includes(city.toLowerCase()))
      .map(redactCitizen);
    
    return {
      content: [{
        type: 'text',
        text: matches.length > 0
          ? JSON.stringify(matches, null, 2)
          : `No citizens found in "${city}"`,
      }],
    };
  }
);

// Tool: Get citizen by ID (redacted)
server.tool(
  'get_citizen',
  'Get a specific citizen by ID. PII is automatically redacted.',
  { id: z.number().describe('Citizen ID to look up') },
  async ({ id }) => {
    auditLog('get_citizen', { id });
    
    const citizen = citizens.find(c => c.id === id);
    if (!citizen) {
      return { content: [{ type: 'text', text: `Citizen #${id} not found` }] };
    }
    
    return {
      content: [{
        type: 'text',
        text: JSON.stringify(redactCitizen(citizen), null, 2),
      }],
    };
  }
);

// ──────────────────────────────────────────────
// Start the server
// ──────────────────────────────────────────────
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('✅ SAFE MCP Server running (PII redaction enabled)');
}

main().catch(console.error);
