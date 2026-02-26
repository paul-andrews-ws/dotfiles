#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_DOTFILES="$DOTFILES_DIR/.claude"

# ===================
# Zsh Configuration
# ===================
echo "Setting up Zsh dotfiles..."

if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

if [ -L "$HOME/.zshrc" ]; then
    echo "Removing existing symlink for .zshrc"
    rm "$HOME/.zshrc"
fi

ln -s "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
echo "✓ Linked .zshrc"
echo ""

# ===================
# Claude Code Configuration
# ===================
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

# Symlink MEMORY.md
# The memory path is derived from the home directory (e.g. -Users-paul-andrews)
MEMORY_PROJECT_KEY=$(echo "$HOME" | sed 's|/|-|g')
MEMORY_DIR="$CLAUDE_DIR/projects/$MEMORY_PROJECT_KEY/memory"
mkdir -p "$MEMORY_DIR"

if [ -f "$MEMORY_DIR/MEMORY.md" ] && [ ! -L "$MEMORY_DIR/MEMORY.md" ]; then
    echo "Backing up existing MEMORY.md to MEMORY.md.backup"
    mv "$MEMORY_DIR/MEMORY.md" "$MEMORY_DIR/MEMORY.md.backup"
fi

if [ -L "$MEMORY_DIR/MEMORY.md" ]; then
    echo "Removing existing symlink for MEMORY.md"
    rm "$MEMORY_DIR/MEMORY.md"
fi

ln -s "$CLAUDE_DOTFILES/memory/MEMORY.md" "$MEMORY_DIR/MEMORY.md"
echo "✓ Linked MEMORY.md"

echo ""
echo "Setup complete!"
echo ""
echo "Your existing settings.local.json (if any) is preserved for machine-specific overrides."
echo "Run 'ls -la ~/.claude/' to verify symlinks."
