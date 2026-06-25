#!/usr/bin/env bash
# loop-kit / humanize : 한국어 AI 슬롭 검출 게이트 (심각도·등급·변경률)
# 사용법 : bash verify.sh <다듬은-파일> [원문-파일]
# 통과   : exit 0 (S1=0)  /  실패 : exit 1 (S1 잔존)  /  사용법오류 : exit 2
set -uo pipefail

TARGET="${1:-}"
ORIG="${2:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <다듬은-파일> [원문-파일]" >&2
  exit 2
fi

# 심각도별 패턴 (카탈로그: reference/patterns.md)
S1_PATS=( "살펴보겠습니다" "알아보겠습니다" "대해 알아보" "에 대해 살펴"
          "아무리 강조해도 지나치지" "필수불가결" )
S2_PATS=( "혁신적" "획기적" "체계적" "종합적" "효과적인" "핵심적인 역할"
          "결론적으로" "요컨대" "다음과 같습니다:" "아래와 같습니다:"
          "라고 할 수 있습니다" "라고 볼 수 있습니다" "것으로 보입니다" "것으로 생각됩니다"
          "이 이루어졌다" "필요한 상황" )
S3_PATS=( "레버리지" "인사이트" "퀄리티" "디테일" )

c1=0; c2=0; c3=0

for p in "${S1_PATS[@]}"; do
  while IFS= read -r ln; do [[ -n "$ln" ]] || continue; echo "  ✗ S1 [$p] $ln"; c1=$((c1+1)); done < <(grep -nF "$p" "$TARGET" || true)
done
# 구두점(em/en-dash)도 S1
while IFS= read -r ln; do [[ -n "$ln" ]] || continue; echo "  ✗ S1 [em/en-dash → 콜론(:)] $ln"; c1=$((c1+1)); done < <(grep -nE "[—–]" "$TARGET" || true)
for p in "${S2_PATS[@]}"; do
  while IFS= read -r ln; do [[ -n "$ln" ]] || continue; echo "  ⚠ S2 [$p] $ln"; c2=$((c2+1)); done < <(grep -nF "$p" "$TARGET" || true)
done
for p in "${S3_PATS[@]}"; do
  while IFS= read -r ln; do [[ -n "$ln" ]] || continue; echo "  · S3 [$p] $ln"; c3=$((c3+1)); done < <(grep -nF "$p" "$TARGET" || true)
done

# 변경률 가드 (원문 제공 시) : 의미 보존을 위해 과도한 재작성 경고
rate_line=""
if [[ -n "$ORIG" && -f "$ORIG" ]]; then
  la=$(wc -m < "$TARGET" | tr -d ' '); lo=$(wc -m < "$ORIG" | tr -d ' ')
  if [[ "${lo:-0}" -gt 0 ]]; then
    d=$(( la>lo ? la-lo : lo-la )); pct=$(( d*100/lo ))
    rate_line="변경률 ${pct}% (원문 ${lo}자 → ${la}자)"
    if   [[ "$pct" -gt 50 ]]; then rate_line="$rate_line  ⚠ 50% 초과: 의미 보존 재확인 필요"
    elif [[ "$pct" -gt 30 ]]; then rate_line="$rate_line  ⚠ 30% 초과"; fi
  fi
fi

# 등급
if   [[ "$c1" -gt 0 ]]; then grade="D"
elif [[ "$c2" -gt 0 ]]; then grade="C"
elif [[ "$c3" -gt 0 ]]; then grade="B"
else grade="A"; fi

echo ""
echo "심각도 : S1 ${c1} · S2 ${c2} · S3 ${c3}    등급 : ${grade}"
[[ -n "$rate_line" ]] && echo "$rate_line"
if [[ "$c1" -gt 0 ]]; then
  echo "✗ S1(치명) 잔존 → humanize 미통과 (등급 ${grade})"
  exit 1
fi
echo "✓ S1 0건 → humanize 통과 (등급 ${grade}; S2·S3는 권고, 목표는 A)"
exit 0
