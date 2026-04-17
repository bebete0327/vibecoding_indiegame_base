# Knowledge Base - LLM Wiki System

Andrei Karpathy 방식의 LLM 지식 기반 시스템입니다.
개발 지식을 영구적으로 자산화합니다.

## Folder Structure

```
knowledge_base/
├── Raw/           # 가공되지 않은 원본 자료
│   └── (웹 클리퍼, 리서치, 에러 로그 등)
├── Wiki/          # AI가 정제한 지식 문서
│   └── (분류/연결/정제된 문서)
├── Index/         # 검색 최적화 인덱스
│   └── master-index.md
└── README.md      # 이 파일
```

## How to Use

### 1. Ingest (자료 수집)
Raw 폴더에 원본 자료를 저장합니다:
- 웹에서 복사한 튜토리얼
- 에러 해결 과정 기록
- 유용한 코드 스니펫
- GDScript API 메모

### 2. Process (정제)
Claude에게 요청:
```
"Raw 폴더의 [파일명]을 읽고 Wiki에 정리해줘"
```

AI가 자동으로:
- 핵심 내용 추출
- 카테고리 분류
- 관련 문서 링크 연결
- master-index.md 업데이트

### 3. Query (검색)
```
"내 위키에서 [키워드]에 대한 내용 찾아줘"
```

AI가 Index를 참조하여 관련 문서를 빠르게 찾습니다.

### 4. Lint (정비)
주기적으로 요청:
```
"위키의 깨진 링크 수정하고 관계 재설정해줘"
```

## Wiki Document Format
```markdown
# [제목]

## Tags
- category: [godot/gdscript/pattern/debug/tool]
- difficulty: [beginner/intermediate/advanced]
- related: [[다른 문서 링크]]

## Summary
(한 문장 요약)

## Content
(본문)

## Examples
(코드 예시)

## References
- (출처 링크)
```

## Obsidian Integration (선택)
이 폴더를 Obsidian Vault로 열면 `[[위키링크]]`를 통해 그래프 뷰로 지식 관계를 시각화할 수 있습니다.
