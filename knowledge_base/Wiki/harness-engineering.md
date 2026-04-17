# Harness Engineering Guide

## Tags
- category: harness
- difficulty: intermediate
- related: [[godot-vibecoding-basics]]

## Summary
AI가 실수를 반복하지 않도록 구조적 울타리를 치는 하네스 엔지니어링의 4대 기둥.

## The 4 Pillars

### 1. Context Files (컨텍스트 파일)
AI가 매 세션마다 읽는 지침 문서.

| 파일 | 역할 | 읽는 시점 |
|------|------|-----------|
| `CLAUDE.md` | 프로젝트 헌법 | 세션 시작 시 자동 |
| `docs/RESEARCH.md` | 분석 결과 | 코딩 전 필수 |
| `docs/PLAN.md` | 구현 계획 | 구현 전 필수 |
| `docs/ARCHITECTURE.md` | 아키텍처 | 구조 변경 시 |
| `docs/CONVENTIONS.md` | 코딩 규칙 | 코드 작성 시 |

**핵심**: CLAUDE.md가 "읽어라"고 지시하면 AI는 반드시 읽음.

### 2. Hooks (자동화 훅)
코드 수정 시 자동으로 실행되는 검증 스크립트.

```json
// .claude/settings.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "godot --headless --check-only --path .",
        "description": "GDScript 문법 자동 체크"
      }
    ]
  }
}
```

**서킷 브레이커**: 에러 → AI에게 자동 피드백 → 즉시 수정

### 3. Gating (도구 경계 설정)
AI가 승인 없이 할 수 없는 작업을 명시.

CLAUDE.md에서 설정:
- `project.godot` 수정 금지
- 3개 이상 파일 동시 수정 금지
- PLAN.md 승인 없이 구현 금지

### 4. Feedback Loop (피드백 루프)
작업 결과를 기록하여 AI가 같은 실수를 반복하지 않게 함.

```
실패 사례 → knowledge_base/Raw/에 기록
         → AI가 Wiki로 정제
         → 다음 세션에서 참고
```

## Context Rot Prevention

### 문제: Context Rot
긴 세션에서 AI가 초기 지침을 잊어버리는 현상.

### 해결 방법
1. **작업 단위 분리**: 하나의 기능을 잘게 쪼개어 Phase별 실행
2. **상태 파일**: 진행 상황을 PLAN.md에 체크 표시로 기록
3. **세션 리프레시**: 큰 작업은 여러 세션으로 나누어 진행
4. **CLAUDE.md 참조**: "잘 모르겠으면 CLAUDE.md를 다시 읽어라" 규칙 추가

## Practical Example

```
사용자: "플레이어 이동 기능 만들어줘"

[AI Workflow]
1. CLAUDE.md 읽음 → 규칙 확인
2. docs/RESEARCH.md에 기존 코드 분석 기록
3. docs/PLAN.md에 구현 계획 작성
4. 사용자에게 PLAN.md 승인 요청
5. (승인 후) scripts/player_controller.gd 작성
6. Hook이 자동으로 godot --headless --check-only 실행
7. 에러 있으면 자동 수정, 없으면 완료 보고
8. knowledge_base에 성공 사례 기록
```

## ECC Integration

ECC(Everything Claude Code) 설치 시 추가되는 하네스:
- `/ecc:plan` → 더 정교한 계획 수립
- `/tdd` → 테스트 주도 개발 자동화
- `/security-scan` → 보안 취약점 자동 검사
- 38+ 전문 에이전트 호출 가능

## Paperclip Integration

paperclip.ing으로 에이전트 팀 운영:
```bash
npx paperclipai onboard --yes
```

역할별 에이전트:
- **CEO**: 전략 설정, 업무 분배
- **Developer**: Claude Code로 코딩
- **QA**: 테스트 및 품질 검증
- **Designer**: 기획 문서 작성
