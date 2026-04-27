## ObjectPool 테스트 — acquire / release / 자동 확장 / META 검증.
extends GutTest

var _scene: PackedScene


func before_each() -> void:
	# 매 테스트마다 가벼운 인라인 PackedScene 사용 (외부 .tscn 의존 X)
	var node2d := Node2D.new()
	_scene = PackedScene.new()
	_scene.pack(node2d)
	node2d.queue_free()


func test_pre_alloc_creates_correct_count() -> void:
	var parent := Node.new()
	add_child_autofree(parent)
	var pool := ObjectPool.new(_scene, 5, parent, true)
	assert_eq(pool.size(), 5)
	assert_eq(pool.available(), 5)
	pool.clear()


func test_acquire_reduces_available() -> void:
	var parent := Node.new()
	add_child_autofree(parent)
	var pool := ObjectPool.new(_scene, 3, parent, true)
	var n1 := pool.acquire()
	assert_not_null(n1)
	assert_eq(pool.available(), 2)
	pool.clear()


func test_release_returns_to_pool() -> void:
	var parent := Node.new()
	add_child_autofree(parent)
	var pool := ObjectPool.new(_scene, 2, parent, true)
	var n := pool.acquire()
	pool.release(n)
	assert_eq(pool.available(), 2)
	pool.clear()


func test_grow_when_exhausted() -> void:
	var parent := Node.new()
	add_child_autofree(parent)
	var pool := ObjectPool.new(_scene, 2, parent, true)  # allow_grow=true
	var n1 := pool.acquire()
	var n2 := pool.acquire()
	var n3 := pool.acquire()  # exhausted, but grow=true → new instance
	assert_not_null(n3)
	assert_eq(pool.size(), 3, "allow_grow 시 새 인스턴스 생성으로 풀 확장")
	pool.clear()


func test_no_grow_returns_null_when_exhausted() -> void:
	var parent := Node.new()
	add_child_autofree(parent)
	var pool := ObjectPool.new(_scene, 1, parent, false)  # allow_grow=false
	var n1 := pool.acquire()
	assert_not_null(n1)
	var n2 := pool.acquire()
	assert_null(n2, "allow_grow=false 시 풀 고갈하면 null")
	pool.clear()


func test_release_foreign_node_rejected() -> void:
	var parent := Node.new()
	add_child_autofree(parent)
	var pool := ObjectPool.new(_scene, 1, parent, true)
	var foreign := Node.new()
	add_child_autofree(foreign)
	pool.release(foreign)  # 다른 풀의 노드 — 거부되어야 함
	assert_eq(pool.available(), 1, "외부 노드 release 거부됨")
	pool.clear()


func test_double_release_idempotent() -> void:
	var parent := Node.new()
	add_child_autofree(parent)
	var pool := ObjectPool.new(_scene, 1, parent, true)
	var n := pool.acquire()
	pool.release(n)
	pool.release(n)  # 두 번째 release 는 무시
	assert_eq(pool.available(), 1)
	pool.clear()
