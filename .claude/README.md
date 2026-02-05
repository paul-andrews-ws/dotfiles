# Claude Code Configuration

Personal Claude Code configuration synced via dotfiles.

## Contents

- `settings.json` - User-level settings (model, plugins, status line)
- `CLAUDE.md` - User-level instructions loaded into every session
- `skills/` - Personal skills available across all projects

## Skills Included

| Skill | Description |
|-------|-------------|
| `business-banking-context` | Business Banking architecture context for Fort-Knox/corporate features |
| `code-review` | Multi-agent code review with severity ranking |
| `observability-implementation` | Add instrumentation, document monitoring, verify post-deployment |
| `observability-planning` | Plan observability during design phase |
| `react-code-principles` | React/React Native patterns for maintainable code |
| `typescript-best-practices` | Company-wide TypeScript standards |

## Setup

Run the setup script from the dotfiles root:

```bash
cd ~/dotfiles
./setup.sh
```

This will symlink `.claude/` to `~/.claude/`.

## Local Overrides

Machine-specific settings go in `~/.claude/settings.local.json` (not synced).
Project-specific settings go in `.claude/` in your repo (overrides user settings).

## Precedence

1. **Local** - `.claude/*.local.*` (your overrides for a specific repo)
2. **Project** - `.claude/` in repo (team-shared)
3. **User** - `~/.claude/` (this dotfiles config)
