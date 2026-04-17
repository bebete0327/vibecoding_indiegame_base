# assets/

게임 리소스를 이곳에 배치합니다.

| 폴더 | 용도 | 예시 파일 |
|------|------|-----------|
| `sprites/` | 2D 스프라이트, 아이콘, UI 이미지 | `.png`, `.svg`, `.webp` |
| `audio/` | BGM, SFX, 내레이션 | `.ogg`, `.wav`, `.mp3` |
| `fonts/` | 폰트 파일 | `.ttf`, `.otf`, `.fnt` |
| `models/` | 3D 모델, 애니메이션 | `.glb`, `.gltf`, `.fbx` |

## 가이드라인

- **하위 분류 권장**: `audio/bgm/`, `audio/sfx/`, `sprites/enemies/`, `sprites/ui/` 등
- **대용량 바이너리**: `.gitattributes` 의 LFS 규칙이 자동 적용됩니다
- **임포트 설정**: Godot 이 `<file>.import` 파일을 자동 생성하며, 이 파일은 Git 에 커밋해야 합니다
- **라이선스**: 써드파티 에셋은 각 폴더에 `LICENSE.md` 를 함께 둡니다
