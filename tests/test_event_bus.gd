## EventBus autoload 테스트.
## 새 시그널 추가 시 여기에 케이스를 늘려가세요.
extends GutTest


func test_event_bus_autoload_exists() -> void:
	assert_not_null(EventBus, "EventBus Autoload 가 등록되어 있어야 함")


func test_score_changed_signal_fires() -> void:
	watch_signals(EventBus)
	EventBus.score_changed.emit(42)
	assert_signal_emitted_with_parameters(EventBus, "score_changed", [42])


func test_game_paused_signal_carries_bool() -> void:
	watch_signals(EventBus)
	EventBus.game_paused.emit(true)
	assert_signal_emitted_with_parameters(EventBus, "game_paused", [true])


func test_connect_and_receive() -> void:
	var received: Array = []
	var cb := func(new_score: int) -> void: received.append(new_score)
	EventBus.score_changed.connect(cb)
	EventBus.score_changed.emit(100)
	EventBus.score_changed.emit(200)
	EventBus.score_changed.disconnect(cb)
	assert_eq(received, [100, 200])
