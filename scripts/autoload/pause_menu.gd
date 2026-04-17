## 기본 일시정지 메뉴 — Esc 로 토글.
## Autoload 이름: PauseMenu
##
## `pause` 액션 (기본 Esc / 게임패드 Select) 입력 감지 → GameManager.toggle_pause() 호출.
## EventBus.game_paused 수신 → 메뉴 보이기/숨기기.
##
## 이 메뉴는 MVP. 실제 게임에선 이걸 상속/교체해서 "이어하기 / 설정 / 종료" 버튼 추가:
##   - 이 스크립트의 _build_ui() 를 오버라이드
##   - 또는 PauseMenu 자체를 자신의 UI 로 교체 (project.godot autoload 경로 변경)
extends CanvasLayer

var _panel: Panel
var _label: Label
var _can_pause: bool = true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 50
	_build_ui()
	visible = false

	if is_instance_valid(EventBus):
		EventBus.game_paused.connect(_on_game_paused)


func _unhandled_input(event: InputEvent) -> void:
	if not _can_pause:
		return
	if event.is_action_pressed(&"pause"):
		if is_instance_valid(GameManager):
			GameManager.toggle_pause()
			get_viewport().set_input_as_handled()


## 서브클래스가 오버라이드해서 UI 를 커스터마이즈.
func _build_ui() -> void:
	_panel = Panel.new()
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.custom_minimum_size = Vector2(320, 180)
	_panel.position = Vector2(-160, -90)
	add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override(&"separation", 16)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_panel.add_child(vbox)

	_label = Label.new()
	_label.text = "⏸  PAUSED"
	_label.add_theme_font_size_override(&"font_size", 28)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_label)

	var hint := Label.new()
	hint.text = "Press ESC to resume"
	hint.add_theme_font_size_override(&"font_size", 14)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.modulate = Color(1, 1, 1, 0.6)
	vbox.add_child(hint)


func _on_game_paused(is_paused: bool) -> void:
	visible = is_paused


## 특정 상황 (인트로/컷씬 중) 에 일시정지 막기.
func set_can_pause(value: bool) -> void:
	_can_pause = value
