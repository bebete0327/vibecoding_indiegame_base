#!/usr/bin/env bash
# Spine Godot Runtime (GDExtension) 자동 설치 스크립트
# -----------------------------------------------------
# Esoteric Software 공식 S3 에서 Spine GDExtension zip 을 받아 프로젝트 루트의 bin/ 에 압축 해제.
#
# 사용법:
#   bash scripts/dev_tools/install_spine_runtime.sh
#
# 변경하려면: 이 스크립트 상단의 SPINE_VERSION, GODOT_VERSION 수정.
#
# 라이선스: Spine 에디터 구매자는 런타임을 자유롭게 통합/배포 가능.
#           https://esotericsoftware.com/spine-purchase

set -euo pipefail

# ===== 설정 =====
SPINE_VERSION="4.2"                # Spine 에디터 호환 버전 (export 한 .skel/.atlas 이 이 버전이어야 함)
GODOT_VERSION="4.6.1-stable"       # 4.6.2-stable 용 빌드는 아직 없음. 4.6.1 빌드가 4.6.x 전체와 ABI 호환.
# ================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BIN_DIR="$REPO_ROOT/bin"
ZIP_URL="https://spine-godot.s3.eu-central-1.amazonaws.com/$SPINE_VERSION/$GODOT_VERSION/spine-godot-extension-$SPINE_VERSION-$GODOT_VERSION.zip"
TMP_ZIP="/tmp/spine-godot-extension-$SPINE_VERSION-$GODOT_VERSION.zip"

echo "══════════════════════════════════════════════════"
echo "  Spine Godot Runtime Installer"
echo "  Spine:  $SPINE_VERSION"
echo "  Godot:  $GODOT_VERSION"
echo "  Target: $BIN_DIR/"
echo "══════════════════════════════════════════════════"

if [ -d "$BIN_DIR" ]; then
    echo ""
    echo "⚠️  bin/ 폴더가 이미 존재합니다."
    read -p "덮어쓸까요? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "취소됨."
        exit 0
    fi
    rm -rf "$BIN_DIR"
fi

echo ""
echo "[1/3] 다운로드 중..."
echo "  URL: $ZIP_URL"
if ! curl -fL --progress-bar -o "$TMP_ZIP" "$ZIP_URL"; then
    echo ""
    echo "❌ 다운로드 실패. 가능한 원인:"
    echo "  - GODOT_VERSION ($GODOT_VERSION) 용 빌드가 S3 에 없음"
    echo "  - 사용 가능한 버전 확인: https://esotericsoftware.com/spine-godot"
    echo "  - 네트워크/프록시 문제"
    exit 1
fi

echo ""
echo "[2/3] 압축 해제..."
mkdir -p "$REPO_ROOT"
unzip -q "$TMP_ZIP" -d "$REPO_ROOT"

if [ ! -f "$BIN_DIR/spine_godot_extension.gdextension" ]; then
    echo "❌ 압축 해제 후 $BIN_DIR/spine_godot_extension.gdextension 이 없음. zip 내용물 이상."
    exit 1
fi

echo ""
echo "[3/3] 검증..."
COUNT=$(find "$BIN_DIR" -type f | wc -l)
SIZE_MB=$(du -sm "$BIN_DIR" 2>/dev/null | awk '{print $1}' || echo "?")
echo "  ✓ bin/spine_godot_extension.gdextension"
echo "  ✓ ${COUNT} 파일 설치됨 (약 ${SIZE_MB} MB)"

# 정리
rm -f "$TMP_ZIP"

echo ""
echo "══════════════════════════════════════════════════"
echo "  ✅ 설치 완료"
echo "══════════════════════════════════════════════════"
echo ""
echo "다음 단계:"
echo "  1. Godot 에디터 열기:"
echo "       \"\$GODOT_PATH\" --path $REPO_ROOT"
echo "  2. Spine 에디터에서 export 한 .skel + .atlas + .png 를 assets/spine/ 에 배치"
echo "  3. Godot 씬에 SpineSprite 노드 추가 후 리소스 지정"
echo ""
echo "문서: docs/SPINE.md · 예제 씬: scenes/examples/spine_example.tscn"
