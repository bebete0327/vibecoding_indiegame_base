# Godot Vibe-Coding Template

> **Godot 4.6 + GDScript 기반 바이브코딩 전용 템플릿**
> 솔로 인디 개발자가 Claude Code 와 함께 빠르게 게임을 만들기 위한 구조물.

---

## 🚀 지금 뭘 해야 하지?

**처음 클론한 경우** → [`docs/START_HERE.md`](docs/START_HERE.md) (5분)

**환경 설정이 안 된 경우** → [`docs/SETUP.md`](docs/SETUP.md)

**새 게임을 시작한다면** → [`docs/TEMPLATE_GUIDE.md`](docs/TEMPLATE_GUIDE.md)

**어떤 워크플로를 쓸지 모르겠다면** → [`docs/WORKFLOW.md`](docs/WORKFLOW.md) 결정 트리

---

## 📦 무엇이 들어있나

| 영역 | 내용 |
|------|------|
| **Godot** | 4.6 mobile renderer, Jolt Physics, GDScript only |
| **Autoloads** | EventBus · GameManager · AudioManager · SaveManager · ServiceLocator · DebugHUD · FadeTransition · PauseMenu · Screenshot_Capture |
| **Patterns** | State Machine · ReactiveProperty · Component (HealthComponent 예시) |
| **Testing** | GUT 사전 설치 · 28개 테스트 예시 · CI (GitHub Actions) |
| **AI Skills** | 9개 슬래시 명령 — `/brainstorm`, `/code-review`, `/smoke-check`, `/balance-check` 등 |
| **AI Agents** | 10개 전문 에이전트 — Godot 4종, 디자인 리드 3종, 리뷰/QA/퍼포먼스 3종 |
| **Docs** | SETUP · TEMPLATE_GUIDE · WORKFLOW · CONVENTIONS · ARCHITECTURE · GDD_TEMPLATE · UPGRADE · COLLABORATIVE-DESIGN-PRINCIPLE |
| **Engine Reference** | Godot 4.6 지식갭 보완 (VERSION · breaking-changes · deprecated-apis · 8개 모듈) |

---

## ⚡ 빠른 시작

```bash
# 1. 환경변수 설정 (한번만)
#    Windows PowerShell 에서:
#    [System.Environment]::SetEnvironmentVariable('GODOT_PATH', 'C:\path\to\Godot.exe', 'User')

# 2. 프로젝트 검증
"$GODOT_PATH" --headless --path . -e --quit

# 3. 테스트 실행
"$GODOT_PATH" -d -s --path . addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit

# 4. 자가진단 (위 둘을 한 번에)
"$GODOT_PATH" --headless --path . --script res://scripts/dev_tools/health_check.gd

# 5. 에디터 열기
"$GODOT_PATH" --path .
```

실행 중 단축키:
- **F3** — 디버그 HUD 토글 (FPS/MEM/Nodes)
- **F9** — 스크린샷 저장 (`user://screenshots/`)
- **Esc** — 일시정지 메뉴

---

## 🎯 바이브코딩 철학

1. **빠른 피드백 루프** — PostToolUse 훅이 `.gd` 저장마다 프로젝트 자동 검증
2. **AI 가 보는 것이 개발자가 보는 것** — F9 스크린샷 → Claude 에게 공유
3. **낮은 인지 부담** — 슬래시 명령으로 요약, 결정 트리로 선택
4. **좋은 기본값** — Autoload · Input map · State machine · Tests 모두 사전 설정
5. **관대함** — 자동 백업, rollback 가능한 Git 중심 워크플로

상세: [`CLAUDE.md`](CLAUDE.md) "Vibe Coding Workflow" 섹션.

---

## 🔀 이 템플릿을 업그레이드할 때

원본 템플릿이 개선되면 [`docs/UPGRADE.md`](docs/UPGRADE.md) 의 cherry-pick 절차 참고.

---

## 📄 라이선스

MIT — 자유롭게 포크/개조 가능. `LICENSE` 파일 참조.

---

## 🙏 크레딧

- [Godot Engine](https://godotengine.org/) — 오픈소스 게임 엔진
- [GUT](https://github.com/bitwes/Gut) — Godot Unit Test 프레임워크
- [Claude Code Game Studios](https://github.com/) — 에이전트/스킬 시스템 일부 포팅
