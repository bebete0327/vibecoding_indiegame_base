## 글로벌 시그널 허브 (Signal Bus 패턴).
## 서로 모르는 노드들 사이의 느슨한 결합을 위해 사용합니다.
## Autoload 이름: EventBus  (Project Settings → Autoload 에 등록됨)
##
## 사용 예:
##   EventBus.game_started.emit()
##   EventBus.score_changed.connect(_on_score_changed)
##
## NOTE: Autoload 스크립트는 class_name 선언 안 함 (Autoload 이름과 충돌 방지).
extends Node

## 게임 라이프사이클
signal game_started
signal game_paused(is_paused: bool)
signal game_over(reason: StringName)

## 점수/진행도
signal score_changed(new_score: int)

## 씬 전환
signal scene_transition_requested(target_scene_path: String)
signal scene_transition_completed(scene_path: String)

## 플레이어 상태 (공용)
signal player_damaged(amount: int)
signal player_died
signal player_respawned
