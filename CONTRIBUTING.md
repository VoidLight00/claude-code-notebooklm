# Contributing

기여를 환영합니다.

## 개발 원칙

- 인증 정보나 개인 NotebookLM 데이터를 커밋하지 않습니다.
- README는 비개발자도 따라 할 수 있게 유지합니다.
- 명령 예시는 가능한 한 복사해서 바로 실행할 수 있게 작성합니다.
- 장기 작업은 `artifact wait`, `source wait`, `research wait` 패턴을 명확히 설명합니다.
- Google, NotebookLM, Claude 관련 상표를 공식 제휴처럼 표현하지 않습니다.

## 문서 수정

문서를 수정한 뒤 아래를 확인하세요.

```bash
grep -R "NOTEBOOKLM_AUTH_JSON\|storage_state\|SID\|HSID\|SSID\|APISID\|SAPISID" -n . --exclude-dir=.git
```

설명 문맥이 아닌 실제 값이 있으면 제거하세요.

## 스크립트 수정

스크립트는 macOS/Linux shell에서 동작해야 합니다.

```bash
bash -n scripts/install.sh
bash -n scripts/verify.sh
```

## 릴리스

변경이 충분히 안정화되면 SemVer 태그를 사용합니다.

```bash
git tag v0.1.0
git push origin v0.1.0
```
