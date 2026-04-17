## 런타임 서비스 등록/조회 — Autoload 로 해결하기 어려운 동적 의존성에 사용.
## Autoload 이름: ServiceLocator
##
## 사용 예:
##   ServiceLocator.register(&"QuestSystem", quest_system_node)
##   var quests = ServiceLocator.get_service(&"QuestSystem")
##
## 주의: 단순 싱글톤은 Autoload 로 처리하세요. ServiceLocator 는
## 런타임 교체가 필요한 경우 (테스트 더블 주입 등) 에 사용합니다.
##
## NOTE: Autoload 스크립트는 class_name 선언 안 함.
extends Node

var _services: Dictionary[StringName, Object] = {}


func register(key: StringName, service: Object) -> void:
	if _services.has(key):
		push_warning("[ServiceLocator] Overwriting service: %s" % key)
	_services[key] = service


func unregister(key: StringName) -> void:
	_services.erase(key)


func get_service(key: StringName) -> Object:
	return _services.get(key)


func has_service(key: StringName) -> bool:
	return _services.has(key)


func clear() -> void:
	_services.clear()
