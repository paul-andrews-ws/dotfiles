---
name: Parallel Sourcegraph subagents for cross-repo research
description: For any "how does X work across our backend?" question, dispatch parallel subagents with Sourcegraph MCP access — this pattern works noticeably better than local grep
type: feedback
originSessionId: 61947b33-d8bf-4a17-945e-1b45af3422c0
---
For cross-repo architectural research (fort-knox + risk-service + ws-decision-platform + front-end-monorepo spanning questions), the most effective pattern is:

1. Split the question into 2-4 independent facets (e.g. "backend enforcement logic", "decision rules", "frontend UX", "personal vs business differentiation").
2. Dispatch one `general-purpose` Agent per facet in parallel.
3. Explicitly tell each agent to use the Sourcegraph MCP tools (`mcp__sourcegraph__sg_deepsearch`, `sg_keyword_search`, `sg_read_file`, etc.) and to call `ToolSearch` first with `query: "select:sg_deepsearch,sg_keyword_search,..."` to load schemas (the Sourcegraph tools are deferred, not loaded by default).
4. Ask for concrete file paths + line numbers + code quotes, not paraphrased summaries.

**Why:** Sourcegraph indexes every internal repo, including ones not cloned locally (`ws-decision-platform`, `risk-service`, `notification-service`). Local grep misses these. Parallel subagents also keep the main context clean — each one does ~25-40 tool calls without bloating the top-level conversation.

**How to apply:** Any "how does [backend concept] work end-to-end?" question — especially if the answer likely spans fort-knox + risk-service + decision platform + a frontend. Don't try to do it serially from the main agent; dispatch.

**Why:** The user explicitly asked for this approach in the e-transfer limits investigation and it produced a complete tri-repo map in one shot, including pulling the exact Flink SQL tenure gate (`tenure_now >= 30`) that wouldn't have been findable without Sourcegraph.
