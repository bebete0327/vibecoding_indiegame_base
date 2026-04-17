# Godot MCP & AI Integration Tools

## Tags
- category: tool, automation
- difficulty: intermediate
- related: [[harness-engineering]], [[godot-vibecoding-basics]]

## Summary
Claude Code와 Godot 에디터를 직접 연결하는 MCP(Model Context Protocol) 도구 및 LSP 연동 가이드.

## 1. GDScript LSP (Language Server Protocol)

### 개요
Godot 4.x에는 내장 LSP가 포함되어 있어 Claude Code에서 GDScript 자동완성, 타입 체크, 정의 이동 등이 가능.

### 설치: claude-code-gdscript-lsp
```bash
git clone https://github.com/Sods2/claude-code-gdscript-lsp.git
cd claude-code-gdscript-lsp
./scripts/install.sh
```

### 기능
- 실시간 GDScript 오류/경고 감지
- 타입 정보 호버
- 함수/클래스 정의로 이동
- 컨텍스트 인식 자동완성
- 프로젝트 전체 심볼 검색
- Godot 재시작 시 자동 재연결

### 요구사항
- Claude Code v2.0.74+
- Godot 4.x (에디터가 열려있어야 LSP 활성화)
- Node.js 18+

## 2. Godot MCP Servers

### 비교표
| 이름 | 가격 | 도구 수 | Godot 4.6 | 특징 |
|------|------|---------|-----------|------|
| **Coding-Solo** | 무료 | ~10 | ⚠️ 윈도우 버그 | 기본 씬 관리 |
| **PurpleJelly** | 무료 | 77 | 미확인 | 스크린샷 캡처, GUT 지원 |
| **y1uda MCP Pro** | $5 | 163 | ✅ | 가장 종합적, 활발 유지보수 |
| **GDAI MCP** | $19 | 풍부 | ✅ | 올인원 프리미엄 |

### 추천: Coding-Solo (무료 시작)
```bash
claude mcp add godot -- npx @coding-solo/godot-mcp
```

설치 후 환경변수 설정:
```
GODOT_PATH=C:\Users\NHN\Desktop\Godot_v4.6.2-stable_win64.exe
```

### 추천: y1uda MCP Pro ($5, 가장 안정적)
- itch.io에서 구매: https://y1uda.itch.io/godot-mcp-pro
- Godot Asset Library에서도 설치 가능
- 163개 도구: 씬, 애니메이션, 3D, 물리, 파티클, 오디오, 셰이더 등

## 3. MCP가 바이브코딩에 주는 이점

### Without MCP (현재)
```
Claude Code → GDScript 파일 작성 → 사용자가 에디터에서 확인
```

### With MCP
```
Claude Code → MCP → Godot 에디터에서 직접 실행/수정/캡처
```

주요 이점:
- AI가 씬 트리를 직접 조작 가능
- 게임 실행 후 스크린샷을 AI에게 자동 전달
- 디버그 출력을 AI가 직접 읽음
- GUT 테스트를 AI가 직접 실행하고 결과 확인

## 4. 설치 우선순위 가이드

### 즉시 설치 (무료)
1. **claude-code-gdscript-lsp** - GDScript 자동완성/에러 감지
2. **Coding-Solo godot-mcp** - 기본 MCP 연동

### 나중에 (게임 제작 시작 후)
3. **GUT** - 테스트 프레임워크 (AssetLib에서 설치)
4. **y1uda MCP Pro** - 종합 MCP (씬 제어, 디버그)

### 선택 사항
5. **GDAI MCP** - 프리미엄 올인원
6. **Godot GIF Exporter** - 게임플레이 녹화
