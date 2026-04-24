#!/usr/bin/env bash
# Runs once — installs Homebrew if not present.

set -euo pipefail

if command -v brew &>/dev/null; then
  exit 0
fi

echo "==> Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "✓ Homebrew installed"
