<p align="center">
  <img src="assets/hero.png" alt="Claude Code controls NotebookLM" width="100%" />
</p>

# Claude Code × NotebookLM Automation

Claude Code에서 `/notebooklm` 명령으로 Google NotebookLM을 제어하기 위한 설치형 스킬 패키지입니다. 노트북 생성, 자료 추가, 요약 질의, 팟캐스트·영상·슬라이드·퀴즈·마인드맵·보고서 생성, 결과 다운로드까지 Claude Code 대화 안에서 실행할 수 있게 구성합니다.

이 레포는 [`notebooklm-py`](https://github.com/teng-lin/notebooklm-py) CLI를 기반으로 하며, 비개발자도 따라올 수 있도록 Google 로그인, Claude Code 스킬 설치, 기본 사용법, 문제 해결을 한곳에 정리했습니다.

## 무엇을 할 수 있나요?

| 기능 | 예시 |
|---|---|
| 노트북 관리 | 새 NotebookLM 노트북 생성, 목록 확인, 현재 작업 노트북 선택 |
| 자료 추가 | 웹 URL, YouTube, PDF, Markdown, Word, 오디오, 비디오, 이미지 추가 |
| 질의응답 | 자료 기반 질문, 인용 포함 JSON 답변, 대화 기록 저장 |
| 생성형 산출물 | 오디오 개요, 영상, 슬라이드, 보고서, 퀴즈, 플래시카드, 데이터 테이블, 마인드맵 |
| 다운로드 | MP3, MP4, PDF, PPTX, Markdown, CSV, JSON, HTML 등으로 저장 |
| 자동화 | 긴 생성 작업을 백그라운드 에이전트로 기다린 뒤 다운로드 |

## 빠른 시작

### 1. 준비물 확인

- Google 계정
- NotebookLM을 사용할 수 있는 브라우저 로그인 환경
- Claude Code
- Python 3.10 이상
- macOS, Linux, 또는 WSL 권장

터미널에서 확인합니다.

```bash
python3 --version
claude --version
```

### 2. 이 레포 받기

```bash
git clone https://github.com/VoidLight00/claude-code-notebooklm.git
cd claude-code-notebooklm
```

직접 압축 파일로 내려받아도 됩니다. 압축으로 받은 경우 폴더를 열고 아래 명령을 실행하세요.

### 3. 설치 스크립트 실행

```bash
./scripts/install.sh
```

설치 스크립트가 하는 일은 다음과 같습니다.

1. `notebooklm-py` CLI 설치 또는 업그레이드
2. Claude Code 스킬 폴더에 `/notebooklm` 스킬 설치
3. 설치 상태 점검
4. 다음에 실행할 로그인 명령 안내

### 4. Google NotebookLM 로그인

```bash
notebooklm login
```

브라우저가 열리면 Google 계정으로 로그인하고 권한 요청을 완료합니다. 로그인 후 아래 명령으로 인증을 확인합니다.

```bash
notebooklm status
notebooklm list
```

정상이라면 Claude Code에서 다음처럼 사용할 수 있습니다.

```text
/notebooklm 새 노트북 "AI 강의 준비" 만들고 이 URL들을 자료로 추가한 뒤 핵심 요약해줘
```

## Claude Code에서 쓰는 방식

Claude Code 대화창에 `/notebooklm`으로 시작해 요청하면 됩니다.

```text
/notebooklm NotebookLM 인증 상태 확인해줘
/notebooklm "AI Agent 강의" 노트북을 만들고 docs/lecture.pdf를 소스로 추가해줘
/notebooklm 현재 노트북 자료를 바탕으로 초보자용 스터디 가이드를 만들어줘
/notebooklm 추가된 자료로 한국어 팟캐스트 개요를 생성하고 완료되면 notebooklm/ 폴더에 저장해줘
```

Claude Code는 이 스킬 파일을 읽고 다음 원칙으로 행동합니다.

- 상태 확인, 노트북 생성, 자료 추가, 목록 확인, 일반 질문은 자동 실행
- 삭제, 장시간 생성, 다운로드, 노트 저장처럼 영향을 주거나 오래 걸리는 작업은 먼저 확인
- 여러 에이전트가 동시에 작업할 때는 `notebooklm use` 대신 명시적 notebook ID 사용
- 모든 다운로드 결과는 프로젝트 안의 `notebooklm/` 폴더에 정리

## CLI로 직접 쓰기

스킬 없이도 CLI를 직접 실행할 수 있습니다.

```bash
notebooklm create "Research: AI Agents"
notebooklm source add "https://example.com/article"
notebooklm source add ./docs/report.pdf
notebooklm source list
notebooklm ask "핵심 내용을 5개 bullet로 요약해줘"
notebooklm generate report --format briefing-doc --language ko
notebooklm artifact list
```

자세한 명령은 [docs/commands.md](docs/commands.md)를 보세요.

## 비개발자용 전체 설치 가이드

처음 설치하는 분은 [docs/setup-for-non-developers.md](docs/setup-for-non-developers.md)를 순서대로 따라 하세요.

문서에는 다음 내용이 포함되어 있습니다.

- Terminal 여는 법
- Python 설치 확인
- Claude Code 설치 확인
- NotebookLM Google 로그인
- `/notebooklm` 스킬 설치 확인
- 인증 오류 해결
- 안전하게 로그아웃하거나 계정을 바꾸는 방법

## 레포 구조

```text
.
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── assets/
│   ├── hero.png
│   └── hero-square.png
├── docs/
│   ├── architecture.md
│   ├── commands.md
│   ├── configuration.md
│   ├── publishing.md
│   ├── setup-for-non-developers.md
│   ├── skill-analysis.md
│   └── troubleshooting.md
├── examples/
│   ├── bulk-import.md
│   ├── podcast-workflow.md
│   └── research-report.md
├── scripts/
│   ├── install.sh
│   └── verify.sh
└── skill/
    └── SKILL.md
```

## 중요한 보안 메모

- Google 계정 쿠키와 인증 상태는 개인 기기에 저장됩니다.
- `~/.notebooklm/` 또는 `NOTEBOOKLM_AUTH_JSON` 내용을 GitHub에 올리지 마세요.
- 팀 환경에서는 계정별로 `NOTEBOOKLM_HOME`을 분리하세요.
- 공개 레포에는 노트북 ID, 민감한 자료 제목, 사내 URL, 다운로드 산출물을 올리지 않는 것을 권장합니다.

## 작동 원리

1. `notebooklm-py`가 NotebookLM 웹 세션을 인증합니다.
2. CLI가 NotebookLM RPC를 호출해 노트북, 소스, 아티팩트를 관리합니다.
3. Claude Code의 `/notebooklm` 스킬이 어떤 명령은 자동 실행하고 어떤 명령은 확인받을지 정책을 제공합니다.
4. 긴 작업은 Claude Code 서브에이전트가 `wait` 명령으로 기다렸다가 다운로드할 수 있습니다.
5. 다운로드 산출물은 프로젝트별 `notebooklm/` 폴더에 기록해 세션이 끊겨도 복구할 수 있게 합니다.

더 자세한 설명은 [docs/architecture.md](docs/architecture.md)를 참고하세요.

## 라이선스

이 레포의 문서와 스킬 템플릿은 MIT 라이선스로 배포합니다. NotebookLM과 Google은 Google LLC의 서비스이며, 이 레포는 Google 또는 Anthropic의 공식 제품이 아닙니다. `notebooklm-py`는 원저작자의 라이선스를 따릅니다.
