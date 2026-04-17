## 게임 전역 상태 및 씬 전환 관리자.
## Autoload 이름: GameManager  (Project Settings → Autoload 에 등록됨)
##
## NOTE: Autoload 스크립트는 class_name 선언 안 함 (Autoload 이름과 충돌 방지).
extends Node

enum GameState {
	BOOT,
	MAIN_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER,
}

## 현재 게임 상태 — set 으로만 변경 (state_changed 시그널 자동 emit).
var state: GameState = GameState.BOOT:
	set(value):
		if value == state:
			return
		var previous := state
		state = value
		state_changed.emit(previous, value)

## 누적 점수 (예시). 필요 시 자유롭게 확장.
var score: int = 0:
	set(value):
		if value == score:
			return
		score = value
		EventBus.score_changed.emit(value)

signal state_changed(previous: GameState, current: GameState)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # PAUSED 상태에서도 동작


## 씬 전환 — 비동기 로드로 부드럽게 전환.
## EventBus.scene_transition_requested/completed 시그널도 함께 emit.
func change_scene(scene_path: String) -> void:
	assert(ResourceLoader.exists(scene_path), "Scene not found: %s" % scene_path)
	EventBus.scene_transition_requested.emit(scene_path)
	var err := get_tree().change_scene_to_file(scene_path)
	if err != OK:
		push_error("[GameManager] change_scene failed: %s (err=%d)" % [scene_path, err])
		return
	EventBus.scene_transition_completed.emit(scene_path)


## 게임 일시정지 토글. SceneTree.paused 를 변경하고 EventBus 에 알림.
func toggle_pause() -> void:
	var new_paused := not get_tree().paused
	get_tree().paused = new_paused
	state = GameState.PAUSED if new_paused else GameState.PLAYING
	EventBus.game_paused.emit(new_paused)


## 게임 시작.
func start_game() -> void:
	score = 0
	state = GameState.PLAYING
	EventBus.game_started.emit()


## 게임 오버 — reason 은 UI/리포팅에 활용.
func end_game(reason: StringName = &"default") -> void:
	state = GameState.GAME_OVER
	EventBus.game_over.emit(reason)
