#!/usr/bin/env bash
# loop-kit / blog : 블로그 글 규약 검증 게이트
# 사용법 : bash verify.sh <글-md-파일>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <글-md-파일>" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD ─────────────────────────────────────────────────
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $ln"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" 2>/dev/null || true)

# 제목(H1) 필수
grep -qE "^#[[:space:]]+\S" "$TARGET" || { echo "  ✗ [구조 : 제목 #(H1) 없음]"; fail=$((fail + 1)); }

# ── WARN ─────────────────────────────────────────────────
h2=$(grep -cE "^##[[:space:]]+\S" "$TARGET" || true)
if [[ "$h2" -lt 2 ]]; then
  echo "  ⚠ [구조 : 소제목 ##(H2) ${h2}개 — 2개 이상으로 끊어라]"; warn=$((warn + 1))
fi

grep -qiE "(^태그[[:space:]]*:|^요약[[:space:]]*:|tags?[[:space:]]*:)" "$TARGET" || \
  { echo "  ⚠ [메타 : 요약·태그 없음 — 검색·공유에서 손해]"; warn=$((warn + 1)); }

chars=$(wc -m < "$TARGET" | tr -d ' ')
if [[ "$chars" -lt 600 ]]; then
  echo "  ⚠ [분량 : ${chars}자 — 600자 미만, 근거·예시가 부족할 수 있다]"; warn=$((warn + 1))
fi

# ── 판정 ─────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : blog 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : blog 통과"
exit 0
