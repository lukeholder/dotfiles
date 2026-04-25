#!/usr/bin/env bash
# Runs once — generates starship config from the Catppuccin Powerline preset.

set -euo pipefail

if ! command -v starship &>/dev/null; then
  echo "Warning: starship not found — skipping config generation"
  exit 0
fi

echo "==> Configuring starship with Catppuccin Powerline preset..."
starship preset catppuccin-powerline -o ~/.config/starship.toml
echo "✓ starship config applied"
