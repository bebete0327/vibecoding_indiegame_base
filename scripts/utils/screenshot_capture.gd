## AI 피드백용 스크린샷 캡처 유틸리티
## 게임 화면을 캡처하여 Claude에게 보여줄 수 있습니다.
## Autoload로 등록하여 어디서든 호출 가능.
class_name ScreenshotCapture
extends Node

const SCREENSHOT_DIR := "user://screenshots/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SCREENSHOT_DIR)

## 현재 화면을 PNG로 캡처
func capture(filename: String = "") -> String:
	await RenderingServer.frame_post_draw
	var viewport_image: Image = get_viewport().get_texture().get_image()
	if filename.is_empty():
		var timestamp := Time.get_datetime_string_from_system().replace(":", "-")
		filename = "screenshot_%s.png" % timestamp
	var path := SCREENSHOT_DIR + filename
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
	var path := SCREENSHOT_DIR + filename
	cropped.save_png(path)
	print("[Screenshot] Region saved: %s" % path)
	return path

## F9 키로 빠른 캡처 (F12 는 브라우저/OS 개발자 도구와 충돌하므로 F9 사용).
## 변경이 필요하면 아래 keycode 를 KEY_F1~KEY_F12 중 원하는 값으로 바꾸세요.
const CAPTURE_KEY: Key = KEY_F9

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == CAPTURE_KEY:
		capture()
