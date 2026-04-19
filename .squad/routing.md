# Work Routing

How to decide who handles what.

## Routing Table

| Work Type | Route To | Examples |
|-----------|----------|----------|
| Architecture, scope, decisions | Keaton | Design reviews, trade-offs, what to build next |
| Frontend, UI, Swagger, OpenAPI | Verbal | UI components, Swagger docs, static web config |
| Backend, API, services, JPA, SQL | Fenster | Endpoints, business logic, database, Docker |
| Tests, quality, edge cases | Hockney | Write tests, find edge cases, verify fixes |
| Azure DevOps, work items, sprints | McManus | Epics, stories, t-shirt sizing, sprint planning |
| Documentation, explanations | Kobayashi | Plain-language docs, concept breakdowns |
| Competitive analysis, tool comparison | Redfoot | Copilot vs Cursor/Cloud Code/Windsurf |
| Repo investigation, what exists, duplication check | Kujan | Scan existing work, prevent rework, map coverage |
| Session export, save PDF, session report | Strausz | Capture Q&A to PDF reference doc |
| Java fixes, implement perf findings, bug fixes, issue implementation | Baer | Apply N+1 fixes, pagination, caching, Spring Boot code changes |
| Code review | Keaton | Review PRs, check quality, suggest improvements |
| Copilot customization, instructions, prompts, agents, skills, MCP config | Edie | copilot-instructions.md, .prompt.md, .chatmode.md, .agent.md, .skill.md, MCP servers, hooks |
| Session logging | Scribe | Automatic — never needs routing |

## Issue Routing

| Label | Action | Who |
|-------|--------|-----|
| `squad` | Triage: analyze issue, assign `squad:{member}` label | Lead |
| `squad:{name}` | Pick up issue and complete the work | Named member |

### How Issue Assignment Works

1. When a GitHub issue gets the `squad` label, the **Lead** triages it — analyzing content, assigning the right `squad:{member}` label, and commenting with triage notes.
2. When a `squad:{member}` label is applied, that member picks up the issue in their next session.
3. Members can reassign by removing their label and adding another member's label.
4. The `squad` label is the "inbox" — untriaged issues waiting for Lead review.

## Rules

1. **Eager by default** — spawn all agents who could usefully start work, including anticipatory downstream work.
2. **Scribe always runs** after substantial work, always as `mode: "background"`. Never blocks.
3. **Quick facts → coordinator answers directly.** Don't spawn an agent for "what port does the server run on?"
4. **When two agents could handle it**, pick the one whose domain is the primary concern.
5. **"Team, ..." → fan-out.** Spawn all relevant agents in parallel as `mode: "background"`.
6. **Anticipate downstream work.** If a feature is being built, spawn the tester to write test cases from requirements simultaneously.
7. **Issue-labeled work** — when a `squad:{member}` label is applied to an issue, route to that member. The Lead handles all `squad` (base label) triage.
