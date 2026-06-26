#!/usr/bin/env bash
# loop-kit / resume : HTML 이력서·자기소개서 규약 검증 게이트
# 사용법 : bash verify.sh <이력서-html-파일>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <이력서-html-파일>" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD ─────────────────────────────────────────────────
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [외부 의존성 : CDN script/stylesheet 금지 — CSS 인라인 필수] $ln"; fail=$((fail + 1))
done < <(grep -nE '<(script|link)[^>]*(src|href)="https?://' "$TARGET" || true)

while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $ln"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" 2>/dev/null || true)

grep -qiE "<h1" "$TARGET" || { echo "  ✗ [구조 : 제목 <h1>(이름) 없음]"; fail=$((fail + 1)); }

# ── WARN ─────────────────────────────────────────────────
grep -qiE "(@|이메일|메일|전화|연락처|010|tel:|mailto:)" "$TARGET" || \
  { echo "  ⚠ [연락처 : 이메일·전화 없음 — 채용 담당이 연락할 수 없다]"; warn=$((warn + 1)); }

grep -qiE "(경력|프로젝트|experience|업무 경험|주요 성과)" "$TARGET" || \
  { echo "  ⚠ [핵심 : 경력·프로젝트 섹션 없음]"; warn=$((warn + 1)); }

grep -qiE "(역량|스킬|skill|기술|보유 기술)" "$TARGET" || \
  { echo "  ⚠ [역량 : 역량·스킬 섹션 없음]"; warn=$((warn + 1)); }

grep -qE "[0-9]+(%|건|명|원|개|배|년|개월|만|억|p)" "$TARGET" || \
  { echo "  ⚠ [정량 : 수치 성과 없음 — 활동이 아니라 성과를 수치로]"; warn=$((warn + 1)); }

grep -qiE "@media[[:space:]]+print" "$TARGET" || \
  { echo "  ⚠ [인쇄 : @media print 미대응 — PDF 제출 품질 저하]"; warn=$((warn + 1)); }

grep -qiE "<style" "$TARGET" || { echo "  ⚠ [자체완결 : 인라인 <style> 없음]"; warn=$((warn + 1)); }

# ── 판정 ─────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : resume 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : resume 통과"
exit 0
