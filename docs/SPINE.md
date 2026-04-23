# Spine 2D Runtime — 설치 및 사용 가이드

이 템플릿은 **Spine 2D 런타임 (GDExtension)** 통합을 지원합니다.
2D 스켈레탈 애니메이션은 Spine 으로 제작하고 Godot 에서 재생.

---

## 0. 라이선스 (참고)

Spine 에디터는 상용 소프트웨어 — 이 템플릿 사용자는 **라이선스 보유 기준**으로 작성됨.

- 에디터 구매: https://esotericsoftware.com/spine-purchase
- 런타임은 라이선스 소유자가 자유롭게 배포/수정 가능 (Spine Runtimes License Agreement)

템플릿엔 런타임 바이너리를 커밋하지 않고 각자 공식 S3 에서 받도록 한 이유는 용량(43MB) + 버전 매칭 유연성 때문이지 법적 이유가 아닙니다.

---

## 1. 런타임 설치

### 자동 (권장)

Git Bash 에서:
```bash
bash scripts/dev_tools/install_spine_runtime.sh
```

- S3 에서 ~14MB zip 다운로드
- 프로젝트 루트의 `bin/` 에 압축 해제
- 약 43MB 의 플랫폼별 바이너리 (Windows/Linux/macOS/iOS/Android/Web) 설치
- `bin/` 은 `.gitignore` 되어 있음 (각자 설치)

### 수동

1. https://esotericsoftware.com/spine-godot 방문
2. 본인 Godot 버전에 맞는 GDExtension zip 다운로드
3. 프로젝트 루트에 압축 해제 → `bin/spine_godot_extension.gdextension` 이 생겨야 함

### 버전 호환성

현재 설치 스크립트 기본값:
- **Spine**: 4.2.x
- **Godot**: 4.6.1-stable (4.6.x 전체와 ABI 호환)

우리 프로젝트가 **Godot 4.6.2-stable** 이지만 Spine 4.6.2 빌드가 S3 에 없어서 4.6.1 GDExtension 을 씁니다. 테스트 결과 **정상 작동** 확인됨 (GDExtension API 패치 버전 간 호환).

Godot 버전 바뀌면 `install_spine_runtime.sh` 의 `GODOT_VERSION` 변수 수정.

---

## 2. 설치 검증

```bash
"$GODOT_PATH" --headless --path . -e --quit
```

에러 없이 종료되면 성공. 상세 클래스 확인:

```bash
# 임시 스크립트 실행
cat > _spine_check.gd << 'EOF'
extends SceneTree
func _init():
    for cls in ["SpineSkeletonDataResource", "SpineSprite", "SpineAnimationState"]:
        print("  %s: %s" % [cls, "OK" if ClassDB.class_exists(cls) else "MISSING"])
    quit()
EOF
"$GODOT_PATH" --headless --path . --script res://_spine_check.gd
rm _spine_check.gd
```

기대 출력:
```
  SpineSkeletonDataResource: OK
  SpineSprite: OK
  SpineAnimationState: OK
```

---

## 3. Spine 에셋 준비

### Spine 에디터에서 export

1. Spine 에디터 → 프로젝트 열기
2. **File → Settings → Export**:
   - Format: **Binary** (`.skel`, 권장) 또는 **JSON** (`.json`, 디버깅용)
   - Version: **4.2.x**
3. **Export → Atlas**:
   - Texture packer 실행 → `.atlas` + `.png` (또는 `.webp`) 생성

### Godot 프로젝트에 배치

```
assets/spine/<character_name>/
├── hero.skel       # 스켈레톤 데이터
├── hero.atlas      # 아틀라스 매니페스트
└── hero.png        # 텍스처 (LFS 자동 추적됨)
```

---

## 4. Godot 에서 사용

### 에디터에서 리소스 설정

1. `assets/spine/hero/` 에 에셋 배치
2. **FileSystem 우클릭 → New Resource... → SpineAtlasResource**
   - `hero_atlas.tres` 로 저장
   - `atlas_file` 속성에 `hero.atlas` 드래그
3. **New Resource... → SpineSkeletonDataResource**
   - `hero_skeleton_data.tres` 로 저장
   - `skeleton_file_res` = `hero.skel`
   - `atlas_res` = 위에서 만든 atlas 리소스
4. 씬에 **SpineSprite** 노드 추가
   - `skeleton_data_res` 속성에 `hero_skeleton_data.tres` 지정

### 코드로 재생

```gdscript
class_name HeroCharacter
extends Node2D

@onready var spine_sprite: SpineSprite = $SpineSprite


func _ready() -> void:
    # 기본 애니메이션 "idle" 무한 재생
    spine_sprite.animation_state.set_animation("idle", true, 0)
    # 시그널 연결
    spine_sprite.animation_finished.connect(_on_anim_finished)


func play_attack() -> void:
    # "attack" 애니메이션을 트랙 0 에 한 번 재생 후 "idle" 로 큐잉
    spine_sprite.animation_state.set_animation("attack", false, 0)
    spine_sprite.animation_state.add_animation("idle", 0, true, 0)


func _on_anim_finished(track: SpineTrackEntry) -> void:
    print("Animation finished: ", track.get_animation().get_name())
```

### 흔히 쓰는 API

| 메서드 | 용도 |
|-------|------|
| `animation_state.set_animation(name, loop, track)` | 지정 애니메이션 즉시 재생 |
| `animation_state.add_animation(name, delay, loop, track)` | 큐에 다음 애니메이션 추가 |
| `animation_state.set_empty_animation(track, mix_duration)` | 트랙 클리어 (페이드아웃) |
| `skeleton.find_bone(name)` | 본 참조 (외부에서 제어) |
| `skeleton.find_slot(name).color = ...` | 슬롯 색상 변경 (데미지 플래시 등) |

---

## 5. 트러블슈팅

### ❌ `Class "SpineSprite" not found`
런타임 미설치. `bash scripts/dev_tools/install_spine_runtime.sh` 실행.

### ❌ `bin/spine_godot_extension.gdextension` 파일이 없음
설치 스크립트 실패했거나 수동 압축 해제 시 경로 잘못. 프로젝트 루트 바로 아래 `bin/` 이 있어야 함 (레포 루트에서 `ls bin/spine_godot_extension.gdextension` 이 뜨는지 확인).

### ❌ Godot 4.6.x 에서 `GDExtension failed to load`
현재 S3 에 4.6.1 까지만 있음. 4.7+ 이 나오면:
1. https://esotericsoftware.com/spine-godot 에서 새 빌드 확인
2. `install_spine_runtime.sh` 의 `GODOT_VERSION` 업데이트
3. 재설치

### ❌ 에셋 import 실패
Spine 에디터의 export 버전이 4.2.x 가 아님. 4.0 / 4.1 로 export 한 파일은 **호환 안 됨**. Spine 에디터에서 Settings → Runtime 을 4.2 로 맞춘 뒤 재 export.

### ❌ `.atlas` 는 있는데 이미지가 로드 안 됨
아틀라스 파일 안에 기록된 이미지 파일명이 실제와 일치해야 함. Spine 에디터의 "Texture packer → File name" 옵션 확인.

### ❌ 성능 문제 (캐릭터 많을 때)
- `SpineSprite.preinstantiated_mesh_count` 설정으로 메시 풀 확보
- 화면 밖 스프라이트는 `visible = false` 로 렌더링 스킵
- [perf-profile 스킬](../knowledge_base/Wiki/ccgs-integration.md) 로 병목 분석

---

## 6. 업그레이드

**Spine 4.3+ 출시 시**:
1. Spine 에디터 업데이트
2. `install_spine_runtime.sh` 의 `SPINE_VERSION=4.3` 변경
3. 재설치
4. 기존 `.skel` 파일은 Spine 에디터에서 re-export (4.3 포맷으로)

**Godot 4.7+ 업그레이드 시**:
1. `install_spine_runtime.sh` 의 `GODOT_VERSION` 업데이트 (S3 에 빌드 있을 때까지 대기)
2. `docs/engine-reference/godot/VERSION.md` 도 업데이트

---

## 7. 참고 링크

- 공식 Spine Godot 문서: https://esotericsoftware.com/spine-godot
- spine-runtimes 레포 (Godot 경로): https://github.com/EsotericSoftware/spine-runtimes/tree/4.2/spine-godot
- 예제 프로젝트: https://github.com/EsotericSoftware/spine-runtimes/tree/4.2/spine-godot/example-v4-extension
- Spine API 레퍼런스: https://esotericsoftware.com/spine-api-reference
- 가격/라이선스: https://esotericsoftware.com/spine-purchase
