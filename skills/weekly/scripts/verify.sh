#!/usr/bin/env bash
# loop-kit / weekly : 주간 업무 보고(WBR) 규약 검증 게이트
# 사용법 : bash verify.sh <주간보고-md-파일>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <주간보고-md-파일>" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD ─────────────────────────────────────────────────
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $ln"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" 2>/dev/null || true)

# ── WARN ─────────────────────────────────────────────────
grep -qiE "(한 줄 요약|핵심 요약|요약)" "$TARGET" || \
  { echo "  ⚠ [요약 : 한 줄 요약 섹션 없음 — 바쁘면 이것만 읽는다]"; warn=$((warn + 1)); }

grep -qiE "(금주|이번 주|금주 실적|이번주)" "$TARGET" || \
  { echo "  ⚠ [실적 : 금주 실적 섹션 없음]"; warn=$((warn + 1)); }

grep -qiE "(차주|다음 주|차주 계획|다음주)" "$TARGET" || \
  { echo "  ⚠ [계획 : 차주 계획 섹션 없음]"; warn=$((warn + 1)); }

grep -qiE "(이슈|리스크|위험|블로커|병목)" "$TARGET" || \
  { echo "  ⚠ [리스크 : 이슈·리스크 섹션 없음 — 보통 숨은 리스크가 있다]"; warn=$((warn + 1)); }

grep -qE "[0-9]+(%|건|명|원|개|배|시간|점|p)" "$TARGET" || \
  { echo "  ⚠ [정량 : 수치 지표 없음 — 활동이 아니라 결과를 수치로]"; warn=$((warn + 1)); }

# ── 판정 ─────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : weekly 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : weekly 통과"
exit 0
