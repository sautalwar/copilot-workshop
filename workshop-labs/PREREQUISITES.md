# Workshop Prerequisites — GitHub Copilot Hands-On Lab

## Overview

In this workshop, you'll learn how GitHub Copilot can speed up your development work—right inside your code editor. We'll build a real Order Management System for OutFront Media using Spring Boot and Java, with Copilot assisting you every step of the way.

You'll write less boilerplate, catch bugs faster, and focus on the business logic that matters.

**Estimated setup time:** ~5 minutes with the setup script, ~30 minutes manual

---

## 🚀 One-Touch Setup (Recommended)

Don't want to install everything manually? Run a single script that checks what you already have and installs only what's missing.

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-windows.ps1
```

**macOS (Terminal):**
```bash
chmod +x scripts/setup-macos.sh && ./scripts/setup-macos.sh
```

**Linux — Ubuntu/Debian/Fedora (Terminal):**
```bash
chmod +x scripts/setup-linux.sh && ./scripts/setup-linux.sh
```

**What the scripts do:**
- ✅ Check each tool (Java, Maven, Git, Node.js, VS Code) and skip if already installed
- ✅ Install only what's missing using your OS package manager (winget, Homebrew, apt/dnf)
- ✅ Set up environment variables (JAVA_HOME, etc.)
- ✅ Install required VS Code extensions
- ✅ Run a final verification to confirm everything works

**Preview mode:** Add `--dry-run` to see what would be installed without making changes.

> **Prefer manual setup?** Skip this section and follow the step-by-step instructions below.

---

## Required Software

Below is everything you need installed. Each section shows what the software does, how to install it, and how to verify it's working.

### JDK 17+ (Java Development Kit)

**What it is:** The engine that runs Java code. You need version 17 or higher.

**Install on Windows:**
```bash
winget install EclipseAdoptium.Temurin.17.JDK
```

Or download from: https://adoptium.net/

**Verify it's installed:**
```bash
java -version
```

You should see output like: `openjdk version "17.0.x"` or similar.

---

### Maven 3.9+

**What it is:** A tool that downloads libraries, builds your project, and runs tests. Think of it as the "project manager" for Java.

**Install on Windows:**
```bash
winget install Apache.Maven
```

Or download from: https://maven.apache.org/download.cgi

**Verify it's installed:**
```bash
mvn -version
```

You should see output like: `Apache Maven 3.9.x`

---

### VS Code (Latest Stable)

**What it is:** Your code editor. We use VS Code because it's lightweight and Copilot works beautifully in it.

**Download from:** https://code.visualstudio.com/

**Verify it's installed:**
```bash
code --version
```

---

### VS Code Extensions (REQUIRED)

**What they are:** Small add-ons that make VS Code smarter. These extensions add Copilot, Java support, and Spring Boot helpers.

**Install all at once:**
```bash
code --install-extension github.copilot github.copilot-chat vscjava.vscode-java-pack vmware.vscode-boot-dev-pack
```

Or install manually in VS Code:
1. Click the **Extensions** icon on the left sidebar (looks like four squares)
2. Search for and install:
   - `GitHub Copilot` (github.copilot)
   - `GitHub Copilot Chat` (github.copilot-chat)
   - `Extension Pack for Java` (vscjava.vscode-java-pack)
   - `Spring Boot Extension Pack` (vmware.vscode-boot-dev-pack)

**Verify:** Look for the GitHub Copilot icon (Copilot logo) in the VS Code status bar at the bottom. You should also see a Java logo indicating Java support is active.

---

### Git 2.40+

**What it is:** Version control. You'll use it to clone the workshop project.

**On Windows**, Git usually comes with VS Code. If not, download from: https://git-scm.com/

**Verify it's installed:**
```bash
git --version
```

---

### Node.js 18+ (for Lab 3)

**What it is:** JavaScript runtime. The workshop includes an MCP (Model Context Protocol) server built with Node.js that you'll explore in Lab 3.

**Install on Windows:**
```bash
winget install OpenJS.NodeJS.LTS
```

Or download from: https://nodejs.org/

**Verify it's installed:**
```bash
node --version
npm --version
```

You should see versions 18 or higher for both.

---

### GitHub Account with Copilot License

**What you need:** 
- A GitHub account (create one at https://github.com if you don't have one)
- An active GitHub Copilot license (Business or Enterprise through OutFront Media)

**To verify:** 
1. Open https://github.com/settings/copilot
2. You should see "Copilot is active" or "Your Copilot subscription is active"

If Copilot is not active, contact your IT team or OutFront's GitHub administrator.

---

## Optional Software

These tools are nice to have but **not required** for the workshop:

- **Docker Desktop** — only if you want to run SQL Server locally (we use an in-memory H2 database, so this is optional)
- **Postman or Insomnia** — for testing API endpoints by clicking (VS Code REST Client works just fine)
- **DBeaver or TablePlus** — for viewing database contents (optional)

---

## Pre-Workshop Setup (Step by Step)

Follow these steps in order. Each one takes just a few minutes.

### Step 1: Install All Required Software
Complete all installations from the **Required Software** section above. Verify each one works.

### Step 2: Clone the Lab Repository
Open a terminal or PowerShell and run:
```bash
git clone https://github.com/sautalwar/outfront-copilot-workshop.git
cd outfront-copilot-workshop
```

### Step 3: Build the Project
Run:
```bash
mvn clean verify -B
```

This downloads libraries and compiles the code. It should take 1-2 minutes. You should see: `BUILD SUCCESS` at the end.

### Step 4: Start the Application
Run:
```bash
mvn spring-boot:run
```

You should see lines like:
```
...
Tomcat started on port(s): 8080 (http)
...
```

### Step 5: Verify the App is Running
Open your browser and go to: http://localhost:8080/swagger-ui.html

You should see an interactive API documentation page. This is Swagger UI—it shows all the API endpoints in the Order Management System.

### Step 6: Verify Copilot is Active
1. In VS Code, open any `.java` file from the project (e.g., `src/main/java/com/outfront/workshop/controller/OrderController.java`)
2. Type a comment: `// Get all `
3. Press `Ctrl+Enter` (or wait a moment)

Copilot should suggest code to complete your thought. You'll see a gray suggestion appear inline.

### Step 7: Stop the App
In the terminal where the app is running, press `Ctrl+C` to stop it.

---

## Verification Checklist

Before the workshop, make sure all of these work:

- [ ] `java -version` shows **17 or higher**
- [ ] `mvn -version` shows **3.9 or higher**
- [ ] `git --version` shows **2.40 or higher**
- [ ] `node --version` shows **18 or higher**
- [ ] VS Code opens and shows the Copilot icon in the status bar
- [ ] `mvn clean verify -B` completes with **BUILD SUCCESS**
- [ ] App starts successfully on http://localhost:8080
- [ ] Swagger UI loads at http://localhost:8080/swagger-ui.html
- [ ] Copilot suggests code when you type a comment

---

## Troubleshooting

### "java: command not found" or "java is not recognized"

**Problem:** Java is installed but your system can't find it.

**Fix (Windows):**
1. Press `Win + X`, then choose **System** → **Advanced system settings**
2. Click **Environment Variables**
3. Under "System variables," click **New**
4. Variable name: `JAVA_HOME`
5. Variable value: `C:\Program Files\Eclipse Adoptium\jdk-17.0.x` (check your actual path)
6. Click **OK**, close, and restart your terminal

Then try `java -version` again.

---

### "mvn: command not found" or "mvn is not recognized"

**Problem:** Maven is installed but not in your system's PATH.

**Fix (Windows):**
1. Press `Win + X`, then choose **System** → **Advanced system settings**
2. Click **Environment Variables**
3. Under "System variables," find or create **Path**, then click **Edit**
4. Click **New** and add: `C:\Program Files\Apache\maven\bin` (check your actual path)
5. Click **OK**, close, and restart your terminal

Then try `mvn -version` again.

---

### Copilot is not suggesting code in VS Code

**Problem:** Copilot extension is installed but not active.

**Fix:**
1. Check that `github.copilot` extension is installed (see Extensions section above)
2. Open VS Code → **Settings** (Ctrl+,) → search for "Copilot"
3. Make sure **Copilot: Enable** is checked
4. Sign in with your GitHub account:
   - Click the Copilot icon in the status bar
   - Click **Sign in with GitHub**
   - Authorize the extension
5. Restart VS Code

If you still don't see suggestions, check https://github.com/settings/copilot to confirm your Copilot subscription is active.

---

### Port 8080 is already in use

**Problem:** Another app is using port 8080, so the Spring Boot app can't start.

**Fix (Windows):**
Find and stop the app using port 8080:
```bash
netstat -ano | findstr :8080
```

Note the PID (process ID), then stop it:
```bash
taskkill /PID <PID> /F
```

Or change the app's port in `src/main/resources/application.properties`:
```properties
server.port=8081
```

Then start the app again.

---

### "BUILD FAILURE" when running `mvn clean verify`

**Problem:** The build failed, usually due to a missing library or Java version mismatch.

**Fix:**
1. Make sure `java -version` shows 17 or higher
2. Delete the Maven cache:
   ```bash
   rm -r ~/.m2/repository
   ```
   (On Windows: delete `%USERPROFILE%\.m2\repository`)
3. Try building again:
   ```bash
   mvn clean verify -B
   ```

If it still fails, check the error message. Common issues:
- Missing JDK (make sure `java -version` works)
- No internet (Maven needs to download libraries)

---

## What You DON'T Need

To be clear: you do **not** need any of these.

- **SQL Server** — The app uses **H2**, an in-memory database that's perfect for development and testing. No SQL Server installation needed.
- **IntelliJ IDEA** — We're using VS Code for this workshop. If you prefer IntelliJ, it works too, but the instructions assume VS Code.
- **Previous GitHub Copilot experience** — We'll teach you everything from scratch. Bring questions!
- **GitHub Copilot Pro** — Your business or enterprise license is enough. You don't need the personal subscription.
- **Docker** — Optional. We won't use Docker in the core workshop exercises.

---

## Questions?

If you hit any issues during setup, reach out to the workshop facilitator or ask in the team chat. Come 10–15 minutes early if you want help verifying everything is installed and working.

**Let's build something great with Copilot.** See you at the workshop!
