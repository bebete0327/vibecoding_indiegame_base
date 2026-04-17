# UPGRADE — 기존 프로젝트에 템플릿 업데이트 반영

> 이 템플릿은 계속 개선됩니다. 이미 이 템플릿으로 시작한 게임 프로젝트에 새 기능/수정사항을 반영하는 방법.

---

## 1. 업그레이드 전략 선택

### 전략 A: Cherry-pick (권장)
템플릿 저장소의 특정 커밋만 골라 적용. 게임 코드와 충돌 최소.

### 전략 B: 전체 rebase
템플릿을 upstream 으로 등록하고 merge. 충돌 해결 부담이 큼 — 초기 개발 단계에서만 권장.

### 전략 C: 수동 복사
`diff` 로 변경사항 확인 후 필요한 파일만 직접 복사. 안전하지만 시간 소요.

---

## 2. Cherry-pick 절차

```bash
# 1) 게임 프로젝트에 템플릿 리모트 등록 (최초 1회)
cd /path/to/my-game
git remote add template https://github.com/<owner>/godot-vibe-template.git
git fetch template main

# 2) 업그레이드 브랜치 생성
git checkout -b template-upgrade

# 3) 템플릿 신규 커밋 확인
git log --oneline template/main ^HEAD

# 4) 원하는 커밋만 cherry-pick
git cherry-pick <commit-sha>

# 5) 충돌 해결 후 검증
"$GODOT_PATH" --headless --path . -e --quit
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit

# 6) 메인 브랜치로 머지
git checkout main
git merge template-upgrade
```

---

## 3. 충돌이 자주 나는 파일

| 파일 | 왜 충돌하나 | 해결 팁 |
|------|-------------|---------|
| `project.godot` | autoload/input map/렌더러 모두 여기 | 섹션별로 수동 머지 — `[autoload]` 와 `[input]` 은 추가만 하면 대부분 무충돌 |
| `CLAUDE.md` | 프로젝트마다 컨벤션 커스터마이즈 | 템플릿의 공통 규칙만 반영, 프로젝트별 내용은 유지 |
| `docs/PLAN.md` / `RESEARCH.md` | 게임별 고유 내용 | 템플릿 변경사항 무시하는 게 보통 안전 |
| `scenes/main.tscn` | 각 게임이 다르게 구성 | 절대 덮어쓰지 말 것 |

---

## 4. 안전한 업그레이드 확인 체크리스트

- [ ] `git status` 에 커밋되지 않은 변경이 없음
- [ ] 백업 브랜치 생성 (`git branch backup-$(date +%Y%m%d)`)
- [ ] `"$GODOT_PATH" --headless --path . -e --quit` 오류 없이 통과
- [ ] `GUT` 전부 통과
- [ ] Godot 에디터에서 메인 씬 정상 플레이 확인
- [ ] (기존 세이브 파일이 있다면) 로드 정상 동작 확인

---

## 5. Breaking Change 가 포함된 업그레이드

템플릿의 `CHANGELOG.md` 에서 **BREAKING** 태그가 붙은 커밋을 별도로 확인.
마이그레이션 가이드가 있으면 해당 커밋 본문에 포함됩니다.

---

## 6. 업그레이드를 하지 않아도 되는 경우

- 템플릿 변경이 이미 여러분의 게임에 구현된 기능과 중복
- 업그레이드가 가져올 기능을 쓸 계획이 없음
- 출시 직전 — 안정성 최우선이면 업그레이드 미루기

**업그레이드는 의무가 아닙니다.** 필요할 때만 반영하세요.
