# TEMPLATE_GUIDE — 이 템플릿으로 새 게임 시작하기

> **전제**: [`docs/SETUP.md`](SETUP.md) 의 모든 체크리스트를 완료했다고 가정합니다.

---

## 1. 전체 흐름 (바이브코딩 루프)

```
  Brainstorm ──► Research ──► Plan ──► Implement ──► Test ──► Commit
  (/office-    (RESEARCH.md) (PLAN.md,  (Phase 단위,  (GUT,    (git +
   hours,                     승인 필수) Hook 자동     스크린샷) knowledge_
   /plan-ceo)                            검증)                  base)
```

자세한 내용은 [`CLAUDE.md`](../CLAUDE.md) 의 "Vibe Coding Workflow" 섹션 참조.

---

## 2. 2D 게임 시작

### 2.1 루트 구조
```
Main (Node)                       ← scenes/main.tscn (기본)
└── World (Node2D)                ← 새로 추가
    ├── Player (CharacterBody2D)
    ├── Enemies (Node2D)
    └── UI (CanvasLayer)
```

### 2.2 절차
1. `scenes/main.tscn` 을 Godot 에디터에서 열기
2. 루트 `Main` 노드 아래에 자식으로 **`Node2D`** 추가 (이름: `World`)
3. `scenes/world_2d.tscn` 으로 저장하여 씬 분리 (권장)
4. `scripts/main.gd` 의 `_ready()` 에서 로드:
   ```gdscript
   add_child(load("res://scenes/world_2d.tscn").instantiate())
   ```
5. 게임 스크립트 `scripts/` 하위 생성 — `CLAUDE.md` 의 File Structure 준수

---

## 3. 3D 게임 시작

### 3.1 루트 구조
```
Main (Node)                       ← scenes/main.tscn (기본)
└── World (Node3D)                ← 새로 추가
    ├── WorldEnvironment
    ├── DirectionalLight3D
    ├── Camera3D
    ├── Player (CharacterBody3D)
    └── UI (CanvasLayer)
```

### 3.2 절차
1. `scenes/main.tscn` 을 Godot 에디터에서 열기
2. 루트 `Main` 노드 아래에 자식으로 **`Node3D`** 추가 (이름: `World`)
3. `scenes/world_3d.tscn` 으로 저장
4. `scripts/main.gd` 의 `_ready()` 에서 로드:
   ```gdscript
   add_child(load("res://scenes/world_3d.tscn").instantiate())
   ```
5. Jolt Physics 가 이미 활성화되어 있으니 `RigidBody3D` / `CharacterBody3D` 바로 사용 가능

---

## 4. Autoload(전역 서비스) 추가

### 4.1 기본 제공 (템플릿에 사전 등록됨)
| Autoload | 파일 | 용도 |
|----------|------|------|
| `Screenshot_Capture` | `scripts/utils/screenshot_capture.gd` | F9 키로 스크린샷 저장 (AI 피드백용) |
| `EventBus` | `scripts/autoload/event_bus.gd` | 글로벌 시그널 허브 |
| `GameManager` | `scripts/autoload/game_manager.gd` | 게임 상태/씬 전환/점수 |
| `AudioManager` | `scripts/autoload/audio_manager.gd` | BGM 크로스페이드 + SFX 풀 |
| `SaveManager` | `scripts/autoload/save_manager.gd` | JSON 기반 세이브/로드 |
| `ServiceLocator` | `scripts/autoload/service_locator.gd` | 런타임 서비스 등록/조회 |

> **주의**: Autoload 스크립트는 `class_name` 을 선언하지 않습니다 (Autoload 이름과 전역 클래스 이름이 충돌). 호출은 그냥 `EventBus.game_started.emit()` 처럼 Autoload 이름으로 합니다.

### 4.2 새 Autoload 추가
1. `scripts/autoload/<your_autoload>.gd` 를 생성 (기존 파일 참고)
2. Godot 에디터 → Project Settings → Autoload → 추가 (이름, 경로 입력)
3. 어디서든 호출: `<Autoload이름>.method()`

패턴 레퍼런스: `knowledge_base/Wiki/gdscript-patterns.md`

---

## 4.5 Input Map (사전 등록된 액션)

템플릿에는 2D/3D 공통으로 쓰이는 액션이 이미 등록되어 있습니다:

| 액션 | 키보드 | 게임패드 |
|------|--------|----------|
| `move_left` / `move_right` / `move_up` / `move_down` | WASD + 화살표키 | 좌 스틱 |
| `jump` | Space | A (Xbox) / Cross (PS) |
| `interact` | E | X (Xbox) / Square (PS) |
| `attack` | 마우스 좌클릭 | Y (Xbox) / Triangle (PS) |
| `pause` | Esc | Select/Back |

사용 예:
```gdscript
func _physics_process(delta: float) -> void:
    var dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
    velocity = dir * speed

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(&"pause"):
        GameManager.toggle_pause()
```

변경: Project Settings → Input Map 에서 수정.

---

## 5. GUT 테스트 추가

### 5.1 파일 규칙
- 위치: `tests/`
- 이름: `test_<feature>.gd`
- 상속: `extends GutTest`
- 함수: `test_<case>() -> void`

### 5.2 예시
```gdscript
# tests/test_player_movement.gd
extends GutTest

var _player: Player

func before_each() -> void:
    _player = Player.new()

func after_each() -> void:
    _player.free()

func test_initial_velocity_is_zero() -> void:
    assert_eq(_player.velocity, Vector2.ZERO)

func test_move_applies_velocity() -> void:
    _player.move(Vector2.RIGHT)
    assert_gt(_player.velocity.x, 0.0)
```

### 5.3 실행
```bash
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit
```

---

## 6. Knowledge Base 활용

### 6.1 구조
```
knowledge_base/
├── Raw/          ← .gitignore (개인 메모/웹 클리퍼)
├── Wiki/         ← AI가 정제한 영구 지식
└── Index/master-index.md
```

### 6.2 워크플로우
1. **Ingest**: 유용한 자료를 `Raw/` 에 그대로 저장
2. **Process**: `Raw/<파일>.md 를 읽고 Wiki 에 정리해줘` → Claude 가 분류/연결/정제
3. **Query**: `내 위키에서 State Machine 패턴 찾아줘` → `Index/master-index.md` 기반 검색
4. **Lint**: 주기적으로 `위키의 깨진 링크 수정해줘`

기존 Wiki 문서 (범용):
- `gdscript-patterns.md` — GDScript 9가지 패턴
- `harness-engineering.md` — Claude Code 훅 설계
- `godot-mcp-tools.md` — MCP/LSP 연동
- `godot-vibecoding-basics.md` — 바이브코딩 기초
- `ecc-optimization-guide.md` — 비용 절감
- `ai-asset-pipeline.md` — AI 에셋 생성
- `game-studios-agent.md` — 에이전트 역할

---

## 7. 커스텀 훅 확장

`.claude/settings.json` 에 이미 GDScript 자동검증 훅이 설정됨. 추가 훅 예시:

### 7.1 커밋 전 GUT 테스트 강제
```json
{
  "matcher": "Bash.*git commit.*",
  "command": "bash -c 'if ! \"$GODOT_PATH\" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit; then echo \"테스트 실패 — 커밋 중단\"; exit 1; fi'",
  "timeout": 60000
}
```

### 7.2 스크린샷 자동 캡처 후 알림
자세한 패턴은 `knowledge_base/Wiki/harness-engineering.md` 참조.

---

## 8. 이 템플릿 업그레이드

이 템플릿은 앞으로 기능이 추가될 수 있습니다. 기존 프로젝트에 새 기능 반영:

1. 템플릿 업데이트 반영할 폴더(`godot-vibe-template/`)에서 `git pull`
2. 기존 프로젝트로 필요한 파일만 수동 복사
3. `git diff` 로 변경사항 확인 후 커밋

충돌 피하려면 템플릿 업그레이드는 **새 브랜치에서** 수행 권장.

---

## 9. 자주 쓰는 명령어 치트시트

```bash
# 프로젝트 로드 검증
"$GODOT_PATH" --headless --path . -e --quit

# GUT 테스트
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit

# 메인 씬 실행 (3초)
"$GODOT_PATH" --headless --path . --scene res://scenes/main.tscn --quit-after 3000

# 에디터 열기
"$GODOT_PATH" --path .

# 특정 씬 실행
"$GODOT_PATH" --path . --scene res://scenes/<scene>.tscn
```

---

## 10. 다음 단계

1. `docs/RESEARCH.md` 에 새 게임 리서치 작성
2. `docs/PLAN.md` 에 Phase 계획 작성 → 사용자 승인
3. Phase 1 부터 구현
4. 각 Phase 완료 시 GUT + 스크린샷 검증
5. 마일스톤 커밋 + `knowledge_base/` 기록
