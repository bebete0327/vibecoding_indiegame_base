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
