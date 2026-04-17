## GUT 스모크 테스트 — 러너가 비어있지 않게 유지하는 최소 테스트.
## 새 게임 기능 테스트는 tests/test_<feature>.gd 로 추가하세요.
extends GutTest


func test_gut_framework_loads() -> void:
	assert_true(true, "GUT 러너가 정상 작동함")


func test_godot_engine_runs() -> void:
	assert_not_null(Engine, "Godot Engine 싱글톤 접근 가능")
	assert_true(Engine.get_version_info().major >= 4, "Godot 4 이상")
