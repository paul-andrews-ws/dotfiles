# CLAUDE.md

## Tools & Environment

- Use `/react-code-principles` skill when writing or modifying React/React Native components
- Use `/typescript-best-practices` skill when writing or modifying TypeScript files
- Use `/superpowers:brainstorming` skill before any creative work - creating features, building components, adding functionality, or modifying behavior
- Use `/superpowers:executing-plans` skill when executing a written implementation plan
- Use `/superpowers:dispatching-parallel-agents` or `/superpowers:subagent-driven-development` skills when implementing work with independent or parallelizable tasks
- Use `/superpowers:requesting-code-review` skill after implementing work to iterate and improve code quality
- Use `/observability-planning` and `/observability-implementation` skills when a prompt asks to consider development planning or monitoring
- During planning and pre-code phases, use `/superpowers:writing-plans` for high-level architecture review and implementation strategy

## Style

- When working in Fort-Knox or any Ruby/backend files, use **Learning** output style - explain concepts, provide context for decisions, and help build understanding of the codebase and patterns

## Engineering Partnership

- Before implementing architectural decisions I give you, briefly assess whether the approach is the right one. If you see a simpler alternative, a potential footgun, or an assumption worth questioning, raise it before writing code.
- For backend/Ruby work (Fort-Knox, wealthsimple monolith), take a stronger partner role — proactively flag risks, explain trade-offs of different approaches, and recommend the better path with reasoning. Don't assume I've considered the backend implications.
- When adding or modifying an SNS event publisher in monolith or fort-knox, proactively trace the full downstream consumer chain (Sourcegraph `keyword_search` on the event_type string) and surface what side effects will fire in prod — don't wait for me to ask. PR "next steps" lists from upstream PRs are not reliable indicators of deployed subscriber state.

## Code Changes

- Examine patterns in neighbouring files first
- Follow linting configs (`.eslintrc`, `.rubocop.yml`, `.editorconfig`)
- Priority: (1) File consistency, (2) Readability, (3) Performance, (4) Conciseness
- Stop and confirm before: architectural changes, multiple valid approaches, shared code/API changes, rewrites
- Preserve existing comments unless provably false
- Go light on comments in new code - code should be self-explanatory
- Don't extract single-use custom hooks, constants, or helpers — inline the logic. Extract only when there's actual reuse or the abstraction clarifies a complex operation. A single-reference constant or a hook called in one component is indirection without benefit.
- Always use explicit braces `{}` for if statements, even single-line returns:
  ```typescript
  // Good
  if (!value) {
    return null;
  }

  // Bad - no inline conditionals
  if (!value) return null;
  ```

## Testing

- Never mock functionality being tested
- Never write tests that only test mocked behaviour
- Avoid mocking external libraries and dependencies - prefer integration tests that use real implementations
- Don't duplicate test cases for the same behaviour - one representative test is sufficient
- Test output must be clean (no ignored warnings/errors)

## Git

- Before committing and pushing, always run lint and tests for the affected projects:
  ```bash
  pnpm nx run <project>:lint
  pnpm nx run <project>:test
  ```
  Use `pnpm nx affected --target=lint,check-types` and `pnpm flightcheck --local-changes` when multiple projects are touched. Fix all failures before pushing — do not rely on remote CI to catch issues.

## Documentation & Design Docs

- When drafting architecture, design, tech plan, spike, or investigation docs as `.md` files in a project, ALSO append the draft to my personal Notion scratchpad so I can read it there: https://www.notion.so/wealthsimple/Scratchpad-2ed41167bd9681fa8094e05c4c318e75
  - Create the Notion page as a child of the scratchpad, using the doc's title as the page title
  - Apply the same rule when iterating on a design doc — keep the Notion version in sync with the `.md` version (update, don't duplicate)
  - Skip for trivial READMEs, commit messages, or single-paragraph notes — this applies to substantive design/planning docs (multiple sections, or explicitly framed as "design doc", "tech plan", "architecture brief", "spike", "investigation")
  - If it's ambiguous whether a doc qualifies, ask once rather than skipping silently

## Forbidden

- Direct commits to main/master
