#!/usr/bin/env bash
# loop-kit / proposal : HTML 제안서 규약 검증 게이트
# 사용법 : bash verify.sh <제안서-html-파일>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <제안서-html-파일>" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD : 통과를 막는 위반 ──────────────────────────────

# 외부 의존성 금지 (자체완결)
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [외부 의존성 : CDN script/stylesheet 금지 — CSS 인라인 필수] $ln"; fail=$((fail + 1))
done < <(grep -nE '<(script|link)[^>]*(src|href)="https?://' "$TARGET" || true)

# 구두점 : em/en-dash 금지 → 콜론
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $ln"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" 2>/dev/null || true)

# 제목 필수 (제목은 한 줄 제안)
grep -qiE "<h1" "$TARGET" || { echo "  ✗ [구조 : 제목 <h1> 없음 — 한 줄 제안이 제목이 된다]"; fail=$((fail + 1)); }

# ── WARN : 품질 경고 ─────────────────────────────────────

grep -qiE "(problem-box|문제|현황|과제|페인|pain)" "$TARGET" || \
  { echo "  ⚠ [설득 : 문제·현황 섹션 없음 — 상대 문제가 먼저다]"; warn=$((warn + 1)); }

grep -qiE "(solution-card|솔루션|해결|제안 내용|제안 솔루션)" "$TARGET" || \
  { echo "  ⚠ [핵심 : 솔루션 섹션 없음 — 문제와 1:1로 대응]"; warn=$((warn + 1)); }

grep -qiE "(timeline|일정|마일스톤|로드맵|추진)" "$TARGET" || \
  { echo "  ⚠ [실행 : 일정 섹션 없음 — 언제 무엇을 하는지 명시]"; warn=$((warn + 1)); }

grep -qiE "(quote-table|견적|투자|비용|예산|금액|ROI)" "$TARGET" || \
  { echo "  ⚠ [의사결정 : 견적·투자 섹션 없음 — 범위·전제와 함께 제시]"; warn=$((warn + 1)); }

grep -qiE "(cta-box|다음 단계|연락|문의|미팅|제안 수락|승인 요청)" "$TARGET" || \
  { echo "  ⚠ [완결 : 다음 단계·CTA 섹션 없음 — 마지막은 구체적 행동]"; warn=$((warn + 1)); }

grep -qiE "<style" "$TARGET" || { echo "  ⚠ [자체완결 : 인라인 <style> 없음]"; warn=$((warn + 1)); }
grep -qiE "@media[[:space:]]+print" "$TARGET" || { echo "  ⚠ [인쇄 : @media print 미대응 — PDF 품질 저하]"; warn=$((warn + 1)); }

# ── 판정 ──────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : proposal 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : proposal 통과"
exit 0
