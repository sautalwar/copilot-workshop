# Exercise 5: Create a Custom Agent

## 🎯 Objective

Create a custom chat agent — a specialized "expert" you can switch to in Copilot Chat for domain-specific conversations.

## ⏱️ Time: ~10 minutes

## Background

So far, you've used:
- **Instructions** — rules that apply automatically to every interaction
- **Path-scoped instructions** — rules for specific file types
- **Prompt files** — on-demand tasks you run once

Custom agents are different. An agent is a **persona** you can have a conversation with. Instead of running a single task, you switch to an agent and it shapes the entire conversation — every question you ask, every answer you get.

This project has two agents already:
- **Spring Architect** — Helps with design patterns, API structure, and architectural decisions
- **Code Reviewer** — Reviews code for quality, security, and team standards

You're going to create a third: a **Database Expert** that specializes in JPA entities, SQL queries, and database design.

## Steps

### Step 1: Read the Spring Architect agent

Open `.github/chatmodes/spring-architect.chatmode.md`.

Notice the structure:

```yaml
---
description: 'Spring Boot architecture advisor — helps with design patterns...'
tools: ['githubRepo', 'codebase', 'fetch']
---
```

- **`description`** — Shows up in the agent picker dropdown
- **`tools`** — What the agent can access (code search, GitHub repo info, web fetch)

Below the front matter is the agent's **identity and expertise** — written in Markdown. This is what makes it different from just asking Copilot Chat a generic question.

### Step 2: Read the Code Reviewer agent

Open `.github/chatmodes/code-reviewer.chatmode.md`.

Compare it to the Spring Architect:
- Different description, different focus area
- Categorizes findings: 🔴 Must Fix, 🟡 Should Fix, 🟢 Suggestion
- Focused on review (reading code) rather than generation (writing code)

> **Key insight:** Each agent has a different personality and area of focus. The same question asked to different agents will get different answers.

### Step 3: Create your Database Expert agent

Create: `.github/chatmodes/database-expert.chatmode.md`

Start with the front matter:

```yaml
---
description: 'Database specialist — JPA entities, SQL queries, H2/SQL Server compatibility, and schema design'
tools: ['githubRepo', 'codebase']
---
```

### Step 4: Write the agent's instructions

Below the front matter, define who this agent is and what it knows. Include:

**Identity:**
- A database specialist for the OutFront Media team
- Focuses on data modeling, query optimization, and JPA configuration

**Core Expertise:**

1. **JPA Entity Design**
   - Proper use of annotations (`@Entity`, `@Table`, `@Column`, `@Id`)
   - Relationship mappings (`@OneToMany`, `@ManyToOne`, `@ManyToMany`)
   - Lazy vs eager loading trade-offs
   - When to use `@Embedded` vs separate entities

2. **SQL & Query Writing**
   - Standard SQL that works on both H2 and SQL Server
   - UPPER_CASE keywords, snake_case table/column names
   - Efficient queries — avoid N+1 problems
   - When to use Spring Data derived methods vs `@Query`

3. **Schema Design**
   - Every table needs a primary key
   - Foreign keys for referential integrity
   - Include `created_at` and `updated_at` on transactional tables
   - Index suggestions for frequently queried columns

4. **Seed Data**
   - Realistic OutFront Media data (billboard campaigns, locations, equipment)
   - Compatible INSERT statements for H2 and SQL Server

**How it should answer:**
- Always consider H2/SQL Server compatibility
- Suggest indexes when query patterns are discussed
- Warn about common JPA pitfalls (N+1 queries, lazy loading outside transactions)
- Reference the existing `data.sql` seed data when relevant

Give it your best shot. Check the [solution](../solutions/05-solution.chatmode.md) if you want to compare.

### Step 5: Activate your agent

1. Open Copilot Chat in VS Code
2. Look for the agent/mode selector (usually at the top of the chat panel — it may say "Ask" or show the current mode)
3. Click it and select **Database Expert** from the dropdown
4. You should see your agent's description

### Step 6: Test your agent

Ask your Database Expert:

```
How should we model a Campaign entity that tracks billboard advertising campaigns?
```

Check the response:
- ✅ Does it suggest JPA annotations?
- ✅ Does it consider H2/SQL Server compatibility?
- ✅ Does it suggest relationships to existing entities (like Order)?
- ✅ Does it mention seed data?

### Step 7: Compare without the agent

1. Switch back to the default Copilot Chat mode (deselect your agent)
2. Ask the exact same question
3. Compare: The default response is likely more generic — less database-focused, less aware of the H2/SQL Server constraint

## ✅ Expected Outcome

You've created a custom agent that provides specialized, focused responses for database-related work. It's like having a database expert on your team who knows your specific tech stack and conventions.

## Solution

Compare your agent: [solutions/05-solution.chatmode.md](../solutions/05-solution.chatmode.md)

## Discussion Questions

### The Decision Matrix

When should you use instructions, prompts, or agents? Here's a cheat sheet:

| | Instructions | Prompts | Agents |
|---|---|---|---|
| **When active** | Always (or by file pattern) | On demand — you run them | When selected in chat |
| **Scope** | All interactions | Single task | Entire conversation |
| **Reusable** | ✅ Automatic | ✅ Run manually | ✅ Select in UI |
| **Best for** | Conventions, project context | Repeatable tasks, workflows | Domain expertise, personas |
| **Example** | "Use constructor injection" | "Scaffold a new endpoint" | "Database design advisor" |

### More questions to think about:

1. **When would you create an agent vs just updating instructions?** If you find yourself always asking database questions with extra context ("remember, we need H2 compatibility"), that's a sign an agent would help.

2. **What domain experts does your team need?** Some ideas:
   - **Security Reviewer** — focused on OWASP top 10, injection prevention
   - **Performance Advisor** — focused on query optimization, caching, connection pooling
   - **API Designer** — focused on REST conventions, error responses, versioning
   - **DevOps Helper** — focused on Docker, CI/CD, deployment configurations

3. **Can agents use the same tools as prompt files?** Yes! The `tools` field in the front matter controls what the agent can access. An agent with `codebase` can search your code; one with `fetch` can look things up online.

---

[← Previous: Build a Reusable Skill](04-create-skill.md) | [Back to Lab 1 overview](../README.md)
