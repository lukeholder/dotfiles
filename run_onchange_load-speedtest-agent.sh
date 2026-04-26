#!/bin/bash
# Reload the speedtest LaunchAgent whenever the plist changes.
# chezmoi runs this script when its content changes (run_onchange_).
# plist hash: {{ include "Library/LaunchAgents/com.lukeholder.speedtest.plist" | sha256sum }}

PLIST="$HOME/Library/LaunchAgents/com.lukeholder.speedtest.plist"

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load "$PLIST"
