# INSTALL — 제로부터 설치 가이드

> **대상**: Python, Node.js, Git 등 아무것도 설치되지 않은 새 PC 에서
> 이 바이브코딩 인디게임 템플릿을 **완전히 동작하는 상태**까지 세팅.
>
> **소요 시간**: 30~45 분 (다운로드 시간 제외 실작업 15분)
>
> **대상 OS**: Windows 10/11 (주), macOS / Linux 요약 하단 별도 섹션.

---

## 📋 필수 프로그램 목록 (체크리스트)

클론 전에 설치해야 할 것들. 전부 **무료**.

| # | 프로그램 | 용도 | 크기 | 필수도 |
|---|---------|------|------|--------|
| 1 | **Git for Windows** (Git Bash 포함) | 레포 클론 + 훅 실행 | ~80 MB | 🔴 필수 |
| 2 | **Godot 4.6.2 Stable** (Standard) | 게임 엔진 | ~90 MB | 🔴 필수 |
| 3 | **Node.js 20+ LTS** | Claude Code CLI 실행 | ~35 MB | 🔴 필수 |
| 4 | **Claude Code CLI** | 바이브코딩 메인 도구 | ~100 MB | 🔴 필수 |
| 5 | **Python 3.10+** | graphify 실행 | ~30 MB | 🟡 권장 |
| 6 | **Git LFS** | 대용량 에셋 (Git 과 함께 설치 가능) | ~10 MB | 🟡 권장 |
| 7 | **GitHub Desktop** | Git 인증 자동 처리 (PAT 입력 회피) | ~150 MB | 🟢 선택 |
| 8 | **VS Code** | 텍스트 에디터 (또는 다른 IDE) | ~100 MB | 🟢 선택 |
| 9 | **Spine 2D Runtime** (GDExtension) | 2D 스켈레탈 애니메이션 | ~43 MB (S3 자동 다운로드) | 🟡 권장 (2D 게임 시) |

**최소 설치**: 1,2,3,4 — 이것만 있으면 기본 게임 개발 가능.
**권장 설치**: +5,6 — graphify 토큰 절감 + LFS 대용량 에셋 지원.
**전체 설치**: +7,8 — 최고 편의성.

---

## 🪟 Windows 11 기준 순서별 설치 가이드

### 0️⃣ 사전 준비

**PowerShell 관리자 권한으로 실행**하는 법 (가끔 필요):
- Windows 키 → `powershell` 입력 → **관리자 권한으로 실행** 클릭

**터미널 권장**: Windows Terminal (Microsoft Store 에서 무료) — 기본 PowerShell 보다 편리.

---

### 1️⃣ Git for Windows (필수, Git Bash 포함)

#### 다운로드
👉 https://git-scm.com/download/win

- `64-bit Git for Windows Setup` 클릭 (최신 버전 선택)

#### 설치 단계
1. 설치 파일 실행 → `Next` 계속
2. **중요 옵션** (이 화면에서만 주의):
   - ✅ **"Git Bash Here"** 체크 — 이 템플릿 훅이 bash 사용
   - ✅ **"Git LFS (Large File Support)"** 체크 — 대용량 바이너리 추적
   - ✅ **"Use Git from the command line and also from 3rd-party software"** 선택
   - ✅ **"Checkout as-is, commit as-is"** 또는 기본값 유지
3. 나머지 `Next` 로 진행
4. 설치 완료 후 **PowerShell 재시작**

#### 확인
```powershell
git --version
# git version 2.43.x 같은 출력 나오면 OK

git lfs version
# git-lfs/3.x.x 같은 출력 나오면 OK
```

---

### 2️⃣ Godot 4.6.2 Stable (필수)

#### 다운로드
👉 https://godotengine.org/download/windows/

- **버전**: `4.6.2 Stable`
- **옵션**: **Standard** 선택 (C# 버전 X, 이 템플릿은 GDScript only)
- 파일명 예: `Godot_v4.6.2-stable_win64.exe.zip`

#### 설치 단계
1. 다운로드한 zip 을 원하는 위치에 압축 해제 (권장: `C:\Users\<사용자명>\Desktop\` 또는 `C:\Tools\Godot\`)
2. 실행파일 경로를 메모장에 기록. 예:
   ```
   C:\Users\홍길동\Desktop\Godot_v4.6.2-stable_win64.exe
   ```

#### ⚙️ 환경변수 `GODOT_PATH` 설정 (매우 중요)

이 템플릿의 훅과 스크립트는 하드코딩 경로 대신 `$GODOT_PATH` 환경변수를 사용합니다.

**PowerShell** 에서 (경로는 실제 위치로 교체):
```powershell
[System.Environment]::SetEnvironmentVariable(
  'GODOT_PATH',
  'C:\Users\홍길동\Desktop\Godot_v4.6.2-stable_win64.exe',
  'User'
)
```

**⚠️ 환경변수 설정 후 새 터미널을 열어야 반영됩니다.**

#### 확인 (새 터미널 에서)
```powershell
# 환경변수 확인
[System.Environment]::GetEnvironmentVariable('GODOT_PATH','User')

# 실제 실행 테스트
& "$env:GODOT_PATH" --version
# 4.6.2.stable.official 같은 출력 나오면 OK
```

---

### 3️⃣ Node.js 20+ LTS (필수 — Claude Code CLI 용)

#### 다운로드
👉 https://nodejs.org/en/download

- **LTS (권장)** 버전 다운로드 (20.x 또는 22.x)
- Windows Installer (.msi) 선택

#### 설치 단계
1. 설치 파일 실행 → 기본값 유지하며 `Next`
2. ✅ **"Automatically install the necessary tools"** 체크 (Python 빌드 도구 자동 설치)
3. 완료 후 **PowerShell 재시작**

#### 확인
```powershell
node --version   # v20.x 또는 v22.x
npm --version    # 10.x 이상
```

---

### 4️⃣ Claude Code CLI (필수)

#### 설치
```powershell
npm install -g @anthropic-ai/claude-code
```

설치 후 Claude 계정 로그인 (최초 1회):
```powershell
claude
```
- 브라우저가 열려 Anthropic 계정 로그인 유도 → 로그인 후 터미널로 돌아옴
- 계정 없으면 https://claude.ai 에서 먼저 가입

#### 확인
```powershell
claude --version
# 버전 번호 출력되면 OK
```

---

### 5️⃣ Python 3.10+ (권장 — graphify 용)

#### 다운로드
👉 https://www.python.org/downloads/windows/

- **최신 3.12.x** 또는 3.11.x 선택 (3.10 이상이면 됨)
- Windows installer (64-bit) 선택

또는 Microsoft Store 에서 "Python 3.12" 검색해서 설치 (더 간편).

#### 설치 단계 (Python.org 설치 파일 경우)
1. 설치 파일 실행
2. **⚠️ 중요**: 첫 화면에서 **✅ "Add Python to PATH"** 반드시 체크
3. `Install Now` 클릭
4. 완료 후 PowerShell 재시작

#### 확인
```powershell
python --version   # Python 3.12.x
pip --version      # pip 25.x 같은 출력
```

#### graphify 설치 (템플릿 클론 전 해도 무관)
```powershell
pip install graphifyy
```

---

### 6️⃣ (선택) GitHub Desktop — Git 인증 자동화

PAT(Personal Access Token) 입력 과정을 없애줍니다.

#### 다운로드
👉 https://desktop.github.com/

설치 후:
1. 실행 → **Sign in to GitHub.com** 클릭
2. 브라우저에서 계정 인증
3. 완료되면 이후 커맨드라인 `git push` 도 자동 인증됨 (credential manager 연동)

---

### 7️⃣ (선택) VS Code — 에디터

#### 다운로드
👉 https://code.visualstudio.com/

설치 후 권장 확장:
- **godot-tools** — GDScript 구문 하이라이트
- **Even Better TOML** — `.tres` 파일 편집 지원

---

## 🚀 템플릿 레포 설치

필수 프로그램이 모두 설치되면 템플릿을 클론합니다.

### 1. 원하는 위치로 이동 후 클론

```powershell
# 권장 위치: C:\Users\<사용자명>\Documents
cd $HOME\Documents

# 레포 클론
git clone https://github.com/bebete0327/vibecoding_indiegame_base.git

# 폴더 진입
cd vibecoding_indiegame_base
```

### 2. Git LFS 활성화 (대용량 에셋 사용 시)

```powershell
git lfs install
git lfs pull   # 기존 LFS 추적 파일 받기
```

### 3. graphify Claude Code 통합 (권장)

```powershell
# 프로젝트 루트에서 실행
graphify claude install      # CLAUDE.md 에 섹션 추가 + PreToolUse 훅
graphify hook install        # git post-commit 훅 (자동 재빌드)
```

### 3.5 Spine 2D 런타임 설치 (2D 게임 제작 시 권장)

Git Bash 에서:
```bash
bash scripts/dev_tools/install_spine_runtime.sh
```

- S3 공식에서 ~14MB 자동 다운로드 → `bin/` 에 압축 해제 (43MB)
- Spine 4.2.x 호환 · Godot 4.6.1-stable 빌드 (4.6.x 전체 ABI 호환)
- **⚠️ 라이선스 주의**: 런타임은 평가용 무료, **게임 배포 시 Spine 에디터 라이선스 ($69~) 필수**
- 자세한 사용법: [`docs/SPINE.md`](docs/SPINE.md)

### 4. 자가진단 실행 (모든 것이 정상인지 확인)

Git Bash 에서 (PowerShell 아님!):
```bash
"$GODOT_PATH" --headless --path . --script res://scripts/dev_tools/health_check.gd
```

기대 출력:
```
══════════════════════════════════════════
  Godot Vibe Template — Health Check
══════════════════════════════════════════
  ✓ Godot 4.6 (required ≥ 4.6)
  ✓ Input map — all 8 actions present
  ✓ Screenshot dir writable: ...
══════════════════════════════════════════
  RESULT: ✓ All checks passed
══════════════════════════════════════════
```

⚠️ `✗` 가 나오면 [트러블슈팅](#-트러블슈팅) 참조.

### 5. Godot 에디터 실행

Git Bash:
```bash
"$GODOT_PATH" --path .
```

또는 탐색기에서 `project.godot` 더블클릭. 에디터가 열리면 `F5` 눌러 실행 → **Welcome** 화면 + 좌상단 디버그 HUD (FPS/MEM/Nodes) 확인.

### 6. Claude Code 세션 시작

템플릿 루트에서:
```powershell
claude
```

자연어로 요구사항 말하기. 예:
- "이런 게임 만들고 싶어: 2D 플랫포머 로그라이크" → AI 가 자동으로 `/brainstorm` 호출
- "Player 스크립트 만들어줘" → AI 가 `Task(godot-gdscript-specialist)` 로 위임

슬래시 명령 외울 필요 없음. [CLAUDE.md](CLAUDE.md) "Autonomous Tool Usage" 섹션 참조.

---

## 🔍 전체 설치 상태 체크리스트

설치 완료 후 각 항목이 ✅ 인지 확인:

```powershell
git --version                                             # Git
git lfs version                                           # Git LFS
node --version                                            # Node.js
npm --version                                             # npm
claude --version                                          # Claude Code CLI
python --version                                          # Python
pip show graphifyy                                        # graphify (name: graphifyy)
[System.Environment]::GetEnvironmentVariable('GODOT_PATH','User')  # GODOT_PATH
& "$env:GODOT_PATH" --version                             # Godot 실제 실행
```

---

## 🍎 macOS 요약

```bash
# 1. Homebrew 설치 (없으면)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 필수 프로그램 설치
brew install git git-lfs node python@3.12

# 3. Godot 다운로드 (수동)
# → https://godotengine.org/download/macos/ → Godot_v4.6.2-stable_macos.universal.zip
# → /Applications/Godot.app 로 설치
# → GODOT_PATH 환경변수 설정 (~/.zshrc):
echo 'export GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"' >> ~/.zshrc
source ~/.zshrc

# 4. Claude Code + graphify
npm install -g @anthropic-ai/claude-code
pip3 install graphifyy

# 5. 클론 + 셋업
git clone https://github.com/bebete0327/vibecoding_indiegame_base.git
cd vibecoding_indiegame_base
graphify claude install && graphify hook install
```

---

## 🐧 Linux (Ubuntu/Debian) 요약

```bash
# 1. 필수 프로그램
sudo apt update
sudo apt install -y git git-lfs nodejs npm python3 python3-pip

# 2. Godot 다운로드 (수동)
# → https://godotengine.org/download/linux/
# → 압축 해제 후 ~/bin/godot 로 심볼릭 링크
# → GODOT_PATH 환경변수 설정 (~/.bashrc):
echo 'export GODOT_PATH="$HOME/bin/godot"' >> ~/.bashrc
source ~/.bashrc

# 3. Claude Code + graphify
sudo npm install -g @anthropic-ai/claude-code
pip3 install graphifyy --user

# 4. 클론 + 셋업
git clone https://github.com/bebete0327/vibecoding_indiegame_base.git
cd vibecoding_indiegame_base
graphify claude install && graphify hook install
```

---

## 🛠 트러블슈팅

### ❌ `git: command not found`
Git 설치 누락. 1️⃣ 단계 재확인. PowerShell 재시작 필요.

### ❌ `$GODOT_PATH` 가 비어있음
```powershell
# 설정 재확인
[System.Environment]::GetEnvironmentVariable('GODOT_PATH','User')
```
비어있으면 2️⃣ 단계의 환경변수 설정 재실행. **새 터미널 열기** 필수.

### ❌ `bash: command not found`
Git Bash 가 설치 안 됨. Git 재설치 시 "Git Bash Here" 옵션 체크 확인.

### ❌ `npm install -g` 에서 권한 오류
```powershell
# PowerShell 을 관리자 권한으로 재실행 후 다시 시도
```
또는 Node.js 설치 시 "Automatically install tools" 옵션 체크했는지 확인.

### ❌ `graphify: command not found` (설치됐는데)
Python Scripts 경로가 PATH 에 없음. Git Bash 에서:
```bash
# Python 경로 확인
python -c "import sys; print(sys.prefix + '/Scripts')"

# 출력된 경로를 ~/.bashrc 에 추가 (경로는 실제 값으로 교체):
echo 'export PATH="/c/Users/홍길동/AppData/Local/Packages/PythonSoftwareFoundation.Python.3.12_qbz5n2kfra8p0/LocalCache/local-packages/Python312/Scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### ❌ Godot 실행 시 `failed to load project.godot`
프로젝트 루트가 아닌 곳에서 실행 중. `cd` 로 레포 루트 이동 후 재실행.

### ❌ 한글 깨짐 (터미널)
Windows PowerShell 기본 인코딩 문제. **Windows Terminal** (UTF-8 기본 지원) 사용 권장. 또는:
```powershell
chcp 65001   # UTF-8 로 변경
```

### ❌ Claude Code 에서 "permission required" 프롬프트 자주 뜸
이 템플릿의 `.claude/settings.json` 이 이미 광범위 allow 리스트를 가지고 있음. 만약 뜨면:
1. 일단 승인 클릭
2. 반복되면 `.claude/settings.json` 의 `permissions.allow` 에 해당 패턴 추가

### ❌ `post-commit` 훅이 실행 안 됨 (graphify 재빌드)
```bash
cd <repo-root>
graphify hook status   # "installed" 인지 확인
```
"not installed" 이면:
```bash
graphify hook install
```

### ❌ 무언가 이상하게 꼬임 / 초기화하고 싶음
```bash
cd <repo-root>
git reset --hard origin/main    # ⚠️ 로컬 변경 전부 삭제
git clean -fd                    # 추적 안 되는 파일 삭제
```

---

## 📚 다음 단계

설치 완료 후:

1. **[`docs/START_HERE.md`](docs/START_HERE.md)** — 5분 안에 템플릿 구조 익히기
2. **[`docs/TEMPLATE_GUIDE.md`](docs/TEMPLATE_GUIDE.md)** — 첫 게임 만들기 (2D 또는 3D 선택)
3. **[`docs/WORKFLOW.md`](docs/WORKFLOW.md)** — 변경 크기별 워크플로 결정 트리
4. **[`CLAUDE.md`](CLAUDE.md)** — 컨벤션 + 자율 툴 사용 지침 (Claude 가 자동 읽음)

**막혔을 때**: Claude 에게 자연어로 물어보세요. 슬래시 명령 외울 필요 없음.

---

## 📏 예상 저장 용량

| 구성 요소 | 용량 |
|---------|------|
| 각 프로그램 (Git/Node/Python/Godot 등) | ~500 MB |
| 클론된 템플릿 (초기) | ~10 MB |
| Godot 임포트 캐시 (`.godot/`) | ~30 MB (첫 실행 시 자동 생성) |
| Claude Code 유저 설정 (`~/.claude/`) | ~50 MB |
| graphify (pip 의존성 포함) | ~200 MB |
| **총 필요 디스크** | **~800 MB ~ 1.2 GB** |

---

## ⚠️ 주의사항

- **환경변수 수정 후 새 터미널 열기**: 기존 창은 이전 값만 알고 있음
- **PowerShell vs Git Bash 구분**: 훅 명령어는 Git Bash 필요, 일반 명령은 PowerShell 가능
- **C# 스크립트 만들지 말기**: 이 템플릿은 GDScript only. C# 파일은 훅 검증 안 됨
- **`.godot/` 폴더 건들지 말기**: Godot 자동 생성/관리

---

## 🆘 지원

문제가 지속되면:
- **GitHub Issues**: https://github.com/bebete0327/vibecoding_indiegame_base/issues
- **Claude 에게 자연어로 문의** — 이 문서를 참조하며 도와줍니다

---

**Happy vibe-coding! 🎮**
