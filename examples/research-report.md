# Example: Research Report

Claude Code에 입력:

```text
/notebooklm "NotebookLM 자동화 조사" 노트북을 만들고 "Claude Code와 NotebookLM 자동화 활용 사례"를 deep research로 조사해줘. 완료되면 모든 소스를 가져오고, 한국어 briefing doc 보고서를 생성해서 notebooklm/reports/briefing.md로 저장해줘.
```

CLI 흐름:

```bash
notebooklm create "NotebookLM 자동화 조사" --json
notebooklm source add-research "Claude Code NotebookLM automation use cases" --mode deep --no-wait
notebooklm research wait -n <notebook_id> --import-all --timeout 1800
notebooklm generate report --format briefing-doc --language ko --json
notebooklm artifact wait <artifact_id> -n <notebook_id> --timeout 900
notebooklm download report notebooklm/reports/briefing.md -a <artifact_id> -n <notebook_id>
```

권장 후속 질문:

```bash
notebooklm ask "이 보고서를 비개발자 대상 워크숍 커리큘럼으로 바꾸면 어떤 순서가 좋을까?" --notebook <notebook_id> --json
```
