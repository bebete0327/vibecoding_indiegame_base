# GDScript Coding Conventions

## Quick Reference

### Naming Rules
| 요소 | 규칙 | 예시 |
|------|------|------|
| Class | PascalCase | `PlayerController` |
| Function | snake_case | `get_health()` |
| Variable | snake_case | `move_speed` |
| Constant | UPPER_SNAKE | `MAX_HEALTH` |
| Signal | past_tense snake | `health_changed` |
| Enum | PascalCase.UPPER | `State.IDLE` |
| Private | _prefix | `_internal_var` |
| Boolean | is/has/can prefix | `is_alive`, `has_key` |
| Node ref | type suffix | `player_sprite`, `health_label` |

### Type Hints (필수)
```gdscript
# 모든 변수에 타입 명시
var speed: float = 200.0
var name: String = ""
var items: Array[Item] = []
var stats: Dictionary = {}

# 함수 파라미터와 리턴 타입 필수
func deal_damage(target: CharacterBody2D, amount: int) -> bool:
    return target.take_damage(amount)

# 시그널 파라미터 타입 명시
signal item_collected(item: Item, count: int)
```

### Export Variables
```gdscript
# 에디터에서 조절할 값은 @export
@export var speed: float = 200.0
@export_range(0, 100) var health: int = 100
@export_group("Movement")
@export var jump_force: float = 400.0
@export var gravity_scale: float = 1.0
```

### Node References
```gdscript
# @onready로 노드 참조 (타입 명시)
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# 절대 경로 대신 상대 경로 사용
# Good: $Sprite2D
# Bad:  get_node("/root/Main/Player/Sprite2D")
```

### Signal Connection
```gdscript
# 코드에서 연결 시 Callable 사용
func _ready() -> void:
    health_changed.connect(_on_health_changed)
    $Button.pressed.connect(_on_button_pressed)

# 시그널 핸들러는 _on_ prefix
func _on_health_changed(new_health: int) -> void:
    health_bar.value = new_health
```

### Error Handling
```gdscript
# null 체크
if player != null:
    player.take_damage(10)

# is_instance_valid 사용 (해제된 객체)
if is_instance_valid(target):
    target.queue_free()

# assert는 디버그용으로만
assert(health >= 0, "Health cannot be negative")
```

### Documentation
```gdscript
## 클래스 설명은 ## 더블 해시로
## PlayerController handles movement and input for the player character.
class_name PlayerController
extends CharacterBody2D

## 복잡한 함수에만 주석
## Applies damage and triggers death if health reaches zero.
func take_damage(amount: int) -> void:
    health -= amount
    if health <= 0:
        _die()
```

## Anti-Patterns (금지)

### DO NOT
```gdscript
# 타입 없는 변수
var speed = 200          # Bad
var speed: float = 200.0 # Good

# get_node with string path from root
get_node("/root/Main/Player")  # Bad
$Player                         # Good (상대경로)

# process에서 매 프레임 new 객체
func _process(delta):
    var vec = Vector2(1, 0)  # Bad - 매 프레임 생성

# 미사용 시그널 연결 방치
# 씬에서 연결한 시그널은 반드시 핸들러 구현
```

## Variant 추론 경고 (Warnings as Errors)

Godot 4 는 Variant 에서 타입 추론을 경고로 띄우며, 이 템플릿은 경고를 에러로 취급합니다. `:=` 연산자를 Variant 값에 쓰면 크래시합니다.

```gdscript
# Bad — value 가 Variant 이면 old 도 Variant 로 추론되어 경고
var old := some_variant_value

# Good — Variant 를 명시
var old: Variant = some_variant_value
```

Variant 를 사용해야 하는 전형적인 상황: `Dictionary.get()`, `JSON.parse_string()`, `Resource` 의 동적 프로퍼티.

## Autoload 스크립트 예외

Autoload 로 등록되는 스크립트는 `class_name` 을 선언하지 **않습니다**. Autoload 이름이 전역 변수로 등록되면서 동명의 `class_name` 과 충돌합니다.

```gdscript
# scripts/autoload/event_bus.gd — Autoload 이름: EventBus
# class_name EventBus     # Bad — 충돌
extends Node               # Good — class_name 생략
```

호출은 Autoload 이름으로: `EventBus.game_started.emit()`
