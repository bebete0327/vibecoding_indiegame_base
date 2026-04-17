## HealthComponent 테스트 — 데미지/힐/사망/무적 처리.
extends GutTest

var _hc: HealthComponent


func before_each() -> void:
	_hc = HealthComponent.new()
	_hc.max_health = 100
	add_child_autofree(_hc)


func test_starts_full() -> void:
	assert_eq(_hc.current_health, 100)
	assert_true(_hc.is_alive)


func test_take_damage_reduces_health() -> void:
	_hc.take_damage(30)
	assert_eq(_hc.current_health, 70)


func test_damage_clamps_to_zero_and_emits_died() -> void:
	watch_signals(_hc)
	_hc.take_damage(9999)
	assert_eq(_hc.current_health, 0)
	assert_false(_hc.is_alive)
	assert_signal_emitted(_hc, "died")


func test_heal_respects_max() -> void:
	_hc.take_damage(50)
	_hc.heal(999)
	assert_eq(_hc.current_health, 100)


func test_invulnerable_blocks_damage() -> void:
	_hc.invulnerable = true
	_hc.take_damage(50)
	assert_eq(_hc.current_health, 100)


func test_dead_cannot_be_damaged_or_healed() -> void:
	_hc.take_damage(9999)
	_hc.heal(50)
	assert_eq(_hc.current_health, 0, "죽은 상태에서 힐은 무시 (revive 로만 부활)")


func test_revive_restores_health() -> void:
	_hc.take_damage(9999)
	_hc.revive()
	assert_eq(_hc.current_health, 100)
	assert_true(_hc.is_alive)


func test_health_changed_signal() -> void:
	watch_signals(_hc)
	_hc.take_damage(25)
	assert_signal_emitted_with_parameters(_hc, "health_changed", [75, 100])
