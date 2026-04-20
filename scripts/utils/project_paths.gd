## 런타임 쓰기 가능 디렉토리 경로 헬퍼.
##
## **모든 런타임 쓰기 가능 파일(세이브, 스크린샷, 로그 등) 은 이 유틸리티로 경로를 얻어야 합니다.**
## 일관된 규칙을 강제해서 "사용자 AppData 에 파일이 흩어지는" 문제를 방지.
##
## ## 규칙
##
## | 실행 모드 | 기본 경로 | 이유 |
## |----------|----------|------|
## | **에디터 실행** (`OS.has_feature("editor") == true`) | `<프로젝트 루트>/<subdir>/` | 탐색기에서 즉시 접근, Git 관리 명확 (.gitignore) |
## | **익스포트 빌드** | `user://<subdir>/` (플랫폼별 AppData) | `res://` 가 PCK 안에 packed-readonly 라서 |
##
## ## 사용 예
##
## ```gdscript
## # 세이브 파일 경로
## var save_dir := ProjectPaths.writable_dir("saves/")
## var save_path := save_dir.path_join("slot_0.save")
##
## # 스크린샷
## var ss_dir := ProjectPaths.writable_dir("screenshots/")
##
## # 로그
## var log_dir := ProjectPaths.writable_dir("logs/")
##
## # 프로파일러 출력
## var prof_dir := ProjectPaths.writable_dir("profiles/")
## ```
##
## ## 주의
##
## - 새 `writable_dir("foo/")` 를 사용하면 **`.gitignore` 에 `foo/` 도 추가**해야 Git 이 무시합니다.
## - 경로는 항상 **절대 경로** (Windows: `C:/...`, Linux/Mac: `/...`) 가 반환됩니다.
## - 디렉토리는 자동 생성되지 않음 — 호출측에서 `DirAccess.make_dir_recursive_absolute()` 로 보장.
class_name ProjectPaths
extends RefCounted


## 에디터 실행 중이면 프로젝트 루트의 subdir, 아니면 user://subdir 를 반환 (모두 절대 경로).
static func writable_dir(subdir: String) -> String:
	var base := "res://" if OS.has_feature("editor") else "user://"
	var virtual_path := base + subdir
	return ProjectSettings.globalize_path(virtual_path)


## 위와 동일하나 디렉토리 자동 생성까지 수행.
static func ensure_writable_dir(subdir: String) -> String:
	var path := writable_dir(subdir)
	DirAccess.make_dir_recursive_absolute(path)
	return path


## 현재 환경이 에디터인지 여부 (위 결정에 사용).
static func is_editor_run() -> bool:
	return OS.has_feature("editor")
