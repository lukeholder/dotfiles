#!/usr/bin/env bash
#
# Minimal bootstrap for a new macOS machine.
# Installs Xcode CLT, Homebrew, and chezmoi, then lets chezmoi do the rest.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/lukeholder/dotfiles/main/setup.sh | bash
#   — or —
#   bash setup.sh

set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}==> ${NC}$*"; }
step() { echo -e "\n${BLUE}-------- $* --------${NC}"; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo -e "${RED}Error: This script is intended for macOS only.${NC}" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ---------------------------------------------------------------------------
step "Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
fi
echo -e "${GREEN}✓ Xcode Command Line Tools ready${NC}"

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------
step "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
echo -e "${GREEN}✓ Homebrew ready${NC}"

# ---------------------------------------------------------------------------
# 3. chezmoi — init and apply dotfiles
#    Run scripts in .chezmoiscripts handle the rest (brew bundle, mise, fzf)
# ---------------------------------------------------------------------------
step "chezmoi dotfiles"
if ! command -v chezmoi &>/dev/null; then
  info "Installing chezmoi..."
  brew install chezmoi
fi

if [[ -d "$HOME/.local/share/chezmoi/.git" ]]; then
  info "chezmoi already initialised — applying latest..."
  chezmoi apply
else
  info "Initialising chezmoi from lukeholder/dotfiles..."
  chezmoi init --apply lukeholder/dotfiles
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup complete! Please restart your terminal.       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or open a new tab)"
echo "  2. Open 1Password and configure it"
echo "  3. Sign into the App Store, then install 1Password for Safari:"
echo "       mas install 1569813296"
echo "  4. Open Ghostty and other apps to finish first-launch setup"
echo ""
