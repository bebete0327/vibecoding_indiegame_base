## 디버그 HUD — F3 키로 토글.
## Autoload 이름: DebugHUD
##
## 스크린샷 캡처 시 AI 가 FPS/메모리/노드 수를 즉시 보도록 화면 상단에 표시.
## 릴리스 빌드에선 자동 비활성 (OS.has_feature("editor") 체크).
##
## 토글 키 변경: CAPTURE_KEY 상수 변경. 표시 위치: 상단 좌측.
extends CanvasLayer

const TOGGLE_KEY: Key = KEY_F3
const FONT_SIZE: int = 14
const PAD: Vector2 = Vector2(8, 6)

@export var enabled: bool = true

var _label: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100  # 다른 UI 위에
	_label = Label.new()
	_label.add_theme_font_size_override(&"font_size", FONT_SIZE)
	_label.add_theme_color_override(&"font_color", Color(0.0, 1.0, 0.4))
	_label.add_theme_color_override(&"font_shadow_color", Color(0, 0, 0, 0.8))
	_label.add_theme_constant_override(&"shadow_offset_x", 1)
	_label.add_theme_constant_override(&"shadow_offset_y", 1)
	_label.position = PAD
	add_child(_label)
	visible = enabled


func _process(_delta: float) -> void:
	if not visible:
		return
	var fps := Engine.get_frames_per_second()
	var mem_mb := int(OS.get_static_memory_usage()) >> 20
	var nodes := get_tree().get_node_count()
	var ver: String = Engine.get_version_info().string
	_label.text = "FPS: %d  |  MEM: %d MB  |  NODES: %d  |  GODOT: %s" % [fps, mem_mb, nodes, ver]


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == TOGGLE_KEY:
		enabled = not enabled
		visible = enabled
