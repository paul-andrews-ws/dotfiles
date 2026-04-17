---
name: wrap-up
description: >
  Use when the user says "wrap up", "close session", "end session", "wrap
  things up", "close out this task", or invokes /wrap-up. Runs a five-phase
  end-of-session checklist covering file hygiene, memory consolidation,
  developer-facing learnings capture, self-improvement analysis, and content
  publishing. Execute all phases automatically and present a consolidated
  report at the end.
---

# Session Wrap-Up

You are now in wrap-up mode. Run all five phases in order — each is
conversational and executed inline. **Do not create separate documents for
this process.** Apply all changes autonomously without asking for permission
first; surface what you did in the consolidated report at the end.

---

## Phase 1: Verify It

Goal: Ensure the session's artifacts are correctly placed and the task list
reflects reality.

### Document placement

If any document-type files (`.md`, `.docx`, `.pdf`, `.xlsx`, `.pptx`) were
written to the workspace root or inside source code directories during this
session, and they are documentation rather than code, move them to the
appropriate docs folder.

### Task list hygiene

1. Review the task list for any in-progress or stale items.
2. Mark completed tasks as done. Flag orphaned tasks (started but no longer
   relevant) with a note explaining why they were abandoned, then close them.

---

## Phase 2: Remember It

Goal: Consolidate knowledge gained during this session into the right place so
it is available and actionable in future sessions.

Review the full conversation. For each piece of knowledge worth preserving,
decide where it belongs using the guide below, then write it there.

### Memory placement guide

| Location | Owned by | Use for |
|---|---|---|
| `MEMORY.md` | Claude (auto-memory) | Patterns, debugging insights, project quirks, and anything Claude discovered that will improve future performance |
| `CLAUDE.md` | Project instructions | Permanent conventions, commands, architecture decisions, and rules that should guide **all** future sessions on this project |
| `CLAUDE.local.md` | Private per-project | Personal WIP context, local URLs, sandbox credentials, current focus — not committed to git |
| `@import` reference | Either CLAUDE file | When content already exists in another file — reference it rather than duplicating |

### Decision framework

- Is it a permanent project convention or rule? → `CLAUDE.md`
- Is it a pattern or insight Claude discovered through trial and error? → `MEMORY.md`
- Is it personal or ephemeral context (local env, current sprint focus)? → `CLAUDE.local.md`
- Is it already documented somewhere else? → Add an `@import` reference instead

### Generalizability filter

Before writing anything to memory, apply this test: **"Would this help in a
session working on a completely different feature?"**

- **Yes** → Save it. Examples: environment quirks, testing patterns that apply
  across packages, tooling gotchas, user preferences about workflow.
- **No** → Don't save it. Examples: architecture details of the feature just
  built, backend behavior specific to one ticket, one-off debugging findings.
  These belong in external docs (Notion, PR descriptions, code comments) — not
  in Claude's memory.

Ticket-scoped knowledge (how a specific feature works, backend race conditions
discovered during one investigation, requirement resolution details) should be
captured in team-facing docs like Notion or PR descriptions, not in memory
files. Memory is for **cross-session, cross-feature patterns**.

Apply updates now. If nothing noteworthy was learned, say so and move on.

---

## Phase 3: Capture Developer Learnings

Goal: Capture technical learnings, gotchas, and workflow insights valuable to
the user as a developer — distinct from Phase 2, which is Claude's own
memory.

Append to the **Developer Learnings** Notion page:
https://www.notion.so/34541167bd968102bfd6e461f61de260

### What qualifies

- **Technical** — non-obvious mechanics of a library, tool, framework, or
  system that took effort to figure out and will likely matter again
- **Gotcha / footgun** — surprising behavior, silent failure modes, sharp
  edges, easy-to-miss assumptions
- **Claude workflow** — a prompting pattern, skill, or collaboration approach
  that worked notably well (or badly) and is worth repeating/avoiding
- **Cross-cutting insight** — pattern or principle that applies across
  features, not tied to one ticket

### What does NOT qualify

- Ticket-specific feature details → belongs in the PR description or Notion
  tech doc
- Content already captured in Phase 2 (Claude's memory) — don't duplicate
- One-off trivia with no reuse value

### How to append

Fetch the Developer Learnings page, then append each learning to the most
relevant toggled section:

- `front-end-monorepo` — specific to the FE monorepo
- `fort-knox` — specific to fort-knox
- `wealthsimple monolith` — specific to the Rails monolith
- `Cross-cutting / general engineering` — patterns that apply across repos
- `AI & Claude workflows` — prompting / skill / collaboration insights
- `Gotchas & footguns` — sharp edges worth flagging regardless of repo

Prepend new entries to the top of the section as a **toggle heading 3** so
the section stays scannable. Format (tabs, not spaces, for indentation —
Notion requires tabs to nest children under a toggle):

```
### YYYY-MM-DD — short descriptive title {toggle="true"}
	One- or two-sentence summary phrased to be understandable without session
	context.

	Optional: links to relevant files, PRs, or docs. Multi-paragraph detail,
	code snippets, tables, etc. all go indented inside the toggle.
```

Result: each section reads as a list of dated toggle-titles; a reader
expands only the specific learning they want to read.

If nothing from this session qualifies, say "No developer learnings to capture
this session" and move on.

---

## Phase 4: Review & Apply

Goal: Identify friction, gaps, and automation opportunities from this session,
and apply improvements immediately.

If the session was short, routine, or produced nothing notable, say
"Nothing to improve this session" and skip to Phase 5.

Otherwise, scan the conversation for findings in these categories:

### Finding categories

- **Skill gap** — Claude struggled, got something wrong, or needed multiple
  attempts to get it right
- **Friction** — The user had to ask for something that should have been
  automatic; repeated manual steps; anything that felt like unnecessary back
  and forth
- **Knowledge** — Facts about the project, user preferences, or environment
  that Claude didn't know but should have had
- **Automation** — Repetitive patterns that could become a skill, hook, or
  script to save future effort

### Action types (apply these now, don't just list them)

- **`CLAUDE.md`** — Edit the relevant project or global CLAUDE.md to encode
  the rule or convention
- **`Rules`** — Create or update a `.claude/rules/` file for more structured
  guidance
- **`MEMORY.md`** — Write the insight into auto-memory for future sessions
- **`Skill / Hook`** — If a new skill or hook would address the finding, write
  a spec for it (or create it if straightforward)
- **`CLAUDE.local.md`** — Capture per-project context that's too personal to
  commit

### Sync to dotfiles

After applying all Phase 3 changes, commit and push any modified dotfiles
(CLAUDE.md, MEMORY.md, skills, rules, hooks, etc.) to the personal dotfiles
repo so changes persist across machines:

```bash
cd ~/path/to/dotfiles  # locate the dotfiles repo if not already known
git add -A
git commit -m "chore: wrap-up session updates [$(date +%Y-%m-%d)]"
git push origin main
```

The dotfiles repo is: https://github.com/paul-andrews-ws/dotfiles

If the dotfiles repo path is not already known, locate it with:
```bash
find ~ -maxdepth 4 -name ".git" -type d | xargs -I{} dirname {} | xargs -I{} sh -c 'git -C {} remote get-url origin 2>/dev/null' | grep dotfiles
```

Only push files that belong in dotfiles (config, skills, rules, CLAUDE.md,
MEMORY.md). Never commit secrets, tokens, or `CLAUDE.local.md`.

### Report format

Present a consolidated summary after applying — applied items first, then
anything reviewed but left unchanged:

**Findings (applied):**

1. ✅ Friction: Had to manually run lint after every file change
   → [CLAUDE.md] Added pre-commit lint reminder to project instructions

2. ✅ Skill gap: Incorrectly estimated token costs twice
   → [MEMORY.md] Saved note on token estimation patterns for this project

3. ✅ Automation: Health check after deploy was always a manual step
   → [Skill spec] Drafted `post-deploy-check` skill in `.claude/skills/`

4. ✅ Dotfiles synced → pushed to github.com/paul-andrews-ws/dotfiles

---
**No action taken:**

5. Knowledge: Discovered that X service batches requests
   Already documented in `CLAUDE.md` under the API section

---

## Phase 5: Publish It

Goal: Surface session material worth sharing publicly and draft content for
review before posting.

Scan the full conversation for material that could create value for others:

- Interesting technical solutions or non-obvious debugging stories
- Community-relevant announcements, launches, or updates
- Educational content — how-tos, tips, lessons learned
- Project milestones or notable feature releases

### If publishable material exists

Draft the content and save it as a Notion doc. Present suggestions with the
draft:

> All wrap-up steps complete. I also found potential content to publish:
>
> 1. **"Title of Post"** — 1–2 sentence description of the content angle.
>    Platform: Reddit
>    Draft saved to: Drafts/Title-Of-Post/Reddit.md

Wait for the user to respond. If they approve, post to Notion in the private
Scratchpad:
https://www.notion.so/wealthsimple/Scratchpad-2ed41167bd9681fa8094e05c4c318e75

If they decline, leave the drafts in place for later — do not delete them.

### Scheduling

- If the session produced multiple publishable items, **do not post them all
  at once**
- Space posts at least a few hours apart per platform
- If multiple posts are needed, post the most time-sensitive one now and
  present a suggested schedule for the remainder

### If no publishable material exists

Say "Nothing worth publishing from this session" — and you're done.
