## 템플릿 자가진단 — 설정이 올바른지 한 번에 확인.
##
## 실행 방법:
##   1. 에디터에서: 게임 실행하면 main.gd 가 자동 호출 (에디터 빌드일 때만)
##   2. 헤드리스: "$GODOT_PATH" --headless --path . --script res://scripts/dev_tools/health_check.gd
##
## 체크 항목:
##   - Godot 버전 >= 4.6
##   - 필수 Autoload 6개 (EventBus, GameManager, AudioManager, SaveManager, ServiceLocator, DebugHUD)
##   - Input map 8개 액션
##   - 스크린샷 디렉토리 생성 가능
class_name HealthCheck
extends SceneTree


const REQUIRED_AUTOLOADS: Array[String] = [
	"EventBus", "GameManager", "AudioManager", "SaveManager",
	"ServiceLocator", "DebugHUD", "FadeTransition", "PauseMenu",
	"Screenshot_Capture",
]

const REQUIRED_ACTIONS: Array[StringName] = [
	&"move_left", &"move_right", &"move_up", &"move_down",
	&"jump", &"interact", &"attack", &"pause",
]

const MIN_GODOT_MAJOR: int = 4
const MIN_GODOT_MINOR: int = 6


static func run() -> bool:
	var all_ok := true
	print("══════════════════════════════════════════")
	print("  Godot Vibe Template — Health Check")
	print("══════════════════════════════════════════")

	# 1. Godot 버전
	var info := Engine.get_version_info()
	if info.major >= MIN_GODOT_MAJOR and info.minor >= MIN_GODOT_MINOR:
		print("  ✓ Godot %d.%d (required ≥ %d.%d)" % [info.major, info.minor, MIN_GODOT_MAJOR, MIN_GODOT_MINOR])
	else:
		print("  ✗ Godot %d.%d is too old (required ≥ %d.%d)" % [info.major, info.minor, MIN_GODOT_MAJOR, MIN_GODOT_MINOR])
		all_ok = false

	# 2. Input map
	var missing_actions: Array[StringName] = []
	for a in REQUIRED_ACTIONS:
		if not InputMap.has_action(a):
			missing_actions.append(a)
	if missing_actions.is_empty():
		print("  ✓ Input map — all %d actions present" % REQUIRED_ACTIONS.size())
	else:
		print("  ✗ Input map — missing: %s" % missing_actions)
		all_ok = false

	# 3. 스크린샷 디렉토리 쓰기 가능 (에디터 실행 시 프로젝트 루트, 아니면 user://)
	var ss_dir: String = ProjectSettings.globalize_path(
		"res://screenshots/" if OS.has_feature("editor") else "user://screenshots/"
	)
	var err := DirAccess.make_dir_recursive_absolute(ss_dir)
	if err == OK:
		print("  ✓ Screenshot dir writable: %s" % ss_dir)
	else:
		print("  ✗ Screenshot dir NOT writable (err=%d)" % err)
		all_ok = false

	# 4. Autoload 는 SceneTree 가 필요하므로 실행 모드에 따라 다르게 체크
	if Engine.get_main_loop() != null and Engine.get_main_loop() is SceneTree:
		var tree: SceneTree = Engine.get_main_loop()
		var missing_autoloads: Array[String] = []
		for al in REQUIRED_AUTOLOADS:
			if tree.root.get_node_or_null(NodePath(al)) == null:
				missing_autoloads.append(al)
		if missing_autoloads.is_empty():
			print("  ✓ Autoloads — all %d registered" % REQUIRED_AUTOLOADS.size())
		else:
			print("  ✗ Autoloads — missing: %s" % missing_autoloads)
			all_ok = false
	else:
		print("  - Autoload check skipped (no SceneTree available)")

	print("══════════════════════════════════════════")
	if all_ok:
		print("  RESULT: ✓ All checks passed")
	else:
		print("  RESULT: ✗ Some checks failed — see above")
	print("══════════════════════════════════════════")
	return all_ok


# 헤드리스 실행 지원: --script 로 이 파일을 직접 실행하면 SceneTree 로 구동
func _init() -> void:
	var ok := run()
	quit(0 if ok else 1)
