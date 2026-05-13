# 비개발자용 설치 가이드

이 문서는 Terminal을 거의 써 본 적 없는 분도 Claude Code에서 `/notebooklm`을 사용할 수 있게 안내합니다.

## 0. 전체 흐름

한 번만 설치하면 됩니다.

1. Terminal 열기
2. Python과 Claude Code가 있는지 확인
3. 이 레포 다운로드
4. 설치 스크립트 실행
5. Google 계정으로 NotebookLM 로그인
6. Claude Code에서 `/notebooklm` 실행

## 1. Terminal 열기

### macOS

1. `Command + Space`를 누릅니다.
2. `Terminal`을 입력합니다.
3. Enter를 누릅니다.

### Windows

WSL 또는 PowerShell을 사용할 수 있습니다. 개발 경험이 없다면 WSL을 권장합니다.

## 2. Python 확인

Terminal에 아래 명령을 복사해 붙여 넣고 Enter를 누릅니다.

```bash
python3 --version
```

`Python 3.10` 이상이 보이면 통과입니다.

안 보이면 Python을 설치해야 합니다.

- macOS: Homebrew가 있다면 `brew install python`
- Windows: Python 공식 설치 파일 또는 WSL의 `sudo apt install python3 python3-pip`

## 3. Claude Code 확인

```bash
claude --version
```

버전이 보이면 통과입니다. 안 보이면 Claude Code를 먼저 설치하고 로그인하세요.

## 4. 레포 다운로드

Git을 사용할 수 있다면:

```bash
git clone https://github.com/VoidLight00/claude-code-notebooklm.git
cd claude-code-notebooklm
```

Git이 어렵다면:

1. GitHub 페이지에서 `Code` 버튼을 누릅니다.
2. `Download ZIP`을 누릅니다.
3. 압축을 풉니다.
4. Terminal에서 압축을 푼 폴더로 이동합니다.

예시:

```bash
cd ~/Downloads/claude-code-notebooklm-main
```

## 5. 설치 실행

```bash
./scripts/install.sh
```

권한 오류가 나면 아래를 한 번 실행하고 다시 시도합니다.

```bash
chmod +x scripts/install.sh scripts/verify.sh
./scripts/install.sh
```

설치가 끝나면 `Installation complete` 메시지가 보입니다.

## 6. Google NotebookLM 로그인

```bash
notebooklm login
```

브라우저가 열립니다.

1. NotebookLM에 사용할 Google 계정을 선택합니다.
2. 로그인 과정을 마칩니다.
3. Terminal로 돌아옵니다.

인증 확인:

```bash
notebooklm status
notebooklm list
```

정상이라면 현재 로그인 계정과 노트북 목록이 보입니다.

## 7. Claude Code에서 사용하기

Claude Code를 열고 다음처럼 입력합니다.

```text
/notebooklm 인증 상태 확인해줘
```

첫 테스트가 통과하면 다음 요청을 해 볼 수 있습니다.

```text
/notebooklm "테스트 노트북"을 만들고 https://example.com 을 자료로 추가한 뒤 핵심 내용을 요약해줘
```

## 8. 한국어 산출물 설정

NotebookLM 생성 산출물을 한국어로 만들고 싶다면:

```bash
notebooklm language set ko
```

주의: 이 설정은 Google 계정 전체의 NotebookLM 생성 언어에 영향을 줄 수 있습니다.

명령별로만 한국어를 지정할 수도 있습니다.

```bash
notebooklm generate audio --language ko
notebooklm generate report --language ko
```

## 9. 계정을 바꾸고 싶을 때

가장 쉬운 방법은 별도 설정 폴더를 쓰는 것입니다.

```bash
export NOTEBOOKLM_HOME="$HOME/.notebooklm-work"
notebooklm login
```

개인 계정과 업무 계정을 분리할 때 유용합니다.

## 10. 설치 확인 도구

문제가 있는지 자동으로 점검하려면:

```bash
./scripts/verify.sh
```

결과가 실패하면 마지막 줄의 안내를 따르세요.

## 자주 하는 실수

### `notebooklm: command not found`

설치가 안 됐거나 Python 경로 문제입니다.

```bash
python3 -m pip install --upgrade notebooklm-py
```

### 인증 오류가 납니다

Google 로그인 세션이 만료됐을 수 있습니다.

```bash
notebooklm auth check
notebooklm login
```

### Claude Code에서 `/notebooklm`을 모릅니다

스킬 파일이 설치되지 않았을 수 있습니다.

```bash
./scripts/install.sh
```

그래도 안 되면 Claude Code를 재시작하세요.

### 생성이 실패합니다

NotebookLM의 오디오, 영상, 퀴즈, 플래시카드 생성은 Google 쪽 rate limit에 걸릴 수 있습니다. 5~10분 후 다시 시도하거나 NotebookLM 웹 UI에서 확인하세요.
