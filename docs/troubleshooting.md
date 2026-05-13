# Troubleshooting

## 설치 문제

### `notebooklm: command not found`

`notebooklm-py`가 설치되지 않았거나 PATH에 없습니다.

```bash
python3 -m pip install --upgrade notebooklm-py
python3 -m pip show notebooklm-py
```

설치 후에도 안 되면 새 Terminal을 열어 다시 시도하세요.

### `externally-managed-environment`

일부 Python 환경은 전역 설치를 막습니다. 가상환경을 사용하세요.

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip notebooklm-py
```

이 경우 Claude Code도 같은 Terminal 세션에서 실행해야 `notebooklm` 명령을 찾을 수 있습니다.

## 인증 문제

### 인증 만료

```bash
notebooklm auth check
notebooklm login
```

### 여러 계정 사용

계정별로 홈 디렉터리를 분리합니다.

```bash
export NOTEBOOKLM_HOME="$HOME/.notebooklm-personal"
notebooklm login

export NOTEBOOKLM_HOME="$HOME/.notebooklm-work"
notebooklm login
```

### CI나 원격 환경

`NOTEBOOKLM_AUTH_JSON`을 secret으로 설정할 수 있습니다. 이 값은 인증 쿠키와 동일하게 민감합니다. 로그에 출력하지 마세요.

## Claude Code 문제

### `/notebooklm` 스킬이 안 뜹니다

1. 설치 스크립트를 다시 실행합니다.

```bash
./scripts/install.sh
```

2. Claude Code를 재시작합니다.
3. 스킬 파일이 있는지 확인합니다.

```bash
ls ~/.claude/skills/notebooklm/SKILL.md
```

### Claude가 삭제나 다운로드 전에 멈춥니다

정상입니다. 스킬 정책상 삭제, 다운로드, 장기 생성 작업은 확인 후 실행하게 되어 있습니다.

## NotebookLM 작업 문제

### `No notebook context`

현재 노트북이 지정되지 않았습니다. 자동화에서는 명시적 ID를 쓰세요.

```bash
notebooklm list --json
notebooklm ask "질문" --notebook <notebook_id>
```

### 소스가 처리 중입니다

소스 색인이 끝나야 질문과 생성이 안정적으로 동작합니다.

```bash
notebooklm source list --json
notebooklm source wait <source_id> -n <notebook_id> --timeout 600
```

### 생성 실패 또는 rate limit

오디오, 영상, 퀴즈, 플래시카드, 인포그래픽, 슬라이드 생성은 Google rate limit에 걸릴 수 있습니다.

1. 아티팩트 상태 확인

```bash
notebooklm artifact list --json
```

2. 5~10분 후 재시도
3. 필요하면 NotebookLM 웹 UI에서 직접 확인

### 다운로드 실패

아티팩트가 아직 완료되지 않았을 수 있습니다.

```bash
notebooklm artifact wait <artifact_id> -n <notebook_id> --timeout 1200
notebooklm artifact list --json
```

## 안전 점검

GitHub에 올리기 전에 아래를 확인하세요.

```bash
git status --short
git diff -- . ':(exclude)assets/*.png'
```

절대 커밋하면 안 되는 것:

- `~/.notebooklm/`
- `.notebooklm/`
- `storage_state.json`
- `NOTEBOOKLM_AUTH_JSON` 값
- 사내 문서나 비공개 자료
- 민감한 노트북 ID와 artifact ID가 들어간 작업 로그
