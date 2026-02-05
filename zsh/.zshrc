# Dotfiles-managed zsh configuration
DOTFILES_ZSH="$HOME/dotfiles/zsh"

# Load modular configs
source "$DOTFILES_ZSH/tools.zsh"
source "$DOTFILES_ZSH/path.zsh"
source "$DOTFILES_ZSH/aliases.zsh"

# Machine-specific overrides (not synced)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
