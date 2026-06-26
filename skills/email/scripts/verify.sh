#!/usr/bin/env bash
# loop-kit / email : 업무 이메일 규약 검증 게이트
# 사용법 : bash verify.sh <이메일-md-파일>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <이메일-md-파일>" >&2
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
grep -qiE "^제목[[:space:]]*:|^subject[[:space:]]*:" "$TARGET" || \
  { echo "  ⚠ [제목 : '제목:' 라인 없음 — 제목에 용건·기한이 보여야 한다]"; warn=$((warn + 1)); }

grep -qiE "(부탁|요청|회신|확인|검토|제출|답변|까지|다음 단계|드립니다)" "$TARGET" || \
  { echo "  ⚠ [용건 : 요청·다음 단계 단서 없음 — 상대가 할 일이 분명해야 한다]"; warn=$((warn + 1)); }

grep -qiE "(드림|올림|배상|감사합니다|감사드립니다)" "$TARGET" || \
  { echo "  ⚠ [맺음 : 서명·맺음 없음]"; warn=$((warn + 1)); }

lines=$(grep -cve '^[[:space:]]*$' "$TARGET")
if [[ "$lines" -gt 35 ]]; then
  echo "  ⚠ [분량 : 본문 ${lines}줄 — 한 화면(약 35줄) 넘음. 핵심만 남겨라]"; warn=$((warn + 1))
fi

# ── 판정 ─────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : email 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : email 통과"
exit 0
