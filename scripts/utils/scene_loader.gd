## 비동기 씬 로더 — 프로그레스 지원.
##
## 사용 예:
##   var loader := SceneLoader.new()
##   loader.progress.connect(func(p: float) -> void: progress_bar.value = p)
##   loader.loaded.connect(func(scene: PackedScene) -> void: get_tree().change_scene_to_packed(scene))
##   loader.load_async("res://scenes/level_1.tscn")
##
## 동기 로드가 필요하면 ResourceLoader.load() 를 직접 사용하세요.
class_name SceneLoader
extends Node

signal progress(ratio: float)          # 0.0 ~ 1.0
signal loaded(scene: PackedScene)
signal failed(path: String, error_code: int)

var _path: String = ""
var _polling: bool = false


func load_async(path: String) -> void:
	assert(ResourceLoader.exists(path), "Scene not found: %s" % path)
	_path = path
	var err := ResourceLoader.load_threaded_request(path)
	if err != OK:
		failed.emit(path, err)
		return
	_polling = true
	set_process(true)


func _process(_delta: float) -> void:
	if not _polling:
		return
	var status_array: Array = []
	var status := ResourceLoader.load_threaded_get_status(_path, status_array)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if status_array.size() > 0:
				progress.emit(float(status_array[0]))
		ResourceLoader.THREAD_LOAD_LOADED:
			_polling = false
			set_process(false)
			var res := ResourceLoader.load_threaded_get(_path) as PackedScene
			if res:
				progress.emit(1.0)
				loaded.emit(res)
			else:
				failed.emit(_path, ERR_CANT_RESOLVE)
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_polling = false
			set_process(false)
			failed.emit(_path, status)
