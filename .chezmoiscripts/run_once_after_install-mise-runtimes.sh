#!/usr/bin/env bash
# Runs once to install mise language runtimes.

set -euo pipefail

if ! command -v mise &>/dev/null; then
  echo "Warning: mise not found — skipping runtime install"
  exit 0
fi

echo "==> Installing mise runtimes..."
eval "$(mise activate bash 2>/dev/null || true)"
mise install 2>/dev/null || echo "Warning: some mise runtimes failed — re-run 'mise install' manually"
echo "✓ mise runtimes installed"
