## 오브젝트 풀 — 자주 생성/해제되는 노드의 재사용 패턴.
##
## 총알, 파티클, 데미지 숫자, 적 등 **매 프레임/초 마다 spawn 되는 객체**에 사용.
## `instantiate()` + `queue_free()` 사이클은 GC 압력 + 프레임 드롭 원인이므로
## **미리 할당한 인스턴스를 재활용** 하는 방식이 표준.
##
## ## 사용 예
##
## ```gdscript
## # Player 또는 BulletManager 에서:
## @onready var bullet_pool: ObjectPool = ObjectPool.new(
##     preload("res://scenes/bullet.tscn"),
##     pre_alloc = 32,                          # 시작 시 32개 미리 생성
##     parent = get_tree().current_scene,       # 풀 인스턴스 부모 노드
## )
##
## # 발사 시
## func shoot() -> void:
##     var bullet := bullet_pool.acquire() as Bullet
##     bullet.global_position = muzzle.global_position
##     bullet.set_velocity(forward * 800)
##     bullet.activate()
##
## # 적 명중 / 화면 밖 등에서
## func _on_bullet_done(bullet: Bullet) -> void:
##     bullet_pool.release(bullet)
## ```
##
## ## 노드가 풀에 반납될 때 호출되는 메서드 (있으면)
##
## 풀링 대상 노드에 다음 메서드를 구현하면 자동 호출됨:
##   - `_pool_acquire()`  — 풀에서 꺼낼 때 (visible=true, reset state 등)
##   - `_pool_release()`  — 풀에 반납할 때 (visible=false, stop motion 등)
##
## 메서드가 없으면 `process_mode` 와 `visible` 만 자동 토글.
##
## ## 동시 사용량 초과 시
##
## acquire() 호출 시 풀이 비어있으면:
##   - allow_grow=true (기본): 새 인스턴스 즉시 생성 후 반환 (풀 크기 증가)
##   - allow_grow=false: null 반환 + 경고 (예측 가능한 메모리 사용 시)
class_name ObjectPool
extends RefCounted

const META_POOL_KEY := &"_object_pool_owner"

var _scene: PackedScene
var _parent: Node
var _available: Array[Node] = []
var _all: Array[Node] = []
var _allow_grow: bool = true


## scene: 풀링할 .tscn  ·  pre_alloc: 미리 생성할 개수  ·  parent: 인스턴스의 부모
##
## allow_grow=false 면 풀 고갈 시 acquire() 가 null 반환 (메모리 상한 강제).
func _init(scene: PackedScene, pre_alloc: int = 8, parent: Node = null, allow_grow: bool = true) -> void:
	_scene = scene
	_parent = parent
	_allow_grow = allow_grow
	for i in pre_alloc:
		_create_and_release()


## 풀에서 노드 1개 가져오기. 없으면 새로 만들거나(allow_grow=true) null.
func acquire() -> Node:
	var node: Node
	if _available.is_empty():
		if not _allow_grow:
			push_warning("[ObjectPool] exhausted (size=%d, allow_grow=false) — returning null" % _all.size())
			return null
		node = _instantiate()
	else:
		node = _available.pop_back()
	_activate(node)
	return node


## 노드를 풀에 반납. 다른 풀의 노드는 거부.
func release(node: Node) -> void:
	if node == null:
		return
	if not node.has_meta(META_POOL_KEY) or node.get_meta(META_POOL_KEY) != self:
		push_warning("[ObjectPool] node %s 가 이 풀의 소유가 아님 — release 거부" % node)
		return
	if node in _available:
		return  # 이미 반납됨
	_deactivate(node)
	_available.append(node)


## 풀 전체 노드 수 (acquired + available).
func size() -> int:
	return _all.size()


## 현재 사용 가능한 노드 수.
func available() -> int:
	return _available.size()


## 풀 정리 — 모든 노드 free. 사용 후 _all/_available 비움.
func clear() -> void:
	for node in _all:
		if is_instance_valid(node):
			node.queue_free()
	_all.clear()
	_available.clear()


# ===== 내부 =====

func _instantiate() -> Node:
	var node := _scene.instantiate()
	node.set_meta(META_POOL_KEY, self)
	if _parent != null and is_instance_valid(_parent):
		_parent.add_child(node)
	_all.append(node)
	return node


func _create_and_release() -> void:
	var node := _instantiate()
	_deactivate(node)
	_available.append(node)


func _activate(node: Node) -> void:
	if not is_instance_valid(node):
		return
	node.process_mode = Node.PROCESS_MODE_INHERIT
	if node is CanvasItem:
		(node as CanvasItem).visible = true
	if node.has_method(&"_pool_acquire"):
		node.call(&"_pool_acquire")


func _deactivate(node: Node) -> void:
	if not is_instance_valid(node):
		return
	node.process_mode = Node.PROCESS_MODE_DISABLED
	if node is CanvasItem:
		(node as CanvasItem).visible = false
	if node.has_method(&"_pool_release"):
		node.call(&"_pool_release")
