# `/notebooklm` Skill Analysis

이 문서는 Claude Code의 `/notebooklm` 명령이 실제로 어떻게 작동하는지 분석한 내용입니다.

## 핵심 요약

`/notebooklm`은 독립 실행 프로그램이 아니라 Claude Code 스킬입니다. 사용자가 `/notebooklm ...`이라고 입력하면 Claude Code가 `SKILL.md`를 읽고, 그 안의 정책에 따라 로컬 `notebooklm` CLI를 실행합니다.

```text
사용자: /notebooklm 팟캐스트 만들어줘
        │
        ▼
Claude Code skill loader
        │
        ▼
~/.claude/skills/notebooklm/SKILL.md
        │
        ▼
notebooklm CLI 명령 실행
        │
        ▼
Google NotebookLM
```

## 스킬 파일의 역할

`SKILL.md`는 다음 정보를 Claude Code에 제공합니다.

1. 언제 이 스킬을 활성화할지
2. 어떤 CLI 명령을 사용할지
3. 어떤 작업은 자동으로 해도 되는지
4. 어떤 작업은 사용자 확인이 필요한지
5. 긴 작업을 어떻게 기다리고 다운로드할지
6. 결과물을 프로젝트에 어떻게 보관할지

즉, 스킬은 “명령어 설명서 + 운영 정책 + 자동화 플레이북”입니다.

## 활성화 조건

스킬은 보통 다음 상황에서 활성화됩니다.

- 사용자가 `/notebooklm`을 직접 입력
- “NotebookLM 사용해줘”라고 요청
- “이 자료로 팟캐스트 만들어줘”처럼 NotebookLM 산출물이 필요한 요청
- “퀴즈”, “플래시카드”, “마인드맵”, “오디오 개요”, “NotebookLM에 자료 추가” 같은 의도

## 내부 의존성

이 스킬 자체는 Google NotebookLM에 직접 접속하지 않습니다. 반드시 `notebooklm-py` 패키지가 제공하는 CLI가 필요합니다.

```bash
pip install notebooklm-py
notebooklm login
```

## 인증 흐름

1. 사용자가 `notebooklm login`을 실행합니다.
2. 브라우저가 열리고 Google 로그인 과정을 진행합니다.
3. CLI가 로컬 설정 디렉터리에 인증 상태를 저장합니다.
4. 이후 Claude Code는 저장된 인증 상태를 통해 `notebooklm` CLI 명령을 실행합니다.

기본 설정 디렉터리:

```text
~/.notebooklm
```

계정별 또는 에이전트별 분리는 `NOTEBOOKLM_HOME`으로 합니다.

```bash
export NOTEBOOKLM_HOME="$HOME/.notebooklm-work"
```

## 명령 카테고리

### 1. 읽기/상태 확인

안전하고 짧은 명령입니다.

```bash
notebooklm status
notebooklm list --json
notebooklm source list --json
notebooklm artifact list --json
notebooklm auth check
```

Claude Code가 자동 실행해도 되는 범주입니다.

### 2. 노트북과 소스 생성

새 노트북 생성이나 자료 추가는 일반적으로 되돌릴 수 있고 위험도가 낮습니다.

```bash
notebooklm create "Title" --json
notebooklm source add ./file.pdf --json
notebooklm source add "https://example.com" --json
```

### 3. 질의응답

자료를 바탕으로 질문합니다.

```bash
notebooklm ask "질문" --json
```

단, `--save-as-note`는 NotebookLM에 새 노트를 쓰는 작업이므로 확인을 받는 것이 안전합니다.

### 4. 생성 작업

오래 걸리고 실패 가능성이 있는 작업입니다.

```bash
notebooklm generate audio "instructions" --json
notebooklm generate video "instructions" --json
notebooklm generate report --format briefing-doc --json
notebooklm generate quiz --json
```

Claude Code는 생성 전에 사용자 확인을 받아야 합니다.

### 5. 다운로드

로컬 파일 시스템에 파일을 씁니다.

```bash
notebooklm download audio notebooklm/audio/output.mp3 -a <artifact_id> -n <notebook_id>
```

다운로드는 프로젝트 폴더의 `notebooklm/` 하위에 저장하는 것이 원칙입니다.

### 6. 삭제

삭제는 파괴적 작업이므로 반드시 확인이 필요합니다.

```bash
notebooklm notebook delete <notebook_id>
notebooklm source delete <source_id>
notebooklm artifact delete <artifact_id>
```

## 병렬 에이전트 안전성

`notebooklm use <id>`는 현재 노트북 컨텍스트를 파일에 저장합니다. 여러 에이전트가 동시에 쓰면 서로 덮어쓸 수 있습니다.

따라서 자동화에서는 아래처럼 명시적 notebook ID를 써야 합니다.

```bash
notebooklm ask "질문" --notebook <notebook_id>
notebooklm artifact wait <artifact_id> -n <notebook_id>
notebooklm download audio output.mp3 -a <artifact_id> -n <notebook_id>
```

## JSON 중심 자동화

CLI는 `--json` 출력으로 자동화에 필요한 ID를 제공합니다.

```json
{"id":"notebook-id","title":"Research"}
```

```json
{"source_id":"source-id","title":"file.pdf","status":"processing"}
```

```json
{"task_id":"artifact-or-task-id","status":"pending"}
```

Claude Code는 이 값을 파싱해 후속 명령에 전달합니다.

## 장기 작업 전략

생성 작업은 5~45분까지 걸릴 수 있습니다. 메인 대화에서 계속 기다리면 사용성이 떨어집니다.

권장 방식:

1. 생성 시작
2. artifact ID 기록
3. 백그라운드 에이전트 실행
4. 에이전트가 `artifact wait` 수행
5. 완료 후 다운로드
6. `notebooklm/README.md` 업데이트

## 왜 프로젝트별 아카이브가 필요한가

NotebookLM 결과물은 세션이 끊기면 어느 노트북에서 어떤 ID로 만들었는지 잃기 쉽습니다. 그래서 모든 워크플로우는 프로젝트 안에 `notebooklm/README.md`를 남깁니다.

기록 항목:

- notebook title
- notebook ID
- source IDs
- artifact IDs
- 다운로드 경로
- 생성 목적
- 남은 작업

## 주요 한계

- Google 내부 API 변화에 영향을 받을 수 있습니다.
- 오디오, 영상, 퀴즈, 플래시카드, 슬라이드는 rate limit이 발생할 수 있습니다.
- 인증 쿠키가 만료되면 `notebooklm login`이 필요합니다.
- 글로벌 언어 설정은 계정 전체에 영향을 줄 수 있습니다.

## 이 레포의 개선점

원본 스킬은 강력하지만 설치 초보자에게는 진입 장벽이 있습니다. 이 레포는 다음을 추가합니다.

- 비개발자용 설치 문서
- 설치/검증 스크립트
- 공개 배포 가능한 스킬 템플릿
- 명령 레퍼런스
- 장기 작업 예제
- GitHub README용 이미지와 구조화된 레포 구성
