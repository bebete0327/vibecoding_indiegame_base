# CCGS Integration — Claude Code Game Studios 이식 가이드

**출처**: [Claude-Code-Game-Studios](https://github.com/) (49 agents, 72 skills, 12 hooks 중 인디 Godot 용도로 큐레이션)
**이식일**: 2026-04-17
**이식 범위**: 7 agents + 15 skills + 14 engine-reference docs + 5 rules + 2 design docs

---

## 왜 일부만 가져왔나

CCGS 는 다인팀 AAA 개발을 전제로 한 대형 프레임워크. 솔로 인디 바이브코딩에는 다음이 과했음:

- `team-*` 스킬 (team-combat, team-narrative 등) — 부서간 핸드오프 워크플로
- Unity/Unreal 전문 에이전트 (`unity-*`, `ue-*`) — 우리는 Godot-only
- Live-ops / Localization / Release-manager — 출시 후 단계
- Network / Multiplayer 스페셜리스트 — 싱글플레이 전제

대신 **솔로 개발자에게 직접 도움이 되는 것만** 추렸습니다.

---

## 무엇을 가져왔나

### Agents (`.claude/agents/`)

| Agent | 언제 사용 |
|-------|----------|
| `godot-specialist` | 씬/노드 아키텍처, 엔진 전반 의사결정 (Task tool 로 위임) |
| `godot-gdscript-specialist` | GDScript 코드 품질, 타입, 시그널 아키텍처 |
| `godot-shader-specialist` | 셰이더 (`.gdshader`) 작성/최적화 |
| `godot-gdextension-specialist` | 성능 핫스팟의 C++/Rust 확장 판단 |
| `creative-director` | 게임 필라 검토, "재미 있는가" 판단 |
| `technical-director` | 아키텍처 큰 그림, 기술 선택 |
| `game-designer` | 메카닉 설계, GDD 작성 도움 |

에이전트 호출은 Claude Code 의 Task 도구로: `"ask godot-gdscript-specialist to review this signal architecture"` 같은 형태.

### Skills (`.claude/skills/` — 슬래시 명령으로 노출됨)

| Skill | 용도 | 언제 |
|-------|------|------|
| `/brainstorm` | 게임 컨셉 아이데이션 (구조화된 질의) | 프로젝트 시작 |
| `/quick-design` | 4시간 이하 변경의 경량 디자인 스펙 | 소규모 튜닝/추가 |
| `/scope-check` | 스코프 크립 탐지 + 컷 추천 | 스프린트 중간/끝 |
| `/balance-check` | 밸런스 수식/데이터 이상치 분석 | 데이터 튜닝 후 |
| `/design-review` | GDD 품질 검토 | 새 GDD 작성 후 |
| `/code-review` | SOLID + 엔진 패턴 준수 코드 리뷰 | 스토리 완료 전 |
| `/smoke-check` | 기본 런/빌드/기본기능 확인 | 커밋 전 |
| `/perf-profile` | 성능 프로파일 (프레임, 메모리, 드로우콜) | 실감 이슈 발생 시 |
| `/tech-debt` | 기술 부채 카탈로그 + 우선순위 | 분기별 |
| `/retrospective` | 회고 — 잘됨/안됨/액션 | 마일스톤 후 |
| `/bug-report` | 구조화된 버그 보고서 생성 | 버그 발견 시 |
| `/bug-triage` | 버그 큐 우선순위화 | 주간 |
| `/playtest-report` | 플레이테스트 노트 → 구조화 | 테스트 세션 후 |
| `/prototype` | 프로토타이핑 가이드 | 새 메카닉 검증 |
| `/sprint-plan` | 스프린트 플래닝 템플릿 | 스프린트 시작 |

**솔로 모드 주의**: 스킬 중 일부 (`playtest-report`, `sprint-plan`) 는 멀티 레뷰어 모드가 기본. `--review solo` 플래그로 간소화.

### Engine Reference (`docs/engine-reference/godot/`)

LLM 지식 컷오프 (May 2025) 이후 Godot 4.4~4.6 변경사항을 정리한 문서. **에이전트가 최신 API 를 제안하기 전 의무적으로 참조**.

| 파일 | 내용 |
|------|------|
| `VERSION.md` | 현재 버전 고정 (4.6), 지식갭 위험도 |
| `breaking-changes.md` | 4.3→4.4→4.5→4.6 버전별 breaking change |
| `current-best-practices.md` | 변이드 함수 `@abstract`, Jolt 기본화 등 새 기능 |
| `deprecated-apis.md` | `yield()` → `await`, `instance()` → `instantiate()` 등 |
| `modules/*.md` | 8개 서브시스템 (animation/audio/input/navigation/networking/physics/rendering/ui) 의 현재 베스트 프랙티스 |

### Rules (`.claude/rules/`)

각 코드 범주별 필수 규칙. 리뷰 스킬이 자동 검토.

| 파일 | 범위 |
|------|------|
| `gameplay-code.md` | 하드코딩 금지, delta 사용, DI 원칙 |
| `test-standards.md` | 테스트 명명, 결정성, 격리 |
| `ui-code.md` | UI ↔ 게임 상태 분리 |
| `shader-code.md` | 셰이더 작성 규약 |
| `data-files.md` | `.tres`/`.json` 데이터 구조 규약 |

### Docs (`docs/`)

| 파일 | 내용 |
|------|------|
| `COLLABORATIVE-DESIGN-PRINCIPLE.md` | **핵심 철학** — 자율 생성이 아니라 Question→Options→Decision→Draft→Approval 패턴 |
| `GDD_TEMPLATE.md` | 8-섹션 GDD 템플릿 (Overview/Fantasy/Rules/Formulas/Edge/Deps/Knobs/Acceptance) |

---

## 기존 템플릿과의 통합

우리 템플릿의 기존 구조와 어떻게 공존하는지:

| 기존 | CCGS 추가분 | 통합 |
|------|------------|------|
| `docs/RESEARCH.md` → `PLAN.md` → 구현 | `/brainstorm` → `docs/GDD_TEMPLATE.md` → `/design-review` → 기존 플로우 | 브레인스토밍/GDD 단계 앞에 추가 |
| `docs/CONVENTIONS.md` | `.claude/rules/*` | CONVENTIONS 가 한국어 요약, rules 가 구체적 체크 |
| `docs/ARCHITECTURE.md` | `docs/engine-reference/godot/` | ARCHITECTURE 가 "우리 프로젝트", engine-reference 가 "Godot 4.6 최신 API" |
| GUT 테스트 | `/code-review`, `/smoke-check` | 테스트를 작성하는 건 여전히 GUT, 리뷰 스킬이 품질 게이트 |

---

## 권장 워크플로 (기존 바이브코딩 루프 + CCGS)

```
[시작]
   ↓
/brainstorm          ← CCGS: 구조화된 아이데이션
   ↓
docs/RESEARCH.md     ← 기존: 관련 코드 분석
   ↓
docs/GDD_TEMPLATE → design/gdd/<system>.md  ← CCGS: 8-섹션 디자인 문서
   ↓
/design-review       ← CCGS: GDD 품질 검토
   ↓
docs/PLAN.md         ← 기존: Phase 계획 (사용자 승인)
   ↓
구현 (Godot 전문가 에이전트에게 delegate 가능)
   ↓
GUT 테스트          ← 기존
   ↓
/code-review         ← CCGS: 코드 품질 게이트
   ↓
/scope-check         ← CCGS: 스코프 크립 확인
   ↓
/smoke-check         ← CCGS: 커밋 전 런 체크
   ↓
git commit + knowledge_base 기록
   ↓
/retrospective       ← CCGS: 마일스톤 회고
```

---

## 스킵한 것 (참고용)

관심 있으면 원본 레포 (`Claude-Code-Game-Studios`) 에서 필요 시 추가 이식:

- **team-* 스킬** (team-combat, team-narrative, team-ui 등) — 다인팀 조율
- **sprint-status, story-done, story-readiness** — 스토리 기반 워크플로 (우리는 PLAN.md Phase 기반)
- **ux-design, ux-review** — 대형 UX 단계 (인디는 playtest-report 로 충분할 때 많음)
- **release-checklist, launch-checklist, day-one-patch** — 출시 임박 시 개별 이식
- **setup-engine, create-epics, create-stories** — 과정 오버헤드 큼
- **Unity/UE 에이전트들** — 다른 엔진 프로젝트로 확장 시 추가

---

## 업데이트

원본 CCGS 가 개선될 경우, 우리가 가져간 파일만 `docs/UPGRADE.md` 의 cherry-pick 절차로 동기화.
