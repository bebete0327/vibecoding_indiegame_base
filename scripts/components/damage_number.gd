## 데미지 숫자 플로터 — 적/플레이어 위에 떠오르며 페이드아웃하는 라벨.
##
## ObjectPool 에 친화적 (`_pool_acquire`, `_pool_release` 메서드 구현됨).
## 자주 spawn 되므로 `DamageNumberManager` 가 관리하는 풀로 사용 권장.
##
## ## 단독 사용 예
##
## ```gdscript
## var dmg := preload("res://scenes/effects/damage_number.tscn").instantiate() as DamageNumber
## get_tree().current_scene.add_child(dmg)
## dmg.spawn(global_position, 25, DamageNumber.Style.NORMAL)
## ```
##
## ## 풀 + 매니저 사용 예 (권장)
##
## ```gdscript
## # 씬 어디서든
## DamageNumberManager.spawn(enemy.global_position, 42, DamageNumber.Style.CRIT)
## ```
##
## ## 색상/스타일
##
## | Style | 색상 | 용도 |
## |-------|------|------|
## | NORMAL | 흰색 | 일반 데미지 |
## | CRIT | 노란색 + 큰 글씨 | 치명타 |
## | HEAL | 초록색 | 회복 |
## | POISON | 보라색 | 도트 데미지 |
## | MISS | 회색 | 빗나감 |
class_name DamageNumber
extends Node2D

enum Style { NORMAL, CRIT, HEAL, POISON, MISS }

const DEFAULT_DURATION: float = 0.9
const RISE_DISTANCE: float = 48.0
const HORIZONTAL_SPREAD: float = 24.0
const FONT_SIZE_NORMAL: int = 20
const FONT_SIZE_CRIT: int = 32

var _label: Label
var _tween: Tween
var _elapsed: float = 0.0


func _ready() -> void:
	# get_node_or_null 사용 — 코드 생성 시 (DamageNumber.new()) 자식 없어도 에러 안 남
	_label = get_node_or_null("Label") as Label
	if _label == null:
		# 씬 없이 코드로 인스턴스화한 경우 — Label 자동 생성
		_label = Label.new()
		_label.name = "Label"
		_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(_label)


## 위치/값/스타일 지정해서 시각 효과 시작.
func spawn(world_pos: Vector2, value: int, style: Style = Style.NORMAL, duration: float = DEFAULT_DURATION) -> void:
	global_position = world_pos
	_apply_style(value, style)
	_animate(duration)


## 풀에서 꺼낼 때 자동 호출.
func _pool_acquire() -> void:
	# 상태 리셋. spawn() 이 곧 호출될 거라 디테일은 거기서.
	modulate = Color.WHITE
	scale = Vector2.ONE
	if _label != null:
		_label.modulate = Color.WHITE


## 풀에 반납될 때 자동 호출.
func _pool_release() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_elapsed = 0.0


func _apply_style(value: int, style: Style) -> void:
	if _label == null:
		return
	var color: Color
	var size := FONT_SIZE_NORMAL
	var prefix := ""
	match style:
		Style.NORMAL:
			color = Color.WHITE
		Style.CRIT:
			color = Color(1.0, 0.85, 0.2)
			size = FONT_SIZE_CRIT
			prefix = "!"
		Style.HEAL:
			color = Color(0.4, 1.0, 0.5)
			prefix = "+"
		Style.POISON:
			color = Color(0.7, 0.4, 1.0)
		Style.MISS:
			color = Color(0.7, 0.7, 0.7)
			_label.text = "MISS"
			_label.add_theme_font_size_override(&"font_size", FONT_SIZE_NORMAL)
			_label.add_theme_color_override(&"font_color", color)
			return
	_label.text = "%s%d" % [prefix, absi(value)]
	_label.add_theme_font_size_override(&"font_size", size)
	_label.add_theme_color_override(&"font_color", color)
	# 시인성 위한 그림자
	_label.add_theme_color_override(&"font_shadow_color", Color(0, 0, 0, 0.7))
	_label.add_theme_constant_override(&"shadow_offset_x", 1)
	_label.add_theme_constant_override(&"shadow_offset_y", 1)


func _animate(duration: float) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	# 좌우 랜덤 분산해서 같은 위치 누적 시 가독성 ↑
	var spread_x := randf_range(-HORIZONTAL_SPREAD, HORIZONTAL_SPREAD)
	var start_pos := global_position
	var end_pos := start_pos + Vector2(spread_x, -RISE_DISTANCE)

	_tween = create_tween().set_parallel(true)
	# 위로 떠오름
	_tween.tween_property(self, "global_position", end_pos, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# 살짝 커졌다가 작아짐 (펀치 효과)
	_tween.tween_property(self, "scale", Vector2(1.2, 1.2), duration * 0.2).set_ease(Tween.EASE_OUT)
	_tween.chain().tween_property(self, "scale", Vector2(0.9, 0.9), duration * 0.8).set_ease(Tween.EASE_IN)
	# 끝에 페이드
	_tween.tween_property(self, "modulate:a", 0.0, duration * 0.5).set_delay(duration * 0.5)
	# 종료 시 자동 풀 반납 (META_POOL_KEY 있으면 풀에, 없으면 free)
	_tween.chain().tween_callback(_finish)


func _finish() -> void:
	if has_meta(ObjectPool.META_POOL_KEY):
		var pool: ObjectPool = get_meta(ObjectPool.META_POOL_KEY)
		pool.release(self)
	else:
		queue_free()
