# Lab 1: Prompts, Skills & Custom Agents

## 🎯 Objective

Learn how to customize GitHub Copilot's behavior so it understands **your** project — not just generic Java. By the end of this lab, Copilot will know that OutFront Media sells billboard equipment, that your code follows the Controller → Service → Repository pattern, and that tests should be named `shouldDoX_whenY`.

## ⏱️ Duration

~45 minutes (5 exercises)

## Why This Lab?

**Intent:** Before you write a single line of code with Copilot, you need to teach it about YOUR project. This lab is about making Copilot a team member who understands your codebase, not a stranger guessing.

**The value:** Without customization, Copilot gives generic suggestions. With instructions, prompts, and agents, it gives suggestions that already follow your team's conventions, understand your domain, and match your architecture. The difference is like hiring someone who's read the company handbook vs. someone who just walked in off the street.

**How agentic AI helps:** Instead of manually onboarding every new developer to your coding standards, you define them once in configuration files. Copilot reads these on every interaction — it's like having an always-available senior developer who never forgets the rules.

## Prerequisites

- VS Code with GitHub Copilot and Copilot Chat installed
- The `workshop-labs/` folder open as your workspace root
- Project builds successfully: `mvn clean verify -B`
- Familiarity with Java and Spring Boot basics

## What You'll Learn

Copilot has three layers of customization, each for a different purpose:

| Layer | File | When It Kicks In | Good For |
|-------|------|-------------------|----------|
| **Instructions** | `.github/copilot-instructions.md` | Every Copilot interaction | Project context, coding conventions |
| **Path-Scoped Instructions** | `.github/instructions/*.instructions.md` | When editing matching files | File-type-specific rules |
| **Prompt Files** | `.github/prompts/*.prompt.md` | When you run them manually | Repeatable tasks, team workflows |
| **Custom Agents** | `.github/chatmodes/*.chatmode.md` | When you select them in chat | Domain expertise, specialized roles |

Think of it like layers of a cake:
- **Instructions** are the base — always there, always shaping responses.
- **Path-scoped instructions** add extra flavor for specific file types.
- **Prompt files** are recipes you follow on demand.
- **Custom agents** are specialist chefs you call in for specific jobs.

## Exercises

| # | Exercise | Time | What You'll Do |
|---|----------|------|----------------|
| 1 | [Explore Custom Instructions](exercises/01-explore-instructions.md) | ~10 min | See how `copilot-instructions.md` shapes every Copilot response |
| 2 | [Create Path-Scoped Instructions](exercises/02-create-path-scoped.md) | ~10 min | Write file-pattern-specific rules for test files |
| 3 | [Use & Create Prompt Files](exercises/03-use-prompt-files.md) | ~10 min | Run existing prompts and build your own reusable template |
| 4 | [Build a Reusable Skill](exercises/04-create-skill.md) | ~8 min | Create a multi-step prompt that scaffolds an entire domain stack |
| 5 | [Create a Custom Agent](exercises/05-create-custom-agent.md) | ~10 min | Build a specialized chat agent for database work |

## Folder Structure

```
workshop-labs/
├── .github/
│   ├── copilot-instructions.md          ← Repo-level instructions (Exercise 1)
│   ├── instructions/
│   │   ├── java.instructions.md         ← Java file rules (Exercise 2)
│   │   └── sql.instructions.md          ← SQL file rules (Exercise 2)
│   ├── prompts/
│   │   ├── add-endpoint.prompt.md       ← Endpoint scaffold (Exercise 3)
│   │   ├── write-tests.prompt.md        ← Test generator (Exercise 3)
│   │   └── fix-bug.prompt.md            ← Bug fix workflow (Exercise 3)
│   └── chatmodes/
│       ├── spring-architect.chatmode.md ← Architecture advisor (Exercise 5)
│       └── code-reviewer.chatmode.md    ← Code reviewer (Exercise 5)
└── src/                                 ← The Java app you'll be working with
```

> **Tip:** Work through the exercises in order. Each one builds on concepts from the previous one.

