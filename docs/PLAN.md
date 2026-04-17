# Implementation Plan

> **이 파일은 구현 전 계획을 기록하는 곳입니다.**
> 작성 후 **사용자 승인을 받고** Phase 단위로 실행하세요.
> `CLAUDE.md` 의 "Phase 3: Plan (SDD)" 단계 문서.

---

## <게임 이름> Plan — <YYYY-MM-DD>

### Status: [ ] Draft / [ ] Approved / [ ] In Progress / [ ] Done

---

### Overview
- **목표**:
- **총 Phase 수**:
- **예상 작업 규모**: 파일 N개 내외
- **핵심 원칙**: CLAUDE.md 컨벤션 준수

---

## Phase 1: <이름>

**목표**:

### 생성 파일
| 파일 | 역할 |
|------|------|
| | |

### 검증
- [ ] `"$GODOT_PATH" --headless --path . -e --quit` 통과
- [ ] GUT 테스트 N/N 통과
- [ ] 스크린샷/수동 검증

---

## Phase 2: <이름>

**목표**:

### 생성 파일
| 파일 | 역할 |
|------|------|
| | |

### 검증
- [ ]

---

## 테스트 전략

### 단위 테스트 (GUT)
- 각 Phase 마다 해당 스크립트 테스트 작성

### 통합 테스트
- Phase 완료 시마다 헤드리스 실행으로 크래시 없음 확인

### 실행 커맨드
```bash
"$GODOT_PATH" --headless --path . -e --quit
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit
"$GODOT_PATH" --path .
```

---

## Rollback Plan
- 각 Phase 는 독립된 Git 커밋으로 남김
- 문제 발생 시 `git reset --hard HEAD~N` 으로 해당 Phase 만 되돌림
- `knowledge_base/Raw/` 에 문제 원인 기록 후 Wiki 문서화

---

## 사용자 승인 요청 사항

**다음 결정이 필요합니다:**

### 결정 1: <질문>
- [ ] **A**:
- [ ] **B**:

### 결정 2: 구현 진행 방식
- [ ] **A**: 전체 Phase 자동 진행 (중간 보고)
- [ ] **B**: Phase 별 완료 시마다 승인 받고 진행
- [ ] **C**: 일부 Phase 만 먼저

---

> **사용자 승인 후 Phase 1부터 시작합니다.**
