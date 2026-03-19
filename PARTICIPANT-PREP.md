# 🚀 GitHub Copilot Workshop — Participant Prep Guide

**OutFront Media — Hands-On Garage Session**

Hi team! 👋

We're excited to invite you to our upcoming GitHub Copilot workshop. This is a hands-on "garage session" where we'll explore how AI-assisted development can transform the way we write code at OutFront.

**Please complete the setup steps below at least a few days before the workshop** so we can hit the ground running. If you run into any issues, don't hesitate to reach out — we're here to help!

---

## 📋 What to Expect

- **Format:** This is a hands-on, interactive session — bring your laptop and be ready to code along with the group. No slides-only presentations here!
- **Duration:** ~4 hours
- **Topics we'll cover:**
  - Setting up and configuring GitHub Copilot in your IDE
  - AI-assisted coding — completions, chat, and inline suggestions
  - Model selection — choosing the right AI model for your task
  - MCP (Model Context Protocol) integrations — connecting Copilot to external tools
  - Security and governance — how Copilot fits into our enterprise policies
- **Skill level:** All levels are welcome! Whether you've never used an AI coding tool or you've been experimenting on your own, you'll get something out of this session. No prior experience with AI coding assistants is needed.

---

## ✅ Prerequisites — Please Complete Before the Workshop

Work through each step below. The whole process should take about 20–30 minutes.

---

### 1. IDE Setup (Pick One)

#### Option A: Visual Studio Code (Recommended)

1. **Download VS Code** from [https://code.visualstudio.com](https://code.visualstudio.com) if you don't already have it.
2. Open VS Code.
3. Go to the **Extensions** view:
   - Click the Extensions icon in the left sidebar (it looks like four squares), or
   - Press `Ctrl+Shift+X` (Windows) / `Cmd+Shift+X` (Mac)
4. Search for **"GitHub Copilot"** and click **Install**.
5. Search for **"GitHub Copilot Chat"** and click **Install**.
6. You should now see a Copilot icon (a small robot/sparkle icon) in the bottom status bar.

#### Option B: Visual Studio 2022

1. Make sure you have **Visual Studio 2022 version 17.8 or later**.
   - To check: open Visual Studio → **Help** → **About Microsoft Visual Studio** → verify the version number.
   - If you need to update: **Help** → **Check for Updates**.
2. Install the GitHub Copilot extension:
   - Go to **Extensions** → **Manage Extensions**.
   - Search for **"GitHub Copilot"** and click **Download/Install**.
   - Restart Visual Studio when prompted.
3. After restart, you should see the Copilot icon in the bottom-right status bar.

---

### 2. GitHub Sign-In

1. In your IDE (VS Code or Visual Studio), look for a **GitHub sign-in prompt** or click the Copilot icon in the status bar.
2. Sign in using your **OutFront GitHub Enterprise account** (via SSO).
   - You'll be redirected to your browser to authenticate. Use your corporate credentials.
3. After signing in, verify that:
   - The Copilot icon in the status bar shows as **active** (not crossed out or grayed out).
   - In VS Code: you can also check by opening the Command Palette (`Ctrl+Shift+P`) and typing `GitHub Copilot: Status`.

> **Note:** You must be signed in with your OutFront enterprise account — personal GitHub accounts won't have Copilot access for this workshop.

---

### 3. Java Development Kit (JDK 17+)

Our workshop app is a Java Spring Boot application, so you'll need a JDK installed.

1. **Download and install JDK 17** (or newer). We recommend [Eclipse Temurin (Adoptium)](https://adoptium.net/):
   - Go to [https://adoptium.net/](https://adoptium.net/)
   - Select **Temurin 17 (LTS)** for your operating system.
   - Run the installer. **During installation, check the option to set JAVA_HOME and update PATH** if available.
2. **Verify the installation** — open a new terminal/command prompt and run:
   ```
   java --version
   ```
   You should see output like:
   ```
   openjdk 17.0.x 2024-xx-xx
   OpenJDK Runtime Environment Temurin-17.0.x+x (build 17.0.x+x)
   ```

---

### 4. Apache Maven (3.9+)

Maven is our build tool. Install it if you don't already have it.

1. **Download Maven** from [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
   - Download the **Binary zip archive** (e.g., `apache-maven-3.9.x-bin.zip`).
2. **Extract** the archive to a directory of your choice (e.g., `C:\tools\maven` on Windows or `/opt/maven` on Mac/Linux).
3. **Add Maven to your PATH:**
   - **Windows:** Add `C:\tools\maven\apache-maven-3.9.x\bin` to your system `PATH` environment variable.
   - **Mac/Linux:** Add `export PATH=/opt/maven/apache-maven-3.9.x/bin:$PATH` to your `~/.bashrc` or `~/.zshrc`.
4. **Verify the installation** — open a new terminal and run:
   ```
   mvn --version
   ```
   You should see output showing Maven 3.9+ and your Java version.

---

### 5. Clone the Workshop Repository

Open a terminal and run:

```bash
git clone https://github.com/sautalwar/outfront-copilot-workshop.git
```

This will download the workshop project to your machine.

---

### 6. Verify the App Runs

Let's make sure everything is wired up correctly:

```bash
cd outfront-copilot-workshop
mvn spring-boot:run
```

- Wait for the application to start. You should see a message like **"Started Application"** in the console output.
- Open your browser and go to: [http://localhost:8080/api/orders](http://localhost:8080/api/orders)
- You should see sample order data in JSON format.
- Press `Ctrl+C` in the terminal to stop the application.

---

### 7. Verify Copilot Works

Let's make sure Copilot is active and generating suggestions:

1. Open the workshop project in your IDE.
2. Navigate to any `.java` file in the `src/main/java` directory.
3. Place your cursor inside a class body and start typing a comment like:
   ```java
   // method to calculate total order value
   ```
4. Pause for a moment — you should see **ghost text** (grayed-out suggestions) appear below your comment with a method implementation.
5. Press `Tab` to accept a suggestion, or `Esc` to dismiss it.

If suggestions appear, you're all set! 🎉

---

## 📊 Quick Poll — Please Reply to Jeff

To help us tailor the workshop to the group, please reply to this email with your answers:

1. **What IDE do you primarily use?**
   - [ ] VS Code
   - [ ] Visual Studio
   - [ ] JetBrains IntelliJ
   - [ ] Other: ___________

2. **Rate your familiarity with AI coding assistants:**
   - 1 ⭐ — Never used one
   - 2 ⭐ — Heard about them, haven't tried
   - 3 ⭐ — Tried it a few times
   - 4 ⭐ — Use occasionally
   - 5 ⭐ — Daily user

3. **What's one thing you'd like to learn about AI-assisted development?**
   > _(Write anything — "how to write tests faster", "is it secure?", "can it help with our legacy code?", etc.)_

---

## 🔧 Troubleshooting

### Copilot not showing suggestions?
- **Check sign-in:** Make sure you're signed in with your OutFront enterprise GitHub account (not a personal account).
- **Check the extension:** In VS Code, go to Extensions and make sure "GitHub Copilot" shows as enabled (not disabled or uninstalled).
- **Check the status bar:** The Copilot icon should be active. Click it to see the status. If it says "Copilot is disabled," click to enable it.
- **Restart the IDE:** Sometimes a restart is all it takes.

### `java` command not found?
- Make sure the JDK `bin` directory is in your system `PATH`.
- Open a **new** terminal window after installing (existing terminals won't pick up PATH changes).
- On Windows, you may need to restart your computer after modifying environment variables.

### Maven build failures?
- **"Invalid target release" error:** This usually means your JDK version is too old. Make sure you have JDK 17+.
- **"JAVA_HOME is not set" error:** Set the `JAVA_HOME` environment variable to your JDK installation directory (e.g., `C:\Program Files\Eclipse Adoptium\jdk-17.0.x.x-hotspot`).
- **Dependency download failures:** Make sure you have internet access. If you're behind a corporate proxy, you may need to configure Maven's `settings.xml` with proxy details.

### Can't clone the repository?
- Make sure `git` is installed: run `git --version` in your terminal.
- If you get a permission error, make sure you're authenticated with your OutFront GitHub account.

---

## 📞 Need Help?

If you get stuck on any of these steps, don't worry — just reach out to **Jeff** or reply to this email. We'd rather help you troubleshoot now than lose workshop time to setup issues.

See you at the workshop! 💻✨
