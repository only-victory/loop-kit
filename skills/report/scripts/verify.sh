#!/usr/bin/env bash
# loop-kit / report : 단일 HTML 보고서 자체완결성 검증 게이트
# 사용법 : bash verify.sh <보고서-html-파일>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <보고서-html-파일>" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD ──────────────────────────────────────────────
# 외부 코드 의존성 : 외부 CDN script/stylesheet 금지 (의존성 제로)
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [외부 의존성 : 의존성 제로 위반] $ln"; fail=$((fail + 1))
done < <(grep -nE '<(script|link)[^>]*(src|href)="https?://' "$TARGET" || true)

# 구두점 : em/en-dash 금지 → 콜론
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $ln"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" || true)

# ── WARN ──────────────────────────────────────────────
grep -qiE "<style" "$TARGET" || { echo "  ⚠ [자체완결 : 인라인 <style> 없음]"; warn=$((warn + 1)); }
grep -qiE "<h1" "$TARGET"    || { echo "  ⚠ [구조 : 제목 <h1> 없음]"; warn=$((warn + 1)); }
grep -qiE "@media[[:space:]]+print" "$TARGET" || { echo "  ⚠ [인쇄 : @media print 미대응 — PDF 저장 품질]"; warn=$((warn + 1)); }

echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : report 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : report 통과"
exit 0
