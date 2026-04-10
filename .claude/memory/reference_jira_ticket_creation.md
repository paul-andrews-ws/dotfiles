---
name: JIRA ticket creation via MCP Locker
description: How to create and format JIRA tickets using mcplocker tools, including panel formatting and BB project conventions
type: reference
originSessionId: f0ce86ae-797a-49bd-b791-ed7bf6a6e307
---
**MCP Locker JIRA tools** require OAuth authentication via `mcp__mcplocker__authenticate` before use. Once authed, key tools: `jira_get_ticket`, `jira_create_ticket`, `jira_update_ticket`, `jira_get_project_metadata`.

**Always call `jira_get_project_metadata`** before creating tickets to discover available issue types and field IDs.

**BB project ticket template** uses JIRA wiki markup `{info:title=SectionName}...{info}` panels for colour-coded sections:
- `{info:title=Description}` — context and purpose
- `{info:title=Acceptance Criteria}` — bullet list of completion criteria
- `{info:title=Notes}` — links to Figma designs, project docs (omit if none)
- `{info:title=Developer Notes}` — prior artifacts, files to modify, suggested approach

**Inline code** in JIRA wiki markup uses double curly braces: `{{code_here}}`.

**Links**: `[display text|https://url]`

**Epic link field**: `customfield_10008` — value must be an Epic issue key. Stories/Tasks cannot be used as epic links. Use `parent_key` param for parent-child relationships within the hierarchy, but only if the parent type supports children of that type.

**GitHub Repo field**: `customfield_16282` (text) — e.g. "fort-knox"
