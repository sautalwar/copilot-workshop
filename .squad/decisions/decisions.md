# Decisions Ledger

**Project:** outfront-copilot-workshop  
**Last Updated:** 2026-04-14T16:36:30Z

---

## Foundational Decisions

### Workshop Structure & Labs
**Decision:** Multi-lab progression starting with Prompts → Skills → Agents → Integration  
**Rationale:** Scaffolded learning reduces cognitive overload; hands-on practice with real OutFront Media context  
**Owner:** Kobayashi  
**Date:** 2026-04-14  
**Impact:** Lab 1 (Prompts, Skills, Agents) + Road map for Lab 02+

### Directory Architecture
**Decision:** Separate workshop-labs/ from production app; include src/, mcp-server/, workshop-prompts/, .github/, Docker files  
**Rationale:** Clean separation allows participants to fork; reusable scaffolding; MCP server as hands-on extension point  
**Owner:** Fenster  
**Date:** 2026-04-14  
**Impact:** 50+ file structure enabling self-guided exploration

### Participant Onboarding
**Decision:** PREREQUISITES.md with platform-agnostic setup steps + troubleshooting; README.md as navigator  
**Rationale:** Reduces day-of support burden; participants arrive prepared; quick-start patterns documented  
**Owner:** Kobayashi  
**Date:** 2026-04-14  
**Impact:** Parallel setup (JDK 17, Maven, VS Code, Git, optional Docker/Node.js)

### Prompt Library
**Decision:** 7 reusable domain-specific prompts (Order design, Inventory, API, tests, validation, error handling, performance)  
**Rationale:** Fork-and-iterate model; OutFront Media billboard/signage context boosts relevance; reduces participant blank-page anxiety  
**Owner:** Fenster  
**Date:** 2026-04-14  
**Impact:** workshop-prompts/ used in Lab 1 Exercise 03; extensible for future labs

### Domain Context
**Decision:** All workshop materials grounded in OutFront Media Order Management (billboard/digital signage orders, warehouse inventory, cross-domain validation)  
**Rationale:** Real business domain increases motivation; Java Spring Boot alignment with production app; skill transfer to actual system  
**Owner:** Team  
**Date:** 2026-04-14  
**Impact:** Cohesive participant experience across Labs and exercises

---

## Derived Patterns (Cross-Agent Learnings)

### Workshop Content Format
- **HTML+PDF dual delivery** maximizes distribution (web + print)
- **Presenter guide** with click-by-click + Q&A prep reduces live-demo friction
- **Landscape PDF orientation** required for complex data tables (team workshop plan)

### Copilot Skill Deployment
- **Path-scoped skills** allow participants to extend Copilot without global configuration changes
- **Custom agents** enable cross-domain orchestration (order-inventory validation use case)
- **MCP server integration** bridges Copilot and backend data, supporting agent decision-making

### Participant Success Factors
- **Progressive difficulty** (explore → skill → prompt → agent → integration) scaffolds learning
- **Multiple correct answers** encouraged; solutions show one valid approach
- **Troubleshooting guide** (PREREQUISITES.md) embedded in setup reduces blockers

---

## Archived Decisions
(None yet — first session)
