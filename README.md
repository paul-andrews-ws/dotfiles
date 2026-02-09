# dotfiles

Personal development environment configuration.

## What's included

- **zsh/** — Shell configuration (`.zshrc`, aliases, PATH, tool setup)
- **.claude/** — [Claude Code](https://claude.ai/claude-code) configuration
  - `CLAUDE.md` — Global instructions for all projects
  - `settings.json` — Claude Code settings
  - `skills/` — Custom skills (business-banking-context, code-review, observability, react, typescript)

## Setup

```bash
git clone git@github.com:paul-andrews-ws/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script symlinks config files into place, backing up any existing files first.
