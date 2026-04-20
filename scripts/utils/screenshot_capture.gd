## AI 피드백용 스크린샷 캡처 유틸리티
## 게임 화면을 캡처하여 Claude에게 보여줄 수 있습니다.
## Autoload로 등록하여 어디서든 호출 가능.
##
## 저장 경로:
##   에디터 실행: `<프로젝트 루트>/screenshots/`  — 탐색기에서 쉽게 접근, Git 추적 X (.gitignore)
##   익스포트 빌드: `user://screenshots/`         — 플랫폼별 AppData (res:// 가 읽기전용이라서)
class_name ScreenshotCapture
extends Node

## F9 키로 빠른 캡처 (F12 는 브라우저/OS 개발자 도구와 충돌).
## 바꾸려면 KEY_F1 ~ KEY_F12 중 선택.
const CAPTURE_KEY: Key = KEY_F9

## 에디터 실행 여부에 따라 경로 결정. capture() 호출 시마다 재계산.
@export_dir var override_dir: String = ""  # 비워두면 자동 선택


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(_get_screenshot_dir())


## 현재 화면을 PNG로 캡처
func capture(filename: String = "") -> String:
	await RenderingServer.frame_post_draw
	var viewport_image: Image = get_viewport().get_texture().get_image()
	if filename.is_empty():
		var timestamp := Time.get_datetime_string_from_system().replace(":", "-")
		filename = "screenshot_%s.png" % timestamp
	var path := _get_screenshot_dir().path_join(filename)
	viewport_image.save_png(path)
	print("[Screenshot] Saved: %s" % path)
	return path


## 특정 영역만 캡처
func capture_region(rect: Rect2i, filename: String = "") -> String:
	await RenderingServer.frame_post_draw
	var viewport_image: Image = get_viewport().get_texture().get_image()
	var cropped: Image = viewport_image.get_region(rect)
	if filename.is_empty():
		var timestamp := Time.get_datetime_string_from_system().replace(":", "-")
		filename = "region_%s.png" % timestamp
	var path := _get_screenshot_dir().path_join(filename)
	cropped.save_png(path)
	print("[Screenshot] Region saved: %s" % path)
	return path


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == CAPTURE_KEY:
		capture()


## 저장 디렉토리 해석:
##   1. override_dir 지정 있으면 그걸 사용 (절대/상대 모두 가능)
##   2. 그 외 → ProjectPaths.writable_dir("screenshots/") 규칙 따름
##      (에디터: 프로젝트 루트, 익스포트: user://)
func _get_screenshot_dir() -> String:
	if not override_dir.is_empty():
		return ProjectSettings.globalize_path(override_dir)
	return ProjectPaths.writable_dir("screenshots/")
