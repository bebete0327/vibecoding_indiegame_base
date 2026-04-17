## 체력 컴포넌트 — Player/Enemy 등의 자식 노드로 배치하여 체력 관리를 위임.
##
## 씬 구조 예:
##   Enemy (CharacterBody2D)
##   └── HealthComponent  (max_health=50)
##
## 사용 예:
##   @onready var health: HealthComponent = $HealthComponent
##   func _on_hit(dmg: int) -> void:
##       health.take_damage(dmg)
class_name HealthComponent
extends Node

## health_changed: current 값 변경 시 (데미지/힐 공통) — setter 에서 자동 emit.
## damaged/healed: 데미지/힐 이벤트 자체 (양 정보 포함).
## died: current_health 가 0 도달 시 — setter 에서 자동 emit.
signal health_changed(current: int, maximum: int)
signal damaged(amount: int)
signal healed(amount: int)
signal died

@export var max_health: int = 100
@export var start_full: bool = true
@export var invulnerable: bool = false

var current_health: int:
	set(value):
		var clamped := clampi(value, 0, max_health)
		if clamped == current_health:
			return
		current_health = clamped
		health_changed.emit(current_health, max_health)
		if current_health == 0:
			died.emit()

var is_alive: bool:
	get:
		return current_health > 0


func _ready() -> void:
	if start_full:
		current_health = max_health


func take_damage(amount: int) -> void:
	if invulnerable or not is_alive or amount <= 0:
		return
	current_health -= amount
	damaged.emit(amount)


func heal(amount: int) -> void:
	if not is_alive or amount <= 0:
		return
	current_health += amount
	healed.emit(amount)


func revive(health: int = -1) -> void:
	current_health = max_health if health < 0 else clampi(health, 1, max_health)
