## Project entry point — 2D/3D 중립 스텁.
## 새 게임을 시작할 때 여기에서 루트 게임 씬을 load/instantiate 하세요.
## docs/TEMPLATE_GUIDE.md 를 먼저 읽고 시작하는 것을 권장합니다.
class_name Main
extends Node


func _ready() -> void:
	print("══════════════════════════════════════════")
	print("  Godot Vibe Template")
	print("  • 설치 가이드: docs/SETUP.md")
	print("  • 시작 가이드: docs/TEMPLATE_GUIDE.md")
	print("══════════════════════════════════════════")
	# TODO: 여기에서 게임 루트 씬을 추가하세요.
	# 예시:
	#   var game: Node = load("res://scenes/your_game.tscn").instantiate()
	#   add_child(game)
