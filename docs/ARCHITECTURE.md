# Architecture Document

## Engine Configuration
- **Godot**: 4.6.2
- **Language**: GDScript (typed)
- **Renderer**: Mobile (기본값) — [Renderer 선택](#renderer-선택) 참조
- **Physics**: Jolt Physics (3D)

## Renderer 선택

템플릿 기본값은 **Mobile** 렌더러 + **D3D12** 드라이버 (Windows 기준).
게임 종류에 따라 변경을 권장합니다:

| 렌더러 | 권장 사례 | 성능 |
|--------|-----------|------|
| **Mobile** (기본) | 모바일 출시, 저사양 호환, 픽셀 아트 2D | GLES3 / Vulkan Mobile |
| **Forward+** | 데스크톱 3D, 고급 라이팅 필요 | Vulkan Desktop, 가장 많은 기능 |
| **Compatibility** | WebGL, 구형 하드웨어 | GLES3, 기능 제한 |

### 변경 방법
1. `project.godot` 의 `[rendering]` 섹션 수정:
   ```ini
   [rendering]
   renderer/rendering_method="forward_plus"    # 또는 "mobile", "gl_compatibility"
   ```
2. `config/features` 의 Mobile/Forward Plus 태그도 맞추기 (에디터에서 자동 처리됨)
3. 드라이버 (`rendering_device/driver.windows`) 는 Forward+ / Mobile 은 `vulkan` 또는 `d3d12` 권장, Compatibility 는 `opengl3`

### macOS / Linux 주의
현재 `rendering_device/driver.windows="d3d12"` 로 Windows 에만 적용됩니다. 다른 플랫폼에서는 Vulkan 이 기본으로 동작하므로 별도 설정 불필요.

## Project Architecture

### Scene Tree Design
```
Main (Node)
├── World (Node2D/Node3D)
│   ├── Environment
│   ├── Entities
│   └── UI_Layer
├── GameManager (Autoload)
├── AudioManager (Autoload)
└── SaveManager (Autoload)
```

### Autoload Services (싱글톤)
| Name | Purpose | Priority |
|------|---------|----------|
| GameManager | 게임 상태 관리, 씬 전환 | High |
| AudioManager | BGM/SFX 관리 | Medium |
| SaveManager | 세이브/로드 | Medium |

### Signal Bus Pattern
글로벌 시그널은 전용 Autoload를 통해 관리:
```gdscript
# scripts/autoload/event_bus.gd
class_name EventBus
extends Node

signal game_started
signal game_paused
signal game_over
signal score_changed(new_score: int)
```

### State Machine Pattern
복잡한 객체 상태는 State Machine으로 관리:
```
scripts/
├── states/
│   ├── state.gd          # 베이스 State 클래스
│   ├── state_machine.gd  # StateMachine 관리자
│   ├── idle_state.gd
│   ├── move_state.gd
│   └── attack_state.gd
```

### Resource Pattern
데이터는 Resource로 분리:
```gdscript
# scripts/resources/character_data.gd
class_name CharacterData
extends Resource

@export var name: String
@export var max_health: int = 100
@export var speed: float = 200.0
```

### Reactive Property Pattern
UI 데이터 바인딩에 사용. 값 변경 시 구독자에 자동 알림:
```gdscript
var health := ReactiveProperty.new(100)
health.subscribe(func(val): health_bar.value = val, true)
health.value -= 10  # UI 자동 업데이트
```

### Service Locator Pattern
Autoload 기반 경량 서비스 관리:
```gdscript
ServiceLocator.register_service(&"AudioManager", audio_mgr)
var audio = ServiceLocator.get_service(&"AudioManager")
```

## Directory Rules
- 하나의 씬 = 하나의 `.tscn` + 하나의 `.gd`
- 공유 유틸리티 → `scripts/utils/`
- 데이터 리소스 → `scripts/resources/`
- 상태 머신 → `scripts/states/`
- Autoload → `scripts/autoload/`
- 컴포넌트 → `scripts/components/`

## Performance Guidelines (Mobile Renderer)
- Draw call 최소화
- 텍스처 아틀라스 사용
- GDScript에서 `_process` 대신 가능하면 시그널/타이머 사용
- 물리 연산은 `_physics_process`에서만
- Object pooling 적극 활용
