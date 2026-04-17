# production/

> CCGS 스킬들이 참조하는 프로덕션 메타데이터 폴더.
> 솔로 인디 바이브코딩 모드에서는 **경량으로만 사용**.

## 기본 파일

- `review-mode.txt` — `solo` / `lean` / `full` — CCGS 디렉터 게이트 활성화 수준 (기본: `solo`)

## 선택적 하위 폴더 (스킬이 사용 시 자동 생성)

| 폴더 | 용도 | 생성 시점 |
|------|------|----------|
| `qa/playtests/` | `/playtest-report` 실행 시 리포트 저장 | 스킬 실행 |
| `qa/bugs/` | `/bug-report` 실행 시 버그 카드 저장 | 스킬 실행 |
| `qa/evidence/` | 시각/UI 증빙 (스크린샷, 워크스루) | 스킬 실행 |
| `qa/smoke-*.md` | `/smoke-check` 결과 | 스킬 실행 |
| `sprints/` | `/sprint-plan` 실행 시 스프린트 문서 | 솔로에선 비권장 |
| `milestones/` | 마일스톤 문서 | 솔로에선 비권장 |
| `session-state/` | 세션 상태 메타데이터 | CCGS 자동 |

## 솔로 모드에서는 무엇을 써야 하나?

솔로 바이브코딩 워크플로와 CCGS 프로덕션 폴더는 **중복됨**. 권장:

- 가벼운 작업 (PLAN.md, RESEARCH.md) → `docs/` 그대로 사용
- 버그/플레이테스트 기록 → `production/qa/` 에 CCGS 형식으로
- 스프린트/마일스톤 → 솔로엔 불필요. `docs/PLAN.md` 의 Phase 로 대체

## 주의

이 폴더는 `.gitignore` 되지 **않음** — 팀 이전 시 공유되므로 민감한 노트는 `knowledge_base/Raw/` (gitignored) 에.
