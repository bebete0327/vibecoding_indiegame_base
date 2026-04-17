# Technical Preferences

> CCGS 스킬들이 엔진별 스페셜리스트 매핑을 확인할 때 참조하는 파일.
> 이 템플릿은 **Godot 4.6 + GDScript only** 로 고정.

## Engine Specialists

- **Primary**: `godot-specialist`
- **Language/Code Specialist**: `godot-gdscript-specialist`
- **Shader Specialist**: `godot-shader-specialist`
- **UI Specialist**: `godot-gdscript-specialist` (전용 UI 에이전트 없음 — GDScript 스페셜리스트가 담당)
- **Performance**: `godot-gdextension-specialist` (핫스팟 C++ 판단용)

## File Pattern → Specialist Routing

| Pattern | Specialist |
|---------|-----------|
| `*.gd` | godot-gdscript-specialist |
| `*.gdshader` | godot-shader-specialist |
| `*.tscn` / `*.tres` | godot-specialist |
| `*.cpp` / `*.h` (gdextension) | godot-gdextension-specialist |

## Not Configured (의도적 비어있음)

- **C#** — 이 템플릿은 GDScript only. `godot-csharp-specialist` 필요 시 [CCGS 원본](https://github.com/)에서 이식.
- **Unity / UE** — 스킵. 다른 엔진 프로젝트라면 해당 스페셜리스트 이식 필요.

## Notes for Skill Authors

만약 스킬이 "언급된 스페셜리스트가 없다" 라고 경고하면:
1. 에이전트 포팅 누락인지 확인 (`.claude/agents/` 목록)
2. 누락이면 [CCGS 원본](https://github.com/)의 `.claude/agents/` 에서 복사
3. 솔로 인디 모드라서 필요 없다면 스킬 본문에서 해당 스페셜리스트 스폰을 조건부로 스킵
