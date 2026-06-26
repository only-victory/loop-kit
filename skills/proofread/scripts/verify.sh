#!/usr/bin/env bash
# loop-kit / proofread : 한국어 교정 결과 검증 게이트
# 교정문(TARGET)에 흔한 어문 오류가 남아 있지 않은지 본다.
# 사용법 : bash verify.sh <교정문-파일> [원문-파일]
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
ORIG="${2:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <교정문-파일> [원문-파일]" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD : 명백한 맞춤법 오류 (잔존 0건이어야 통과) ────────
SPELL=( "되요" "안되요" "할께" "갈께" "줄께" "볼께" "몇일" "웬지" "역활"
        "어떻해" "읍니다" "금새" "오랫만" "희안" "어의없" "왠만" "뵈요" )
for p in "${SPELL[@]}"; do
  while IFS= read -r ln; do
    [[ -n "$ln" ]] || continue
    echo "  ✗ [맞춤법 : '$p' 교정 안 됨] $ln"; fail=$((fail + 1))
  done < <(grep -nF "$p" "$TARGET" || true)
done

# em/en-dash → 콜론
while IFS= read -r ln; do
  [[ -n "$ln" ]] || continue
  echo "  ✗ [문장부호 : em/en-dash → 콜론(:)] $ln"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" 2>/dev/null || true)

# ── WARN : 흔한 띄어쓰기·외래어 (오탐 여지 있어 경고) ──────
SPACE=( "할수있" "할수없" "수있습니다" "것같습니다" "할수 있" )
for p in "${SPACE[@]}"; do
  while IFS= read -r ln; do
    [[ -n "$ln" ]] || continue
    echo "  ⚠ [띄어쓰기 : '$p' 점검] $ln"; warn=$((warn + 1))
  done < <(grep -nF "$p" "$TARGET" || true)
done
LOAN=( "컨텐츠" "메세지" "악세사리" "악세서리" "리더쉽" "프로세싱" "런칭" )
for p in "${LOAN[@]}"; do
  while IFS= read -r ln; do
    [[ -n "$ln" ]] || continue
    echo "  ⚠ [외래어 : '$p' 표기 점검] $ln"; warn=$((warn + 1))
  done < <(grep -nF "$p" "$TARGET" || true)
done

# ── 판정 ─────────────────────────────────────────────────
echo ""
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : proofread 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : proofread 통과"
exit 0
