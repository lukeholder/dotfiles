#!/usr/bin/env bash
# Runs once to set up fzf shell integration.

set -euo pipefail

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
