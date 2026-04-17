## Project entry point — 2D/3D 중립 스텁.
##
## 첫 실행 시: 환영 화면 + 자가진단 결과 표시. 사용자는 이 스크립트를 수정해서
## 실제 게임 루트 씬을 load/instantiate 합니다.
## docs/TEMPLATE_GUIDE.md 와 docs/START_HERE.md 를 먼저 읽기 권장.
class_name Main
extends Node

const GAME_TITLE: String = "Godot Vibe Template"


func _ready() -> void:
	_print_banner()
	_build_welcome_ui()

	# 에디터 빌드에서만 자가진단 실행 (릴리스에선 스킵)
	if OS.has_feature("editor"):
		HealthCheck.run()

	# TODO: 여기에서 실제 게임 루트 씬을 추가하세요.
	# 예시:
	#   await get_tree().create_timer(1.0).timeout
	#   GameManager.change_scene("res://scenes/world_2d.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump") or event.is_action_pressed(&"interact"):
		print("[Main] `ui_accept` pressed — load your game scene via GameManager.change_scene()")


func _print_banner() -> void:
	print("══════════════════════════════════════════")
	print("  %s" % GAME_TITLE)
	print("  • 시작 가이드: docs/START_HERE.md")
	print("  • 워크플로 결정: docs/WORKFLOW.md")
	print("  • 템플릿 가이드: docs/TEMPLATE_GUIDE.md")
	print("  • F3 로 디버그 HUD · F9 로 스크린샷 · Esc 로 일시정지")
	print("══════════════════════════════════════════")


func _build_welcome_ui() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override(&"separation", 18)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	var title := Label.new()
	title.text = "🎮  %s" % GAME_TITLE
	title.add_theme_font_size_override(&"font_size", 42)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Template loaded. Replace this screen with your game."
	subtitle.add_theme_font_size_override(&"font_size", 16)
	subtitle.add_theme_color_override(&"font_color", Color(1, 1, 1, 0.7))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle)

	var hints := Label.new()
	hints.text = "Edit scripts/main.gd  |  See docs/START_HERE.md  |  F3 toggle HUD"
	hints.add_theme_font_size_override(&"font_size", 13)
	hints.add_theme_color_override(&"font_color", Color(0.5, 0.9, 0.6, 0.9))
	hints.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(hints)
