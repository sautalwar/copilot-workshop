# Mastering GitHub Copilot Configuration — Workshop

A comprehensive hands-on workshop that teaches teams how to configure and customize GitHub Copilot from the ground up. This presentation covers enterprise-grade Copilot customization, from basic instructions to advanced agent configuration and content governance.

**Based on the real hackathon project:** [github.com/sautalwar/ghcp-hackathon-custom](https://github.com/sautalwar/ghcp-hackathon-custom)

## Overview

GitHub Copilot is a powerful AI coding assistant, but its real value comes from proper configuration tailored to your team's needs. This workshop teaches you how to:

- Configure Copilot instructions for your entire repository
- Create path-specific customizations for different project areas
- Build custom agents (chat modes) for specialized workflows
- Implement enterprise content governance policies
- Deploy and manage Copilot configurations at scale

Whether you're managing a small team or an enterprise organization, this workshop provides the strategies and hands-on examples you need to get the most from GitHub Copilot.

## What You'll Learn

- **Copilot Instructions Fundamentals** — How to write effective copilot-instructions.md files that shape Copilot's behavior
- **Path-Specific Customization** — Tailoring Copilot instructions to different project directories and file types
- **Prompt Engineering for Developers** — Creating reusable prompt files for common development tasks
- **Custom Agents (Chat Modes)** — Building specialized Copilot agents for your team's specific workflows
- **Enterprise Content Governance** — Implementing policies to control what content Copilot can access and generate
- **Real-World Examples** — Practical configurations used in production at scale
- **Best Practices & Patterns** — Design patterns for maintainable, effective Copilot configurations
- **Deployment & Management** — How to roll out and manage Copilot configurations across teams
- **Troubleshooting & Optimization** — Debugging common issues and optimizing performance
- **Integration with Development Workflows** — Embedding Copilot customization into your CI/CD and development processes

## Prerequisites

- GitHub account with Copilot access (Individual, Team, or Enterprise)
- Basic understanding of Git and GitHub
- Familiarity with your team's development workflow
- A code editor (VS Code recommended)
- Docker (optional, for containerized workshop)

## Running Locally

Simply open the workshop presentation in your browser:

```bash
# Navigate to the repository directory
cd GitHub_Copilot_101

# Open the workshop presentation
open workshop.html
# or on Windows
start workshop.html
# or on Linux
xdg-open workshop.html
```

The presentation includes interactive examples and code snippets you can follow along with.

## Running with Docker

Build and run the workshop in a containerized environment:

```bash
# Build the Docker image
docker build -t copilot-workshop:latest .

# Run the container
docker run -p 8080:8080 copilot-workshop:latest

# Open your browser to http://localhost:8080
```

## Deploying to Azure

This workshop includes a GitHub Actions workflow for automated deployment to Azure. The workflow:

- Builds the workshop presentation
- Creates a Docker image
- Deploys to Azure Container Instances or Azure App Service
- Makes the presentation publicly accessible

See `.github/workflows/deploy.yml` for configuration details.

**Deploy with:**
```bash
git push origin main
```

The GitHub Actions workflow will automatically handle the rest.

## Workshop Structure

The workshop is organized into **10 comprehensive sections**:

1. **Introduction to GitHub Copilot Customization** (8 slides)
   - Why customize Copilot
   - What's possible with configuration
   - Real-world use cases

2. **Setting Up copilot-instructions.md** (12 slides)
   - File format and structure
   - Basic instruction patterns
   - Testing your instructions

3. **Path-Specific Instructions** (10 slides)
   - Directory-level customization
   - File type matching
   - Inheritance and overrides

4. **Working with Prompt Files** (9 slides)
   - Creating reusable prompts
   - Prompt organization strategies
   - Sharing prompts with your team

5. **Building Custom Agents** (14 slides)
   - Agent architecture
   - Creating specialized chat modes
   - Agent-to-agent communication

6. **Enterprise Content Governance** (11 slides)
   - Policy frameworks
   - Content filtering strategies
   - Compliance and security

7. **Real-World Examples & Case Studies** (13 slides)
   - Configuration examples from production
   - Before/after comparisons
   - Lessons learned

8. **Best Practices & Design Patterns** (10 slides)
   - Scalable configuration patterns
   - Common pitfalls and solutions
   - Team collaboration strategies

9. **Deployment & Management at Scale** (12 slides)
   - Rolling out configurations
   - Monitoring and analytics
   - Version control for Copilot configs

10. **Troubleshooting, Q&A, & Next Steps** (8 slides)
    - Common issues and solutions
    - Advanced debugging techniques
    - Resources for continued learning

**Total: ~107 slides**

## Resources

- **[GitHub Copilot Documentation](https://docs.github.com/en/copilot)** — Official GitHub Copilot docs
- **[GitHub Copilot Configuration Guide](https://docs.github.com/en/copilot/managing-copilot/configure-personal-settings-for-copilot)** — How to configure Copilot
- **[Hackathon Repository](https://github.com/sautalwar/ghcp-hackathon-custom)** — Real configurations from the hackathon
- **[Agent Skills](https://agentskills.io)** — Advanced agent patterns and examples
- **[GitHub Copilot Enterprise Documentation](https://docs.github.com/en/enterprise-cloud@latest/copilot/overview-of-github-copilot)** — Enterprise-specific features

## Author

**Saurabh Talwar** — GitHub AI Developer

---

Questions? Found an issue? Have suggestions for improving the workshop? Open an [issue](https://github.com/sautalwar/copilot-workshop/issues) or submit a [pull request](https://github.com/sautalwar/copilot-workshop/pulls).

**Happy learning! 🚀**
