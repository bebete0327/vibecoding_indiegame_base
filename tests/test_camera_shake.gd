## CameraShake 테스트 — trauma 누적/감쇠/오프셋 적용/리셋.
extends GutTest

var _camera: Camera2D
var _shake: CameraShake


func before_each() -> void:
	_camera = Camera2D.new()
	_shake = CameraShake.new()
	_camera.add_child(_shake)
	add_child_autofree(_camera)
	# add_child_autofree 후 _ready() 가 동기 실행됨 — await 불필요


func test_initial_trauma_is_zero() -> void:
	assert_eq(_shake.trauma, 0.0)


func test_add_trauma_clamps_to_one() -> void:
	_shake.add_trauma(0.7)
	_shake.add_trauma(0.7)
	assert_eq(_shake.trauma, 1.0, "trauma > 1.0 클램프")


func test_add_trauma_negative_safe() -> void:
	_shake.trauma = 0.5
	_shake.add_trauma(-1.0)
	assert_eq(_shake.trauma, 0.0, "음수 누적 시 0 으로 클램프")


func test_decay_reduces_trauma_over_time() -> void:
	_shake.trauma_decay = 2.0
	_shake.trauma = 1.0
	# _process(0.1s) 한 프레임 → 0.2 감소
	_shake._process(0.1)
	assert_almost_eq(_shake.trauma, 0.8, 0.01, "trauma 감쇠 적용")


func test_reset_zeros_trauma() -> void:
	_shake.trauma = 0.8
	_shake.reset()
	assert_eq(_shake.trauma, 0.0)


func test_offset_applied_when_trauma_active() -> void:
	_shake.trauma = 1.0
	_shake._process(0.05)
	# offset 이 0,0 에서 변했어야 함 (trauma² · max_offset · noise)
	assert_ne(_camera.offset, Vector2.ZERO, "trauma 활성 시 카메라 offset 변경")


func test_disabled_does_nothing() -> void:
	_shake.enabled = false
	_shake.trauma = 1.0
	_shake._process(0.1)
	assert_eq(_camera.offset, Vector2.ZERO, "enabled=false 면 offset 안 건드림")
