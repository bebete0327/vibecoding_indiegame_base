# Architecture Document

## Engine Configuration
- **Godot**: 4.6.2
- **Language**: GDScript (typed)
- **Renderer**: Mobile (OpenGL ES 3.0 / Vulkan Mobile)
- **Physics**: Jolt Physics (3D)

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
