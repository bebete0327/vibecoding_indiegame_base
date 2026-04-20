# START HERE — 5 분 안에 첫 게임 환경 구축

> 이 템플릿을 처음 클론한 경우 읽는 파일. 5분이면 첫 커밋까지 갑니다.

---

## 0. 읽어야 할 문서 우선순위

헷갈리면 이 순서로:

| 순서 | 파일 | 언제 |
|------|------|------|
| **1** | **이 파일 (START_HERE.md)** | 지금 |
| **2** | [docs/SETUP.md](SETUP.md) | `$GODOT_PATH` 설정이 안 되어있다면 |
| **3** | [docs/TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md) | 2D vs 3D 결정하고 첫 씬 만들기 |
| **4** | [docs/WORKFLOW.md](WORKFLOW.md) | "어떤 플로우로 작업할까?" 고민될 때 |
| **5** | [CLAUDE.md](../CLAUDE.md) | 컨벤션 궁금할 때 (Claude 가 자동 읽음, 수동 필수 아님) |

**나머지는 참조용**. 필요할 때만 펼치세요.

---

## 1. 환경 설정 (1회)

이미 되어 있으면 스킵.

```bash
# Godot 4.6 경로를 환경변수로
# Windows PowerShell:
[System.Environment]::SetEnvironmentVariable('GODOT_PATH', 'C:\path\to\Godot.exe', 'User')

# macOS/Linux:
export GODOT_PATH="/path/to/godot"   # ~/.bashrc 또는 ~/.zshrc 에 추가
```

**새 터미널을 열어야** 반영됩니다.

### 1.1 graphify 설치 (선택, 토큰 절감용)

[graphify](https://github.com/safishamsi/graphify) 는 코드베이스를 질의 가능한 knowledge graph 로 변환해 Claude 가 파일 전체 대신 그래프를 조회하게 합니다. 프로젝트가 100+ 파일로 커지면 큰 토큰 절감 효과.

```bash
# 패키지 설치
pip install graphifyy

# Claude Code 통합 (프로젝트 루트에서 실행)
graphify claude install   # CLAUDE.md 에 섹션 추가 + PreToolUse 훅 등록
graphify hook install     # git post-commit 훅 (코드 변경 시 자동 재빌드)

# 초기 그래프 빌드 (Claude Code 세션에서)
/graphify .
```

**현재 템플릿 상태**: 총 ~28K 단어 (단일 컨텍스트에 적재 가능). 프로젝트가 이보다 커지면 초기 빌드 추천.

**주의**: `.gd` 파일은 tree-sitter GDScript 미지원으로 AST 추출 제외. markdown/JSON/문서만 그래프화.

---

## 2. 자가진단 실행

설정이 제대로 됐는지 한 번에 확인:

```bash
"$GODOT_PATH" --headless --path . --script res://scripts/dev_tools/health_check.gd
```

`RESULT: ✓ All checks passed` 가 나와야 합니다. 아니면 [SETUP.md](SETUP.md) 트러블슈팅.

---

## 3. 첫 실행

```bash
"$GODOT_PATH" --path .
```

Godot 에디터가 열립니다. 초록색 ▶ (또는 F5) 눌러 실행하면 "Welcome" 화면이 뜹니다.

**이때 확인할 것**:
- ✅ 화면 좌상단에 디버그 HUD (FPS, MEM, NODES) — **없으면 F3**
- ✅ `Esc` 누르면 일시정지 메뉴
- ✅ `F9` 누르면 스크린샷이 프로젝트 루트의 `screenshots/` 폴더에 저장 (에디터 실행 시)

---

## 4. 첫 변경 — 3분 튜토리얼

게임 로직을 추가하기 전 템플릿 구조를 익혀봅시다.

### 4.1. 환영 메시지 바꾸기

`scripts/main.gd` 열고 `_ready()` 의 print 문 수정:

```gdscript
print("My game name")
```

저장하면 Hook 이 자동 검증합니다. Godot 에디터 재실행 → 메시지 확인.

### 4.2. Claude 와 대화해보기

터미널에서 Claude Code 실행 중이라면:

```
/smoke-check
```

또는

```
/code-review scripts/main.gd
```

또는 그냥 자연어로:

> "scripts/autoload 에 있는 GameManager 의 역할을 3줄로 설명해줘"

### 4.3. 첫 커밋

```bash
git add scripts/main.gd
git commit -m "chore: customize welcome message"
```

---

## 5. 다음 단계 — 2가지 경로

### 경로 A: "바로 코딩하고 싶다"

→ [docs/TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md) §2 (2D) 또는 §3 (3D) 선택 → 5분 안에 첫 게임 씬 생성.

### 경로 B: "컨셉부터 체계적으로 만들고 싶다"

→ Claude 에게 `/brainstorm` 실행. 구조화된 질문으로 컨셉을 빌드업.
→ 이후 [docs/GDD_TEMPLATE.md](GDD_TEMPLATE.md) 복사해 `design/gdd/<system>.md` 작성.
→ [docs/WORKFLOW.md](WORKFLOW.md) 결정 트리로 다음 단계.

---

## 6. 뭘 해야 할지 막힐 때

**"지금 뭐 할까"** → [docs/WORKFLOW.md](WORKFLOW.md) 결정 트리

**"어떤 스킬 쓸까"** → [CLAUDE.md](../CLAUDE.md) "Skills" 섹션 표

**"에러 났어"** → [docs/SETUP.md](SETUP.md) §6 트러블슈팅

**"아키텍처 이해 못하겠어"** → [docs/ARCHITECTURE.md](ARCHITECTURE.md)

**"업그레이드 하고 싶어"** → [docs/UPGRADE.md](UPGRADE.md)

---

## 7. 핵심 단축키 치트시트

### Godot 에디터
| 키 | 동작 |
|----|------|
| F5 | 메인 씬 실행 |
| F6 | 현재 씬만 실행 |
| F8 | 현재 씬 실행 (개별) |
| Ctrl+S | 저장 |

### 실행 중 (템플릿 기본)
| 키 | 동작 |
|----|------|
| **F3** | 디버그 HUD 토글 (FPS/MEM/Nodes) |
| **F9** | 스크린샷 저장 |
| **Esc** | 일시정지 토글 |
| WASD / 화살표 | 이동 (Input map) |
| Space | 점프 |
| E | 상호작용 |
| 마우스 좌클릭 | 공격 |

### Claude Code 슬래시
| 명령어 | 용도 |
|--------|------|
| `/brainstorm` | 컨셉 아이데이션 |
| `/quick-design` | 경량 디자인 스펙 |
| `/code-review` | 커밋 전 코드 리뷰 |
| `/smoke-check` | 기본 런 체크 |
| `/balance-check` | 밸런스 수식 점검 |
| `/perf-profile` | 프레임/메모리 프로파일 |
| `/playtest-report` | 플레이테스트 노트 구조화 |
| `/tech-debt` | 기술 부채 카탈로그 |
| `/retrospective` | 마일스톤 회고 |

---

## 8. 자주 하는 실수

| 실수 | 해결 |
|------|------|
| `C#` 스크립트 생성 | ❌ 이 템플릿은 **GDScript only**. |
| `$GODOT_PATH` 미설정 상태로 훅 실행 | 새 터미널 열기. [SETUP.md](SETUP.md) §2. |
| 30분 이상 `/clear` 안 씀 | 컨텍스트 희석 — 작업 단위 끝나면 `/clear`. |
| `docs/PLAN.md` 없이 구현 시작 | 1일 이상 작업이면 반드시 PLAN.md 작성 + 승인. |
| GDD 를 모든 기능에 작성 | 1주 이상 기능만. 작은 건 `/quick-design` 으로. |
| 버그 수정을 3개 파일에 동시에 | CLAUDE.md 규칙 위반 — 한 번에 2개 이하 파일만 수정. |

---

## 9. 5 분 안에 여기까지 왔다면

✅ 템플릿 준비 완료.
🎯 이제 [TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md) 로 가서 **실제 게임을 만들기 시작**하세요.
