## 값 변경 시 구독자에게 알리는 반응형 프로퍼티.
## UI 데이터 바인딩, 상태 관찰 등에 사용.
##
## 사용 예:
##   var health := ReactiveProperty.new(100)
##   health.subscribe(func(v: Variant) -> void: health_bar.value = v, true)
##   health.value -= 10  # 구독자 자동 호출
##
## 현재 값이 이전 값과 같으면 알림은 생략됩니다.
class_name ReactiveProperty
extends RefCounted

signal changed(new_value: Variant, old_value: Variant)

var value: Variant:
	set(new_value):
		if typeof(new_value) == typeof(value) and new_value == value:
			return
		var old := value
		value = new_value
		changed.emit(new_value, old)


func _init(initial_value: Variant = null) -> void:
	value = initial_value


## 구독 — emit_initial=true 이면 현재 값으로 즉시 한 번 호출.
## 반환값: 해제용 Callable. `var unsub := prop.subscribe(cb)` 후 `unsub.call()` 로 해제.
func subscribe(callback: Callable, emit_initial: bool = false) -> Callable:
	var wrapper := func(new_value: Variant, _old: Variant) -> void:
		callback.call(new_value)
	changed.connect(wrapper)
	if emit_initial:
		callback.call(value)
	return func() -> void:
		if changed.is_connected(wrapper):
			changed.disconnect(wrapper)
