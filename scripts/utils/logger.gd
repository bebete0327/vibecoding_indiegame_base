## 레벨 기반 로거 — print/push_warning/push_error 를 일관된 포맷으로 래핑.
##
## NOTE: `Logger` 는 Godot 네이티브 클래스명과 충돌하므로 `VibeLog` 로 선언.
##
## 사용 예:
##   VibeLog.info(&"Player", "spawned at %s" % position)
##   VibeLog.warn(&"Audio", "missing BGM: %s" % path)
##   VibeLog.error(&"Save", "file corrupted at slot %d" % slot)
##
## Static 메서드이므로 new() 필요 없음.
## 프로덕션 빌드에서는 VibeLog.threshold = VibeLog.Level.WARN 로 상향.
class_name VibeLog
extends RefCounted

enum Level { DEBUG, INFO, WARN, ERROR }

## 이 레벨 미만은 출력 생략. 릴리스 빌드에서 Level.WARN 권장.
static var threshold: Level = Level.DEBUG


static func debug(tag: StringName, msg: String) -> void:
	if threshold <= Level.DEBUG:
		print("[DEBUG][%s] %s" % [tag, msg])


static func info(tag: StringName, msg: String) -> void:
	if threshold <= Level.INFO:
		print("[INFO ][%s] %s" % [tag, msg])


static func warn(tag: StringName, msg: String) -> void:
	if threshold <= Level.WARN:
		push_warning("[%s] %s" % [tag, msg])


static func error(tag: StringName, msg: String) -> void:
	if threshold <= Level.ERROR:
		push_error("[%s] %s" % [tag, msg])
