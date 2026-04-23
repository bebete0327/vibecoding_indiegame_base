# CLAUDE.md - Vibe Coding Indie Game Template Constitution

> **Quick Start**: 먼저 [`docs/SETUP.md`](docs/SETUP.md) 를 읽고 필수 도구를 설치하세요.
> 새 게임을 시작한다면 [`docs/TEMPLATE_GUIDE.md`](docs/TEMPLATE_GUIDE.md) 가 출발점입니다.

## Project Overview
- **Engine**: Godot 4.6.2 (GDScript only, NO C#)
- **Godot Path**: `$GODOT_PATH` 환경변수 사용 (`docs/SETUP.md` 참조)
- **Renderer**: Mobile
- **Physics**: Jolt Physics
- **Genre**: TBD (범용 템플릿 — 2D/3D 모두 지원)
- **Test Framework**: GUT (Godot Unit Test) — `addons/gut/` 에 사전 포함

## Critical Rules (절대 규칙)

### NEVER DO
- C# 스크립트 생성 금지 - GDScript ONLY
- 기존 씬 구조를 사전 승인 없이 변경 금지
- `project.godot` 직접 수정 금지 (설정 변경은 에디터에서)
- `.godot/` 폴더 내부 수정 금지
- 플레이스홀더/더미 코드 커밋 금지
- 한 번에 3개 이상의 파일을 동시 수정 금지 (변경 추적 용이)
- 구현 중 `/compact` 사용 금지 (변수/경로 유실 위험)

### ALWAYS DO
- 코딩 전 반드시 `docs/RESEARCH.md`에 분석 결과 기록
- 구현 전 반드시 `docs/PLAN.md`에 계획 작성 후 **사용자 승인** 대기
- 새 스크립트 생성 시 `scripts/` 폴더에 배치
- 새 씬 생성 시 `scenes/` 폴더에 배치
- 모든 GDScript에 `class_name` 선언 (**예외**: Autoload 스크립트 — Autoload 이름과 전역 클래스 이름 충돌 방지)
- 시그널 사용 시 타입 힌팅 포함
- 새 기능 구현 시 GUT 테스트도 함께 작성 (`tests/` 폴더)
- 커밋 전 headless 검증 실행
- 위키에 유용한 해결 사례 기록

## Vibe Coding Workflow (바이브코딩 무한 루프)

> **변경 크기에 따라 다른 플로우**: [docs/WORKFLOW.md](docs/WORKFLOW.md) 결정 트리 먼저 확인. 아래는 기본 (1일~1주 기능) 플로우.

### Phase 1: Brainstorm (브레인스토밍)
```
사용자: "이런 게임을 만들고 싶어" → AI가 시스템 구조 제안
gstack: /office-hours 또는 /plan-ceo-review 활용
```

### Phase 2: Research (리서치)
```
관련 코드/씬 분석 → docs/RESEARCH.md에 기록
knowledge_base/Wiki/ 기존 사례 참고
```

### Phase 3: Plan (SDD - Spec-Driven Development)
```
docs/PLAN.md에 구현 계획 작성 → 사용자 승인 대기
Phase별로 세분화, 각 Phase에 검증 기준 포함
```

### Phase 4: Implement (구현)
```
승인된 PLAN.md Phase 단위로 실행
코드 작성 → Hook이 자동 검증 → 에러 시 즉시 수정
```

### Phase 5: Test (테스트)
```
GUT 테스트 작성 → headless 실행 → 스크린샷 캡처
사용자가 Godot 에디터에서 비주얼 확인
```

### Phase 6: Commit (기록)
```
git commit → knowledge_base에 성공/실패 사례 기록
/clear → 다음 기능으로 이동
```

## GDScript Conventions

### Naming
- **클래스**: PascalCase (`PlayerController`)
- **함수/변수**: snake_case (`move_speed`, `_on_body_entered`)
- **상수**: SCREAMING_SNAKE (`MAX_HEALTH`)
- **시그널**: past_tense (`health_changed`, `player_died`)
- **private**: underscore prefix (`_internal_state`)

### Structure Order (파일 내 순서)
```gdscript
class_name ClassName
extends BaseClass

# Signals
signal example_signal

# Enums
enum State { IDLE, RUNNING, JUMPING }

# Constants
const MAX_SPEED := 300.0

# Exports
@export var speed: float = 200.0

# Public variables
var health: int = 100

# Private variables
var _internal_timer: float = 0.0

# Onready
@onready var sprite: Sprite2D = $Sprite2D

# Built-in virtual methods
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    pass

# Public methods
func take_damage(amount: int) -> void:
    pass

# Private methods
func _update_ui() -> void:
    pass
```

### Type Hinting (필수)
```gdscript
var speed: float = 200.0
var player_name: String = ""
func calculate_damage(base: int, multiplier: float) -> int:
    return int(base * multiplier)
signal health_changed(new_health: int)
```

## File Structure
```
scenes/              → .tscn 씬 파일
scripts/             → .gd 스크립트 파일
scripts/utils/       → 유틸리티 (ScreenshotCapture, ProjectPaths 등)
scripts/autoload/    → Autoload 싱글톤
scripts/components/  → 재사용 컴포넌트
scripts/states/      → State Machine
scripts/resources/   → Resource 데이터 클래스
scripts/dev_tools/   → 개발 도구 (health_check, install_spine_runtime 등)
assets/sprites/      → 스프라이트/이미지
assets/audio/        → 사운드/음악
assets/fonts/        → 폰트
assets/spine/        → Spine 2D 에셋 (.skel/.atlas/.png, 캐릭터별 서브폴더)
addons/              → Godot 플러그인 (GUT 등)
bin/                 → Spine GDExtension 런타임 (.gitignore, 각자 설치)
tests/               → GUT 테스트 스크립트
docs/                → 문서 (SETUP, TEMPLATE_GUIDE, RESEARCH, PLAN, ARCHITECTURE, CONVENTIONS, GDD_TEMPLATE, UPGRADE, COLLABORATIVE-DESIGN-PRINCIPLE)
docs/engine-reference/godot/  → Godot 4.6 API 변경사항 (LLM 지식갭 보완)
design/gdd/          → 게임 디자인 문서 (GDD_TEMPLATE 참조하여 작성)
knowledge_base/      → LLM 지식 위키
.claude/agents/      → 전문 에이전트 (godot-*, creative/technical director)
.claude/skills/      → 슬래시 명령 스킬 (/brainstorm, /code-review 등)
.claude/rules/       → 파일 패턴별 코드 규칙 (gameplay-code, test-standards 등)
```

## Testing (GUT)
```bash
# GUT 테스트 실행 (headless) — $GODOT_PATH 환경변수 사용
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit

# 설정 파일: .gutconfig.json
```

테스트 파일 규칙:
- `tests/` 폴더에 배치
- 파일명: `test_` 접두사 (예: `test_player.gd`)
- `extends GutTest`
- 함수명: `test_` 접두사

## Screenshot Capture (AI 피드백용)
`scripts/utils/screenshot_capture.gd` 는 이미 **Autoload로 등록되어 있습니다** (`project.godot`의 `[autoload]` 섹션).
- F9 키로 스크린샷 캡처 (F12 는 브라우저/OS 과 충돌 가능)
- 저장 경로: `ProjectPaths.writable_dir("screenshots/")` — 에디터 실행 시 **프로젝트 루트의 `screenshots/`**, 익스포트 빌드 시 `user://screenshots/`
- `.gitignore` 로 커밋 방지됨
- 캡처된 이미지를 Claude에게 보여주어 UI/물리 버그 피드백 가능

## File Persistence Convention (필수 규칙)

**런타임에 프로젝트가 읽거나 쓰는 모든 파일은 [`scripts/utils/project_paths.gd`](scripts/utils/project_paths.gd) 의 `ProjectPaths.writable_dir()` 을 사용합니다.**

### 왜 이 규칙이 필요한가

이전엔 세이브/스크린샷이 `user://` (Windows: `%APPDATA%\Godot\...`) 에 흩어져 저장됐습니다. 솔로 인디 개발 중엔 **프로젝트 폴더 안에 모든 것이 모여 있어야** 관리가 쉽습니다.

### 규칙

```gdscript
# ❌ Bad — 플랫폼별 사용자 폴더에 흩어짐
var path := "user://saves/slot_0.save"

# ❌ Bad — 익스포트 빌드에서 res:// 는 읽기전용
var path := "res://saves/slot_0.save"

# ✅ Good — ProjectPaths 가 모드별로 알아서 결정
var dir := ProjectPaths.writable_dir("saves/")
var path := dir.path_join("slot_0.save")

# 또는 디렉토리 생성까지 한 번에:
var dir := ProjectPaths.ensure_writable_dir("saves/")
```

### 경로 해석 규칙 (`ProjectPaths` 내부)

| 실행 모드 | 결과 경로 |
|----------|----------|
| 에디터 실행 (`OS.has_feature("editor") == true`) | `<프로젝트 루트>/<subdir>/` |
| 익스포트 빌드 | `user://<subdir>/` → 플랫폼별 AppData |

### 새로운 subdir 추가 시 체크리스트

1. `ProjectPaths.writable_dir("foo/")` 로 경로 얻기
2. `.gitignore` 에 `foo/` 추가 (런타임 생성 파일은 Git 추적 제외)
3. 필요하면 `scripts/dev_tools/health_check.gd` 의 디렉토리 체크 리스트에 추가

현재 사용 중인 subdir: `screenshots/`, `saves/`, `logs/`, `profiles/`

## Skills (슬래시 명령)

### 프로젝트 내장 — `.claude/skills/` (CCGS 에서 이식, 솔로 인디 9개)
| 명령어 | 용도 | 분류 |
|--------|------|------|
| `/brainstorm` | 게임 컨셉 아이데이션 (구조화 질의) | HEAVY |
| `/quick-design` | 경량 디자인 스펙 (4시간 이하 변경) | VIBE |
| `/balance-check` | 밸런스 데이터/수식 이상치 분석 | HEAVY |
| `/code-review` | SOLID + 엔진 패턴 코드 리뷰 | VIBE |
| `/smoke-check` | 커밋 전 기본 런/빌드 확인 | VIBE |
| `/perf-profile` | 프레임/메모리 성능 프로파일 | HEAVY |
| `/tech-debt` | 기술 부채 카탈로그 | VIBE |
| `/retrospective` | 회고 — 잘됨/안됨/액션 | VIBE |
| `/playtest-report` | 플레이테스트 노트 구조화 | HEAVY |

> **제거됨 (팀 워크플로 가정, 솔로에 과함)**: `/scope-check`, `/design-review`, `/sprint-plan`, `/bug-report`, `/bug-triage`, `/prototype`. 필요 시 [CCGS 원본](https://github.com/)에서 개별 이식.

**사용 예**: `/code-review scripts/autoload/game_manager.gd`
통합 가이드: [knowledge_base/Wiki/ccgs-integration.md](knowledge_base/Wiki/ccgs-integration.md)

### 전문 에이전트 — `.claude/agents/` (Task 도구로 위임, 10개)
**Godot 엔진 (4)**:
- `godot-specialist` — 씬/노드 아키텍처, 엔진 전반
- `godot-gdscript-specialist` — GDScript 코드 품질, 시그널
- `godot-shader-specialist` — `.gdshader` 작성/최적화
- `godot-gdextension-specialist` — 성능 핫스팟의 C++/Rust

**디자인/기술 리드 (3)**:
- `creative-director` — 게임 필라, 플레이어 경험 검토
- `technical-director` — 아키텍처 큰 그림, 기술 선택
- `game-designer` — 메카닉 설계, GDD 작성

**리뷰/QA/퍼포먼스 (3)** — `/code-review`, `/perf-profile` 스킬이 스폰:
- `lead-programmer` — SOLID/아키텍처 코드 리뷰 리드
- `qa-tester` — 테스트 케이스 실행 가능성 검토
- `performance-analyst` — 프로파일링, 병목 분석

### 외부 — gstack (선택, `~/.claude/skills/gstack/`)
`docs/SETUP.md` 참조. **CCGS 스킬과 중복되지 않는 것**만 선별 사용 권장:
- `/office-hours` — 엔지니어링 1:1 상담 (CCGS 에 대체 없음)
- `/plan-ceo-review` — 제품 전략 리뷰 (CCGS 에 대체 없음)
- `/careful` — 신중 모드 (CCGS 에 대체 없음)
- `/learn` — 패턴 학습 (CCGS 에 대체 없음)

**중복되는 것 — CCGS 쪽 권장**:
- gstack `/review` ⟷ CCGS `/code-review` (**후자 사용** — 구조화된 체크리스트)
- gstack `/retro` ⟷ CCGS `/retrospective` (**후자 사용** — 더 상세한 템플릿)
- gstack `/qa` ⟷ CCGS `/smoke-check` + `/bug-report` (**후자 조합 사용**)

### Solo Review Mode (CCGS 디렉터 게이트)
기본값: `solo` (`production/review-mode.txt` 에 저장). 스킬이 creative-director 등 게이트를 스폰하기 전 이 값을 확인하고 대부분 스킵합니다. 팀 모드가 필요하면 `production/review-mode.txt` 를 `lean` 또는 `full` 로 수정.

## Autonomous Tool Usage (AI 자율 판단 지침)

**사용자는 슬래시 명령이나 에이전트 이름을 외우고 싶어하지 않습니다.** 사용자가 자연어로 요구하면 **AI 가 스스로 판단해 해당 툴을 호출**합니다. 다음 매핑을 기본으로 따르되, 상황에 맞게 유연하게.

### 사용자 자연어 → 자동 툴 호출

| 사용자가 말하면 | AI 가 자동 실행 |
|----------------|---------------|
| "버그 있어" / "안 돼" / "이상해" | → `Task(qa-tester)` 로 재현 + 원인 분석, 이후 `/code-review` |
| "느려" / "프레임 떨어져" / "렉" | → `Task(performance-analyst)` + `/perf-profile` |
| "이런 게임 만들고 싶어" (큰 방향) | → `/brainstorm` 시작 |
| "X 값 30 으로 바꿔줘" (간단 튜닝) | → 즉시 편집 + `/balance-check` 로 검증 |
| "X 기능 추가하고 싶어" (4h 이하) | → `/quick-design` 으로 경량 스펙, 그 후 구현 |
| "X 시스템 설계해줘" (1주 이상) | → `Task(game-designer)` 로 GDD 작성 |
| "씬/노드 구조 어떻게?" | → `Task(godot-specialist)` |
| "GDScript 코드 개선" | → `Task(godot-gdscript-specialist)` |
| "셰이더 만들어줘" | → `Task(godot-shader-specialist)` |
| "이거 C++ 로 빼야하나?" | → `Task(godot-gdextension-specialist)` |
| "이 코드 맞게 짠 거야?" | → `/code-review` (lead-programmer + qa-tester 병렬 스폰) |
| "필라 / 비전 검토" | → `Task(creative-director)` (비쌈, 큰 결정에만) |
| "아키텍처 결정해줘" | → `Task(technical-director)` (비쌈, 큰 결정에만) |
| "테스트 좀 돌려봐" | → `/smoke-check` |
| "커밋 전 점검" | → `/smoke-check` + `/code-review` (변경 파일 3개 이상이면) |
| "기술 부채 정리해야겠어" | → `/tech-debt` |
| "마일스톤 끝났어" / "이번 달 돌아보자" | → `/retrospective` |
| "플레이해봤는데..." (테스트 노트) | → `/playtest-report analyze` |
| "이 코드베이스 구조가 뭐야?" | → `graphify-out/graph.json` 존재하면 `graphify query`, 없으면 `/graphify .` 제안 |

### AI 가 능동적으로 제안할 타이밍

- **Phase 완료 시** → 자동 `/smoke-check` + `git status` 확인
- **3개 파일 이상 편집 후 커밋 직전** → 자동 `/code-review` 후 커밋
- **GDD 작성 후** → GDD 의 Tuning Knobs 섹션 자동 스캔 → `/balance-check` 제안
- **새 Autoload 추가 시** → `project.godot` 자동 업데이트 제안
- **스크린샷 저장 시** → AI 가 이미지 확인 후 UI/물리 이슈 설명

### 자동화하지 말 것

- `/clear` — **절대 자동 실행 금지** (컨텍스트 손실)
- `/compact` — 마일스톤에서만, 사용자 승인 필수
- `/brainstorm` — 컨셉 완전 부재일 때만. 이미 방향 있으면 `/quick-design`
- `creative-director`, `technical-director` — 비쌈. 진짜 큰 결정에만
- 파괴적 git 작업 (`push --force origin main`, `reset --hard origin/*`) — settings.json 에 deny 리스트

### Permissions 모드

`.claude/settings.json` permissions.allow 는 `Bash(*)`, `Task(*)` 등 광범위 개방. deny 리스트로 파괴적 명령만 차단. **일반 작업은 승인 프롬프트 없이 자동 진행**.

---

## Context Management
- `/clear`: 작업 단위 변경 시 사용자 재량. **AI 가 자동 실행 금지**
- `/compact`: 마일스톤에서만, 사용자 승인 필요
- 하나의 세션에서 3개 이상의 기능 구현 금지
- 역할 전환 시 `/clear` 권장 (사용자 판단)

## Knowledge Base
- 새로운 지식/사례 → `knowledge_base/Raw/` 에 저장 (`.gitignore` 됨, 개인용)
- "이 사례를 분석해서 위키에 영구 기록해줘" → `knowledge_base/Wiki/` 로 정제
- 인덱스 → `knowledge_base/Index/master-index.md` 자동 업데이트
- 참고: `docs/ARCHITECTURE.md`, `docs/CONVENTIONS.md`

## Headless Commands
> **참고**: 아래 명령은 `$GODOT_PATH` 환경변수가 설정되어 있다고 가정합니다. 미설정 시 `docs/SETUP.md` 를 참조하세요.

```bash
# 프로젝트 검증
"$GODOT_PATH" --headless --path . -e --quit

# 스크립트 실행
"$GODOT_PATH" --headless --path . -s tests/test_runner.gd

# 씬 실행 (5초)
"$GODOT_PATH" --headless --path . --scene res://scenes/main.tscn --quit-after 5000

# 에디터 실행
"$GODOT_PATH" --path .
```

## Agent Roles (에이전트 역할 활용)
상황에 맞는 역할을 부여하여 더 나은 결과물:
- **Creative Director**: `/office-hours`, `/plan-ceo-review`
- **Tech Lead**: `/plan-eng-review`, docs/ARCHITECTURE.md 참조
- **QA Engineer**: `/qa`, GUT 테스트 작성
- **Code Reviewer**: `/review`, docs/CONVENTIONS.md 준수 확인
- **Security Officer**: `/cso`, 보안 취약점 검토

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)
