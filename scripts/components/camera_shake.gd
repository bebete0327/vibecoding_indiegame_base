## 카메라 흔들림 — 데미지/폭발/임팩트 시 game feel 개선.
##
## Camera2D 의 자식 노드로 배치. trauma 값(0..1) 을 누적하면 자동으로 진동 + 시간에 따라 감쇠.
## 충돌/타격 시 `add_trauma(0.5)` 한 번 호출하면 끝.
##
## ## 사용 예
##
## ```gdscript
## # 씬 트리:
## #   World (Node2D)
## #   └── Camera2D
## #       └── CameraShake
##
## @onready var shake: CameraShake = $Camera2D/CameraShake
##
## func _on_player_damaged(amount: int) -> void:
##     shake.add_trauma(remap(amount, 0, 100, 0.2, 0.8))
##
## func _on_explosion() -> void:
##     shake.add_trauma(0.7)
## ```
##
## ## 알고리즘
##
## "Trauma squared" 패턴 (GDC 2019, Squirrel Eiserloh).
## - trauma: 누적값 (0..1)
## - shake = trauma² → 더 강한 입력일수록 더 격렬, 약한 입력은 부드러움
## - decay: trauma 가 매 초 자동 감소 (기본 1.0/sec)
## - 결과: offset(x,y) + rotation 을 카메라에 적용
class_name CameraShake
extends Node

const NOISE_PERIOD := 0.05  # 1프레임 ~ 50ms 간격으로 sample

@export_range(0.0, 5.0, 0.1) var max_offset: float = 16.0       # 픽셀
@export_range(0.0, 30.0, 0.5) var max_roll_deg: float = 8.0     # 회전 각도
@export_range(0.5, 5.0, 0.1) var trauma_decay: float = 1.5      # 초당 감소량
@export var enabled: bool = true

## 외부에서 add_trauma() 로만 변경. 직접 set 도 가능하지만 권장 안 함.
var trauma: float = 0.0:
	set(value):
		trauma = clampf(value, 0.0, 1.0)

var _camera: Camera2D
var _time_accum: float = 0.0
var _last_offset: Vector2 = Vector2.ZERO
var _last_rotation: float = 0.0
var _seed_x: int
var _seed_y: int
var _seed_r: int


func _ready() -> void:
	# Camera2D 부모 자동 탐색 (씬 구조: Camera2D > CameraShake)
	if get_parent() is Camera2D:
		_camera = get_parent()
	else:
		# fallback: 트리 위로 탐색
		var node: Node = get_parent()
		while node != null:
			if node is Camera2D:
				_camera = node
				break
			node = node.get_parent()
	if _camera == null:
		push_warning("[CameraShake] Camera2D 부모 없음 — 비활성")
		enabled = false
	# 매 인스턴스마다 다른 noise seed
	_seed_x = randi()
	_seed_y = randi()
	_seed_r = randi()


func _process(delta: float) -> void:
	if not enabled or _camera == null:
		return
	# trauma 자연 감쇠
	if trauma > 0.0:
		trauma = maxf(trauma - trauma_decay * delta, 0.0)

	# 이전 흔들림 제거 (다른 시스템이 카메라 offset 건드릴 수 있으므로 누적 방지)
	_camera.offset -= _last_offset
	_camera.rotation -= _last_rotation

	if trauma <= 0.0:
		_last_offset = Vector2.ZERO
		_last_rotation = 0.0
		return

	# trauma² 패턴
	var amount := trauma * trauma
	_time_accum += delta
	var t := _time_accum / NOISE_PERIOD

	_last_offset = Vector2(
		max_offset * amount * _pseudo_noise(_seed_x, t),
		max_offset * amount * _pseudo_noise(_seed_y, t),
	)
	_last_rotation = deg_to_rad(max_roll_deg * amount * _pseudo_noise(_seed_r, t))

	_camera.offset += _last_offset
	_camera.rotation += _last_rotation


## trauma 누적. 같은 프레임에 여러 번 add 해도 1.0 으로 클램프됨.
func add_trauma(amount: float) -> void:
	trauma = trauma + amount


## 즉시 멈춤 (컷씬 시작 등).
func reset() -> void:
	trauma = 0.0
	if _camera != null:
		_camera.offset -= _last_offset
		_camera.rotation -= _last_rotation
	_last_offset = Vector2.ZERO
	_last_rotation = 0.0


## 내부 — Perlin 흉내 (실제 Perlin 도 좋지만 의존성 줄이려고 sin+seed 조합).
## -1 ~ +1 범위.
func _pseudo_noise(seed_value: int, t: float) -> float:
	# 다중 주파수 sin 조합으로 자연스러운 흔들림
	return sin(t * 6.28318 + float(seed_value % 1000)) * 0.6 + sin(t * 13.0 + float(seed_value % 333)) * 0.4
