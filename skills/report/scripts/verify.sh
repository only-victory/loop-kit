#!/usr/bin/env bash
# loop-kit / report : HTML 보고서 규약 검증 게이트
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

# ── HARD : 통과를 막는 위반 ──────────────────────────────

# 외부 의존성 금지 (보고서는 완전 자체완결)
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [외부 의존성 : CDN script/stylesheet 금지 — CSS 인라인 필수] $ln"; fail=$((fail + 1))
done < <(grep -nE '<(script|link)[^>]*(src|href)="https?://' "$TARGET" || true)

# 구두점 : em/en-dash 금지 → 콜론
if echo | grep -qP '' 2>/dev/null; then
  dash_hits=$(grep -nP '\xe2\x80\x94|\xe2\x80\x93' "$TARGET" || true)
else
  dash_hits=$(LC_ALL=C.UTF-8 grep -nE "[—–]" "$TARGET" 2>/dev/null || true)
fi
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $ln"; fail=$((fail + 1))
done < <(printf '%s\n' "$dash_hits")

# 제목 필수
grep -qiE "<h1" "$TARGET" || { echo "  ✗ [구조 : 제목 <h1> 없음 — 결론이 제목이 된다]"; fail=$((fail + 1)); }

# ── WARN : 품질 경고 (통과는 시키되 알림) ─────────────────

# 인라인 CSS
grep -qiE "<style" "$TARGET" || { echo "  ⚠ [자체완결 : 인라인 <style> 없음 — 외부 CSS 없으면 이것이 유일한 스타일]"; warn=$((warn + 1)); }

# 인쇄 대응
grep -qiE "@media[[:space:]]+print" "$TARGET" || { echo "  ⚠ [인쇄 : @media print 미대응 — PDF 저장 품질 저하]"; warn=$((warn + 1)); }

# 요약·결론 섹션 (역피라미드 원칙)
grep -qiE "(summary-box|summary|핵심 결론|결론|요약)" "$TARGET" || \
  { echo "  ⚠ [역피라미드 : 요약/결론 섹션 없음 — 결론이 먼저 나와야 한다]"; warn=$((warn + 1)); }

# 권고·행동 섹션
grep -qiE "(action-box|권고|다음 단계|다음 행동|조치|계획)" "$TARGET" || \
  { echo "  ⚠ [완결성 : 권고/행동 섹션 없음 — 독자가 무엇을 해야 하는지 명시]"; warn=$((warn + 1)); }

# ── 판정 ──────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : report 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : report 통과"
exit 0
