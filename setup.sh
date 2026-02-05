#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_DOTFILES="$DOTFILES_DIR/.claude"

echo "Setting up Claude Code dotfiles..."
echo "  Source: $CLAUDE_DOTFILES"
echo "  Target: $CLAUDE_DIR"
echo ""

# Ensure ~/.claude exists
mkdir -p "$CLAUDE_DIR"

# Symlink settings.json
if [ -f "$CLAUDE_DIR/settings.json" ] && [ ! -L "$CLAUDE_DIR/settings.json" ]; then
    echo "Backing up existing settings.json to settings.json.backup"
    mv "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.backup"
fi

if [ -L "$CLAUDE_DIR/settings.json" ]; then
    echo "Removing existing symlink for settings.json"
    rm "$CLAUDE_DIR/settings.json"
fi

ln -s "$CLAUDE_DOTFILES/settings.json" "$CLAUDE_DIR/settings.json"
echo "✓ Linked settings.json"

# Symlink skills directory
if [ -d "$CLAUDE_DIR/skills" ] && [ ! -L "$CLAUDE_DIR/skills" ]; then
    echo "Backing up existing skills/ to skills.backup/"
    mv "$CLAUDE_DIR/skills" "$CLAUDE_DIR/skills.backup"
fi

if [ -L "$CLAUDE_DIR/skills" ]; then
    echo "Removing existing symlink for skills/"
    rm "$CLAUDE_DIR/skills"
fi

ln -s "$CLAUDE_DOTFILES/skills" "$CLAUDE_DIR/skills"
echo "✓ Linked skills/"

# Symlink CLAUDE.md
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "Backing up existing CLAUDE.md to CLAUDE.md.backup"
    mv "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
fi

if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "Removing existing symlink for CLAUDE.md"
    rm "$CLAUDE_DIR/CLAUDE.md"
fi

ln -s "$CLAUDE_DOTFILES/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "✓ Linked CLAUDE.md"

echo ""
echo "Setup complete!"
echo ""
echo "Your existing settings.local.json (if any) is preserved for machine-specific overrides."
echo "Run 'ls -la ~/.claude/' to verify symlinks."
