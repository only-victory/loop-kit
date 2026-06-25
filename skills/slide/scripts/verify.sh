#!/usr/bin/env bash
# loop-kit / slide : HTML 슬라이드 규약 검증 게이트
# 사용법 : bash verify.sh <슬라이드-html-파일>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <슬라이드-html-파일>" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD : 통과를 막는 규약 위반 ──────────────────────────────

# 구두점 : em-dash(—)·en-dash(–) 금지 → 콜론(:)
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $line"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" || true)

# 외부 코드 의존성 : 외부 CDN script/stylesheet 금지 (자체완결)
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [외부 의존성 : 단일 파일 자체완결 위반] $line"; fail=$((fail + 1))
done < <(grep -nE '<(script|link)[^>]*(src|href)="https?://' "$TARGET" || true)

# 슬라이드 존재 : <section class="...slide...">  1개 이상 (HTML 주석 제외)
nocomment=$(perl -0777 -pe 's/<!--.*?-->//gs' "$TARGET" 2>/dev/null || cat "$TARGET")
slide_count=$(printf '%s' "$nocomment" | grep -oE '<section[^>]*class="[^"]*\bslide\b' | wc -l | tr -d ' ')
if [[ "$slide_count" -lt 1 ]]; then
  echo "  ✗ [구조 : .slide 요소 0개 — 슬라이드가 없음]"; fail=$((fail + 1))
fi

# ── WARN : 품질 경고 (통과는 시키되 알림) ─────────────────────

grep -qF "✦" "$TARGET" || { echo "  ⚠ [모티프 : 좌상단 심볼 ✦ 없음]"; warn=$((warn + 1)); }

grep -qiE "keydown|keypress" "$TARGET" || \
  { echo "  ⚠ [내비 : 키보드 이벤트 없음 — 정적 슬라이드는 키보드 내비 필수]"; warn=$((warn + 1)); }

grep -qiE "prefers-reduced-motion" "$TARGET" || \
  { echo "  ⚠ [접근성 : prefers-reduced-motion 미대응]"; warn=$((warn + 1)); }

# 본문 폰트 14px 미만 (px 직접 지정 한정 휴리스틱)
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ⚠ [가독성 : 14px 미만 폰트 — 프로젝터 뒷자리 위험] $line"; warn=$((warn + 1))
done < <(grep -nE 'font-size:[[:space:]]*(1[0-3]|[0-9])px' "$TARGET" || true)

# ── 판정 ──────────────────────────────────────────────────────
echo ""
echo "슬라이드 수 : ${slide_count}장"
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : slide 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : slide 통과"
exit 0
