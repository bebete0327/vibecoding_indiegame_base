## Spine Godot GDExtension 런타임 검증 테스트.
##
## 이 테스트는 `bin/spine_godot_extension.gdextension` 이 올바르게 로드되어
## SpineSprite/SpineAtlasResource/SpineSkeletonDataResource 등의 클래스를 사용할 수
## 있는지 확인합니다. 실제 Spine 에셋 (.skel/.atlas) 이 없어도 돌아갑니다.
##
## 만약 이 테스트가 실패하면:
##   `bash scripts/dev_tools/install_spine_runtime.sh` 실행 후 Godot 재시작.
extends GutTest


const REQUIRED_CLASSES: Array[String] = [
	"SpineSkeletonDataResource",
	"SpineAtlasResource",
	"SpineSprite",
	"SpineAnimationState",
	"SpineSkeleton",
	"SpineBone",
	"SpineSlot",
	"SpineEvent",
	"SpineTrackEntry",
]


func test_spine_runtime_installed() -> void:
	assert_true(ClassDB.class_exists("SpineSprite"),
		"Spine 런타임 미설치 — `bash scripts/dev_tools/install_spine_runtime.sh` 실행 필요")


func test_all_core_classes_registered() -> void:
	var missing: Array[String] = []
	for cls in REQUIRED_CLASSES:
		if not ClassDB.class_exists(cls):
			missing.append(cls)
	assert_eq(missing, [] as Array[String],
		"누락된 Spine 클래스: %s" % str(missing))


func test_spine_sprite_extends_node2d() -> void:
	if not ClassDB.class_exists("SpineSprite"):
		pending("Spine 런타임 미설치")
		return
	var parent := ClassDB.get_parent_class("SpineSprite")
	assert_eq(parent, "Node2D", "SpineSprite 는 Node2D 를 상속해야 함 (2D 스프라이트)")


func test_atlas_resource_can_be_instantiated() -> void:
	if not ClassDB.class_exists("SpineAtlasResource"):
		pending("Spine 런타임 미설치")
		return
	var atlas: Object = ClassDB.instantiate(&"SpineAtlasResource")
	assert_not_null(atlas, "SpineAtlasResource.new() 가 가능해야 함")
	if atlas != null:
		assert_true(atlas is Resource, "SpineAtlasResource 는 Resource 여야 함")


func test_skeleton_data_resource_can_be_instantiated() -> void:
	if not ClassDB.class_exists("SpineSkeletonDataResource"):
		pending("Spine 런타임 미설치")
		return
	var data: Object = ClassDB.instantiate(&"SpineSkeletonDataResource")
	assert_not_null(data)
	if data != null:
		assert_true(data is Resource, "SpineSkeletonDataResource 는 Resource 여야 함")


func test_spine_sprite_has_animation_signals() -> void:
	if not ClassDB.class_exists("SpineSprite"):
		pending("Spine 런타임 미설치")
		return
	var sprite: Node = ClassDB.instantiate(&"SpineSprite") as Node
	assert_not_null(sprite)
	if sprite != null:
		var signal_names: Array[String] = []
		for sig in sprite.get_signal_list():
			signal_names.append(sig.name)
		# 핵심 라이프사이클 시그널 4개 체크
		for expected in ["animation_started", "animation_completed", "animation_ended", "animation_interrupted"]:
			assert_true(expected in signal_names,
				"SpineSprite 에 %s 시그널이 없음 (있는 시그널: %s)" % [expected, signal_names])
		sprite.queue_free()


func test_spine_animation_component_loads() -> void:
	# 우리 헬퍼 컴포넌트가 Spine 런타임 없이도 crash 없이 로드되어야 함
	var comp := SpineAnimationComponent.new()
	add_child_autofree(comp)
	assert_not_null(comp)
	# spine_sprite 미지정 상태에서도 메서드 호출 시 crash 없어야 함 (early return)
	comp.play(&"does_not_matter")
	comp.stop()
	var animations := comp.list_animations()
	assert_eq(animations, [] as Array[String], "spine_sprite 미지정 시 빈 배열 반환")
