## StateMachine + State 통합 테스트.
## 인라인 더미 State 서브클래스로 enter/exit/transition 동작을 확인.
extends GutTest

var _fsm: StateMachine
var _owner: Node
var _idle_calls: Array
var _move_calls: Array


func before_each() -> void:
	_idle_calls = []
	_move_calls = []
	_owner = Node.new()
	add_child_autofree(_owner)

	_fsm = StateMachine.new()
	_fsm.name = "StateMachine"
	_owner.add_child(_fsm)

	var idle := _make_tracking_state("IdleState", _idle_calls)
	_fsm.add_child(idle)
	var move := _make_tracking_state("MoveState", _move_calls)
	_fsm.add_child(move)

	_fsm.setup(_owner, &"IdleState")


func test_initial_state_enters() -> void:
	assert_eq(_fsm.current_state.name, "IdleState")
	assert_eq(_idle_calls, ["enter"])


func test_transition_to_exits_and_enters() -> void:
	_fsm.transition_to(&"MoveState")
	assert_eq(_fsm.current_state.name, "MoveState")
	assert_eq(_idle_calls, ["enter", "exit"])
	assert_eq(_move_calls, ["enter"])


func test_transition_to_same_state_is_noop() -> void:
	_fsm.transition_to(&"IdleState")
	assert_eq(_idle_calls, ["enter"], "같은 상태 재진입은 무시되어야 함")


func test_transition_emits_signal() -> void:
	watch_signals(_fsm)
	_fsm.transition_to(&"MoveState")
	assert_signal_emitted_with_parameters(_fsm, "state_changed", [&"IdleState", &"MoveState"])


# ----- 헬퍼 -----

func _make_tracking_state(state_name: String, log: Array) -> State:
	# State 를 직접 상속하는 게 이상적이지만 GDScript 인라인 서브클래싱 제약으로
	# State 를 new 한 뒤 필요한 훅을 시그널로 대체합니다.
	var s := _TrackingState.new()
	s.name = state_name
	s.log_target = log
	return s


class _TrackingState extends State:
	var log_target: Array
	func enter() -> void: log_target.append("enter")
	func exit() -> void: log_target.append("exit")
