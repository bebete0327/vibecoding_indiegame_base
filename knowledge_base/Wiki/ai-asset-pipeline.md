# AI Asset Pipeline - 에셋 제작 도구 가이드

## Tags
- category: tool, asset
- difficulty: beginner
- related: [[godot-vibecoding-basics]]

## Summary
AI를 활용한 게임 에셋(이미지, 사운드, 애니메이션) 제작 파이프라인.

## 1. Image / Sprite (이미지)

| 도구 | 특징 | 용도 | 비용 |
|------|------|------|------|
| **Leonardo.ai** | 게임 에셋 특화, 스타일 일관성 | 캐릭터, 배경, UI | 무료 크레딧 + 유료 |
| **Midjourney** | 고품질 아트, 컨셉 아트 | 컨셉 아트, 분위기 참고 | 유료 ($10/월~) |
| **Stable Diffusion** | 로컬 실행, 커스텀 학습 | 대량 생산, 스타일 통일 | 무료 (GPU 필요) |
| **Piskel** | 픽셀아트 에디터 (무료) | 픽셀아트 스프라이트 | 무료 |
| **Aseprite** | 픽셀아트 + 애니메이션 | 스프라이트시트 제작 | $20 (1회) |

### Godot 연동 팁
```
1. AI로 이미지 생성 → PNG/WebP로 저장
2. assets/sprites/ 폴더에 배치
3. Godot Import 설정에서 Filter: Nearest (픽셀아트) 또는 Linear (HD)
4. SpriteSheet는 AnimatedSprite2D의 SpriteFrames에 등록
```

## 2. Sound / Music (사운드)

| 도구 | 특징 | 용도 | 비용 |
|------|------|------|------|
| **Jace** | AI 효과음 생성 | SFX (타격, 폭발, UI) | 무료 크레딧 |
| **Udio** | AI 음악 생성, 고품질 | BGM, 테마곡 | 무료~유료 |
| **Suno** | AI 음악, 가사 포함 | BGM, 보컬 트랙 | 무료~유료 |
| **sfxr / jsfxr** | 레트로 효과음 생성기 | 8bit/16bit SFX | 무료 |
| **Freesound.org** | CC 라이선스 효과음 | 환경음, 배경음 | 무료 |

### Godot 연동 팁
```
1. WAV: 짧은 효과음 (SFX) → Import 시 Loop OFF
2. OGG: BGM, 긴 오디오 → Import 시 Loop ON
3. assets/audio/ 폴더에 sfx/, bgm/ 하위 폴더로 분류
4. AudioStreamPlayer / AudioStreamPlayer2D로 재생
```

## 3. Animation (애니메이션)

| 도구 | 특징 | 용도 |
|------|------|------|
| **Cascadeur** | 물리 기반 AI 애니메이션 | 3D 캐릭터 모션 |
| **Mixamo** | Adobe 무료 모션 캡처 | 3D 휴머노이드 애니메이션 |
| **DragonBones** | 2D 스켈레탈 애니메이션 | 2D 캐릭터 관절 애니메이션 |

## 4. 3D Model (3D 모델)

| 도구 | 특징 | 용도 |
|------|------|------|
| **Meshy** | AI 텍스트→3D | 빠른 프로토타입 |
| **Tripo3D** | AI 이미지→3D | 컨셉→모델 변환 |
| **Blender** | 오픈소스 3D 모델링 | 정밀 모델링/리깅 |
| **Kenney.nl** | CC0 게임 에셋 라이브러리 | 무료 프로토타입 에셋 |

## 5. Asset Integration Workflow

```
[AI 생성] → [포맷 변환] → [Godot Import] → [테스트]

이미지: PNG/WebP → assets/sprites/ → Import 설정 조정
사운드: WAV/OGG → assets/audio/ → Loop 설정
3D: GLTF/GLB → assets/models/ → Material 조정
```

## License 주의사항
- AI 생성 에셋의 상업적 사용 가능 여부 반드시 확인
- Leonardo.ai: 유료 플랜 상업적 사용 가능
- Midjourney: 유료 플랜 상업적 사용 가능
- Suno/Udio: 플랜별 라이선스 상이 → 출시 전 확인 필수
- CC0 에셋 (Kenney): 무조건 자유 사용 가능
