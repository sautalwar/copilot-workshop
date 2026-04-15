# Workshop Prerequisites — Setup Scripts

One-touch installer scripts that detect what's already installed and only install what's missing.

## Which Script to Run

| OS | Script | Command |
|----|--------|---------|
| **Windows** | `setup-windows.ps1` | `powershell -ExecutionPolicy Bypass -File setup-windows.ps1` |
| **macOS** | `setup-macos.sh` | `chmod +x setup-macos.sh && ./setup-macos.sh` |
| **Linux** (Ubuntu/Debian/Fedora/RHEL) | `setup-linux.sh` | `chmod +x setup-linux.sh && ./setup-linux.sh` |

## What Gets Installed

The scripts check for — and install if missing — the following prerequisites:

| Tool | Minimum Version | Windows (winget) | macOS (brew) | Linux (apt/dnf) |
|------|----------------|-------------------|--------------|------------------|
| JDK | 17+ | Eclipse Temurin | temurin (cask) | openjdk-17 |
| Maven | 3.9+ | Apache.Maven | maven | maven |
| Git | 2.40+ | Git.Git | git | git |
| Node.js | 18+ (LTS) | OpenJS.NodeJS.LTS | node@18 | NodeSource repo |
| VS Code | latest | Microsoft.VisualStudioCode | visual-studio-code (cask) | Microsoft repo |

**VS Code Extensions** (installed via `code --install-extension`):
- `github.copilot` — GitHub Copilot
- `github.copilot-chat` — GitHub Copilot Chat
- `vscjava.vscode-java-pack` — Java Extension Pack
- `vmware.vscode-boot-dev-pack` — Spring Boot Extension Pack

## What the Scripts Do NOT Install

- Docker / Docker Desktop
- SQL Server or any database
- Azure CLI or cloud tools
- IDE themes, fonts, or personal preferences

## Dry Run Mode

Preview what would be installed without making any changes:

```bash
# Windows
powershell -ExecutionPolicy Bypass -File setup-windows.ps1 -DryRun

# macOS
./setup-macos.sh --dry-run

# Linux
./setup-linux.sh --dry-run
```

## Idempotent & Safe

The scripts are safe to run multiple times. They check installed versions before taking action:

1. **Tool found, version meets minimum** → skipped with ✅
2. **Tool found, version too old** → upgraded / reinstalled
3. **Tool not found** → installed
4. **Installation fails** → error shown with manual download link

## Troubleshooting

### Windows — winget not available

`winget` ships with the **App Installer** package from the Microsoft Store. If it's missing:

1. Open the Microsoft Store and search for "App Installer"
2. Or download directly: <https://aka.ms/getwinget>

### macOS — Homebrew not available

The macOS script will offer to install Homebrew automatically. You can also install it manually:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Linux — apt-get / dnf not found

The Linux script supports:
- **Ubuntu / Debian / Mint / Pop!_OS** → `apt-get`
- **Fedora / RHEL / CentOS / Rocky / Alma** → `dnf`

Other distributions are not currently supported. Install the prerequisites manually using the links shown in the script output.

### VS Code `code` command not found

- **macOS**: Open VS Code, press `Cmd+Shift+P`, type "Shell Command", and select **Install 'code' command in PATH**.
- **Linux**: The `code` command should be available after installing via the Microsoft repo. Try opening a new terminal.
- **Windows**: The `code` command is added to PATH during VS Code installation. Restart your terminal.

### Environment variables not taking effect

The scripts set `JAVA_HOME` (and `MAVEN_HOME` on Windows) but you may need to **restart your terminal** for changes to take effect.
