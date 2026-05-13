# Example: Bulk Import

여러 자료를 한 번에 추가하고 처리 완료를 기다리는 패턴입니다.

Claude Code에 입력:

```text
/notebooklm "시장 조사 자료실" 노트북을 만들고 docs 폴더의 PDF 3개와 아래 URL 2개를 추가해줘. 모든 소스가 준비되면 핵심 인사이트와 출처별 차이를 요약해줘.
```

CLI 흐름:

```bash
notebooklm create "시장 조사 자료실" --json
notebooklm source add ./docs/report-1.pdf --json
notebooklm source add ./docs/report-2.pdf --json
notebooklm source add ./docs/report-3.pdf --json
notebooklm source add "https://example.com/a" --json
notebooklm source add "https://example.com/b" --json

notebooklm source wait <source_id_1> -n <notebook_id> --timeout 600
notebooklm source wait <source_id_2> -n <notebook_id> --timeout 600
notebooklm source wait <source_id_3> -n <notebook_id> --timeout 600
notebooklm source wait <source_id_4> -n <notebook_id> --timeout 600
notebooklm source wait <source_id_5> -n <notebook_id> --timeout 600

notebooklm ask "전체 자료의 핵심 인사이트와 출처별 관점 차이를 표로 요약해줘" --notebook <notebook_id> --json
```

많은 소스를 다룰 때는 Claude Code 백그라운드 에이전트에게 `source wait`만 맡기면 대화가 막히지 않습니다.
