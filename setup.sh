#!/usr/bin/env bash
#
# Idempotent MacBook Pro developer setup script.
# Run this script on a fresh macOS installation to bootstrap your environment.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/lukeholder/laptop/main/setup.sh | bash
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ---------------------------------------------------------------------------
step "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
  success "Xcode Command Line Tools already installed"
else
  info "Installing Xcode Command Line Tools (a dialog may appear)..."
  xcode-select --install
  # Wait until the tools are installed
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
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  success "Homebrew installed"
fi

info "Updating Homebrew..."
brew update --quiet

# ---------------------------------------------------------------------------
# 3. Install packages from Brewfile
# ---------------------------------------------------------------------------
step "Brewfile packages"
if [[ -f "$SCRIPT_DIR/Brewfile" ]]; then
  info "Running brew bundle..."
  if brew bundle --help 2>&1 | grep -q -- '--no-lock'; then
    brew bundle --file="$SCRIPT_DIR/Brewfile" --no-lock
  else
    brew bundle --file="$SCRIPT_DIR/Brewfile"
  fi
  success "Brewfile packages installed"
else
  warn "Brewfile not found at $SCRIPT_DIR/Brewfile — skipping"
fi

# ---------------------------------------------------------------------------
# 4. chezmoi — dotfile management
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
  info "Initializing chezmoi from lukeholder/laptop..."
  chezmoi init --apply lukeholder/laptop
  success "chezmoi dotfiles applied"
fi

# ---------------------------------------------------------------------------
# 5. mise — runtime version manager
# ---------------------------------------------------------------------------
step "mise runtimes"
if ! command -v mise &>/dev/null; then
  info "Installing mise..."
  brew install mise
fi

# Activate mise for the rest of this script
eval "$(mise activate bash 2>/dev/null || true)"

# Write a global .mise.toml if one is not already present
MISE_GLOBAL="$HOME/.config/mise/config.toml"
if [[ ! -f "$MISE_GLOBAL" ]]; then
  info "Writing global mise config..."
  mkdir -p "$(dirname "$MISE_GLOBAL")"
  cp "$SCRIPT_DIR/.mise.toml" "$MISE_GLOBAL"
fi

info "Installing language runtimes via mise (this may take a few minutes)..."
mise install 2>/dev/null || warn "Some mise runtimes failed to install — re-run 'mise install' after setup"
success "mise runtimes installed"

# ---------------------------------------------------------------------------
# 6. Claude Code CLI (requires Node, which mise just installed)
# ---------------------------------------------------------------------------
step "Claude Code CLI"
if command -v claude &>/dev/null; then
  success "Claude Code CLI already installed"
else
  # Ensure the mise-managed node is on PATH
  eval "$(mise activate bash 2>/dev/null || true)"
  if command -v npm &>/dev/null; then
    info "Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code
    success "Claude Code CLI installed"
  else
    warn "npm not found — skipping Claude Code CLI (run 'npm install -g @anthropic-ai/claude-code' after mise is activated)"
  fi
fi

# ---------------------------------------------------------------------------
# 7. ddev — local development environment
# ---------------------------------------------------------------------------
step "ddev"
if command -v ddev &>/dev/null; then
  success "ddev already installed"
else
  info "Installing ddev..."
  brew install ddev/ddev/ddev
  success "ddev installed"
fi

# ---------------------------------------------------------------------------
# 8. fzf shell integration (creates ~/.fzf.zsh; ~/.zshrc is managed by chezmoi)
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
echo "  4. Open Ghostty, VS Code, and other apps to finish first-launch setup"
echo "  5. Run 'chezmoi edit' to customise your dotfiles"
echo ""
