# Claude Code Game Studios - Agent Hierarchy

## Tags
- category: harness, automation
- difficulty: advanced
- related: [[harness-engineering]], [[ecc-optimization-guide]]

## Summary
단일 AI와 대화하는 것이 아니라, 역할별 전문가 페르소나를 부여하여 팀처럼 운영하는 전략.

## Agent Hierarchy (에이전트 계층)

### Tier 1: 의사결정 (Decision)
| 역할 | 페르소나 | 담당 |
|------|----------|------|
| **Creative Director** | 게임 전체 비전, UX 방향 | "이 기능이 게임의 재미를 높이는가?" |
| **Tech Lead** | 아키텍처 의사결정 | "이 구조가 확장 가능한가?" |

### Tier 2: 실행 (Execution)
| 역할 | 페르소나 | 담당 |
|------|----------|------|
| **Main Programmer** | GDScript 코딩 | 핵심 게임 로직 구현 |
| **Art Director** | 비주얼 방향성 | AI 에셋 프롬프트, 스타일 가이드 |
| **Level Designer** | 씬/레벨 구성 | .tscn 파일 설계, 밸런싱 |

### Tier 3: 검증 (Validation)
| 역할 | 페르소나 | 담당 |
|------|----------|------|
| **QA Engineer** | 버그 탐지 | GUT 테스트 작성, 엣지 케이스 |
| **Code Reviewer** | 코드 품질 | GDScript 컨벤션, 성능 |

## Claude Code에서 활용하는 방법

### 방법 1: 프롬프트에서 역할 지정
```
"너는 지금 QA Engineer 역할이야. 이 player_controller.gd에서 
버그가 될 수 있는 엣지 케이스를 모두 찾아서 GUT 테스트로 작성해줘."
```

### 방법 2: gstack 스킬 활용
| 원하는 역할 | gstack 명령어 |
|------------|--------------|
| CEO/Creative Director | `/plan-ceo-review` |
| Tech Lead | `/plan-eng-review` |
| Code Reviewer | `/review` |
| QA Engineer | `/qa` |
| Security Officer | `/cso` |

### 방법 3: ECC 에이전트 호출
ECC에 내장된 38+ 전문 에이전트:
- **Planner**: 기능 기획
- **Architect**: 시스템 설계
- **TDD-Guide**: 테스트 주도 개발
- **Code-Reviewer**: 코드 리뷰

## 실전 워크플로우 예시

```
1. [Creative Director] "타워 디펜스 게임의 웨이브 시스템 구상"
   → /office-hours 또는 /plan-ceo-review

2. [Tech Lead] "웨이브 시스템 아키텍처 설계"
   → /plan-eng-review → docs/PLAN.md 작성

3. [Main Programmer] "코드 구현"
   → PLAN.md 기반 단계별 코딩

4. [QA Engineer] "테스트 작성 및 실행"
   → GUT 테스트 작성 → headless 실행

5. [Code Reviewer] "최종 리뷰"
   → /review → 피드백 반영

6. [Creative Director] "게임 필 확인"
   → 스크린샷으로 결과 검토
```

## 주의사항
- 한 세션에서 역할을 너무 자주 전환하면 컨텍스트 오염 발생
- 역할 전환 시 `/clear` 사용 권장
- 복잡한 기능은 역할별 세션 분리가 이상적
