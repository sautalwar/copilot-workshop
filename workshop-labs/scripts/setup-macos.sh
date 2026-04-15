#!/bin/bash
# ──────────────────────────────────────────────────────────────────────
# GitHub Copilot Workshop — macOS Prerequisites Installer
# OutFront Media — Prerequisites Installer
#
# Usage:
#   chmod +x setup-macos.sh
#   ./setup-macos.sh            # install missing prerequisites
#   ./setup-macos.sh --dry-run  # show what would be installed
# ──────────────────────────────────────────────────────────────────────
set -euo pipefail

# ── Colour helpers ────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
RESET='\033[0m'

# ── Minimum version requirements ─────────────────────────────────────
MIN_JAVA_MAJOR=17
MIN_MAVEN_VERSION="3.9.0"
MIN_GIT_VERSION="2.40.0"
MIN_NODE_MAJOR=18

VSCODE_EXTENSIONS=(
    "github.copilot"
    "github.copilot-chat"
    "vscjava.vscode-java-pack"
    "vmware.vscode-boot-dev-pack"
)

# ── Fallback download URLs ───────────────────────────────────────────
URL_JAVA="https://adoptium.net/temurin/releases/"
URL_MAVEN="https://maven.apache.org/download.cgi"
URL_GIT="https://git-scm.com/download/mac"
URL_NODE="https://nodejs.org/en/download/"
URL_VSCODE="https://code.visualstudio.com/Download"
URL_BREW="https://brew.sh"

# ── State ─────────────────────────────────────────────────────────────
DRY_RUN=false
declare -a SUMMARY=()

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# ── Helpers ───────────────────────────────────────────────────────────
status_ok()   { echo -e "  ${GREEN}✅ $1${RESET}"; }
status_warn() { echo -e "  ${YELLOW}⚠️  $1${RESET}"; }
status_fail() { echo -e "  ${RED}❌ $1${RESET}"; }
status_pkg()  { echo -e "  ${YELLOW}📦 $1${RESET}"; }
status_link() { echo -e "  ${MAGENTA}🔗 $1${RESET}"; }
status_gear() { echo -e "  ${CYAN}🔧 $1${RESET}"; }

# Compare two dotted version strings. Returns 0 if $1 >= $2.
version_gte() {
    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i=0; i<${#ver2[@]}; i++)); do
        local v1=${ver1[i]:-0}
        local v2=${ver2[i]:-0}
        if ((v1 > v2)); then return 0; fi
        if ((v1 < v2)); then return 1; fi
    done
    return 0
}

banner() {
    echo ""
    echo -e "${CYAN}============================================${RESET}"
    echo -e "${CYAN}  GitHub Copilot Workshop — Setup Script${RESET}"
    echo -e "${CYAN}  OutFront Media — Prerequisites Installer${RESET}"
    echo -e "${CYAN}============================================${RESET}"
    echo ""
    if $DRY_RUN; then
        echo -e "  ${YELLOW}>> DRY RUN MODE — nothing will be installed <<${RESET}"
        echo ""
    fi
}

# ── Homebrew ──────────────────────────────────────────────────────────
ensure_homebrew() {
    if command -v brew &>/dev/null; then
        status_ok "Homebrew — already installed"
        return 0
    fi

    if $DRY_RUN; then
        status_pkg "Would install Homebrew"
        return 0
    fi

    status_warn "Homebrew is not installed."
    echo -e "  ${YELLOW}Homebrew is required to continue. Installing...${RESET}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        status_fail "Homebrew installation failed."
        status_link "Install manually: $URL_BREW"
        exit 1
    }

    # Add brew to PATH for Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    status_ok "Homebrew installed successfully."
}

# ── Detect shell profile ─────────────────────────────────────────────
get_shell_profile() {
    local current_shell
    current_shell=$(basename "${SHELL:-/bin/zsh}")
    case "$current_shell" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash) echo "$HOME/.bash_profile" ;;
        *)    echo "$HOME/.profile" ;;
    esac
}

SHELL_PROFILE="$(get_shell_profile)"

# ── Java ──────────────────────────────────────────────────────────────
install_java() {
    echo ""
    echo "  Checking Java..."

    if command -v java &>/dev/null; then
        local output
        output=$(java -version 2>&1 || true)
        local major
        major=$(echo "$output" | head -1 | sed -n 's/.*"\([0-9]*\).*/\1/p')
        if [[ -n "$major" ]] && (( major >= MIN_JAVA_MAJOR )); then
            local version_line
            version_line=$(echo "$output" | head -1)
            status_ok "Java $major — already installed ($version_line)"
            SUMMARY+=("✅ Java $major")
            return
        fi
        [[ -n "$major" ]] && status_warn "Java $major found but minimum is $MIN_JAVA_MAJOR."
    fi

    if $DRY_RUN; then
        status_pkg "Would install JDK 17 (Eclipse Temurin) via Homebrew"
        SUMMARY+=("📦 Java 17 (would install)")
        return
    fi

    status_pkg "Installing JDK 17 (Eclipse Temurin)..."
    if brew install --cask temurin@17 2>/dev/null || brew install --cask temurin 2>/dev/null; then
        status_ok "JDK 17 installed."
        SUMMARY+=("✅ Java 17 (newly installed)")
    else
        status_fail "Java installation failed."
        status_link "Download manually: $URL_JAVA"
        SUMMARY+=("❌ Java — installation failed")
        return
    fi

    # Set JAVA_HOME
    local java_home_val
    java_home_val=$(/usr/libexec/java_home -v 17 2>/dev/null || true)
    if [[ -n "$java_home_val" ]]; then
        if ! grep -q 'JAVA_HOME' "$SHELL_PROFILE" 2>/dev/null; then
            echo "" >> "$SHELL_PROFILE"
            echo "# Java (set by Copilot Workshop setup)" >> "$SHELL_PROFILE"
            echo "export JAVA_HOME=\"$java_home_val\"" >> "$SHELL_PROFILE"
            echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> "$SHELL_PROFILE"
            status_gear "JAVA_HOME written to $SHELL_PROFILE"
        else
            status_gear "JAVA_HOME already configured in $SHELL_PROFILE"
        fi
        export JAVA_HOME="$java_home_val"
    fi
}

# ── Maven ─────────────────────────────────────────────────────────────
install_maven() {
    echo ""
    echo "  Checking Maven..."

    if command -v mvn &>/dev/null; then
        local output
        output=$(mvn -version 2>&1 || true)
        local current_version
        current_version=$(echo "$output" | grep -oE 'Apache Maven [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        if [[ -n "$current_version" ]] && version_gte "$current_version" "$MIN_MAVEN_VERSION"; then
            status_ok "Maven $current_version — already installed"
            SUMMARY+=("✅ Maven $current_version")
            return
        fi
        [[ -n "$current_version" ]] && status_warn "Maven $current_version found but minimum is $MIN_MAVEN_VERSION."
    fi

    if $DRY_RUN; then
        status_pkg "Would install Maven via Homebrew"
        SUMMARY+=("📦 Maven (would install)")
        return
    fi

    status_pkg "Installing Maven..."
    if brew install maven; then
        status_ok "Maven installed."
        SUMMARY+=("✅ Maven (newly installed)")
    else
        status_fail "Maven installation failed."
        status_link "Download manually: $URL_MAVEN"
        SUMMARY+=("❌ Maven — installation failed")
    fi
}

# ── Git ───────────────────────────────────────────────────────────────
install_git() {
    echo ""
    echo "  Checking Git..."

    if command -v git &>/dev/null; then
        local output
        output=$(git --version 2>&1 || true)
        local current_version
        current_version=$(echo "$output" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        if [[ -n "$current_version" ]] && version_gte "$current_version" "$MIN_GIT_VERSION"; then
            status_ok "Git $current_version — already installed"
            SUMMARY+=("✅ Git $current_version")
            return
        fi
        [[ -n "$current_version" ]] && status_warn "Git $current_version found but minimum is $MIN_GIT_VERSION."
    fi

    if $DRY_RUN; then
        status_pkg "Would install Git via Homebrew"
        SUMMARY+=("📦 Git (would install)")
        return
    fi

    status_pkg "Installing Git..."
    if brew install git; then
        status_ok "Git installed."
        SUMMARY+=("✅ Git (newly installed)")
    else
        status_fail "Git installation failed."
        status_link "Download manually: $URL_GIT"
        SUMMARY+=("❌ Git — installation failed")
    fi
}

# ── Node.js ───────────────────────────────────────────────────────────
install_node() {
    echo ""
    echo "  Checking Node.js..."

    if command -v node &>/dev/null; then
        local output
        output=$(node --version 2>&1 || true)
        local major
        major=$(echo "$output" | sed -n 's/v\([0-9]*\).*/\1/p')
        if [[ -n "$major" ]] && (( major >= MIN_NODE_MAJOR )); then
            local full_version="${output#v}"
            status_ok "Node.js $full_version — already installed"
            SUMMARY+=("✅ Node.js $full_version")
            return
        fi
        [[ -n "$major" ]] && status_warn "Node.js $major found but minimum is $MIN_NODE_MAJOR."
    fi

    if $DRY_RUN; then
        status_pkg "Would install Node.js LTS via Homebrew"
        SUMMARY+=("📦 Node.js (would install)")
        return
    fi

    status_pkg "Installing Node.js LTS..."
    if brew install node@18 && brew link --overwrite node@18 2>/dev/null; then
        status_ok "Node.js installed."
        SUMMARY+=("✅ Node.js (newly installed)")
    elif brew install node; then
        status_ok "Node.js installed."
        SUMMARY+=("✅ Node.js (newly installed)")
    else
        status_fail "Node.js installation failed."
        status_link "Download manually: $URL_NODE"
        SUMMARY+=("❌ Node.js — installation failed")
    fi
}

# ── VS Code ───────────────────────────────────────────────────────────
install_vscode() {
    echo ""
    echo "  Checking VS Code..."

    if command -v code &>/dev/null; then
        local output
        output=$(code --version 2>&1 || true)
        local version_line
        version_line=$(echo "$output" | head -1)
        if [[ "$version_line" =~ ^[0-9]+\.[0-9]+ ]]; then
            status_ok "VS Code $version_line — already installed"
            SUMMARY+=("✅ VS Code $version_line")
            install_vscode_extensions
            return
        fi
    fi

    if $DRY_RUN; then
        status_pkg "Would install VS Code via Homebrew cask"
        SUMMARY+=("📦 VS Code (would install)")
        install_vscode_extensions
        return
    fi

    status_pkg "Installing VS Code..."
    if brew install --cask visual-studio-code; then
        status_ok "VS Code installed."
        SUMMARY+=("✅ VS Code (newly installed)")
    else
        status_fail "VS Code installation failed."
        status_link "Download manually: $URL_VSCODE"
        SUMMARY+=("❌ VS Code — installation failed")
        return
    fi

    install_vscode_extensions
}

install_vscode_extensions() {
    echo ""
    echo "  Checking VS Code extensions..."

    if ! command -v code &>/dev/null && ! $DRY_RUN; then
        status_warn "VS Code CLI not found — skipping extension install."
        SUMMARY+=("⚠️ Extensions — VS Code CLI not found")
        return
    fi

    local installed_extensions=""
    if ! $DRY_RUN; then
        installed_extensions=$(code --list-extensions 2>/dev/null || true)
    fi

    local installed_count=0
    local total_count=${#VSCODE_EXTENSIONS[@]}

    for ext in "${VSCODE_EXTENSIONS[@]}"; do
        if echo "$installed_extensions" | grep -qi "^${ext}$"; then
            status_ok "$ext — already installed"
            ((installed_count++))
        elif $DRY_RUN; then
            status_pkg "Would install extension: $ext"
            ((installed_count++))
        else
            status_pkg "Installing extension: $ext..."
            if code --install-extension "$ext" --force &>/dev/null; then
                status_ok "$ext — installed"
                ((installed_count++))
            else
                status_fail "$ext — installation failed"
            fi
        fi
    done

    if (( installed_count >= total_count )); then
        SUMMARY+=("✅ VS Code Extensions ($installed_count/$total_count)")
    else
        SUMMARY+=("⚠️ VS Code Extensions ($installed_count/$total_count)")
    fi
}

# ── Summary ───────────────────────────────────────────────────────────
print_summary() {
    echo ""
    echo -e "${CYAN}============================================${RESET}"
    echo -e "${CYAN}  Setup Summary${RESET}"
    echo -e "${CYAN}============================================${RESET}"

    for item in "${SUMMARY[@]}"; do
        echo "  $item"
    done

    echo ""
    local has_failures=false
    for item in "${SUMMARY[@]}"; do
        if [[ "$item" == ❌* ]]; then
            has_failures=true
            break
        fi
    done

    if $has_failures; then
        echo -e "  ${RED}Some prerequisites failed to install.${RESET}"
        echo -e "  ${RED}Please install them manually using the URLs above.${RESET}"
    elif $DRY_RUN; then
        echo -e "  ${YELLOW}Dry run complete — no changes were made.${RESET}"
    else
        echo -e "  ${GREEN}All prerequisites installed!${RESET}"
        echo "  Next: cd workshop-labs && mvn clean verify -B"
    fi
    echo ""
}

# ── Main ──────────────────────────────────────────────────────────────

banner
ensure_homebrew
install_java
install_maven
install_git
install_node
install_vscode
print_summary
