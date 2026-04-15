#!/bin/bash
# ──────────────────────────────────────────────────────────────────────
# GitHub Copilot Workshop — Linux Prerequisites Installer
# OutFront Media — Prerequisites Installer
#
# Supports Ubuntu/Debian (apt-get) and Fedora/RHEL (dnf).
#
# Usage:
#   chmod +x setup-linux.sh
#   ./setup-linux.sh            # install missing prerequisites
#   ./setup-linux.sh --dry-run  # show what would be installed
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
URL_GIT="https://git-scm.com/download/linux"
URL_NODE="https://nodejs.org/en/download/"
URL_VSCODE="https://code.visualstudio.com/Download"

# ── State ─────────────────────────────────────────────────────────────
DRY_RUN=false
DISTRO_FAMILY=""   # "debian" or "rhel"
PKG_MANAGER=""     # "apt-get" or "dnf"
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

# ── Distro detection ─────────────────────────────────────────────────
detect_distro() {
    echo "  Detecting Linux distribution..."

    if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        source /etc/os-release
        local id_like="${ID_LIKE:-}"
        local id="${ID:-}"

        case "$id" in
            ubuntu|debian|linuxmint|pop)
                DISTRO_FAMILY="debian"
                PKG_MANAGER="apt-get"
                ;;
            fedora|rhel|centos|rocky|alma)
                DISTRO_FAMILY="rhel"
                PKG_MANAGER="dnf"
                ;;
            *)
                # Fall back to ID_LIKE
                if [[ "$id_like" == *"debian"* || "$id_like" == *"ubuntu"* ]]; then
                    DISTRO_FAMILY="debian"
                    PKG_MANAGER="apt-get"
                elif [[ "$id_like" == *"rhel"* || "$id_like" == *"fedora"* ]]; then
                    DISTRO_FAMILY="rhel"
                    PKG_MANAGER="dnf"
                fi
                ;;
        esac
    fi

    if [[ -z "$DISTRO_FAMILY" ]]; then
        # Last-resort detection
        if command -v apt-get &>/dev/null; then
            DISTRO_FAMILY="debian"
            PKG_MANAGER="apt-get"
        elif command -v dnf &>/dev/null; then
            DISTRO_FAMILY="rhel"
            PKG_MANAGER="dnf"
        else
            status_fail "Unsupported Linux distribution. This script supports Ubuntu/Debian (apt-get) and Fedora/RHEL (dnf)."
            exit 1
        fi
    fi

    status_ok "Detected: $DISTRO_FAMILY family (using $PKG_MANAGER)"
    echo ""
}

pkg_install() {
    local packages=("$@")
    if [[ "$PKG_MANAGER" == "apt-get" ]]; then
        sudo apt-get install -y "${packages[@]}"
    elif [[ "$PKG_MANAGER" == "dnf" ]]; then
        sudo dnf install -y "${packages[@]}"
    fi
}

pkg_update() {
    if [[ "$PKG_MANAGER" == "apt-get" ]]; then
        sudo apt-get update -y
    elif [[ "$PKG_MANAGER" == "dnf" ]]; then
        sudo dnf check-update || true  # dnf check-update returns 100 when updates are available
    fi
}

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
        if [[ "$DISTRO_FAMILY" == "debian" ]]; then
            status_pkg "Would install openjdk-17-jdk via apt-get"
        else
            status_pkg "Would install java-17-openjdk-devel via dnf"
        fi
        SUMMARY+=("📦 Java 17 (would install)")
        return
    fi

    status_pkg "Installing JDK 17..."
    local java_pkg
    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
        java_pkg="openjdk-17-jdk"
    else
        java_pkg="java-17-openjdk-devel"
    fi

    if pkg_install "$java_pkg"; then
        status_ok "JDK 17 installed."
        SUMMARY+=("✅ Java 17 (newly installed)")
    else
        status_fail "Java installation failed."
        status_link "Download manually: $URL_JAVA"
        SUMMARY+=("❌ Java — installation failed")
        return
    fi

    # Set JAVA_HOME in ~/.bashrc
    local java_home_val=""
    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
        java_home_val=$(update-alternatives --query java 2>/dev/null | grep 'Value:' | sed 's|Value: ||;s|/bin/java||' || true)
        if [[ -z "$java_home_val" ]]; then
            java_home_val="/usr/lib/jvm/java-17-openjdk-$(dpkg --print-architecture 2>/dev/null || echo amd64)"
        fi
    else
        java_home_val=$(dirname "$(dirname "$(readlink -f "$(command -v java)")")" 2>/dev/null || true)
        if [[ -z "$java_home_val" ]]; then
            java_home_val="/usr/lib/jvm/java-17-openjdk"
        fi
    fi

    if [[ -n "$java_home_val" ]] && [[ -d "$java_home_val" ]]; then
        if ! grep -q 'JAVA_HOME' "$HOME/.bashrc" 2>/dev/null; then
            echo "" >> "$HOME/.bashrc"
            echo "# Java (set by Copilot Workshop setup)" >> "$HOME/.bashrc"
            echo "export JAVA_HOME=\"$java_home_val\"" >> "$HOME/.bashrc"
            echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> "$HOME/.bashrc"
            status_gear "JAVA_HOME written to ~/.bashrc"
        else
            status_gear "JAVA_HOME already configured in ~/.bashrc"
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
        status_pkg "Would install Maven via $PKG_MANAGER"
        SUMMARY+=("📦 Maven (would install)")
        return
    fi

    status_pkg "Installing Maven..."
    if pkg_install maven; then
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
        status_pkg "Would install Git via $PKG_MANAGER"
        SUMMARY+=("📦 Git (would install)")
        return
    fi

    status_pkg "Installing Git..."
    if pkg_install git; then
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
        status_pkg "Would install Node.js 18+ via NodeSource repository"
        SUMMARY+=("📦 Node.js (would install)")
        return
    fi

    status_pkg "Installing Node.js 18+..."

    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
        # Use NodeSource repository for up-to-date Node.js
        if ! command -v curl &>/dev/null; then
            pkg_install curl ca-certificates gnupg
        fi
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg 2>/dev/null || true
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null
        sudo apt-get update -y
        if sudo apt-get install -y nodejs; then
            status_ok "Node.js installed."
            SUMMARY+=("✅ Node.js (newly installed)")
        else
            status_fail "Node.js installation failed."
            status_link "Download manually: $URL_NODE"
            SUMMARY+=("❌ Node.js — installation failed")
        fi
    else
        # Fedora/RHEL — try dnf module or NodeSource
        if sudo dnf module install -y nodejs:18 2>/dev/null; then
            status_ok "Node.js installed."
            SUMMARY+=("✅ Node.js (newly installed)")
        elif pkg_install nodejs npm; then
            status_ok "Node.js installed."
            SUMMARY+=("✅ Node.js (newly installed)")
        else
            status_fail "Node.js installation failed."
            status_link "Download manually: $URL_NODE"
            SUMMARY+=("❌ Node.js — installation failed")
        fi
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
        status_pkg "Would install VS Code via Microsoft repository"
        SUMMARY+=("📦 VS Code (would install)")
        install_vscode_extensions
        return
    fi

    status_pkg "Installing VS Code..."

    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
        # Add Microsoft GPG key and repo
        if ! command -v curl &>/dev/null; then
            pkg_install curl ca-certificates gnupg
        fi
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg 2>/dev/null || true
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
        sudo apt-get update -y
        if sudo apt-get install -y code; then
            status_ok "VS Code installed."
            SUMMARY+=("✅ VS Code (newly installed)")
        else
            status_fail "VS Code installation failed."
            status_link "Download manually: $URL_VSCODE"
            SUMMARY+=("❌ VS Code — installation failed")
            return
        fi
    else
        # Fedora/RHEL
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 2>/dev/null || true
        sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
        if sudo dnf install -y code; then
            status_ok "VS Code installed."
            SUMMARY+=("✅ VS Code (newly installed)")
        else
            status_fail "VS Code installation failed."
            status_link "Download manually: $URL_VSCODE"
            SUMMARY+=("❌ VS Code — installation failed")
            return
        fi
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
detect_distro

if ! $DRY_RUN; then
    echo "  Updating package index..."
    pkg_update
    echo ""
fi

install_java
install_maven
install_git
install_node
install_vscode
print_summary
