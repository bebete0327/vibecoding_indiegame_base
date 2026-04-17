## BGM / SFX 재생 관리자.
## Autoload 이름: AudioManager
##
## BGM 은 하나의 전용 플레이어로 재생 (크로스페이드 지원).
## SFX 는 풀에서 꺼내 재생 (동시 다발 재생 가능).
##
## 사용 예:
##   AudioManager.play_bgm(preload("res://assets/audio/bgm/menu.ogg"))
##   AudioManager.play_sfx(preload("res://assets/audio/sfx/click.wav"))
##
## NOTE: Autoload 스크립트는 class_name 선언 안 함.
extends Node

const SFX_POOL_SIZE: int = 8
const CROSSFADE_DURATION: float = 0.8

@export_range(0.0, 1.0) var master_volume: float = 1.0:
	set(value):
		master_volume = clampf(value, 0.0, 1.0)
		_apply_bus_volume(&"Master", master_volume)

@export_range(0.0, 1.0) var bgm_volume: float = 0.7:
	set(value):
		bgm_volume = clampf(value, 0.0, 1.0)
		if _bgm_player:
			_bgm_player.volume_db = linear_to_db(bgm_volume)

@export_range(0.0, 1.0) var sfx_volume: float = 1.0:
	set(value):
		sfx_volume = clampf(value, 0.0, 1.0)

var _bgm_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _current_bgm: AudioStream


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = &"Master"
	_bgm_player.volume_db = linear_to_db(bgm_volume)
	add_child(_bgm_player)

	for i in SFX_POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.bus = &"Master"
		add_child(p)
		_sfx_pool.append(p)


func play_bgm(stream: AudioStream, fade: bool = true) -> void:
	if stream == _current_bgm and _bgm_player.playing:
		return
	_current_bgm = stream
	if fade and _bgm_player.playing:
		var tween := create_tween()
		tween.tween_property(_bgm_player, "volume_db", linear_to_db(0.0001), CROSSFADE_DURATION * 0.5)
		tween.tween_callback(func() -> void:
			_bgm_player.stream = stream
			_bgm_player.play()
		)
		tween.tween_property(_bgm_player, "volume_db", linear_to_db(bgm_volume), CROSSFADE_DURATION * 0.5)
	else:
		_bgm_player.stream = stream
		_bgm_player.play()


func stop_bgm() -> void:
	_bgm_player.stop()
	_current_bgm = null


func play_sfx(stream: AudioStream, pitch_range: Vector2 = Vector2(1.0, 1.0)) -> void:
	var player := _get_free_sfx_player()
	if player == null:
		return
	player.stream = stream
	player.volume_db = linear_to_db(sfx_volume)
	player.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	player.play()


func _get_free_sfx_player() -> AudioStreamPlayer:
	for p in _sfx_pool:
		if not p.playing:
			return p
	return null


func _apply_bus_volume(bus_name: StringName, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(linear, 0.0001)))
