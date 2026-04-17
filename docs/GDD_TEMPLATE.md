# Game Design Document Template

> **용도**: 게임의 각 시스템/메카닉마다 하나씩 작성하는 GDD 템플릿.
> **경로**: `design/gdd/<system_name>.md` 로 복사해서 사용.
> **출처**: Claude Code Game Studios 컨벤션의 8-섹션 포맷.
>
> **언제 쓰나**: 구현량이 ~1주 이상인 시스템. 더 작은 변경은 [quick-design](../.claude/skills/quick-design/SKILL.md) 스킬로 처리.

---

## 1. Overview

한 문단 요약. "무엇을, 누가, 왜." 한 화면에 보이는 범위.

## 2. Player Fantasy

플레이어가 이 시스템을 **느끼는** 경험.
> 예: "맨몸의 전사가 되어 거대한 보스를 해체하는 카타르시스"
> 예: "내가 설계한 도시가 스스로 살아 움직이는 쾌감"

기능이 아니라 정서(fantasy)를 기술. 구현이 길을 잃을 때 돌아올 북극성.

## 3. Detailed Rules

명확한 메커닉 규칙. 모호함 없이.
- 상호작용 트리거: X 일 때 Y
- 상태 머신: State A → 조건 → State B
- 입력 → 동작 대응 테이블
- 데미지 계산 순서, 스탯 적용 순서

## 4. Formulas

모든 수식은 변수명과 함께 명시.

```
damage = (base_atk × weapon_mult) × (1 - defense / (defense + 100))
crit_damage = damage × crit_mult
xp_to_next_level(n) = 50 × n × (1 + 0.15 × n)
```

변수는 **§7 Tuning Knobs** 에 튜닝 가능값으로 등록.

## 5. Edge Cases

특이 상황 명시.
- 플레이어 HP 0 인데 힐 받음 → ?
- 네트워크 연결 끊김 중 세이브 시도 → ?
- 애니메이션 도중 죽음 → ?
- 중첩된 버프/디버프 동시 적용 → 우선순위

"이런 경우 어떻게?"를 구현 전에 답해두는 섹션.

## 6. Dependencies

이 시스템이 **의존하는** 다른 시스템.
- `HealthComponent` — 데미지 수신
- `SaveManager` — 영속화
- `EventBus.player_died` — 수신

이 시스템을 **사용하는** 시스템도 기록.
- `AchievementSystem` — 보스 처치 시 트리거
- `QuestLog` — 진행도 업데이트

의존성 방향을 명시하면 순환 참조를 사전 방지.

## 7. Tuning Knobs

**디자이너가 조정할 수 있는 값**. 데이터 파일 (`assets/data/*.tres` 또는 `.json`) 로 빼낼 후보.

| Parameter | Range | Default | Effect |
|-----------|-------|---------|--------|
| `base_atk` | 1–50 | 10 | 공격력 스케일 |
| `crit_mult` | 1.0–5.0 | 2.0 | 치명타 배수 |
| `xp_curve_growth` | 0.05–0.30 | 0.15 | 레벨업 난이도 곡선 |

[rules/gameplay-code.md](../.claude/rules/gameplay-code.md) 에 따라 하드코딩 금지 — 이 표의 값은 전부 Resource/config 파일에서 로드.

## 8. Acceptance Criteria

테스트 가능한 완료 조건. GUT 테스트 또는 스크린샷으로 검증.

- [ ] 기본 공격이 데미지 수식대로 계산됨 (단위 테스트)
- [ ] 치명타 발생 시 §4 수식과 일치 (단위 테스트)
- [ ] 플레이어 HP 0 도달 시 `game_over` 시그널 발동 (통합 테스트)
- [ ] 보스 방에서 60fps 유지 (수동 프로파일, `perf-profile` 스킬)
- [ ] 게임패드/키보드/마우스 모두 동작 (수동 QA, `playtest-report`)

---

## 관련 스킬

- 신규 GDD 검증 → `/design-review`
- 수치만 튜닝 → `/quick-design` (GDD 대신 Quick Spec)
- 구현 완료 후 밸런스 점검 → `/balance-check`
- 수식 변경 시 하위 영향 → 직접 `dependencies` 섹션 재검토
