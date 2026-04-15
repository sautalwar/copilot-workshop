# Workshop Prompt Files

This directory contains sample prompt files for the **OutFront Media GitHub Copilot Workshop**. These prompts guide participants through hands-on exercises demonstrating various Copilot features.

## 📦 What's Included

| Prompt File | Workshop Slide | Feature Demonstrated | Difficulty |
|-------------|----------------|---------------------|------------|
| [`01-find-orders-today.prompt.md`](01-find-orders-today.prompt.md) | Slide 9 | Code Completions — Comment-driven development | ⭐ Easy |
| [`02-explain-transactional.prompt.md`](02-explain-transactional.prompt.md) | Slide 10 | Chat & Inline Edit — Contextual explanations | ⭐ Easy |
| [`03-add-search-endpoint.prompt.md`](03-add-search-endpoint.prompt.md) | Slide 11 | Agent Mode — Full-stack feature (Controller→Service→Repository) | ⭐⭐ Intermediate |
| [`04-write-service-tests.prompt.md`](04-write-service-tests.prompt.md) | Slide 11 | Agent Mode — Comprehensive test generation | ⭐⭐ Intermediate |
| [`05-csv-bulk-import.prompt.md`](05-csv-bulk-import.prompt.md) | Slide 11 | Agent Mode — Complex multi-file feature with external dependencies | ⭐⭐⭐ Advanced |
| [`06-debug-inventory-bug.prompt.md`](06-debug-inventory-bug.prompt.md) | Slide 11 | Agent Mode — Debugging race conditions and concurrency | ⭐⭐⭐ Advanced |
| [`07-review-security.prompt.md`](07-review-security.prompt.md) | Slide 17 | DevSecOps — OWASP Top 10 security analysis | ⭐⭐ Intermediate |

## 🚀 How to Use

### Option 1: Use Prompts Inline (Recommended for Workshop)
1. Open the prompt file (e.g., `01-find-orders-today.prompt.md`)
2. Read the instructions
3. Copy the "Instructions" section into Copilot Chat
4. Follow along with the "Try It" steps

### Option 2: Copy to Your .github/prompts Directory
If you want these prompts permanently available in your project:

1. **Copy files to your repo:**
   ```bash
   # From the workshop repo root
   cp -r workshop-prompts/*.prompt.md .github/prompts/
   ```

2. **Use in VS Code:**
   - Open Copilot Chat
   - Type `#` to see available prompts
   - Select the prompt you want to use
   - Copilot will execute it in Agent mode

3. **Use from Command Line:**
   ```bash
   # If you have the GitHub CLI with Copilot extension
   gh copilot suggest --prompt-file .github/prompts/03-add-search-endpoint.prompt.md
   ```

## 📋 Workshop Flow

### Part 1: Code Completions (Slide 9)
Start with **`01-find-orders-today.prompt.md`**
- Learn how to use comments to generate code
- Experience real-time code suggestions
- Understand completion acceptance workflows

### Part 2: Chat & Inline Edit (Slide 10)
Move to **`02-explain-transactional.prompt.md`**
- Ask Copilot to explain complex code
- Learn contextual code understanding
- Practice inline editing with AI assistance

### Part 3: Agent Mode (Slide 11)
Work through prompts **03 → 04 → 05 → 06** in order:

1. **`03-add-search-endpoint.prompt.md`** — Build confidence with full-stack features
2. **`04-write-service-tests.prompt.md`** — See AI-generated test suites
3. **`05-csv-bulk-import.prompt.md`** — (Optional) Advanced multi-file feature
4. **`06-debug-inventory-bug.prompt.md`** — (Optional) Debugging challenge

### Part 4: DevSecOps (Slide 17)
Finish with **`07-review-security.prompt.md`**
- Proactive security analysis with AI
- OWASP Top 10 vulnerability detection
- Automated security fix suggestions

## 🎯 Learning Objectives

By the end of these exercises, you will:
- ✅ Write code faster using comment-driven development
- ✅ Understand unfamiliar code using AI explanations
- ✅ Build full-stack features across multiple layers
- ✅ Generate comprehensive test suites automatically
- ✅ Debug complex concurrency issues with AI assistance
- ✅ Identify and fix security vulnerabilities proactively

## 💡 Tips for Success

### For Workshop Attendees:
- **Start simple:** Begin with prompts 01-02 before diving into Agent mode
- **Read the context:** Each prompt includes domain-specific OutFront Media context
- **Verify your work:** Run `mvn test` after each exercise to ensure code quality
- **Ask follow-ups:** Don't stop at the first answer — ask Copilot to explain or improve
- **Experiment:** Modify the prompts to fit your own use cases

### For Workshop Facilitators:
- **Time allocation:**
  - Prompts 01-02: ~10 minutes each
  - Prompt 03: ~20 minutes (core Agent mode demo)
  - Prompt 04: ~15 minutes
  - Prompts 05-06: ~20 minutes each (optional, for advanced track)
  - Prompt 07: ~15 minutes
- **Group discussions:** After each major prompt (03, 06, 07), pause for Q&A
- **Live demo first:** Walk through prompt 03 together before letting attendees try on their own

## 🛠️ Prerequisites

Before using these prompts, ensure you have:
- ✅ GitHub Copilot installed and activated in VS Code
- ✅ Java 17+ and Maven installed
- ✅ The OutFront Workshop repo cloned and compiling
- ✅ Basic familiarity with Spring Boot and REST APIs

## 📚 Additional Resources

- **Project Documentation:** See [`../README.md`](../README.md) for repo setup instructions
- **Copilot Instructions:** See [`../.github/copilot-instructions.md`](../.github/copilot-instructions.md) for coding standards
- **Existing Prompts:** See [`../.github/prompts/`](../.github/prompts/) for reference implementations

## 🤝 Contributing

Found an issue or want to add a new prompt? Submit a PR!

### Prompt Template:
```markdown
---
mode: 'agent'
description: '[Clear description]'
---

# [Title]

## 📍 Workshop Section
Slide [N]: [Section Name]

## What This Does
[1-2 sentence explanation]

## Instructions
[Detailed steps for the AI agent]

## Expected Outcome
[What attendees should see]

## Try It
[Step-by-step instructions for attendees]
```

---

**Happy coding with GitHub Copilot! 🚀**
