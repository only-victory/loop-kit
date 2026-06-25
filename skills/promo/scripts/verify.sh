#!/usr/bin/env bash
# loop-kit / promo : 교육 홍보 페이지 검증 게이트
# 사용법 : bash verify.sh <페이지.html>
# 통과   : exit 0 / 실패 : exit 1 / 사용법 오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <페이지.html>" >&2
  exit 2
fi

fail=0; warn=0

# ── HARD : 통과를 막는 위반 ──────────────────────────────────

# h1 제목 존재
h1_count=$(grep -c '<h1' "$TARGET" 2>/dev/null || echo 0)
if [[ "$h1_count" -lt 1 ]]; then
  echo "  ✗ [구조 : h1 없음 — 프로그램명 제목 필수]"; fail=$((fail+1))
fi

# 신청 버튼 또는 링크 존재
apply_count=$(grep -iE '(apply-btn|신청하기|지금 신청|마감 전 신청|forms\.gle|docs\.google\.com/forms|t\.ly)' "$TARGET" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$apply_count" -lt 1 ]]; then
  echo "  ✗ [CTA : 신청 버튼/링크 없음 — apply-btn 클래스 또는 Google Forms 링크 필수]"; fail=$((fail+1))
fi

# footer 존재 (기관 표기 — 내용 무관)
footer_count=$(grep -iE '(<footer|class="footer)' "$TARGET" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$footer_count" -lt 1 ]]; then
  echo "  ✗ [구조 : footer 없음 — 기관명·문의처 표기 필수]"; fail=$((fail+1))
fi

# 구두점 : em-dash·en-dash 금지
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $line"; fail=$((fail+1))
done < <(grep -nE '[—–]' "$TARGET" 2>/dev/null || true)

# 외부 JS CDN 금지
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [외부 JS : CDN 스크립트 금지 — 인라인 JS만 허용] $line"; fail=$((fail+1))
done < <(grep -nE '<script[^>]+src="https?://' "$TARGET" 2>/dev/null || true)

# 허용되지 않은 외부 CSS (폰트 CDN 2종만 허용)
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "$line" | grep -qE '(fonts\.googleapis\.com|cdn\.jsdelivr\.net/gh/orioncactus)' && continue
  echo "  ✗ [외부 CSS : 허용되지 않은 CDN — fonts.googleapis.com·orioncactus만 허용] $line"; fail=$((fail+1))
done < <(grep -nE '<link[^>]+href="https?://' "$TARGET" 2>/dev/null || true)

# ── WARN : 품질 경고 ─────────────────────────────────────────

# 교육 개요 테이블
grep -qE '(info-table|disclosure|교육 개요|교육개요|overview)' "$TARGET" 2>/dev/null || \
  { echo "  ⚠ [구조 : 교육 개요 테이블 없음 — 대상·기간·장소 등 핵심 정보 누락 가능]"; warn=$((warn+1)); }

# meta chips
grep -qE '(meta-row|class="chip)' "$TARGET" 2>/dev/null || \
  { echo "  ⚠ [UX : meta chips 없음 — 기간·인원 등 핵심 메타 정보 시각화 권장]"; warn=$((warn+1)); }

# 신청 버튼 2회 이상 권장 (btn-primary / btn-cta / apply-btn 모두 카운트)
apply_btn_count=$(grep -iE '(apply-btn|btn-primary|btn-cta)' "$TARGET" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$apply_btn_count" -lt 2 ]]; then
  echo "  ⚠ [전환 : 신청 버튼이 1개뿐 — Hero 직후 + 하단 최소 2회 배치 권장]"; warn=$((warn+1))
fi

# ── 판정 ──────────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : promo 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : promo 통과"
exit 0
