#!/usr/bin/env bash
# loop-kit / slide : HTML 슬라이드 규약 검증 게이트
# 사용법 : bash verify.sh <슬라이드-html-파일>
# 통과   : exit 0 (HARD 위반 0건)
# 실패   : exit 1 (HARD 위반) / exit 2 (사용법 오류)
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <슬라이드-html-파일>" >&2
  exit 2
fi

fail=0
warn=0

# [HARD] 구두점 : em-dash(—)·en-dash(–) 금지 → 콜론(:)
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $line"
  fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" || true)

# [HARD] 외부 코드 의존성 : 외부 CDN script/stylesheet 금지 (자체완결 원칙)
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [외부 의존성 : 단일 파일 자체완결 위반] $line"
  fail=$((fail + 1))
done < <(grep -nE '<(script|link)[^>]*(src|href)="https?://' "$TARGET" || true)

# [WARN] 시각 모티프 : 좌상단 심볼 ✦ (SLIDES_SPEC §1.5)
if ! grep -qF "✦" "$TARGET"; then
  echo "  ⚠ [모티프 : 좌상단 심볼 ✦ 없음]"
  warn=$((warn + 1))
fi

echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : slide 미통과"
  exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : slide 통과"
exit 0
