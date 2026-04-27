# SETUP — 환경 설정 (요약 + Claude Code 자동 검증)

> **인간 사용자**: 처음부터 모든 도구를 설치한다면 → **[`/INSTALL.md`](../INSTALL.md)** (전체 30~45분 가이드, 권장)
>
> **이 파일**: AI 에이전트 자동 검증용 + 환경변수 빠른 참조.

---

## 🤖 Claude Code 자동 검증 체크리스트

세션 시작 시 또는 환경 트러블슈팅 시 다음 명령들을 순서대로 실행해서 누락된 도구를 식별:

```bash
# 필수
git --version                                    # 없으면 → INSTALL.md 1️⃣
node --version                                   # 없으면 → INSTALL.md 3️⃣
claude --version                                 # 없으면 → INSTALL.md 4️⃣

# Godot 환경변수
echo "$GODOT_PATH"                               # 빈 값이면 → 아래 2번 섹션
"$GODOT_PATH" --version 2>&1 | head -n 1         # 실행 안 되면 → INSTALL.md 2️⃣

# 권장
python --version                                 # 없으면 → INSTALL.md 5️⃣
git lfs version                                  # 없으면 → INSTALL.md (1️⃣ 의 LFS 옵션)

# 선택
ls ~/.claude/skills/gstack/ 2>&1                 # 없으면 → 아래 3번 섹션
ls ./bin/spine_godot_extension.gdextension 2>&1  # 없으면 → docs/SPINE.md
```

Windows PowerShell 에서 환경변수 확인:
```powershell
[System.Environment]::GetEnvironmentVariable('GODOT_PATH','User')
```

---

## 2. `GODOT_PATH` 환경변수 설정 (필수)

이 템플릿의 훅(`.claude/settings.json`)과 스크립트는 **하드코딩 경로 대신 `$GODOT_PATH` 를 사용**합니다.

### Windows (PowerShell, 사용자 환경변수)

```powershell
[System.Environment]::SetEnvironmentVariable(
  'GODOT_PATH',
  'C:\Users\<사용자명>\Desktop\Godot_v4.6.2-stable_win64.exe',
  'User'
)
```

경로는 실제 Godot 실행파일 위치로 교체.

### macOS/Linux

```bash
echo 'export GODOT_PATH="/path/to/godot"' >> ~/.bashrc   # 또는 ~/.zshrc
source ~/.bashrc
```

### ⚠️ 새 터미널 열기 필수
설정 후 기존 터미널/Claude Code 세션은 값을 못 읽음. 새 창 열거나 재시작.

---

## 3. 선택 도구

### 3-A. gstack 스킬 (선택)

`~/.claude/skills/gstack/` 에 설치. `/office-hours`, `/plan-ceo-review`, `/careful`, `/learn` 제공.

```bash
mkdir -p ~/.claude/skills
# gstack 공식 배포본 압축해제 → ~/.claude/skills/gstack/
```

### 3-B. graphify (권장 — 토큰 절감용)

```bash
pip install graphifyy
graphify claude install
graphify hook install
```

자세한 사용: 프로젝트 루트의 `CLAUDE.md` § graphify 섹션.

### 3-C. Spine 2D 런타임 (2D 애니메이션 사용 시)

```bash
bash scripts/dev_tools/install_spine_runtime.sh
```

자세한 설정: [`docs/SPINE.md`](SPINE.md).

---

## 4. 검증 (모든 게 잘 됐는지)

자가진단 한 줄:

```bash
"$GODOT_PATH" --headless --path . --script res://scripts/dev_tools/health_check.gd
```

기대: `RESULT: ✓ All checks passed`

GUT 테스트:

```bash
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit
```

기대: `---- All tests passed! ----`

---

## 트러블슈팅

| 증상 | 조치 |
|------|------|
| `bash: command not found` | Git for Windows 의 Git Bash 컴포넌트 활성화 → INSTALL.md 1️⃣ |
| `$GODOT_PATH` 가 비어있음 | 위 §2 재실행, **새 터미널** |
| 훅이 30초 이상 멈춤 | 대형 프로젝트 로드 시간. `.claude/settings.json` 의 `timeout` 증가 |
| 한글 깨짐 (Windows) | `chcp 65001` 또는 Windows Terminal 사용 |
| 자세한 트러블슈팅 | [`/INSTALL.md`](../INSTALL.md) §🛠 트러블슈팅 |

---

## 이 파일이 INSTALL.md 와 다른 이유

- **INSTALL.md** (482줄): **사람이 처음 PC 셋업할 때** 단계별 안내. 다운로드 URL, 설치 옵션 클릭 위치 등 상세.
- **이 파일** (~80줄): **이미 셋업 됐는지 검증**하거나 **환경변수 재설정** 빠른 참조. AI 에이전트가 자동 점검 시 활용.

전체 가이드는 항상 **INSTALL.md** 가 권위 있는 단일 소스입니다. 새 도구가 추가될 때 INSTALL.md 만 업데이트하고 이 파일은 검증 명령만 1줄 추가.
