# Configuration Guide

NotebookLM 자동화를 안정적으로 쓰기 위한 설정 가이드입니다.

## 기본 설정 위치

기본적으로 `notebooklm-py`는 사용자 홈 아래에 설정과 인증 상태를 저장합니다.

```text
~/.notebooklm
```

이 폴더는 개인 인증 정보를 포함할 수 있으므로 공유하거나 커밋하지 마세요.

## `NOTEBOOKLM_HOME`

설정 위치를 바꾸고 싶을 때 사용합니다.

```bash
export NOTEBOOKLM_HOME="$HOME/.notebooklm-work"
notebooklm login
```

사용 사례:

- 개인 계정과 회사 계정 분리
- 프로젝트별 NotebookLM 세션 분리
- 여러 Claude Code 에이전트가 동시에 작업할 때 충돌 방지

## `NOTEBOOKLM_AUTH_JSON`

인증 JSON을 환경 변수로 직접 넣는 방식입니다. CI/CD나 컨테이너에서 파일 쓰기를 피할 때 사용합니다.

```bash
export NOTEBOOKLM_AUTH_JSON='{"cookies":[...]}'
```

주의:

- 이 값은 비밀번호처럼 민감합니다.
- 터미널 기록, 로그, GitHub Actions 로그에 출력하지 마세요.
- 공개 레포의 `.env` 파일에 넣지 마세요.

## 언어 설정

현재 언어 확인:

```bash
notebooklm language get
```

한국어로 설정:

```bash
notebooklm language set ko
```

주의: 언어 설정은 계정 전체에 영향을 줄 수 있습니다. 특정 생성 명령에서만 언어를 지정하려면 `--language`를 사용하세요.

```bash
notebooklm generate audio "요약" --language ko
notebooklm generate report --format briefing-doc --language ko
```

## Claude Code 스킬 설치 위치

기본 설치 위치:

```text
~/.claude/skills/notebooklm/SKILL.md
```

다른 위치에 설치하려면:

```bash
CLAUDE_SKILLS_DIR="$HOME/.claude/skills/notebooklm-custom" ./scripts/install.sh
```

일반 사용자는 기본 위치를 권장합니다.

## 팀 환경 권장 설정

팀원이 각자 설치해야 합니다.

```bash
git clone https://github.com/YOUR-USERNAME/claude-code-notebooklm.git
cd claude-code-notebooklm
./scripts/install.sh
notebooklm login
```

팀 전체가 공유하면 안 되는 것:

- 인증 폴더
- `NOTEBOOKLM_AUTH_JSON`
- 개인 Google 계정 쿠키
- 비공개 NotebookLM 산출물

## 병렬 작업 권장 설정

여러 에이전트를 동시에 쓰는 경우:

```bash
export NOTEBOOKLM_HOME="/tmp/notebooklm-agent-1"
notebooklm login
```

또는 같은 인증을 쓰되 모든 명령에 notebook ID를 명시합니다.

```bash
notebooklm ask "질문" --notebook <notebook_id>
notebooklm source wait <source_id> -n <notebook_id>
notebooklm artifact wait <artifact_id> -n <notebook_id>
```
