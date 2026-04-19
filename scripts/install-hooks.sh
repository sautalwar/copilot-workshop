#!/bin/sh
# ============================================================
# install-hooks.sh — Install Git hooks for OutFront OMS
# ============================================================
# Usage: ./scripts/install-hooks.sh
#
# This copies hook scripts from scripts/hooks/ into .git/hooks/
# so they run automatically on git commit, push, etc.
#
# Run this once after cloning the repository.
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

HOOK_SOURCE="scripts/hooks"
HOOK_TARGET=".git/hooks"

# Verify we're in the repo root
if [ ! -d ".git" ]; then
    printf "${RED}✗ Not in a Git repository root. Run from the project root directory.${NC}\n"
    exit 1
fi

if [ ! -d "$HOOK_SOURCE" ]; then
    printf "${RED}✗ Hook source directory '%s' not found.${NC}\n" "$HOOK_SOURCE"
    exit 1
fi

printf "${YELLOW}Installing Git hooks for OutFront OMS...${NC}\n\n"

INSTALLED=0
for hook in "$HOOK_SOURCE"/*; do
    hook_name=$(basename "$hook")

    # Skip non-files (directories, etc.)
    [ -f "$hook" ] || continue

    # Back up existing hook if it's not a symlink to ours
    if [ -f "$HOOK_TARGET/$hook_name" ] && [ ! -L "$HOOK_TARGET/$hook_name" ]; then
        cp "$HOOK_TARGET/$hook_name" "$HOOK_TARGET/$hook_name.backup"
        printf "${YELLOW}  ⚠ Backed up existing %s to %s.backup${NC}\n" "$hook_name" "$hook_name"
    fi

    # Copy hook and make executable
    cp "$hook" "$HOOK_TARGET/$hook_name"
    chmod +x "$HOOK_TARGET/$hook_name"
    printf "${GREEN}  ✓ Installed %s${NC}\n" "$hook_name"
    INSTALLED=$((INSTALLED + 1))
done

printf "\n${GREEN}✓ Done! %d hook(s) installed.${NC}\n" "$INSTALLED"
printf "\n"
printf "  Hooks active:\n"
printf "    • pre-commit      — Checks secrets, code style, SQL patterns\n"
printf "    • commit-msg      — Validates commit message format\n"
printf "    • pre-push        — Runs tests before push\n"
printf "    • prepare-commit-msg — Shows commit format template\n"
printf "\n"
printf "  ${YELLOW}To skip hooks in emergencies: git commit --no-verify${NC}\n"
