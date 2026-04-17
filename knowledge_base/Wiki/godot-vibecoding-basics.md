# Godot + AI Vibe Coding Basics

## Tags
- category: godot
- difficulty: beginner
- related: [[harness-engineering]], [[gdscript-patterns]]

## Summary
Godot 엔진이 AI 바이브코딩에 최적화된 이유와 기본 워크플로우.

## Why Godot for Vibe Coding?

### Text-Based Everything
Godot의 모든 핵심 파일이 텍스트 기반:
- `.tscn` (씬 파일) - 텍스트 포맷, AI가 직접 읽기/수정 가능
- `.gd` (스크립트) - GDScript 소스코드
- `.tres` (리소스) - 텍스트 리소스 파일
- `project.godot` - INI 스타일 설정 파일

다른 엔진(Unity, Unreal)은 바이너리 파일이 많아 AI가 직접 수정하기 어려움.

### Headless Mode
```bash
# 에디터 없이 CLI에서 실행
godot --headless --check-only --path .    # 문법 체크
godot --headless --path . -s test.gd      # 스크립트 실행
godot --headless --path . --quit-after 5000  # 5초 후 종료
```

AI가 에디터를 열지 않고도:
- 코드 문법 검증
- 씬 로드 테스트
- 자동화 스크립트 실행
- 게임 로직 테스트

### Collaboration Workflow
```
[AI (Claude Code)]              [Human (Godot Editor)]
     │                                │
     ├─ GDScript 작성/수정            │
     ├─ .tscn 씬 파일 생성           │
     ├─ headless 테스트 실행          │
     │                                ├─ 에디터에서 시각적 확인
     │                                ├─ 노드 트리 조정
     │                                ├─ 애니메이션 편집
     │                                ├─ 물리 충돌 설정
     └─ 피드백 반영 수정              └─ 피드백 제공
```

**핵심**: AI는 코드와 로직을, 사람은 비주얼과 게임 필을 담당.

## Essential Godot Concepts for AI

### Scene Tree
- 모든 것은 Node (노드)
- 노드는 트리 구조로 조합
- 씬 = 재사용 가능한 노드 트리 조합

### Node Lifecycle
```
_init()           → 객체 생성 시
_enter_tree()     → 씬 트리 진입 시
_ready()          → 모든 자식 노드 준비 완료 후
_process(delta)   → 매 프레임
_physics_process(delta) → 매 물리 프레임
_exit_tree()      → 씬 트리 이탈 시
```

### Signal System
노드 간 통신의 핵심 메커니즘:
```gdscript
# 시그널 선언
signal health_changed(new_value: int)

# 발신
health_changed.emit(current_health)

# 수신 (코드에서 연결)
player.health_changed.connect(_on_player_health_changed)
```

### Resource System
데이터와 로직 분리:
```gdscript
# 데이터 정의
class_name WeaponData
extends Resource
@export var damage: int = 10
@export var attack_speed: float = 1.0

# 사용
var sword: WeaponData = preload("res://resources/sword.tres")
```

## Common Pitfalls

1. **@onready 타이밍**: `_ready()` 전에 @onready 변수에 접근하면 null
2. **물리 vs 프레임**: 이동은 `_physics_process`, UI는 `_process`
3. **씬 참조**: `$` 사용 시 노드 이름 정확히 일치 필요
4. **시그널 해제**: 동적 노드 삭제 시 시그널 연결 해제 필요
5. **타입 안전성**: 타입 힌팅 없으면 런타임 에러 발생 가능
