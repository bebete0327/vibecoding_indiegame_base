## ProjectPaths 유틸리티 테스트 — 경로 결정 규칙 검증.
extends GutTest


func test_writable_dir_returns_absolute_path() -> void:
	var path := ProjectPaths.writable_dir("screenshots/")
	assert_true(path.is_absolute_path(), "반환 경로는 항상 절대 경로여야 함")


func test_writable_dir_appends_subdir() -> void:
	var path := ProjectPaths.writable_dir("foo/")
	assert_true(path.ends_with("foo/") or path.ends_with("foo\\") or path.ends_with("foo"),
		"subdir 이름이 경로 끝에 포함되어야 함: %s" % path)


func test_editor_mode_uses_project_root() -> void:
	# GUT 는 에디터/디버그 빌드에서 실행되므로 is_editor_run() == true
	assert_true(ProjectPaths.is_editor_run(), "테스트는 에디터 모드에서 돌아야 함")
	var path := ProjectPaths.writable_dir("saves/")
	var project_root := ProjectSettings.globalize_path("res://")
	assert_true(path.begins_with(project_root),
		"에디터 모드에선 프로젝트 루트 밑에 있어야 함 (project=%s, got=%s)" % [project_root, path])


func test_ensure_writable_dir_creates_directory() -> void:
	var test_subdir := "_test_tmp_project_paths/"
	var path := ProjectPaths.ensure_writable_dir(test_subdir)
	assert_true(DirAccess.dir_exists_absolute(path),
		"ensure_writable_dir 후 실제로 디렉토리가 존재해야 함: %s" % path)
	# 정리
	DirAccess.remove_absolute(path)


func test_different_subdirs_resolve_to_different_paths() -> void:
	var ss := ProjectPaths.writable_dir("screenshots/")
	var saves := ProjectPaths.writable_dir("saves/")
	assert_ne(ss, saves, "다른 subdir 은 다른 경로여야 함")
