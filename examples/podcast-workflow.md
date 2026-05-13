# Example: Research to Korean Podcast

Claude Code에 입력:

```text
/notebooklm "AI Agent 입문 팟캐스트" 노트북을 만들고 아래 자료를 추가해줘.
- ./docs/agent-intro.pdf
- https://example.com/agent-article
소스 처리가 끝나면 한국어 오디오 개요를 생성하고, 완료되면 notebooklm/audio/agent-intro.mp3로 저장해줘.
```

Claude Code가 내부적으로 수행할 흐름:

```bash
notebooklm create "AI Agent 입문 팟캐스트" --json
notebooklm source add ./docs/agent-intro.pdf --json
notebooklm source add "https://example.com/agent-article" --json
notebooklm source wait <source_id> -n <notebook_id> --timeout 600
notebooklm generate audio "AI Agent 입문자가 이해하기 쉽게 핵심 개념과 실제 활용 사례를 설명" --language ko --json
notebooklm artifact wait <artifact_id> -n <notebook_id> --timeout 1200
notebooklm download audio notebooklm/audio/agent-intro.mp3 -a <artifact_id> -n <notebook_id>
```

완료 후 기록할 `notebooklm/README.md` 예시:

```markdown
# NotebookLM Archive

- Notebook title: AI Agent 입문 팟캐스트
- Notebook ID: `<notebook_id>`
- Purpose: 강의 전 사전 청취용 한국어 오디오 개요 생성
- Sources:
  - `<source_id>` — docs/agent-intro.pdf
  - `<source_id>` — https://example.com/agent-article
- Artifacts:
  - `<artifact_id>` — Audio Overview — notebooklm/audio/agent-intro.mp3
- Generated: 2026-05-06
- Follow-up: 강의용 요약 보고서 생성
```
