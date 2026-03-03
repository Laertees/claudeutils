#!/usr/bin/env bash
# Cross-platform setup script for Claude Code configs
# Works on Mac and Windows (Git Bash / WSL)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Code Setup ==="
echo "Repo:   $REPO_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

# Detect platform
case "$(uname -s)" in
    Darwin)  PLATFORM="mac" ;;
    MINGW*|MSYS*|CYGWIN*) PLATFORM="windows" ;;
    Linux)   PLATFORM="linux" ;;
    *)       PLATFORM="unknown" ;;
esac
echo "Platform: $PLATFORM"

# Ensure claude config dir exists
mkdir -p "$CLAUDE_DIR"

# Sync settings if they exist in repo
sync_config() {
    local src="$REPO_DIR/configs/$1"
    local dest="$CLAUDE_DIR/$1"

    if [ ! -f "$src" ]; then
        echo "  SKIP $1 (not in repo yet)"
        return
    fi

    if [ -f "$dest" ]; then
        echo "  EXISTS $1 - backing up to $1.bak"
        cp "$dest" "$dest.bak"
    fi

    cp "$src" "$dest"
    echo "  COPIED $1"
}

echo ""
echo "Syncing configs..."
sync_config "settings.json"
sync_config "keybindings.json"

echo ""
echo "Done. Restart Claude Code to pick up changes."
