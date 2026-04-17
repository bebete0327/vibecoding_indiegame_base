# SETUP — 바이브코딩 Godot 템플릿 환경 구성

> **목적**: 이 파일은 **Claude Code가 처음 열리는 PC에서 이 템플릿을 분석했을 때** 어떤 도구를 설치해야 하는지 자동으로 안내할 수 있도록 작성되었습니다.
>
> **독자**: 사람 또는 Claude Code 에이전트.
>
> Claude Code가 이 문서를 읽은 경우, 아래 체크리스트를 순서대로 실행하면서 미설치 항목을 찾아 사용자에게 설치 방법을 제안하세요.

---

## 0. 빠른 체크 (Claude Code용)

다음 명령을 순서대로 실행해서 미설치 항목을 파악하세요:

```bash
# Git
git --version                                    # 없으면 → Section 1-C
# Node.js
node --version                                   # 없으면 → Section 1-B
# Claude Code
claude --version                                 # 없으면 → Section 1-D
# Godot (환경변수)
echo "$GODOT_PATH"                               # 빈 값이면 → Section 1-A + 2
# Godot (실제 실행)
"$GODOT_PATH" --version 2>&1 | head -n 1         # 오류면 → Section 1-A
# gstack 스킬
ls ~/.claude/skills/gstack/ 2>&1                 # 없으면 → Section 3-A
```

Windows PowerShell 에서 환경변수 확인:
```powershell
[System.Environment]::GetEnvironmentVariable('GODOT_PATH','User')
```

---

## 1. 필수 설치 (Core)

### 1-A. Godot 4.6.2 (Stable, Windows Win64)

1. 공식 다운로드: <https://godotengine.org/download/windows/>
   - 버전: **4.6.2 Stable** (Standard 또는 Mono 중 **Standard** 선택 — 이 템플릿은 C# 사용 안 함)
2. 임의 경로에 압축 해제 (권장: `C:\Users\<사용자명>\Desktop\` 또는 `C:\Tools\Godot\`)
3. 실행파일을 메모 (예: `C:\Users\NHN\Desktop\Godot_v4.6.2-stable_win64.exe`)
4. **`GODOT_PATH` 환경변수 설정** — Section 2 참조

### 1-B. Node.js 20+

- 다운로드: <https://nodejs.org/en/download> (LTS 권장)
- 설치 후 확인: `node --version` → `v20.x` 이상

(선택) **Bun** — 빠른 JS 런타임:
```powershell
powershell -Command "irm bun.sh/install.ps1 | iex"
```

### 1-C. Git

- 다운로드: <https://git-scm.com/download/win>
- 설치 시 "Git Bash" 옵션 활성화 (이 템플릿의 훅은 Bash 사용)
- 확인: `git --version`

### 1-D. Claude Code CLI

공식 방법: <https://docs.claude.com/claude-code>

```bash
npm install -g @anthropic-ai/claude-code
```

확인: `claude --version`

---

## 2. `GODOT_PATH` 환경변수 설정 (필수)

이 템플릿의 훅(`.claude/settings.json`)과 스크립트는 **하드코딩 경로 대신 `$GODOT_PATH` 를 사용**합니다. 설정 필수.

### Windows (PowerShell, 사용자 환경변수)
```powershell
[System.Environment]::SetEnvironmentVariable(
  'GODOT_PATH',
  'C:\Users\NHN\Desktop\Godot_v4.6.2-stable_win64.exe',
  'User'
)
```
경로는 실제 Godot 실행파일 위치로 교체하세요.

### 확인
```powershell
$v = [System.Environment]::GetEnvironmentVariable('GODOT_PATH','User')
Write-Host "Path: $v"
Write-Host "Exists: $(Test-Path $v)"
```

### 새 터미널 열기 필수
환경변수 설정 후 **기존 터미널/Claude Code 세션은 값을 못 읽습니다**. 새 창을 열거나 Claude Code를 재시작하세요.

---

## 3. 바이브코딩 DX 도구 (권장)

이 템플릿의 바이브코딩 루프(Brainstorm → Research → Plan → Implement → Test)를 온전히 활용하려면 아래 도구를 설치하세요.

### 3-A. gstack 스킬

`~/.claude/skills/gstack/` 아래에 설치. `/office-hours`, `/plan-ceo-review`, `/qa` 등 제공.

설치 방법(예시 — 공식 배포 경로에 따라 조정):
```bash
mkdir -p ~/.claude/skills
# gstack 레포를 clone 하거나 공식 배포본을 압축해제하여 아래 경로로:
#   ~/.claude/skills/gstack/
```

확인: `ls ~/.claude/skills/gstack/`

### 3-B. ECC (Everything Claude Code)

Claude Code 플러그인 생태계. `claude plugin` 명령으로 관리:
```bash
claude plugin list
claude plugin install <name>
```

`knowledge_base/Wiki/ecc-optimization-guide.md` 에 최적화 가이드 있음.

### 3-C. GDScript LSP

`claude-code-gdscript-lsp` — 코드 자동완성/타입체크.
- 공식 레포를 찾아 Windows 시스템 경로(예: `C:\Windows\System32\claude-code-gdscript-lsp\`) 에 설치
- Claude Code가 자동 감지

### 3-D. Godot MCP (선택)

MCP 서버로 Godot 에디터를 Claude Code와 연동:
- 참고: <https://gdaimcp.com>
- `claude mcp add ...` 로 등록

---

## 4. Godot 에드온 (템플릿에 사전 포함)

### 4-A. GUT (Godot Unit Test)

**이미 `addons/gut/` 에 포함되어 있습니다.** 별도 설치 불필요.

업데이트/재설치가 필요하면:
1. Godot 에디터 열기: `"$GODOT_PATH" --path .`
2. AssetLib 탭 → "GUT" 검색 → Install
3. Project Settings → Plugins → GUT 활성화

### 4-B. Jolt Physics

**Godot 4.6 에 기본 내장.** 별도 설치 불필요. `project.godot` 에 이미 설정됨:
```
[physics]
3d/physics_engine="Jolt Physics"
```

### 4-C. Git LFS (대용량 바이너리 추적)

템플릿의 `.gitattributes` 는 `.png/.wav/.ogg/.glb/.fbx` 등을 LFS 로 추적합니다. LFS 가 설치되어 있지 않으면 이 규칙은 무시되고 일반 Git 객체로 저장되므로 레포가 비대해집니다.

```bash
# 설치 (Git 설치 시 함께 설치되었다면 생략 가능)
git lfs install

# 확인
git lfs version
git lfs track    # 현재 추적 패턴 목록
```

LFS 가 필요 없는 소규모 프로젝트라면 `.gitattributes` 의 LFS 섹션을 주석 처리하거나 삭제하세요.

---

## 5. 첫 실행 검증 (설치 완료 체크)

세 가지 커맨드를 모두 통과해야 완성:

```bash
# ① 프로젝트 로드 검증 (오류/경고 없어야 함)
"$GODOT_PATH" --headless --path . -e --quit

# ② GUT 스모크 테스트 (2 passed 나와야 함)
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit

# ③ Main 씬 실행 (배너 출력 후 2초 뒤 정상 종료)
"$GODOT_PATH" --headless --path . --scene res://scenes/main.tscn --quit-after 2000
```

기대 출력 (③):
```
══════════════════════════════════════════
  Godot Vibe Template
  • 설치 가이드: docs/SETUP.md
  • 시작 가이드: docs/TEMPLATE_GUIDE.md
══════════════════════════════════════════
```

---

## 6. 트러블슈팅

| 증상 | 원인 / 조치 |
|------|------------|
| 훅이 실행 안 됨 | `$GODOT_PATH` 미설정 — Section 2. 또는 새 터미널 재시작 |
| `bash: command not found` | Git Bash 설치 안 됨 — Section 1-C |
| GUT 테스트 0건 | `addons/gut/` 누락. AssetLib 재설치 — Section 4-A |
| `res://scenes/main.tscn` not found | 파일 삭제됨. `git status` 확인 후 복원 |
| 훅이 느림 (>30초) | 대형 프로젝트 로드 시간. `.claude/settings.json` 의 `timeout` 증가 |
| Windows에서 한글 깨짐 | 터미널 인코딩을 UTF-8 로 변경 (`chcp 65001`) |

---

## 7. 이 템플릿을 새 게임 프로젝트로 복제하기

```bash
# 1) 새 폴더로 복사 (.git 제외)
cp -r /c/Users/NHN/Documents/godot-vibe-template /c/Users/NHN/Documents/my-new-game
cd /c/Users/NHN/Documents/my-new-game
rm -rf .git

# 2) 새 Git 저장소로 초기화
git init
git add .
git commit -m "Initial: bootstrap from godot-vibe-template"

# 3) Godot 에디터 열기
"$GODOT_PATH" --path .

# 4) docs/TEMPLATE_GUIDE.md 를 읽고 시작
```

---

## 요약 — 체크리스트

- [ ] Godot 4.6.2 Stable 설치
- [ ] `GODOT_PATH` 환경변수 설정 (사용자 레벨)
- [ ] Git 설치
- [ ] Node.js 설치
- [ ] Claude Code CLI 설치 + `claude --version` 확인
- [ ] (권장) gstack 스킬 `~/.claude/skills/gstack/`
- [ ] (권장) ECC 플러그인
- [ ] (권장) GDScript LSP
- [ ] Section 5의 세 커맨드 모두 성공

모두 체크되면 [`docs/TEMPLATE_GUIDE.md`](TEMPLATE_GUIDE.md) 로 이동하여 새 게임 시작.
