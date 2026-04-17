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
scripts/utils/       → 유틸리티 (ScreenshotCapture 등)
scripts/autoload/    → Autoload 싱글톤
scripts/components/  → 재사용 컴포넌트
scripts/states/      → State Machine
scripts/resources/   → Resource 데이터 클래스
assets/sprites/      → 스프라이트/이미지
assets/audio/        → 사운드/음악
assets/fonts/        → 폰트
addons/              → Godot 플러그인 (GUT 등)
tests/               → GUT 테스트 스크립트
docs/                → 문서 (SETUP, TEMPLATE_GUIDE, RESEARCH, PLAN, ARCHITECTURE, CONVENTIONS)
knowledge_base/      → LLM 지식 위키
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
- F12 키로 스크린샷 캡처
- `user://screenshots/`에 저장
- 캡처된 이미지를 Claude에게 보여주어 UI/물리 버그 피드백 가능

## gstack Skills
`~/.claude/skills/gstack/` 에 설치 필요 (`docs/SETUP.md` 참조).

| 명령어 | 용도 |
|--------|------|
| `/office-hours` | 엔지니어링 상담 |
| `/plan-ceo-review` | CEO 관점 제품 리뷰 |
| `/plan-eng-review` | 아키텍처 리뷰 |
| `/review` | 코드 리뷰 |
| `/qa` | QA 테스트 |
| `/cso` | 보안 감사 |
| `/autoplan` | 자동 계획 수립 |
| `/careful` | 신중 모드 |
| `/learn` | 패턴 학습 |
| `/retro` | 회고 |

## Context Management
- `/clear`: 작업 단위 변경 시 **반드시** 사용 (어텐션 희석 방지)
- `/compact`: 마일스톤에서만 (기획 완료, 디버깅 종료)
- 하나의 세션에서 3개 이상의 기능 구현 금지
- 역할 전환 시 `/clear` 권장

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
