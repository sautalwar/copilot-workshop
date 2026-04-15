# Exercise 3: Create a Campaign MCP Tool

## 🎯 Objective

Use Copilot Agent Mode to add a new MCP tool — `get_campaign_info` — that lets Copilot look up advertising campaign data. This is the capstone: you'll extend the MCP server with your own tool and test it live.

## ⏱️ Time: ~12 minutes

## Background

OutFront Media runs advertising campaigns for clients like Coca-Cola, Nike, and Spotify. Right now, Copilot can look up inventory and orders — but not campaigns. You're going to fix that.

The new tool should:
- Look up campaigns by **name** or **client** name
- Return campaign details: name, client, status, dates, budget, and location
- Follow the same guardrail pattern as the existing tools

## Steps

### Step 1: Ask Copilot to Add the Tool

Open `mcp-server/index.js` in VS Code.

Switch to **Copilot Agent Mode** (click the mode selector at the top of the chat panel, or use `@workspace` with agent mode).

Type this prompt:

```
Add a new MCP tool called "get_campaign_info" to this file. It should:

1. Add a CAMPAIGNS data Map with these campaigns:
   - "Summer Spectacular" by Coca-Cola, ACTIVE, Jun-Aug 2024, $250,000 budget, Times Square NYC
   - "Back to School" by Nike, ACTIVE, Aug-Sep 2024, $180,000 budget, LA Metro Transit
   - "Holiday Sounds" by Spotify, PLANNED, Nov-Dec 2024, $320,000 budget, Chicago Loop
   - "Spring Forward" by Toyota, COMPLETED, Mar-May 2024, $200,000 budget, Dallas Highway I-35
   - "Game Day" by Pepsi, ACTIVE, Sep-Feb 2025, $400,000 budget, Multiple Cities

2. The tool should search by campaign name or client name (case-insensitive keyword match)

3. Add a filterCampaign() response filter that returns only: name, client, status, startDate, endDate, budget, location

4. Follow the exact same pattern as the existing tools: rate limiting, input validation, audit logging, response filtering

5. Register it with server.tool() using zod schema validation
```

### Step 2: Review the Generated Code

Copilot should generate code that follows the existing patterns. Before accepting, check:

- ✅ **Data structure** — Is there a `CAMPAIGNS` Map with realistic OutFront Media data?
- ✅ **Tool registration** — Does it use `server.tool()` with a name, description, zod schema, and handler?
- ✅ **Guardrails** — Does the handler call `checkRateLimit()`, `validateInput()`, `auditLog()`, and a filter function?
- ✅ **Search logic** — Does it search by campaign name AND client name (case-insensitive)?
- ✅ **Response format** — Does it return `{ content: [{ type: "text", text: "..." }] }`?

> 💡 **Tip:** If anything looks off, tell Copilot what to fix. For example: "The campaign data should include a budget field as a number, not a string."

### Step 3: Accept and Save

Once the code looks good:
1. Accept Copilot's changes
2. Save `mcp-server/index.js`

### Step 4: Restart the MCP Server

The MCP server needs to restart to pick up your changes:

1. Open the Command Palette (Ctrl+Shift+P or Cmd+Shift+P)
2. Type **"MCP: List Servers"** and select it
3. Find **inventory-lookup** and click **Restart**

Alternatively, reload VS Code (Ctrl+Shift+P → "Developer: Reload Window").

### Step 5: Verify the New Tool Appears

1. Open Copilot Chat
2. Click the **🔧 tools icon**
3. Look for **`get_campaign_info`** in the tool list

If it's there, your tool is registered and ready to use!

> **Troubleshooting:** If the tool doesn't appear:
> 1. Check for JavaScript errors: run `node mcp-server/index.js` in a terminal
> 2. Look for syntax errors — Copilot occasionally generates code with small issues
> 3. Compare your code with the solution in `lab-06-mcp-integrations/solutions/index-with-campaign-tool.js`

### Step 6: Test Your Campaign Tool

Try these prompts in Copilot Chat:

**Search by client:**
```
What campaigns do we have for Coca-Cola?
```

Expected: Details about the "Summer Spectacular" campaign — Times Square, $250K budget, ACTIVE.

**Search by campaign name:**
```
Tell me about the Holiday Sounds campaign
```

Expected: Spotify's holiday campaign in the Chicago Loop, $320K budget, PLANNED status.

**Search by keyword:**
```
Which campaigns are running in Dallas?
```

Expected: Toyota's "Spring Forward" campaign on Highway I-35 (COMPLETED status).

**Try a query with no results:**
```
Do we have any campaigns for Microsoft?
```

Expected: A message like "No campaigns found matching 'Microsoft'."

### Step 7 (Bonus): Add a Budget Report Tool

If you have time, ask Copilot to add one more tool:

```
Add a "campaign_budget_report" MCP tool that takes no parameters and returns a summary
of total budget across all campaigns, broken down by status (ACTIVE, PLANNED, COMPLETED).
Include the count of campaigns in each status and the total budget for each.
```

Test it with:
```
Give me a budget summary across all our campaigns
```

## ✅ Expected Outcome

You've:
- Used Copilot Agent Mode to generate a complete MCP tool
- Reviewed the generated code against the existing patterns
- Restarted the MCP server and verified the tool is registered
- Tested the tool with real queries in Copilot Chat
- Experienced the full loop: **write a tool → register it → Copilot uses it**

## 🎉 Congratulations!

You've completed the capstone lab. You now know how to:
1. **Configure** Copilot with custom instructions (Lab 1)
2. **Design** database models with Copilot assistance (Lab 2)
3. **Build** REST APIs using Copilot (Lab 3)
4. **Create** frontend UIs (Lab 4)
5. **Test** your code with Copilot-generated tests (Lab 5)
6. **Extend** Copilot with custom MCP tools (Lab 6)

The MCP pattern you learned today — define a tool, validate inputs, filter outputs — scales to any API or data source in your organization. The only limit is what you connect it to.

---

[← Back to Lab 6 overview](../README.md) | [Previous: Explore Existing Tools ←](02-explore-existing-tools.md)
