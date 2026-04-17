## State 베이스 클래스 — StateMachine 의 자식 노드로 배치.
## 구체 상태는 이 클래스를 상속하여 enter/exit/update/physics_update 를 오버라이드합니다.
##
## 예:
##   class_name IdleState
##   extends State
##
##   func enter() -> void:
##       owner_actor.play_animation(&"idle")
class_name State
extends Node

## 이 상태를 소유한 액터 노드 (StateMachine 이 주입).
var owner_actor: Node


## 상태 진입 시 호출.
func enter() -> void:
	pass


## 상태 종료 시 호출.
func exit() -> void:
	pass


## 매 프레임 update — StateMachine 의 _process 에서 호출.
func update(_delta: float) -> void:
	pass


## 물리 프레임 update — StateMachine 의 _physics_process 에서 호출.
func physics_update(_delta: float) -> void:
	pass


## 입력 처리 — StateMachine 의 _unhandled_input 에서 호출.
func handle_input(_event: InputEvent) -> void:
	pass
