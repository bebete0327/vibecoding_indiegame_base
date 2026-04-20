# Unity 호환성 검토

> 이 템플릿은 **Godot 4.6 + GDScript 기준**으로 작성되었습니다.
> 만약 Unity 프로젝트로 전환하거나 Unity 프로젝트에 일부 이식할 경우의 호환성 정보.

---

## TL;DR

| 대상 | Unity 에서 | 비고 |
|------|-----------|------|
| **엔진별 하드코딩 (40%)** | ❌ 사용 불가 | 완전 Godot 의존 |
| **엔진 중립 (60%)** | ✅ 그대로 사용 | 개념/도구 재활용 가능 |

70% 영역이 Godot-locked 라 Unity 전용 프로젝트엔 **템플릿 포크 후 재구성** 권장. 하지만 **디자인/QA/리뷰 도구는 거의 그대로** 가져갈 수 있습니다.

---

## 1. ❌ Unity 에서 작동 안 함 (Godot 전용)

이 부분은 Unity 프로젝트에 가져가면 **깨지거나 무의미**:

### 엔진 파일
| 파일/폴더 | 이유 |
|----------|------|
| `project.godot` | Godot 전용 설정 |
| `scenes/*.tscn` | `.unity` 씬 아님 |
| `addons/gut/` | Unity 는 GUT 대신 Unity Test Framework 사용 |
| `.gdignore`, `icon.svg.import` | Godot 임포트 시스템 |

### GDScript
| 대상 | 이유 |
|------|------|
| `scripts/**/*.gd` (모든 GDScript) | Unity 는 C# 사용 |
| Autoload 9개 (EventBus, GameManager, AudioManager, etc.) | Godot Autoload 패턴 — Unity 에선 ScriptableObject/DontDestroyOnLoad 로 재구현 |
| PostToolUse 훅 (`*.gd` 검증) | GDScript 파일만 대상 |

### 엔진 전문 에이전트 (4개)
| 에이전트 | Unity 버전 필요 |
|---------|----------------|
| `godot-specialist` | `unity-specialist` |
| `godot-gdscript-specialist` | `unity-csharp-specialist` |
| `godot-shader-specialist` | `unity-shader-specialist` (ShaderGraph/URP/HDRP) |
| `godot-gdextension-specialist` | `unity-native-plugin-specialist` |

→ [CCGS 원본](https://github.com/) 의 `.claude/agents/unity-*.md` 에서 가져오면 됨.

### 규칙
| 파일 | 이유 |
|------|------|
| `.claude/rules/gameplay-code.md` | `paths: scripts/**` — Unity 는 `Assets/Scripts/**` |
| `.claude/rules/shader-code.md` | Godot 셰이더 규칙만 있음 (`.gdshader`) |

### 문서
| 파일 | 이유 |
|------|------|
| `docs/engine-reference/godot/**` | Godot 4.6 API만 (Unity 참조 없음) |
| `docs/ARCHITECTURE.md` (일부) | Jolt Physics, Godot Node 트리 언급 |
| `docs/CONVENTIONS.md` | GDScript 네이밍 규칙 |
| `docs/SETUP.md` | `$GODOT_PATH` 등 Godot 설정 |

---

## 2. ✅ Unity 에서 그대로 사용 가능 (엔진 중립)

60% 는 **개념적 도구**라서 Unity 에서도 유효:

### 디자인/리뷰 에이전트 (6개)
- `creative-director` — 필라/비전 검토 (엔진 무관)
- `technical-director` — 아키텍처 결정 (엔진 무관)
- `game-designer` — 메카닉 설계 (엔진 무관)
- `lead-programmer` — SOLID 리뷰 (엔진 무관)
- `qa-tester` — 테스트 커버리지 분석 (엔진 무관)
- `performance-analyst` — 프로파일 해석 (원리 동일, 도구만 다름)

### 모든 스킬 9개 (개념 이식)
| 스킬 | Unity 에서도 유효한가 |
|------|---------------------|
| `/brainstorm` | ✅ 완전 엔진 중립 |
| `/quick-design` | ✅ 완전 엔진 중립 |
| `/balance-check` | ✅ 수식/데이터 분석 — 엔진 무관 |
| `/code-review` | ✅ SOLID/아키텍처 — 엔진 무관 (Unity 전문가 스폰 시) |
| `/smoke-check` | ⚠️ Godot 헤드리스 명령 포함 → Unity Test Runner 로 교체 |
| `/perf-profile` | ⚠️ 개념 동일. Unity Profiler 로 도구 변경 |
| `/tech-debt` | ✅ 완전 엔진 중립 |
| `/retrospective` | ✅ 완전 엔진 중립 |
| `/playtest-report` | ✅ 완전 엔진 중립 |

### 디자인 문서
- `docs/GDD_TEMPLATE.md` — **완전 포팅 가능** (8-섹션 포맷, 엔진 무관)
- `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` — 철학 문서, 엔진 무관
- `docs/WORKFLOW.md` — 결정 트리, 엔진 무관
- `docs/UPGRADE.md` — cherry-pick 절차, 엔진 무관
- `knowledge_base/Wiki/ccgs-integration.md` — CCGS 통합 가이드

### 인프라
- `.gitattributes` — LFS 규칙 (png/wav/fbx/glb 등) — Unity 에도 100% 유효
- `.github/workflows/gut.yml` → Unity Test Runner 워크플로로 교체
- `graphify` — 엔진 무관 (tree-sitter C# 지원 → Unity C# 코드 AST 분석 가능)
- `production/review-mode.txt` + 솔로 모드 — 엔진 무관
- `.claude/rules/test-standards.md`, `ui-code.md`, `data-files.md` — 대부분 엔진 무관 규칙

---

## 3. Unity 프로젝트로 전환하려면

### 옵션 A: 새 템플릿 포크 (권장)

1. 이 템플릿을 새 레포로 fork
2. 엔진 파일 제거 (`scenes/`, `addons/gut/`, `scripts/*.gd`, `project.godot`)
3. Unity 프로젝트 생성 (`Assets/`, `Packages/`, `ProjectSettings/`)
4. Unity 전용 요소 추가:
   - CCGS 원본에서 `unity-*` 에이전트 4개 복사 → `.claude/agents/`
   - `.claude/rules/gameplay-code.md` 의 `paths:` 를 `Assets/Scripts/**` 로
   - `docs/engine-reference/unity/` 생성 (Unity 버전 정보)
   - `addons/gut/` 삭제, Unity Test Framework 설치
   - `CLAUDE.md` 전면 재작성 (Godot 섹션 → Unity 섹션)
   - PostToolUse 훅을 `.cs` 대상으로 변경

### 옵션 B: 에이전트/스킬만 이식 (하이브리드)

Unity 프로젝트에 이미 있는데 **디자인/리뷰 도구만 가져오기**:

```bash
# 엔진 중립 요소만 복사
cp -r <this-template>/.claude/agents/creative-director.md <unity-project>/.claude/agents/
cp -r <this-template>/.claude/agents/technical-director.md <unity-project>/.claude/agents/
cp -r <this-template>/.claude/agents/game-designer.md <unity-project>/.claude/agents/
cp -r <this-template>/.claude/agents/lead-programmer.md <unity-project>/.claude/agents/
cp -r <this-template>/.claude/agents/qa-tester.md <unity-project>/.claude/agents/
cp -r <this-template>/.claude/agents/performance-analyst.md <unity-project>/.claude/agents/

cp -r <this-template>/.claude/skills <unity-project>/.claude/
# 그 후 /smoke-check 의 Godot 명령어 수동 수정

cp <this-template>/docs/GDD_TEMPLATE.md <unity-project>/docs/
cp <this-template>/docs/COLLABORATIVE-DESIGN-PRINCIPLE.md <unity-project>/docs/
cp <this-template>/docs/WORKFLOW.md <unity-project>/docs/

cp <this-template>/.gitattributes <unity-project>/
```

### 옵션 C: 듀얼 엔진 지원 (복잡함, 비권장)

하나의 템플릿에서 Godot + Unity 양쪽 지원. 유지보수 비용 큼. CCGS 원본이 이 접근인데 **솔로 인디에겐 과함**.

---

## 4. 현재 권장 사항

- **Godot 로 진행**: 이대로 사용. 최적화 완료.
- **Unity 로 전환**: 옵션 A (새 포크) 강력 권장.
- **둘 다 고민 중**: 먼저 Godot 으로 프로토타입 빌드 후 결정. 엔진 선택은 **출시 직전 포팅은 비용 100배**.

---

## 5. 향후 Unity 지원 계획

이 템플릿은 현재 Godot-first 입니다. Unity 용 별도 템플릿 개발 계획은 없음. 필요하면 [CCGS 원본](https://github.com/)을 기반으로 fork 하고 이 템플릿의 엔진 중립 요소 (GDD 템플릿, COLLABORATIVE-DESIGN-PRINCIPLE, 리뷰 스킬)만 선택적으로 이식하는 걸 권장.
