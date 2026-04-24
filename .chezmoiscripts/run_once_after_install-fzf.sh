#!/usr/bin/env bash
# Runs once to set up fzf shell integration.

set -euo pipefail

# Ensure brew is in PATH (needed on fresh installs)
if ! command -v brew &>/dev/null; then
  [[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -f "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"
fi

FZF_INSTALL="$(brew --prefix)/opt/fzf/install"

if [[ ! -f "$FZF_INSTALL" ]]; then
  echo "Warning: fzf not found — skipping shell integration"
  exit 0
fi

if [[ -f "$HOME/.fzf.zsh" ]]; then
  echo "✓ fzf shell integration already configured"
  exit 0
fi

echo "==> Setting up fzf shell integration..."
"$FZF_INSTALL" --key-bindings --completion --no-update-rc
echo "✓ fzf shell integration configured"
