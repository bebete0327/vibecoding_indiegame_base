## 데미지 숫자 풀 + 스폰 매니저.
## Autoload 이름: DamageNumberManager
##
## 어디서든 한 줄로 데미지 숫자 표시 가능. ObjectPool 로 메모리 효율 보장.
##
## 사용 예:
##   DamageNumberManager.spawn(enemy.global_position, 25)                              # 일반
##   DamageNumberManager.spawn(enemy.global_position, 50, DamageNumber.Style.CRIT)     # 치명타
##   DamageNumberManager.spawn(player.global_position, 10, DamageNumber.Style.HEAL)    # 회복
##   DamageNumberManager.spawn_miss(target.global_position)                            # 빗나감
##
## 풀 크기는 PRE_ALLOC (16) 으로 시작하지만 allow_grow=true 라 자동 확장.
## 첫 spawn 호출 시점에 lazy init — 데미지 시스템 없는 게임에선 메모리 안 씀.
##
## NOTE: Autoload 스크립트는 class_name 선언 안 함.
extends Node

const DAMAGE_NUMBER_SCENE_PATH := "res://scenes/effects/damage_number.tscn"
const PRE_ALLOC: int = 16

var _pool: ObjectPool
var _container: Node2D


func _ready() -> void:
	# 컨테이너만 미리 생성. 풀은 첫 spawn 시 lazy init.
	_container = Node2D.new()
	_container.name = "DamageNumberContainer"
	add_child(_container)


## 데미지 숫자 한 개 spawn. value < 0 면 자동으로 절대값 처리.
func spawn(world_pos: Vector2, value: int, style: int = DamageNumber.Style.NORMAL, duration: float = DamageNumber.DEFAULT_DURATION) -> void:
	_ensure_pool()
	var dmg := _pool.acquire() as DamageNumber
	if dmg == null:
		return
	# 풀에서 받은 노드는 _container 의 자식. 월드 좌표 기반 spawn.
	dmg.spawn(world_pos, value, style, duration)


## "MISS" 표시 (값 무관).
func spawn_miss(world_pos: Vector2) -> void:
	spawn(world_pos, 0, DamageNumber.Style.MISS)


## 디버그: 풀 상태.
func get_pool_stats() -> Dictionary:
	if _pool == null:
		return {"initialized": false}
	return {
		"initialized": true,
		"total": _pool.size(),
		"available": _pool.available(),
		"in_use": _pool.size() - _pool.available(),
	}


func _ensure_pool() -> void:
	if _pool != null:
		return
	var scene: PackedScene = load(DAMAGE_NUMBER_SCENE_PATH)
	if scene == null:
		push_error("[DamageNumberManager] %s 로드 실패" % DAMAGE_NUMBER_SCENE_PATH)
		return
	_pool = ObjectPool.new(scene, PRE_ALLOC, _container, true)
