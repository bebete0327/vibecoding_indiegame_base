# design/

> 게임 디자인 문서 저장소. CCGS 스킬과 스타일을 공유합니다.

## 하위 폴더 (필요 시 생성)

| 폴더 | 용도 |
|------|------|
| `gdd/` | Game Design Document — 각 시스템당 1개, `docs/GDD_TEMPLATE.md` 포맷 |
| `balance/` | 밸런스 수식, 스프레드시트, `/balance-check` 대상 |
| `narrative/` | 스토리, 대사, 로어 |
| `quick-specs/` | `/quick-design` 산출물 (경량 디자인 스펙) |

## 워크플로

1. 새 시스템 → [`docs/GDD_TEMPLATE.md`](../docs/GDD_TEMPLATE.md) 복사하여 `design/gdd/<system>.md` 로 저장
2. 작성 완료 → `/design-review design/gdd/<system>.md`
3. 작은 변경 → `/quick-design "변경 설명"` → `design/quick-specs/` 에 저장
4. 밸런스 파라미터 튜닝 → `design/balance/` 에 데이터 파일, `/balance-check` 로 검증

## 솔로 주의

솔로 인디는 보통 GDD 를 완벽하게 쓰지 않아도 됩니다. **Tuning Knobs 섹션만이라도** 꾸준히 채워두면 `/balance-check` 가 즉시 유용해집니다.
