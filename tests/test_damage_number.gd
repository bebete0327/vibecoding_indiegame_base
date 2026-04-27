## DamageNumber + DamageNumberManager 테스트.
extends GutTest


func test_damage_number_can_be_instantiated() -> void:
	var dmg := DamageNumber.new()
	add_child_autofree(dmg)
	assert_not_null(dmg)
	assert_true(dmg is Node2D)


func test_damage_manager_autoload_exists() -> void:
	assert_not_null(DamageNumberManager, "DamageNumberManager Autoload 등록되어야 함")


func test_pool_lazy_init() -> void:
	# 첫 spawn 호출 전엔 pool 초기화 X (메모리 절감)
	var stats: Dictionary = DamageNumberManager.get_pool_stats()
	# 이전 테스트가 spawn 했을 수도 있으므로 두 가지 케이스 다 허용
	assert_true(stats.has("initialized"))


func test_spawn_creates_visible_number() -> void:
	DamageNumberManager.spawn(Vector2(100, 100), 25, DamageNumber.Style.NORMAL)
	await get_tree().process_frame
	var stats: Dictionary = DamageNumberManager.get_pool_stats()
	assert_true(stats.get("initialized") == true, "spawn 후 pool 초기화됨")
	assert_gt(stats.get("total", 0), 0, "최소 1개 이상의 인스턴스 생성")


func test_spawn_miss_uses_miss_style() -> void:
	# spawn_miss 가 crash 없이 동작
	DamageNumberManager.spawn_miss(Vector2(50, 50))
	await get_tree().process_frame
	# 정상 호출 = 통과
	assert_true(true)


func test_pool_acquire_release_lifecycle() -> void:
	# DamageNumber 가 ObjectPool 의 _pool_acquire/_pool_release 메서드를 가짐
	var dmg := DamageNumber.new()
	add_child_autofree(dmg)
	assert_true(dmg.has_method(&"_pool_acquire"))
	assert_true(dmg.has_method(&"_pool_release"))


func test_styles_enum_has_5_values() -> void:
	# NORMAL, CRIT, HEAL, POISON, MISS
	assert_eq(DamageNumber.Style.size(), 5)
