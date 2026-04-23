## SpineSprite 를 감싸는 편의 컴포넌트.
## State Machine / EventBus 와 자연스럽게 연동되도록 일반 시그널로 재노출.
##
## 씬 구조:
##   Character (Node2D)
##   ├── SpineSprite                      ← Spine 런타임 노드 (실제 애니메이션 재생)
##   └── SpineAnimationComponent          ← 이 스크립트 (제어 API)
##
## 사용 예:
##   @onready var anim: SpineAnimationComponent = $SpineAnimationComponent
##
##   func _ready() -> void:
##       anim.spine_sprite = $SpineSprite
##       anim.play("idle", true)
##       anim.queued_anim_finished.connect(_on_finished)
##
##   func take_damage() -> void:
##       anim.play_then_return("hurt", "idle")
##
## Spine 에셋 (.skel/.atlas/.png) 은 `assets/spine/<character>/` 에 두고
## 에디터에서 SpineSkeletonDataResource 를 만들어 SpineSprite 에 연결하세요.
## 자세한 설정: docs/SPINE.md
class_name SpineAnimationComponent
extends Node

## SpineSprite (필수) — 인스펙터에서 직접 지정하거나 _ready() 에서 주입.
@export var spine_sprite: Node  # SpineSprite 타입이지만 런타임 미설치 시 에러 회피 위해 Node.

## 기본 재생 트랙 번호.
@export_range(0, 3) var default_track: int = 0

signal animation_started(anim_name: StringName, track: int)
signal animation_completed(anim_name: StringName, track: int)
signal queued_anim_finished(anim_name: StringName)


func _ready() -> void:
	if spine_sprite == null:
		spine_sprite = _find_sibling_spine_sprite()
	if spine_sprite == null:
		# 설정 누락은 에러 아닌 경고 — 런타임 중 spine_sprite 를 나중에 할당하는 워크플로 허용
		push_warning("[SpineAnimationComponent] SpineSprite 미연결 — 인스펙터에서 spine_sprite 지정 또는 형제 노드로 SpineSprite 배치")
		return
	_connect_signals()


func _find_sibling_spine_sprite() -> Node:
	if get_parent() == null:
		return null
	for child in get_parent().get_children():
		if child.get_class() == "SpineSprite":
			return child
	return null


func _connect_signals() -> void:
	if not ClassDB.class_exists("SpineSprite"):
		push_warning("[SpineAnimationComponent] Spine 런타임 미설치 — 시그널 연결 스킵")
		return
	# SpineSprite 의 animation_started / animation_completed 시그널을 재노출.
	if spine_sprite.has_signal("animation_started"):
		spine_sprite.animation_started.connect(_on_spine_started)
	if spine_sprite.has_signal("animation_completed"):
		spine_sprite.animation_completed.connect(_on_spine_completed)


## 애니메이션 재생. loop=true 이면 반복.
func play(anim_name: StringName, loop: bool = false, track: int = -1) -> void:
	if spine_sprite == null:
		return
	var t := track if track >= 0 else default_track
	# SpineSprite.animation_state.set_animation(name, loop, track)
	var anim_state: Object = spine_sprite.get("animation_state")
	if anim_state:
		anim_state.set_animation(String(anim_name), loop, t)


## 애니메이션을 한 번 재생한 뒤 return_to 로 전환.
func play_then_return(anim_name: StringName, return_to: StringName, track: int = -1) -> void:
	if spine_sprite == null:
		return
	var t := track if track >= 0 else default_track
	var anim_state: Object = spine_sprite.get("animation_state")
	if anim_state:
		anim_state.set_animation(String(anim_name), false, t)
		anim_state.add_animation(String(return_to), 0.0, true, t)


## 현재 트랙 중지.
func stop(track: int = -1) -> void:
	if spine_sprite == null:
		return
	var t := track if track >= 0 else default_track
	var anim_state: Object = spine_sprite.get("animation_state")
	if anim_state:
		anim_state.set_empty_animation(t, 0.1)


## Spine 이 제공하는 애니메이션 이름 전체 목록 (디버그/툴링용).
func list_animations() -> Array[String]:
	var out: Array[String] = []
	if spine_sprite == null:
		return out
	var skel_data: Object = spine_sprite.get("skeleton_data_res")
	if skel_data == null:
		return out
	var skel_internal: Object = skel_data.call("get_skeleton_data")
	if skel_internal == null:
		return out
	var anims: Variant = skel_internal.call("get_animations")
	if anims is Array:
		for a in anims:
			out.append(str(a.call("get_name")))
	return out


# ===== 내부 시그널 재노출 =====

func _on_spine_started(track_entry: Object) -> void:
	if track_entry == null:
		return
	var anim_name := _get_track_anim_name(track_entry)
	var track := int(track_entry.call("get_track_index"))
	animation_started.emit(anim_name, track)


func _on_spine_completed(track_entry: Object) -> void:
	if track_entry == null:
		return
	var anim_name := _get_track_anim_name(track_entry)
	var track := int(track_entry.call("get_track_index"))
	animation_completed.emit(anim_name, track)


func _get_track_anim_name(track_entry: Object) -> StringName:
	var anim: Object = track_entry.call("get_animation")
	if anim == null:
		return &""
	return StringName(str(anim.call("get_name")))
