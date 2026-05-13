# Publishing Checklist

GitHub에 공개하기 전 확인 목록입니다.

## 1. 레포 초기화

```bash
git init
git add README.md LICENSE .gitignore assets docs examples scripts skill
git commit -m "docs: add Claude Code NotebookLM automation package"
```

## 2. GitHub 원격 연결

```bash
git remote add origin git@github.com:YOUR-USERNAME/claude-code-notebooklm.git
git branch -M main
git push -u origin main
```

## 3. README 수정

`README.md`의 아래 부분을 실제 GitHub 사용자명으로 바꾸세요.

```text
https://github.com/YOUR-USERNAME/claude-code-notebooklm.git
```

## 4. 민감 정보 확인

```bash
grep -R "NOTEBOOKLM_AUTH_JSON\|storage_state\|SID\|HSID\|SSID\|APISID\|SAPISID" -n . --exclude-dir=.git
```

`docs`에 있는 보안 설명 외 실제 값이 나오면 삭제하고 다시 커밋하세요.

## 5. 설치 테스트

새 폴더에서 테스트합니다.

```bash
git clone git@github.com:YOUR-USERNAME/claude-code-notebooklm.git /tmp/claude-code-notebooklm-test
cd /tmp/claude-code-notebooklm-test
./scripts/install.sh
./scripts/verify.sh
```

## 6. 릴리스 추천

첫 공개 버전은 `v0.1.0`으로 태그하는 것을 권장합니다.

```bash
git tag v0.1.0
git push origin v0.1.0
```
