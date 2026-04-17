# ECC Optimization & Cost Reduction Guide

## Tags
- category: tool, automation
- difficulty: intermediate
- related: [[harness-engineering]], [[godot-vibecoding-basics]]

## Summary
ECC(Everything Claude Code) v1.10.0 최적화 설정 및 비용 절감 전략.

## 1. Cost Reduction (비용 절감)

### 모델 전환 전략
| 작업 유형 | 권장 모델 | 방법 |
|-----------|-----------|------|
| 단순 코드 작성, 리팩토링 | Sonnet (기본) | `/model sonnet` |
| 복잡한 아키텍처 설계 | Opus | `/model opus` |
| 단순 조회, 파일 검색 | Haiku (서브에이전트) | 자동 선택됨 |
| 빠른 출력 필요 시 | Fast mode | `/fast` 토글 |

**핵심**: 대부분의 바이브코딩 작업은 Sonnet으로 충분. Opus는 복잡한 설계/디버깅에만.

### Thinking Token 최적화
Claude Code에서 직접 `maxThinkingTokens`를 설정하는 것은 현재 불가.
대신 다음으로 대체:
- **짧고 명확한 프롬프트**: AI의 추론 비용 자체를 줄임
- **RESEARCH.md + PLAN.md 워크플로우**: 한번에 정확한 작업 지시
- **`/fast` 모드**: 빠른 출력으로 토큰 효율 향상

## 2. Context Management (컨텍스트 관리)

### Context Rot 방지 규칙
| 명령어 | 언제 사용 | 주의사항 |
|--------|-----------|----------|
| `/clear` | 작업 단위 변경 시 | 이전 작업 잔상 제거 |
| `/compact` | 마일스톤 도달 시 (기획 완료, 디버깅 종료) | **구현 중 사용 금지!** |

### Attention Dilution (어텐션 희석) 방지
- 하나의 세션에서 너무 많은 작업을 하지 않기
- 3개 이상의 기능을 한 세션에서 구현하지 않기
- 긴 대화가 누적되면 `/clear` 후 새 세션 시작

### 작업 단위 분리
```
기능 A 구현 → /clear → 기능 B 구현 → /clear → 테스트
```
각 세션은 독립적으로 CLAUDE.md를 다시 읽으므로 규칙 준수가 유지됨.

## 3. Instinct & Evolve (지속 학습 시스템)

### ECC의 학습 체계
- **Instinct**: 사용자의 패턴을 관찰하여 저장하는 최소 단위
- **Evolve (`/evolve`)**: 3회 이상 반복된 패턴을 정식 스킬 모듈로 승격

### Claude Code 메모리 시스템과 연계
Claude Code 자체 메모리(`~/.claude/projects/.../memory/`)도 동일한 역할:
- 사용자 피드백 → feedback 메모리로 저장
- 프로젝트 컨벤션 → 자동 학습
- "이렇게 하지 마" → 다음 세션부터 자동 적용

### 실전 활용
```
사용자: "GDScript에서는 항상 @export 대신 Resource 패턴 사용해줘"
→ AI가 메모리에 저장
→ 다음 세션부터 자동 적용
→ 3회 이상 패턴 확인 시 CLAUDE.md에 영구 규칙으로 추가 가능
```

## 4. Security (Agent Shield)

### 보안 검증 도구
| 도구 | 설명 | 사용법 |
|------|------|--------|
| ECC Security Scan | 코드 보안 취약점 스캔 | `/security-scan` |
| gstack CSO | OWASP + STRIDE 보안 감사 | `/cso` |
| gstack Guard | 위험한 변경 감지 | `/guard` |

### 보안 체크리스트 (게임 개발용)
- [ ] 세이브 데이터 암호화/검증
- [ ] 네트워크 통신 시 입력 검증
- [ ] API 키/시크릿이 코드에 하드코딩되지 않았는지
- [ ] 사용자 입력 새니타이징 (채팅, 이름 등)

## 5. ECC Key Commands Reference

### 기획/설계
| 명령어 | 설명 |
|--------|------|
| `/ecc:plan` | 기능 기획 및 아키텍처 설계 |
| `/office-hours` | (gstack) 엔지니어링 상담 |
| `/plan-ceo-review` | (gstack) CEO 관점 리뷰 |
| `/plan-eng-review` | (gstack) 엔지니어링 리뷰 |

### 개발
| 명령어 | 설명 |
|--------|------|
| `/tdd` | 테스트 주도 개발 가이드 |
| `/review` | (gstack) 코드 리뷰 |
| `/careful` | (gstack) 신중 모드 |

### 배포/검증
| 명령어 | 설명 |
|--------|------|
| `/security-scan` | 보안 취약점 스캔 |
| `/cso` | (gstack) 보안 감사 |
| `/qa` | (gstack) QA 테스트 |
| `/ship` | (gstack) 배포 |
| `/retro` | (gstack) 회고 |
