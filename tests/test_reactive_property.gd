## ReactiveProperty 테스트 — 값 변경 감지, 초기 emit, 구독 해제.
extends GutTest


func test_initial_value() -> void:
	var p := ReactiveProperty.new(100)
	assert_eq(p.value, 100)


func test_set_different_value_emits_changed() -> void:
	var p := ReactiveProperty.new(0)
	var received: Array = []
	p.changed.connect(func(new_value: Variant, old: Variant) -> void:
		received.append([new_value, old])
	)
	p.value = 1
	p.value = 2
	assert_eq(received, [[1, 0], [2, 1]])


func test_set_same_value_does_not_emit() -> void:
	var p := ReactiveProperty.new(5)
	# int 는 람다에서 값 복사로 캡처되므로 카운터는 Array 로.
	var hits: Array = []
	p.changed.connect(func(_n: Variant, _o: Variant) -> void: hits.append(1))
	p.value = 5
	p.value = 5
	assert_eq(hits.size(), 0)


func test_subscribe_with_emit_initial() -> void:
	var p := ReactiveProperty.new("hello")
	var received: Array = []
	p.subscribe(func(v: Variant) -> void: received.append(v), true)
	assert_eq(received, ["hello"])
	p.value = "world"
	assert_eq(received, ["hello", "world"])


func test_unsubscribe_stops_emission() -> void:
	var p := ReactiveProperty.new(0)
	var hits: Array = []
	var unsub := p.subscribe(func(_v: Variant) -> void: hits.append(1), false)
	p.value = 1
	unsub.call()
	p.value = 2
	assert_eq(hits.size(), 1, "구독 해제 후에는 호출되지 않아야 함")
