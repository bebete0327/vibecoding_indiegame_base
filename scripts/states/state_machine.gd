## 단순 계층적 상태 기계 — State 노드들을 자식으로 갖고, 하나의 활성 상태를 유지.
##
## 씬 트리 예:
##   Player (CharacterBody2D)
##   └── StateMachine
##       ├── IdleState (extends State)
##       ├── MoveState (extends State)
##       └── JumpState (extends State)
##
## 사용 예:
##   @onready var fsm: StateMachine = $StateMachine
##   func _ready() -> void:
##       fsm.setup(self, &"IdleState")
##   func _on_attack_pressed() -> void:
##       fsm.transition_to(&"AttackState")
class_name StateMachine
extends Node

signal state_changed(previous: StringName, current: StringName)

var current_state: State
var _states: Dictionary[StringName, State] = {}
var _owner_actor: Node


## 상태들을 자식 노드에서 수집하고 초기 상태로 진입.
func setup(owner_actor: Node, initial_state_name: StringName) -> void:
	_owner_actor = owner_actor
	for child in get_children():
		if child is State:
			var s := child as State
			s.owner_actor = owner_actor
			_states[s.name] = s
	assert(_states.has(initial_state_name),
		"Initial state not found: %s (available: %s)" % [initial_state_name, _states.keys()])
	current_state = _states[initial_state_name]
	current_state.enter()


func transition_to(state_name: StringName) -> void:
	if not _states.has(state_name):
		push_error("[StateMachine] Unknown state: %s" % state_name)
		return
	var next := _states[state_name]
	if next == current_state:
		return
	var previous_name: StringName = current_state.name if current_state else &""
	if current_state:
		current_state.exit()
	current_state = next
	current_state.enter()
	state_changed.emit(previous_name, state_name)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
