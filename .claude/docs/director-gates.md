# Director Gates — Solo Indie Mode

> CCGS 스킬들이 `creative-director` / `technical-director` 등 디렉터 게이트를 스폰하기 전 확인하는 파일.
>
> **이 템플릿의 기본값: `solo` 모드** — 대부분의 디렉터 게이트는 스킵됩니다.
> 바꾸려면 `production/review-mode.txt` 내용을 `full` / `lean` / `solo` 중 하나로 변경.

## Review Modes

| Mode | 설명 | 디렉터 게이트 |
|------|------|--------------|
| `full` | AAA 스튜디오 — 모든 게이트 활성화 | CD/TD/QA 전체 스폰 |
| `lean` | 중간 규모 — PHASE-GATE 만 | 중요한 gate 만 스폰 |
| `solo` | **솔로 인디 (기본)** — 거의 스킵 | 대부분 스킵하고 노트만 남김 |

## Check Pattern (스킬이 사용)

```
1. 인자로 --review 플래그가 왔으면 그걸 사용
2. production/review-mode.txt 읽어 해당 값 사용
3. 둘 다 없으면 "solo" 기본값
```

## Gate Registry (CCGS 원본 기준, 솔로 모드에선 대부분 스킵)

| Gate ID | 스폰되는 에이전트 | 용도 | Solo 기본 |
|---------|------------------|------|-----------|
| `CD-BRAINSTORM` | creative-director | 컨셉 필라 검증 | 스킵 (노트만) |
| `CD-PLAYTEST` | creative-director | 플레이테스트 경험 검토 | 스킵 |
| `CD-GDD` | creative-director | GDD 비전 적합성 | 스킵 |
| `TD-ARCH` | technical-director | 아키텍처 의사결정 | 스킵 |
| `TD-PERF` | technical-director | 성능 결정 | 스킵 |

> 솔로에서 게이트가 필요하면 스킬 실행 시 `--review full` 또는 `--review lean` 플래그 지정.

## Rationale (왜 솔로 기본인가)

CCGS 의 게이트 시스템은 다인팀 핸드오프를 위한 것. 솔로 바이브코딩에서는:
- 본인이 모든 역할 (creative, technical, QA)
- 게이트 스폰은 중복 대화 발생 (본인이 본인에게 질문)
- 컨텍스트 사용량만 증가

따라서 솔로 모드는 "게이트 노트 = 내가 나중에 자문할 질문 리스트" 로 축소.
