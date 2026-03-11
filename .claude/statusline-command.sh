#!/bin/bash

input=$(cat)

# Git repo name (top-level directory name)
git_repo=""
git_branch=""
repo_root=$(git -C "$(echo "$input" | jq -r '.cwd')" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$repo_root" ]; then
  git_repo=$(basename "$repo_root")
  git_branch=$(git -C "$repo_root" symbolic-ref --short HEAD 2>/dev/null || git -C "$repo_root" rev-parse --short HEAD 2>/dev/null)
fi

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

# Context remaining
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Build output parts
parts=()

if [ -n "$git_repo" ]; then
  parts+=("$(printf '\033[0;36m%s\033[0m' "$git_repo")")
fi

if [ -n "$git_branch" ]; then
  parts+=("$(printf '\033[0;33m%s\033[0m' "$git_branch")")
fi

parts+=("$(printf '\033[0;35m%s\033[0m' "$model")")

if [ -n "$remaining" ]; then
  # Color context: green if plenty, yellow if low, red if critical
  remaining_int=${remaining%.*}
  if [ "$remaining_int" -ge 30 ] 2>/dev/null; then
    ctx_color='\033[0;32m'
  elif [ "$remaining_int" -ge 10 ] 2>/dev/null; then
    ctx_color='\033[0;33m'
  else
    ctx_color='\033[0;31m'
  fi
  parts+=("$(printf "${ctx_color}ctx: %s%%\033[0m" "$remaining_int")")
fi

# Join parts with separator
output=""
for part in "${parts[@]}"; do
  if [ -z "$output" ]; then
    output="$part"
  else
    output="$output $(printf '\033[0;37m|\033[0m') $part"
  fi
done

printf "%s" "$output"
