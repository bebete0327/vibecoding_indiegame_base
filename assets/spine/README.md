# assets/spine/

Spine 2D 애니메이션 에셋 배치 위치.

## 파일 포맷 (Spine 에서 export)

| 확장자 | 용도 |
|--------|------|
| `.skel` / `.json` | 스켈레톤 데이터 (바이너리 또는 JSON) |
| `.atlas` | 텍스처 아틀라스 메타데이터 |
| `.png` / `.webp` | 아틀라스 이미지 파일 |

## 권장 구조

```
assets/spine/
├── character_hero/
│   ├── hero.skel
│   ├── hero.atlas
│   └── hero.png
├── character_enemy/
│   ├── goblin.skel
│   ├── goblin.atlas
│   └── goblin.png
└── effects/
    ├── explosion.skel
    ├── explosion.atlas
    └── explosion.png
```

**캐릭터/이펙트당 1폴더** — Spine 은 skel+atlas+png 3~4 파일이 항상 세트로 움직임.

## Export 버전 주의

이 템플릿의 Spine GDExtension 은 **Spine 4.2.x** 와 호환됩니다. Spine 에디터에서 export 할 때:

1. File → Settings → Version: `4.2.x`
2. Export → Data format: `Binary` 또는 `JSON` (바이너리 권장, 로딩 빠름)

**Spine 4.1 이하로 export 한 파일은 로드 안 됨.** 4.3+ 은 추후 업그레이드 시.

## Godot 씬에서 사용법

```gdscript
# 1. SpineSkeletonDataResource 생성 (에디터: FileSystem 우클릭 → New Resource)
# 2. skeleton_file_res = hero.skel
# 3. atlas_res = SpineAtlasResource (assets/spine/character_hero/hero.atlas 지정)
# 4. 씬에 SpineSprite 노드 추가
# 5. skeleton_data_res = (1) 에서 만든 리소스 지정

# 런타임 애니메이션 재생
var spine_sprite: SpineSprite = $SpineSprite
spine_sprite.animation_state.set_animation("run", true, 0)
```

자세한 사용법: [docs/SPINE.md](../../docs/SPINE.md)

## LFS

`.gitattributes` 에 `.png`, `.webp` 가 이미 LFS 추적되도록 설정되어 있습니다. 큰 아틀라스 이미지는 자동으로 LFS 로 저장됩니다.

`.skel` (바이너리) 는 LFS 추적 안 함 — 보통 수 KB 수준.
