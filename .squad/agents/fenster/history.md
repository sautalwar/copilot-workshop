# Fenster — History

## Project Context
- OutFront Media Order Management System for billboard/digital signage equipment
- Java 17, Spring Boot 3.2.5, Maven, H2/SQL Server, JUnit 5
- Two domains: Orders and Inventory with cross-domain check in OrderService.updateOrderStatus()
- Controller → Service → Repository pattern, constructor injection only
- User: Copilot

## Recent Work (2026-04-14)
- **Wave 1:** Built workshop-labs/ directory structure with 50+ files — src/, .github/, mcp-server/, workshop-prompts/, Docker files, lab-01 skeleton (65s)
- Created workshop-prompts/ directory with 7 reusable prompt templates
- Prompts cover: Order design, Inventory domain, API endpoints, tests, cross-domain validation, error handling, performance
- Each includes context, instructions, expected outputs
- README provides quick-reference index for participants
- **Completed:** orchestration-log entry at 2026-04-14T16:30Z

## Recent Additions from Cross-Agent Work (2026-04-14)
- Kobayashi Wave 1: workshop-labs/PREREQUISITES.md — participant setup guide (JDK 17, Maven, VS Code, Git, optional Docker/Node.js)
- Kobayashi Wave 2 Labs: workshop-labs/lab-01-prompts-skills-agents/ (5 exercises + 4 solutions + README) — progressive labs (explore → skill → prompt → agent → integration)
- Kobayashi Wave 2 README: workshop-labs/README.md — entry point, repo map, lab index, app overview
- Scribe: decisions.md created with foundational decisions + cross-agent learnings; orchestration logs written for all Wave 1 & 2 agents

## Learnings

### Prompt Library Design
- Domain-specific prompts (OutFront Media billboard/signage context) increase participant relevance
- Structuring prompts with context + instructions + expected output reduces interpretation errors
- Participants benefit from fork-and-iterate approach vs. starting from scratch

### Cross-Agent Patterns
- Kobayashi: Presenter guide can showcase prompts in real-time (live coding demos)
- Redfoot: Competitive comparison can show Copilot prompt capability vs. alternatives
- Verbal: UI enhancements support interactive exploration of prompt outputs
