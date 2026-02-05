---
name: code-review
description: Use when reviewing code changes, uncommitted work, or pull requests with comprehensive multi-agent analysis
---

# Code Review

Review the code changes using THREE (3) parallel code review subagents and correlate results into a summary ranked by severity. Use the provided user guidance to steer the review and focus on specific code paths, changes, and/or areas of concern.

## How It Works

1. **VCS Detection**: Automatically detects whether the repo uses git or jj
2. **Multi-Agent Review**: Launches 3 parallel review agents for comprehensive analysis
3. **Severity Ranking**: Correlates findings and ranks by severity
4. **Flexible Scope**: Reviews uncommitted changes by default, last commit if nothing staged

## Usage

```bash
/code-review                          # Review uncommitted changes
/code-review "focus on error handling" # Review with specific guidance
/code-review https://github.com/...   # Review a pull request
```

## Review Scope

- **Uncommitted changes** (default)
- **Last commit** (if no uncommitted changes)
- **Pull/Merge requests** (provide number or link)

## Implementation

Review uncommitted changes by default. If no uncommitted changes, review the last commit. If the user provides a pull request/merge request number or link, use CLI tools (gh/glab) to fetch it and then perform your review.

The review should incorporate user-provided guidance to focus on specific code paths and areas of concern.

First, detect the VCS system (git or jj) and use appropriate commands throughout.

Launch THREE (3) parallel subagents to review the code from different perspectives, then correlate their findings into a single summary ranked by severity.
