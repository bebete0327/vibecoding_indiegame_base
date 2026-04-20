# Game Concept — {{GAME_TITLE}}

> `/brainstorm` 스킬이 이 템플릿을 채워 `design/gdd/game-concept.md` 로 저장합니다.
> 완성 후 시스템별 상세 GDD 는 [`docs/GDD_TEMPLATE.md`](../../../docs/GDD_TEMPLATE.md) 포맷으로 작성.

---

## Core Identity

| Field | Value |
|-------|-------|
| **Working Title** | {{TITLE}} |
| **Elevator Pitch** | 1-2 문장 — "10초 테스트" 통과해야 |
| **Core Verb** | 가장 자주 하는 행동 1개 (build/fight/explore/solve/...) |
| **Core Fantasy** | 플레이어가 느끼길 바라는 정서 |
| **Unique Hook** | "Like X, AND ALSO Y" 포맷 |
| **Primary MDA Aesthetic** | sensation/fantasy/narrative/challenge/fellowship/discovery/expression/submission 중 1 |
| **Estimated Scope** | Small (weeks) / Medium (months) / Large (X-Y months, solo) |
| **Target Platform** | PC / Mobile / Console / Web / Multi |
| **Engine** | Godot 4.6 (이 템플릿 기준) |

---

## Player Experience

### Primary Player Type (Bartle)
- Achiever / Explorer / Socializer / Killer 중 선택 + 이유

### Flow State Design
- **Challenge curve**: 난이도가 어떻게 상승/조정되는가
- **Clear goals**: 플레이어가 매 순간 무엇을 해야 할지 아는가
- **Immediate feedback**: 행동 결과가 즉시 보이는가

### Player Motivation (Self-Determination Theory)
- **Autonomy**: 얼마나 의미있는 선택을 주는가
- **Competence**: 숙련도가 어떻게 성장하는가
- **Relatedness**: 캐릭터/세계와의 연결

---

## Pillars (3-5)

디자인 결정의 북극성. 서로 긴장을 유지해야 진짜 필라.

1. **{{PILLAR_1}}** — 한 문장 정의
   - **Design Test**: "X vs Y 중 선택 시 이 필라는 ___을 고른다"
2. **{{PILLAR_2}}** — 한 문장 정의
   - **Design Test**: ...
3. **{{PILLAR_3}}** — 한 문장 정의
   - **Design Test**: ...

### Anti-Pillars (3+)
이 게임이 **아닌** 것. 스코프 크립 방지.

- "우리는 **X** 를 하지 **않는다** — **{{PILLAR}}** 를 훼손하기 때문"

---

## Visual Identity Anchor

- **Named direction**: (AD-CONCEPT-VISUAL 게이트 또는 사용자가 지정)
- **One-line visual rule**: 예 "All characters must be silhouette-readable from 2 screen heights"
- **Supporting principles** (2-3개):
  1. ...
  2. ...
- **Color philosophy**: ...

---

## Core Loop

### 30-Second Loop (moment-to-moment)
- Core action feel: ...
- Intrinsic satisfaction: Audio feedback / Visual juice / Timing / Tactical depth

### 5-Minute Loop (short-term goals)
- Structure: ...
- "One more turn" psychology: ...

### Session Loop (30-120 min)
- Complete session look like: ...
- Natural stopping points: ...

### Progression Loop (days/weeks)
- Growth: Power / Knowledge / Options / Story
- Long-term goal: ...
- "Done" condition: ...

---

## MVP Definition

핵심 루프가 **재미있는지** 검증할 최소 빌드.

- Minimum playable: ...
- Cut if time runs out: ...
- Must have: ...

---

## Scope Tiers

| Tier | Content | Timeline |
|------|---------|----------|
| **MVP** | 최소 | X주 |
| **V1.0** | 출시 버전 | Y월 |
| **Full Vision** | 꿈 | Z월 |

---

## Risks

| Risk | Type (Tech/Design/Market) | Mitigation |
|------|---------------------------|------------|
| ... | ... | ... |

---

## Next Steps (이 템플릿 기준)

컨셉 작성 후:

1. 시스템 분해 → 각 시스템당 [GDD_TEMPLATE.md](../../../docs/GDD_TEMPLATE.md) 복사하여 `design/gdd/<system>.md`
2. `docs/RESEARCH.md` 작성 (관련 코드/레퍼런스 분석)
3. `docs/PLAN.md` Phase 분할 → 사용자 승인
4. Phase 1 구현 시작 — `Task(godot-gdscript-specialist)` 로 위임 가능
5. 구현 완료 후 `/code-review`, `/smoke-check`, `/playtest-report`

---

**Created**: {{DATE}}
**Creative Director Verdict**: {{CD_VERDICT or "Solo mode — CD gate skipped"}}
