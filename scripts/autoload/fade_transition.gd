## 씬 전환 페이드 효과.
## Autoload 이름: FadeTransition
##
## GameManager.change_scene() 호출 시 자동으로 페이드 인/아웃.
## 직접 호출도 가능: `await FadeTransition.fade_out()` / `await FadeTransition.fade_in()`
##
## EventBus 연결 → scene_transition_requested 때 페이드 아웃, completed 때 페이드 인.
extends CanvasLayer

const FADE_DURATION: float = 0.4
const FADE_COLOR: Color = Color.BLACK

var _rect: ColorRect
var _tween: Tween


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 99  # DebugHUD(100) 아래, 일반 UI 위
	_rect = ColorRect.new()
	_rect.color = FADE_COLOR
	_rect.modulate.a = 0.0
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_rect)

	if is_instance_valid(EventBus):
		EventBus.scene_transition_requested.connect(_on_scene_transition_requested)
		EventBus.scene_transition_completed.connect(_on_scene_transition_completed)


func fade_out(duration: float = FADE_DURATION) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_rect, "modulate:a", 1.0, duration)
	await _tween.finished


func fade_in(duration: float = FADE_DURATION) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_rect, "modulate:a", 0.0, duration)
	await _tween.finished


func _on_scene_transition_requested(_path: String) -> void:
	fade_out()


func _on_scene_transition_completed(_path: String) -> void:
	fade_in()
