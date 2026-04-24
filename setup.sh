#!/usr/bin/env bash
#
# Idempotent MacBook Pro developer setup script.
# Run this script on a fresh macOS installation to bootstrap your environment.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/lukeholder/dotfiles/main/setup.sh | bash
#   — or —
#   bash setup.sh

set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()    { echo -e "${GREEN}==> ${NC}$*"; }
warn()    { echo -e "${YELLOW}Warning: ${NC}$*"; }
step()    { echo -e "\n${BLUE}-------- $* --------${NC}"; }
success() { echo -e "${GREEN}✓ $*${NC}"; }

# Ensure we are running on macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo -e "${RED}Error: This script is intended for macOS only.${NC}" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ---------------------------------------------------------------------------
step "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
  success "Xcode Command Line Tools already installed"
else
  info "Installing Xcode Command Line Tools (a dialog may appear)..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  success "Xcode Command Line Tools installed"
fi

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------
step "Homebrew"
if command -v brew &>/dev/null; then
  success "Homebrew already installed"
else
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for the rest of this script
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  success "Homebrew installed"
fi

info "Updating Homebrew..."
brew update --quiet

# ---------------------------------------------------------------------------
# 3. chezmoi — dotfiles (must run before brew bundle so ~/.Brewfile exists)
# ---------------------------------------------------------------------------
step "chezmoi dotfiles"
if ! command -v chezmoi &>/dev/null; then
  info "Installing chezmoi..."
  brew install chezmoi
fi

CHEZMOI_SOURCE="$HOME/.local/share/chezmoi"
if [[ -d "$CHEZMOI_SOURCE/.git" ]]; then
  info "chezmoi already initialized — applying latest changes..."
  chezmoi apply
  success "chezmoi dotfiles applied"
else
  info "Initializing chezmoi from lukeholder/dotfiles..."
  chezmoi init --apply lukeholder/dotfiles
  success "chezmoi dotfiles applied"
fi

# ---------------------------------------------------------------------------
# 4. Install packages from ~/.Brewfile (managed by chezmoi)
# ---------------------------------------------------------------------------
step "Brewfile packages"
if [[ -f "$HOME/.Brewfile" ]]; then
  info "Running brew bundle --global..."
  brew bundle --global
  success "Brewfile packages installed"
else
  warn "~/.Brewfile not found — skipping (chezmoi may not have applied correctly)"
fi

# ---------------------------------------------------------------------------
# 5. mise — install language runtimes
# ---------------------------------------------------------------------------
step "mise runtimes"
if ! command -v mise &>/dev/null; then
  warn "mise not found — it should have been installed via Brewfile"
else
  eval "$(mise activate bash 2>/dev/null || true)"
  info "Installing language runtimes via mise (this may take a few minutes)..."
  mise install 2>/dev/null || warn "Some mise runtimes failed to install — re-run 'mise install' after setup"
  success "mise runtimes installed"
fi

# ---------------------------------------------------------------------------
# 6. fzf shell integration
# ---------------------------------------------------------------------------
step "fzf shell integration"
if [[ -f "$(brew --prefix)/opt/fzf/install" ]] && [[ ! -f "$HOME/.fzf.zsh" ]]; then
  info "Setting up fzf shell integration..."
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
  success "fzf shell integration configured"
else
  success "fzf shell integration already configured"
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
echo "  5. Run 'chezmoi edit' to customise your dotfiles"
echo ""
