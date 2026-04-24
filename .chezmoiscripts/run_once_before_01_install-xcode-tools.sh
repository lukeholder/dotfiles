#!/usr/bin/env bash
# Runs once — installs Xcode Command Line Tools if not present.

set -euo pipefail

if xcode-select -p &>/dev/null; then
  exit 0
fi

echo "==> Installing Xcode Command Line Tools..."
xcode-select --install
until xcode-select -p &>/dev/null; do sleep 5; done
echo "✓ Xcode Command Line Tools installed"
