# GDScript Design Patterns Reference

## Tags
- category: gdscript, pattern
- difficulty: intermediate
- related: [[godot-vibecoding-basics]]

## Summary
Godot 4.6 GDScript에서 자주 사용하는 디자인 패턴 모음.

## 1. State Machine Pattern

가장 많이 사용하는 패턴. 캐릭터, AI, UI 상태 관리에 필수.

### Base State
```gdscript
# scripts/states/state.gd
class_name State
extends Node

var entity: Node  # 상태를 소유한 엔티티

func enter() -> void:
    pass

func exit() -> void:
    pass

func update(delta: float) -> void:
    pass

func physics_update(delta: float) -> void:
    pass
```

### State Machine
```gdscript
# scripts/states/state_machine.gd
class_name StateMachine
extends Node

@export var initial_state: State
var current_state: State

func _ready() -> void:
    for child in get_children():
        if child is State:
            child.entity = owner
    if initial_state:
        initial_state.enter()
        current_state = initial_state

func transition_to(new_state: State) -> void:
    if current_state:
        current_state.exit()
    current_state = new_state
    current_state.enter()

func _process(delta: float) -> void:
    if current_state:
        current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state:
        current_state.physics_update(delta)
```

## 2. Observer Pattern (Signal Bus)

전역 이벤트 시스템. Autoload로 등록.

```gdscript
# scripts/autoload/event_bus.gd
class_name EventBus
extends Node

# Game flow
signal game_started
signal game_paused(is_paused: bool)
signal game_over(score: int)

# Player
signal player_health_changed(current: int, max_hp: int)
signal player_died
signal player_respawned

# Economy
signal score_changed(new_score: int)
signal item_collected(item_id: String)

# UI
signal dialog_started(dialog_id: String)
signal dialog_ended
```

## 3. Object Pool Pattern

탄환, 이펙트 등 빈번한 생성/삭제 최적화.

```gdscript
class_name ObjectPool
extends Node

@export var scene: PackedScene
@export var pool_size: int = 20

var _pool: Array[Node] = []

func _ready() -> void:
    for i in pool_size:
        var obj := scene.instantiate()
        obj.set_process(false)
        obj.visible = false
        add_child(obj)
        _pool.append(obj)

func get_object() -> Node:
    for obj in _pool:
        if not obj.visible:
            obj.visible = true
            obj.set_process(true)
            return obj
    # Pool exhausted - expand
    var obj := scene.instantiate()
    add_child(obj)
    _pool.append(obj)
    return obj

func release(obj: Node) -> void:
    obj.visible = false
    obj.set_process(false)
```

## 4. Command Pattern

입력 처리, 되돌리기(Undo) 기능.

```gdscript
class_name Command
extends RefCounted

func execute() -> void:
    pass

func undo() -> void:
    pass
```

```gdscript
class_name MoveCommand
extends Command

var entity: Node2D
var direction: Vector2

func _init(p_entity: Node2D, p_direction: Vector2) -> void:
    entity = p_entity
    direction = p_direction

func execute() -> void:
    entity.position += direction

func undo() -> void:
    entity.position -= direction
```

## 5. Component Pattern

기능을 컴포넌트로 분리하여 재사용.

```gdscript
# scripts/components/health_component.gd
class_name HealthComponent
extends Node

signal health_changed(current: int, maximum: int)
signal died

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
    current_health = max_health

func take_damage(amount: int) -> void:
    current_health = maxi(current_health - amount, 0)
    health_changed.emit(current_health, max_health)
    if current_health <= 0:
        died.emit()

func heal(amount: int) -> void:
    current_health = mini(current_health + amount, max_health)
    health_changed.emit(current_health, max_health)
```

## 6. Singleton/Autoload Pattern

```gdscript
# scripts/autoload/game_manager.gd
class_name GameManager
extends Node

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER }

var state: GameState = GameState.MENU
var score: int = 0

func change_state(new_state: GameState) -> void:
    state = new_state
    match new_state:
        GameState.PLAYING:
            get_tree().paused = false
        GameState.PAUSED:
            get_tree().paused = true
        GameState.GAME_OVER:
            EventBus.game_over.emit(score)

func change_scene(scene_path: String) -> void:
    get_tree().change_scene_to_file(scene_path)
```

## 7. Reactive Property Pattern

값이 변경될 때 자동으로 구독자에게 알리는 패턴. UI 바인딩에 핵심.
(C# SubscribableProperty에서 GDScript로 변환)

```gdscript
# scripts/utils/reactive_property.gd
class_name ReactiveProperty
extends RefCounted

signal value_changed(new_value: Variant)

var _value: Variant
var _equality_check: bool = true  # 같은 값 설정 시 시그널 무시

func _init(initial_value: Variant = null, check_equality: bool = true) -> void:
    _value = initial_value
    _equality_check = check_equality

var value: Variant:
    get: return _value
    set(new_val):
        if _equality_check and _value == new_val:
            return
        _value = new_val
        value_changed.emit(_value)

## 구독 편의 메서드 (즉시 현재값 전달 옵션)
func subscribe(callback: Callable, invoke_initial: bool = false) -> void:
    value_changed.connect(callback)
    if invoke_initial:
        callback.call(_value)

func unsubscribe(callback: Callable) -> void:
    if value_changed.is_connected(callback):
        value_changed.disconnect(callback)
```

사용 예시:
```gdscript
# HealthComponent에서 활용
var health := ReactiveProperty.new(100)

func _ready() -> void:
    health.subscribe(_on_health_changed, true)

func _on_health_changed(new_hp: Variant) -> void:
    health_bar.value = new_hp

func take_damage(amount: int) -> void:
    health.value = maxi(health.value - amount, 0)
    # UI 자동 업데이트됨!
```

## 8. Service Locator Pattern

Godot의 Autoload를 활용한 경량 서비스 관리.
(C# DI Container의 GDScript 적응 - Godot에서는 DI보다 Service Locator가 적합)

```gdscript
# scripts/autoload/service_locator.gd
class_name ServiceLocator
extends Node

var _services: Dictionary = {}  # {StringName: Object}

func register_service(service_name: StringName, service: Object) -> void:
    if _services.has(service_name):
        push_warning("Service '%s' already registered, overwriting." % service_name)
    _services[service_name] = service

func get_service(service_name: StringName) -> Object:
    if not _services.has(service_name):
        push_error("Service '%s' not found!" % service_name)
        return null
    return _services[service_name]

func has_service(service_name: StringName) -> bool:
    return _services.has(service_name)

func unregister_service(service_name: StringName) -> void:
    _services.erase(service_name)
```

사용 예시:
```gdscript
# 등록 (Autoload의 _ready에서)
func _ready() -> void:
    ServiceLocator.register_service(&"AudioManager", AudioManager.new())
    ServiceLocator.register_service(&"SaveManager", SaveManager.new())

# 사용
var audio = ServiceLocator.get_service(&"AudioManager") as AudioManager
audio.play_sfx("explosion")
```

## 9. Subscribable Command Pattern

실행 가능 여부를 체크하는 커맨드 패턴. UI 버튼 활성화/비활성화에 유용.

```gdscript
# scripts/utils/subscribable_command.gd
class_name SubscribableCommand
extends RefCounted

signal can_execute_changed(can_execute: bool)

var _execute_callback: Callable
var _can_execute: bool = true

var can_execute: bool:
    get: return _can_execute
    set(new_val):
        if _can_execute != new_val:
            _can_execute = new_val
            can_execute_changed.emit(_can_execute)

func _init(callback: Callable, initially_enabled: bool = true) -> void:
    _execute_callback = callback
    _can_execute = initially_enabled

func execute() -> void:
    if _can_execute and _execute_callback.is_valid():
        _execute_callback.call()
```

사용 예시:
```gdscript
var attack_command := SubscribableCommand.new(_perform_attack)

func _ready() -> void:
    attack_command.can_execute_changed.connect(func(can: bool):
        attack_button.disabled = not can
    )

func _on_cooldown_started() -> void:
    attack_command.can_execute = false

func _on_cooldown_ended() -> void:
    attack_command.can_execute = true
```

## When to Use Which

| Situation | Pattern |
|-----------|---------|
| Character states (idle, run, jump) | State Machine |
| Cross-system communication | Signal Bus |
| Bullets, particles, VFX | Object Pool |
| Input remapping, undo | Command |
| Shared behavior (health, hitbox) | Component |
| Global services | Autoload Singleton |
| UI data binding, auto-update | Reactive Property |
| Loosely coupled service access | Service Locator |
| Button enable/disable logic | Subscribable Command |
