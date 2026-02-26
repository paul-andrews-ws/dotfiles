# Aliases
# Add your custom aliases here

# Example aliases (uncomment to use):
# alias gs="git status"
# alias gd="git diff"
# alias gc="git commit"
# alias gp="git push"
# alias ll="ls -la"

# Claude Code headless commands
alias claude-lint-fix='claude -p "Fix all ESLint and TypeScript errors in the current branch. Follow existing codebase conventions for eslint-disable comments. Run pnpm lint after fixes to verify." --allowedTools "Edit,Read,Bash,Grep"'
