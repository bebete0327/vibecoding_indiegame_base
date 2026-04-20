## 세이브 / 로드 관리자 — JSON 기반, 버전 관리 + 자동 백업 포함.
## Autoload 이름: SaveManager
##
## 파일 구조 (세이브 파일 내용):
##   {
##     "version": 1,                        ← 스키마 버전 (CURRENT_VERSION)
##     "timestamp": 1713303600000,          ← Time.get_unix_time_from_system()
##     "data": { ... 사용자가 넘긴 Dictionary ... }
##   }
##
## 사용 예:
##   SaveManager.save_data({"score": 100, "level": 3})
##   var data := SaveManager.load_data()   # wrapped → 자동으로 data 필드 추출
##   if data.has("score"): ...
##
## 저장 경로 (ProjectPaths 규칙):
##   에디터 실행 시 → `<프로젝트 루트>/saves/slot_N.save`
##   익스포트 빌드 시 → `user://saves/slot_N.save` (플랫폼별 AppData)
##
## 저장 시 기존 파일이 있으면 `.bak` 으로 자동 백업 (실수 방지).
## 스키마 변경 시 CURRENT_VERSION 증가 + _migrate() 구현.
##
## NOTE: Autoload 스크립트는 class_name 선언 안 함.
extends Node

const DEFAULT_SLOT: int = 0
const CURRENT_VERSION: int = 1

signal save_completed(slot: int, success: bool)
signal load_completed(slot: int, success: bool)


func _ready() -> void:
	ProjectPaths.ensure_writable_dir("saves/")


func save_data(data: Dictionary, slot: int = DEFAULT_SLOT) -> bool:
	var path := _slot_path(slot)

	# 기존 파일 백업 (덮어쓰기 방지).
	if FileAccess.file_exists(path):
		var backup_err := DirAccess.copy_absolute(path, path + ".bak")
		if backup_err != OK:
			push_warning("[SaveManager] Backup failed (%d) — proceeding with overwrite" % backup_err)

	var wrapped := {
		"version": CURRENT_VERSION,
		"timestamp": Time.get_unix_time_from_system(),
		"data": data,
	}
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("[SaveManager] Cannot open %s (err=%d)" % [path, FileAccess.get_open_error()])
		save_completed.emit(slot, false)
		return false
	file.store_string(JSON.stringify(wrapped, "\t"))
	file.close()
	save_completed.emit(slot, true)
	return true


func load_data(slot: int = DEFAULT_SLOT) -> Dictionary:
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		load_completed.emit(slot, false)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("[SaveManager] Cannot read %s" % path)
		load_completed.emit(slot, false)
		return {}
	var text := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if not parsed is Dictionary:
		push_error("[SaveManager] Invalid save format at %s (expected Dictionary, got %s)" % [path, type_string(typeof(parsed))])
		load_completed.emit(slot, false)
		return {}

	var wrapped: Dictionary = parsed
	# 언랩 + 마이그레이션
	var version: int = int(wrapped.get("version", 0))
	var inner: Dictionary = wrapped.get("data", {})
	if version == 0:
		# 레거시 (v0.9 이전) — 파일 전체가 data
		inner = wrapped
		push_warning("[SaveManager] Legacy save detected (no version field). Migrating.")
	elif version != CURRENT_VERSION:
		inner = _migrate(inner, version, CURRENT_VERSION)

	load_completed.emit(slot, true)
	return inner


func has_save(slot: int = DEFAULT_SLOT) -> bool:
	return FileAccess.file_exists(_slot_path(slot))


func delete_save(slot: int = DEFAULT_SLOT) -> bool:
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return false
	var err := DirAccess.remove_absolute(path)
	return err == OK


## 스키마 버전 변경 시 이 함수를 확장.
## 기본 구현: 변경 없이 반환 (필드 추가만 있고 제거 없을 때 안전).
func _migrate(data: Dictionary, from_version: int, to_version: int) -> Dictionary:
	push_warning("[SaveManager] Migrating save v%d → v%d (no-op default impl)" % [from_version, to_version])
	return data


func _slot_path(slot: int) -> String:
	return ProjectPaths.writable_dir("saves/").path_join("slot_%d.save" % slot)
