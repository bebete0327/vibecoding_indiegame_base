## 세이브 / 로드 관리자 — JSON 기반 단순 영속화.
## Autoload 이름: SaveManager
##
## 기본 경로: user://saves/slot_<n>.save
##
## 사용 예:
##   SaveManager.save_data({"score": 100, "level": 3})
##   var data := SaveManager.load_data()
##   if data.has("score"): ...
##
## 구조 검증이 필요하면 Resource 기반으로 확장 권장.
##
## NOTE: Autoload 스크립트는 class_name 선언 안 함.
extends Node

const SAVE_DIR: String = "user://saves/"
const DEFAULT_SLOT: int = 0

signal save_completed(slot: int, success: bool)
signal load_completed(slot: int, success: bool)


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)


func save_data(data: Dictionary, slot: int = DEFAULT_SLOT) -> bool:
	var path := _slot_path(slot)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("[SaveManager] Cannot open %s (err=%d)" % [path, FileAccess.get_open_error()])
		save_completed.emit(slot, false)
		return false
	file.store_string(JSON.stringify(data, "\t"))
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
	if parsed is Dictionary:
		load_completed.emit(slot, true)
		return parsed
	push_error("[SaveManager] Invalid save format at %s" % path)
	load_completed.emit(slot, false)
	return {}


func has_save(slot: int = DEFAULT_SLOT) -> bool:
	return FileAccess.file_exists(_slot_path(slot))


func delete_save(slot: int = DEFAULT_SLOT) -> bool:
	var path := _slot_path(slot)
	if not FileAccess.file_exists(path):
		return false
	var err := DirAccess.remove_absolute(path)
	return err == OK


func _slot_path(slot: int) -> String:
	return "%sslot_%d.save" % [SAVE_DIR, slot]
