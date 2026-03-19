# OutFront Media — GitHub Copilot Workshop

A hands-on workshop for OutFront Media teams to learn GitHub Copilot — from first-time setup to advanced features like model selection, MCP integrations, and enterprise governance.

---

## 🚀 Quick Start

### Prerequisites

- **Java JDK 17+** — [Download Eclipse Temurin](https://adoptium.net/)
- **Apache Maven 3.9+** — [Download Maven](https://maven.apache.org/download.cgi)
- **Git** — [Download Git](https://git-scm.com/)
- **VS Code** with [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) and [GitHub Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat) extensions

### Clone & Run

```bash
git clone https://github.com/sautalwar/outfront-copilot-workshop.git
cd outfront-copilot-workshop
mvn spring-boot:run
```

Open [http://localhost:8080/api/orders](http://localhost:8080/api/orders) to see sample order data.

---

## 📅 Workshop Agenda

| Time | Topic |
|------|-------|
| **0:00 – 0:30** | Welcome & environment setup verification |
| **0:30 – 1:15** | GitHub Copilot fundamentals — completions, chat, and inline suggestions |
| **1:15 – 2:00** | Hands-on: AI-assisted coding with the Order Management app |
| **2:00 – 2:15** | ☕ Break |
| **2:15 – 2:45** | Model selection — choosing the right AI model for your task |
| **2:45 – 3:30** | MCP integrations — connecting Copilot to Jira, databases, and more |
| **3:30 – 3:50** | Security & governance — enterprise policies, content exclusions, audit logs |
| **3:50 – 4:00** | Wrap-up, Q&A, and next steps |

---

## 📁 Project Structure

```
outfront-copilot-workshop/
├── src/
│   ├── main/
│   │   ├── java/com/outfront/workshop/
│   │   │   ├── controller/    # REST API controllers
│   │   │   ├── model/         # Data models / entities
│   │   │   ├── repository/    # Data access layer
│   │   │   └── service/       # Business logic
│   │   └── resources/         # Application config (application.yml, etc.)
│   └── test/                  # Unit and integration tests
├── mcp-server/                # MCP server for Copilot integrations demo
├── .github/
│   ├── chatmodes/             # Custom Copilot chat modes
│   ├── instructions/          # Copilot custom instructions
│   └── prompts/               # Reusable prompt files
├── .vscode/                   # VS Code workspace settings
├── PARTICIPANT-PREP.md        # Pre-workshop setup guide for attendees
├── ADMIN-PRECHECK.md          # Admin checklist for workshop readiness
└── README.md                  # This file
```

---

## 📄 Workshop Documents

| Document | Audience | Description |
|----------|----------|-------------|
| [**PARTICIPANT-PREP.md**](PARTICIPANT-PREP.md) | Workshop attendees | Email-ready setup guide — send 2 weeks before the workshop |
| [**ADMIN-PRECHECK.md**](ADMIN-PRECHECK.md) | IT admin (Jeff) | Pre-meeting checklist to verify licensing, network, and environment |

---

## 🛠️ Tech Stack

- **Java 17** with **Spring Boot**
- **Maven** for build and dependency management
- **GitHub Copilot** (Business/Enterprise)
- **MCP (Model Context Protocol)** for tool integrations

---

## 🐳 Deployment

### Run the presentation locally

Open `presentation/index.html` directly in your browser — no server needed.

### Run via Docker (presentation only)

```bash
# From the repo root
docker build -f presentation/Dockerfile -t workshop-slides .
docker run -p 8081:80 workshop-slides
```

Open [http://localhost:8081](http://localhost:8081) to view the slides.

### Run both API + presentation via Docker Compose

```bash
cd presentation
docker-compose up --build
```

| Service | URL |
|---------|-----|
| Spring Boot API | [http://localhost:8080/api/orders](http://localhost:8080/api/orders) |
| Presentation slides | [http://localhost:8081](http://localhost:8081) |

### Deploy to Azure Static Web Apps (optional)

The repo includes `staticwebapp.config.json` with security headers pre-configured. To deploy:

1. Push the repo to GitHub
2. Create an Azure Static Web App resource linked to the repo
3. Set the **app location** to `presentation/` and **output location** to `presentation/`
4. Azure will automatically build and deploy on push

---

## 📝 Credits

Built by **Saurabh Talwar**, Microsoft — for the OutFront Media GitHub Copilot workshop.
