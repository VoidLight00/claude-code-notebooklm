# Architecture

이 레포는 Claude Code 스킬과 `notebooklm-py` CLI를 연결하는 얇은 자동화 패키지입니다.

## 구성 요소

```text
Claude Code user prompt
        │
        ▼
/notebooklm skill/SKILL.md
        │  정책: 자동 실행 / 확인 필요 / 산출물 보관
        ▼
notebooklm CLI from notebooklm-py
        │  인증: browser storage state / Google session
        ▼
Google NotebookLM web RPC
        │
        ▼
Notebook, Sources, Conversations, Artifacts
```

## 책임 분리

| 레이어 | 책임 |
|---|---|
| Claude Code | 사용자 의도 해석, 안전 확인, 장기 작업 위임, 파일 정리 |
| Skill | 어떤 명령을 어떻게 실행할지에 대한 운영 정책 |
| notebooklm CLI | NotebookLM API 호출, 인증, JSON 출력, 다운로드 |
| NotebookLM | 자료 색인, 질의응답, 오디오·영상·보고서 등 생성 |

## 인증 방식

`notebooklm login`은 브라우저를 열어 Google 로그인 세션을 만든 뒤 로컬에 인증 상태를 저장합니다. 기본 위치는 `~/.notebooklm`입니다.

중요한 파일은 절대 GitHub에 올리면 안 됩니다.

- `~/.notebooklm/`
- `storage_state.json`
- `NOTEBOOKLM_AUTH_JSON`

## 컨텍스트와 병렬 작업

CLI는 기본적으로 현재 노트북 컨텍스트를 저장할 수 있습니다.

```bash
notebooklm use <notebook_id>
```

하지만 여러 Claude Code 에이전트가 동시에 작업하면 같은 컨텍스트 파일을 덮어쓸 수 있습니다. 자동화에서는 다음을 권장합니다.

```bash
notebooklm ask "질문" --notebook <notebook_id>
notebooklm artifact wait <artifact_id> -n <notebook_id>
notebooklm download audio output.mp3 -a <artifact_id> -n <notebook_id>
```

## 장기 작업 처리

오디오, 영상, 퀴즈, 슬라이드 생성은 오래 걸릴 수 있습니다.

권장 패턴:

1. 생성 명령은 `--json`으로 실행합니다.
2. 반환된 artifact ID를 기록합니다.
3. Claude Code 백그라운드 에이전트가 `artifact wait`을 실행합니다.
4. 완료되면 `download` 명령으로 프로젝트의 `notebooklm/` 폴더에 저장합니다.
5. `notebooklm/README.md`에 노트북 ID, artifact ID, 파일 경로를 기록합니다.

## 프로젝트 아카이브 규칙

작업 프로젝트 안에 다음 구조를 만듭니다.

```text
notebooklm/
├── README.md
├── audio/
├── video/
├── reports/
├── slides/
├── quizzes/
├── flashcards/
├── mind-maps/
├── tables/
└── chat/
```

이 규칙은 세션이 끊겨도 어떤 노트북에서 어떤 산출물을 만들었는지 추적하기 위한 것입니다.

## 실패 모델

| 실패 | 원인 | 복구 |
|---|---|---|
| 인증 실패 | Google 세션 만료 | `notebooklm auth check`, `notebooklm login` |
| No notebook context | 현재 노트북 미지정 | `--notebook` 또는 `-n` 사용 |
| Generation failed | Google rate limit | 5~10분 후 재시도 |
| Download failed | artifact 미완료 | `artifact list`, `artifact wait` |
| RPC error | NotebookLM 내부 변경 | `notebooklm-py` 업그레이드 |

## 공개 배포 시 주의

이 레포에는 인증 정보가 포함되지 않습니다. 사용자의 Google 로그인은 각자 로컬에서 수행합니다. README의 이미지도 브랜드 로고나 실제 서비스 UI를 복제하지 않는 추상화된 개발 도구 일러스트로 구성했습니다.
