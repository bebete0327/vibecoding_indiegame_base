# WORKFLOW — "이 변경에 어떤 플로우를 써야 하지?"

> 이 템플릿은 두 가지 작업 흐름을 함께 제공합니다. 기본은 **솔로 바이브코딩 루프**, 확장으로 **CCGS 디자인 파이프라인**. 둘 다 쓸지, 하나만 쓸지 이 결정 트리로 판단하세요.

---

## 🎯 결정 트리 (한 줄 요약)

```
이 변경은 얼마나 크고, 무엇을 만지는가?
├── 1시간 미만 버그/튜닝             → 바로 구현 (문서 없음)
├── 4시간 미만 소규모 추가           → /quick-design → 구현
├── 1일~1주 기능                    → docs/RESEARCH.md + docs/PLAN.md → 구현
└── 1주 이상 / 새 시스템 / 복잡한 메카닉 → GDD 작성 (docs/GDD_TEMPLATE.md) → docs/PLAN.md → 구현
```

---

## 📏 기준 4가지

각 기준을 먼저 체크하고 가장 상위 단계의 플로우를 선택.

### 1. 예상 구현 시간

| 범위 | 플로우 |
|------|--------|
| < 1시간 | 바로 구현. 코드 주석으로 충분. |
| 1~4시간 | `/quick-design "변경 설명"` → `design/quick-specs/` 에 1쪽 스펙 → 구현 |
| 0.5~5일 | `docs/RESEARCH.md` (기존 코드 분석) + `docs/PLAN.md` (Phase 계획) |
| > 5일 | GDD 먼저 (`docs/GDD_TEMPLATE.md` 기반) → PLAN.md → Phase 실행 |

### 2. 영향 범위

| 영향 | 플로우 |
|------|--------|
| 1개 파일 | 바로 구현 |
| 1개 시스템 내부 | RESEARCH.md + PLAN.md |
| 여러 시스템 연결 | GDD 작성 (§6 Dependencies 섹션이 핵심) |
| Autoload/프로젝트 설정 변경 | GDD + `technical-director` 에이전트 자문 |

### 3. 밸런스/수식 포함 여부

| 여부 | 플로우 |
|------|--------|
| 없음 (순수 로직/UI) | RESEARCH.md + PLAN.md 면 충분 |
| 수치 조정만 | `/quick-design` → `/balance-check` 로 검증 |
| 수식/커브 새로 설계 | GDD §4 Formulas + §7 Tuning Knobs 필수 |

### 4. 플레이어 경험에 영향

| 영향 | 플로우 |
|------|--------|
| 없음 (리팩토링) | `/code-review` 만 |
| 미미 (튜닝) | `/quick-design` + `/playtest-report` 후속 |
| 큼 (새 메카닉) | GDD §2 Player Fantasy 필수, `/playtest-report` 로 검증 |

---

## 🔄 실제 예시 시나리오

### 예시 A: "점프 높이 5.0 → 6.0 으로 조정"
- 시간: 5분 · 영향: 1파일 · 밸런스: 수치 · UX: 미미
- **결정**: `/quick-design "jump height tune"` → `design/quick-specs/jump-tune-20260417.md` → 값 수정 → `/balance-check combat`

### 예시 B: "대쉬에 무적 프레임 추가"
- 시간: 2시간 · 영향: 1시스템 · 밸런스: 없음 · UX: 중간
- **결정**: `docs/RESEARCH.md` 에 현재 대쉬 구현 분석 → `docs/PLAN.md` Phase 1개 → 구현 → `/code-review` → `/playtest-report`

### 예시 C: "크래프팅 시스템 신규 구현"
- 시간: 2주 · 영향: 여러 시스템 · 밸런스: 레시피/재료 · UX: 큼
- **결정**: `design/gdd/crafting.md` 작성 (8섹션) → `creative-director` 에이전트로 필라 검토 → `docs/PLAN.md` 다단계 Phase → Phase 별 구현+`/code-review` → `/balance-check` → `/playtest-report`

### 예시 D: "버그 수정 — 점프 시 가끔 2번 뛰어짐"
- 시간: 30분 · 영향: 1파일 · 밸런스: 없음 · UX: 없음(버그)
- **결정**: 바로 원인 분석 → 수정 → regression test 추가 → commit. 문서 없음.

---

## 🧭 언제 어떤 스킬을 부르나

| 단계 | 추천 스킬 |
|------|----------|
| 빈 프로젝트 / 컨셉 결정 | `/brainstorm` |
| 소규모 디자인 | `/quick-design` |
| GDD 품질 검토 | `game-designer` 에이전트에게 수동 위임 (스킬 `/design-review` 는 이 템플릿에서 제거됨) |
| 구현 후 품질 게이트 | `/code-review` |
| 커밋 전 sanity check | `/smoke-check` |
| 수치 조정 후 | `/balance-check` |
| 프레임 드랍 의심 | `/perf-profile` |
| 플레이테스트 후 | `/playtest-report` |
| 마일스톤 | `/retrospective` |
| 분기별 부채 점검 | `/tech-debt` |

---

## 🚦 바이브코딩 루프와의 관계

[CLAUDE.md](../CLAUDE.md) 의 **Vibe Coding Workflow** 는 위 결정 트리의 **3단계 "1일~1주"** 플로우를 기본 가정합니다.

```
기본 (CLAUDE.md):   Research → Plan → Implement → Test → Commit
확장 (>5일 시):     + Brainstorm → GDD → Research → Plan → ... → Playtest Report
축소 (<4시간 시):   Quick Design → Implement → Smoke Check
```

**어떤 플로우든 공통**: `/code-review` + `/smoke-check` 는 커밋 전 필수.

---

## ⚠️ 과다 설계(over-engineering) 주의

바이브코딩의 장점은 빠른 반복. 다음은 **안 하는 게 낫습니다**:

- 10분 짜리 버그에 GDD 를 쓰는 것
- 1회성 프로토타입에 `/playtest-report` 를 돌리는 것
- 솔로 프로젝트에 `creative-director` + `technical-director` 를 동시 스폰하는 것 (대화 중복)
- `docs/RESEARCH.md` 와 `design/gdd/*.md` 를 같은 시스템에 둘 다 작성하는 것 (하나만)

**한 문장 룰**: 문서 작성 시간이 구현 시간의 30% 를 넘으면 축소.
