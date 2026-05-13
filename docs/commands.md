# Command Reference

`notebooklm-py` CLI 기준 주요 명령입니다.

## 인증

```bash
notebooklm login
notebooklm status
notebooklm auth check
notebooklm auth check --test
```

## 노트북

```bash
notebooklm list
notebooklm list --json
notebooklm create "노트북 제목"
notebooklm create "노트북 제목" --json
notebooklm use <notebook_id>
notebooklm notebook delete <notebook_id>
```

자동화에서는 `use`보다 명시적 ID를 권장합니다.

```bash
notebooklm ask "질문" --notebook <notebook_id>
```

## 소스

```bash
notebooklm source add "https://example.com" --json
notebooklm source add "https://youtube.com/watch?v=..." --json
notebooklm source add ./document.pdf --json
notebooklm source list --json
notebooklm source wait <source_id> -n <notebook_id> --timeout 600
notebooklm source fulltext <source_id> --json
notebooklm source guide <source_id>
notebooklm source delete <source_id>
notebooklm source delete-by-title "정확한 제목"
```

지원 자료 예시:

- 웹 URL
- YouTube URL
- PDF
- Google Docs
- 텍스트 파일
- Markdown
- Word 문서
- 오디오 파일
- 비디오 파일
- 이미지

## 웹 리서치

```bash
notebooklm source add-research "검색 주제" --mode fast --import-all
notebooklm source add-research "검색 주제" --mode deep --no-wait
notebooklm research status -n <notebook_id> --json
notebooklm research wait -n <notebook_id> --import-all --timeout 1800
```

## 질문과 대화

```bash
notebooklm ask "핵심 내용을 요약해줘"
notebooklm ask "핵심 내용을 요약해줘" --json
notebooklm ask "이 소스만 기준으로 요약해줘" -s <source_id> --json
notebooklm ask "후속 질문" -c <conversation_id> --json
notebooklm ask "답변을 노트로 저장해줘" --save-as-note --note-title "요약 노트"
notebooklm history
notebooklm history --save --note-title "대화 기록"
```

## 생성

모든 생성 명령은 `--language ko`와 `--json`을 함께 쓰면 자동화하기 좋습니다.

```bash
notebooklm generate audio "초보자도 이해할 수 있게 설명" --language ko --json
notebooklm generate video "핵심 개념을 5분 영상으로" --language ko --json
notebooklm generate slide-deck --format detailed --language ko --json
notebooklm generate report --format briefing-doc --language ko --json
notebooklm generate report --format study-guide --append "대상: 입문자" --language ko --json
notebooklm generate quiz --difficulty medium --quantity standard --language ko --json
notebooklm generate flashcards --difficulty medium --quantity standard --language ko --json
notebooklm generate mind-map --json
notebooklm generate data-table "주요 개념, 정의, 예시, 출처를 표로 정리" --json
notebooklm generate infographic --orientation landscape --detail standard --style professional --language ko --json
```

## 아티팩트

```bash
notebooklm artifact list --json
notebooklm artifact wait <artifact_id> -n <notebook_id> --timeout 1200
notebooklm artifact delete <artifact_id>
```

## 다운로드

```bash
notebooklm download audio notebooklm/audio/output.mp3 -a <artifact_id> -n <notebook_id>
notebooklm download video notebooklm/video/output.mp4 -a <artifact_id> -n <notebook_id>
notebooklm download slide-deck notebooklm/slides/deck.pdf -a <artifact_id> -n <notebook_id>
notebooklm download slide-deck notebooklm/slides/deck.pptx --format pptx -a <artifact_id> -n <notebook_id>
notebooklm download report notebooklm/reports/report.md -a <artifact_id> -n <notebook_id>
notebooklm download mind-map notebooklm/mind-maps/map.json -a <artifact_id> -n <notebook_id>
notebooklm download data-table notebooklm/tables/table.csv -a <artifact_id> -n <notebook_id>
notebooklm download quiz --format markdown notebooklm/quizzes/quiz.md -a <artifact_id> -n <notebook_id>
notebooklm download flashcards --format markdown notebooklm/flashcards/cards.md -a <artifact_id> -n <notebook_id>
```

## 언어

```bash
notebooklm language list
notebooklm language get
notebooklm language set ko
```

자주 쓰는 코드:

| 코드 | 언어 |
|---|---|
| `ko` | 한국어 |
| `en` | English |
| `ja` | 日本語 |
| `zh_Hans` | 中文（简体） |
| `zh_Hant` | 中文（繁體） |
| `es` | Español |
| `fr` | Français |
| `de` | Deutsch |
| `pt_BR` | Português (Brasil) |

## JSON 출력에서 ID 추출

```bash
notebooklm create "Research" --json
# {"id":"...","title":"Research"}

notebooklm source add ./report.pdf --json
# {"source_id":"...","title":"report.pdf","status":"processing"}

notebooklm generate audio "요약" --json
# {"task_id":"...","status":"pending"}
```

CLI 버전에 따라 생성 결과의 ID 필드 이름이 `task_id` 또는 artifact 관련 이름으로 나올 수 있으므로, 자동화에서는 전체 JSON을 저장해 두는 것이 안전합니다.
