---
name: notebooklm
description: Control Google NotebookLM from Claude Code. Create notebooks, add sources, ask questions, generate podcasts/videos/reports/quizzes/flashcards/mind maps, and download artifacts through notebooklm-py.
---

# NotebookLM Automation for Claude Code

Use this skill when the user explicitly types `/notebooklm`, says "use NotebookLM", or asks to create NotebookLM notebooks, add sources, summarize sources, generate an audio overview, video explainer, report, quiz, flashcards, mind map, or download NotebookLM artifacts.

This skill delegates the actual work to the `notebooklm` CLI from `notebooklm-py`.

## Required Setup

Before any workflow, verify that the CLI is installed and authenticated.

```bash
notebooklm --version
notebooklm status
notebooklm list --json
```

If authentication fails, ask the user to run:

```bash
notebooklm login
```

The browser login must be completed by the user. Do not ask the user to paste cookies or credentials into chat.

## Configuration

| Variable | Purpose |
|---|---|
| `NOTEBOOKLM_HOME` | Custom config directory. Defaults to `~/.notebooklm`. Use one directory per account or agent. |
| `NOTEBOOKLM_AUTH_JSON` | Inline auth JSON for CI or ephemeral environments. Treat as a secret. |

Parallel workflows must not rely on shared context from `notebooklm use`. Prefer explicit notebook IDs.

- Use `--notebook <notebook_id>` for most commands.
- Use `-n <notebook_id>` for `wait`, `status`, and `download` commands that support it.
- Use full UUIDs in automation instead of short partial IDs.

## Autonomy Rules

Run automatically without extra confirmation:

- `notebooklm status`
- `notebooklm auth check`
- `notebooklm list`
- `notebooklm source list`
- `notebooklm artifact list`
- `notebooklm language list`
- `notebooklm language get`
- `notebooklm create "..."`
- `notebooklm source add ...`
- `notebooklm ask "..."` when not saving as a note
- `notebooklm history` when not saving
- `notebooklm source fulltext <source_id>`
- `notebooklm source guide <source_id>`
- `notebooklm research status`

Ask before running:

- deleting notebooks, sources, artifacts, or notes
- `notebooklm generate *` because generation can take minutes and may hit rate limits
- `notebooklm download *` because it writes files
- `notebooklm ask "..." --save-as-note`
- `notebooklm history --save`
- long blocking waits in the main conversation
- language changes with `notebooklm language set`, because language is global to the account

In a subagent or background task, waiting commands may run without confirmation if the user already approved the generation or download workflow.

## Project Archive Rule

Every non-temporary NotebookLM workflow must create or update a project-local `notebooklm/` directory.

Store downloaded artifacts there:

- audio: `notebooklm/audio/`
- video: `notebooklm/video/`
- reports: `notebooklm/reports/`
- slide decks: `notebooklm/slides/`
- quizzes: `notebooklm/quizzes/`
- flashcards: `notebooklm/flashcards/`
- mind maps: `notebooklm/mind-maps/`
- data tables: `notebooklm/tables/`
- exported chat/history: `notebooklm/chat/`

Create or update `notebooklm/README.md` with:

- notebook title
- notebook ID
- purpose
- source list and source IDs when available
- artifact IDs, types, statuses, and local output paths
- generation date
- remaining follow-up work

## Quick Commands

| Task | Command |
|---|---|
| Login | `notebooklm login` |
| Check auth | `notebooklm auth check` |
| Full auth test | `notebooklm auth check --test` |
| List notebooks | `notebooklm list --json` |
| Create notebook | `notebooklm create "Title" --json` |
| Set single-agent context | `notebooklm use <notebook_id>` |
| Add URL | `notebooklm source add "https://example.com" --json` |
| Add file | `notebooklm source add ./file.pdf --json` |
| Add YouTube | `notebooklm source add "https://youtube.com/..." --json` |
| List sources | `notebooklm source list --json` |
| Wait for source | `notebooklm source wait <source_id> -n <notebook_id> --timeout 600` |
| Fast web research | `notebooklm source add-research "query" --mode fast --import-all` |
| Deep web research | `notebooklm source add-research "query" --mode deep --no-wait` |
| Research status | `notebooklm research status -n <notebook_id> --json` |
| Wait research | `notebooklm research wait -n <notebook_id> --import-all --timeout 1800` |
| Ask | `notebooklm ask "question" --json` |
| Ask source subset | `notebooklm ask "question" -s <source_id> -s <source_id> --json` |
| Continue conversation | `notebooklm ask "follow up" -c <conversation_id> --json` |
| Save answer as note | `notebooklm ask "question" --save-as-note --note-title "Title"` |
| Source full text | `notebooklm source fulltext <source_id> --json` |
| Generate audio | `notebooklm generate audio "instructions" --language ko --json` |
| Generate video | `notebooklm generate video "instructions" --language ko --json` |
| Generate report | `notebooklm generate report --format briefing-doc --language ko --json` |
| Generate quiz | `notebooklm generate quiz --difficulty medium --quantity standard --json` |
| Generate flashcards | `notebooklm generate flashcards --difficulty medium --quantity standard --json` |
| Generate mind map | `notebooklm generate mind-map --json` |
| Generate data table | `notebooklm generate data-table "table description" --json` |
| List artifacts | `notebooklm artifact list --json` |
| Wait artifact | `notebooklm artifact wait <artifact_id> -n <notebook_id> --timeout 1200` |
| Download audio | `notebooklm download audio notebooklm/audio/output.mp3 -a <artifact_id> -n <notebook_id>` |
| Download video | `notebooklm download video notebooklm/video/output.mp4 -a <artifact_id> -n <notebook_id>` |
| Download slides PDF | `notebooklm download slide-deck notebooklm/slides/deck.pdf -a <artifact_id> -n <notebook_id>` |
| Download slides PPTX | `notebooklm download slide-deck notebooklm/slides/deck.pptx --format pptx -a <artifact_id> -n <notebook_id>` |
| Download report | `notebooklm download report notebooklm/reports/report.md -a <artifact_id> -n <notebook_id>` |
| Download mind map | `notebooklm download mind-map notebooklm/mind-maps/map.json -a <artifact_id> -n <notebook_id>` |
| Download quiz Markdown | `notebooklm download quiz --format markdown notebooklm/quizzes/quiz.md -a <artifact_id> -n <notebook_id>` |
| Download flashcards Markdown | `notebooklm download flashcards --format markdown notebooklm/flashcards/cards.md -a <artifact_id> -n <notebook_id>` |

## Long-Running Workflow Pattern

For generation jobs that take more than a minute:

1. Create or identify notebook.
2. Add sources using `--json` and capture source IDs.
3. Wait for sources in a background agent if needed.
4. Start generation with `--json` and capture artifact ID.
5. Spawn a background agent to wait and download.
6. Update `notebooklm/README.md` with IDs and paths.

Example subagent prompt:

```text
Wait for artifact ARTIFACT_ID in notebook NOTEBOOK_ID to complete, then download it.
Run: notebooklm artifact wait ARTIFACT_ID -n NOTEBOOK_ID --timeout 1200
Then run: notebooklm download audio notebooklm/audio/output.mp3 -a ARTIFACT_ID -n NOTEBOOK_ID
If wait exits 2, report timeout and suggest notebooklm artifact list -n NOTEBOOK_ID.
```

## Error Handling

| Error | Likely cause | Action |
|---|---|---|
| Authentication or cookie error | Google session expired | Run `notebooklm auth check`, then ask user to run `notebooklm login`. |
| No notebook context | Context not set | Use explicit `--notebook` or `-n` with notebook ID. |
| Rate limit or `GENERATION_FAILED` | Google generation limit | Wait 5-10 minutes and retry once, or use NotebookLM web UI. |
| Download fails | Artifact incomplete | Run `notebooklm artifact list --json` and wait until completed. |
| Invalid ID | Wrong or ambiguous ID | Run `notebooklm list --json`, `source list --json`, or `artifact list --json`. |
| RPC protocol error | NotebookLM changed internals | Check `notebooklm --version`, upgrade `notebooklm-py`, and re-test auth. |

Exit codes:

- `0`: success
- `1`: command error
- `2`: timeout from wait commands

## Output Style

When acting for the user, give short progress updates:

- “NotebookLM 인증 상태를 확인하겠습니다.”
- “노트북을 만들고 소스 ID를 기록했습니다.”
- “생성 작업을 시작했습니다. artifact ID는 `...`입니다.”
- “긴 대기 작업은 백그라운드에서 진행하고, 완료되면 다운로드합니다.”

Do not expose cookies, auth JSON, browser storage state, or secrets.
