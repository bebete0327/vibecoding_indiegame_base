## SaveManager 저장/로드 라운드트립 테스트.
## 실제 파일 시스템(user://saves/)을 사용하므로 테스트 슬롯을 격리해서 씁니다.
extends GutTest

const TEST_SLOT: int = 999


func before_each() -> void:
	SaveManager.delete_save(TEST_SLOT)


func after_all() -> void:
	SaveManager.delete_save(TEST_SLOT)


func test_save_and_load_roundtrip() -> void:
	var data := {"score": 42, "player_name": "Tester", "items": ["sword", "shield"]}
	assert_true(SaveManager.save_data(data, TEST_SLOT), "저장 성공")
	var loaded: Dictionary = SaveManager.load_data(TEST_SLOT)
	# JSON 은 number 만 있으므로 int 가 float 로 복원됨 — 의도된 동작.
	assert_eq(int(loaded.get("score")), 42)
	assert_eq(loaded.get("player_name"), "Tester")
	assert_eq(loaded.get("items"), ["sword", "shield"])


func test_load_nonexistent_slot_returns_empty() -> void:
	var loaded: Dictionary = SaveManager.load_data(TEST_SLOT)
	assert_eq(loaded, {})


func test_has_save_reflects_existence() -> void:
	assert_false(SaveManager.has_save(TEST_SLOT))
	SaveManager.save_data({"x": 1}, TEST_SLOT)
	assert_true(SaveManager.has_save(TEST_SLOT))


func test_delete_save_removes_file() -> void:
	SaveManager.save_data({"x": 1}, TEST_SLOT)
	assert_true(SaveManager.delete_save(TEST_SLOT))
	assert_false(SaveManager.has_save(TEST_SLOT))


func test_save_completed_signal_fires() -> void:
	watch_signals(SaveManager)
	SaveManager.save_data({"x": 1}, TEST_SLOT)
	assert_signal_emitted_with_parameters(SaveManager, "save_completed", [TEST_SLOT, true])
