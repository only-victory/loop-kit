#!/usr/bin/env bash
# loop-kit / humanize : 한국어 AI 슬롭 검출 게이트
# 사용법 : bash verify.sh <검사할-텍스트-파일>
# 통과   : exit 0 (금지 패턴 0건)
# 실패   : exit 1 (금지 패턴 발견) / exit 2 (사용법 오류)
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <검사할-텍스트-파일>" >&2
  exit 2
fi

# 금지 패턴 (한국어 AI 슬롭). 고정 문자열로 검사한다.
patterns=(
  "살펴보겠습니다"
  "알아보겠습니다"
  "대해 알아보"
  "아무리 강조해도 지나치지"
  "다음과 같습니다:"
  "결론적으로"
  "종합적으로"
  "종합적인"
  "체계적으로"
  "체계적인"
  "혁신적인"
  "획기적인"
  "라고 할 수 있습니다"
  "것으로 보입니다"
  "레버리지"
  "인사이트"
)

found=0

for p in "${patterns[@]}"; do
  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    echo "  ✗ [$p] $line"
    found=$((found + 1))
  done < <(grep -nF "$p" "$TARGET" || true)
done

# 구두점 규칙 : em-dash(—)·en-dash(–) 는 콜론(:)으로
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [em-dash/en-dash → 콜론(:) 사용] $line"
  found=$((found + 1))
done < <(grep -nE "[—–]" "$TARGET" || true)

echo ""
if [[ "$found" -gt 0 ]]; then
  echo "✗ 금지 패턴 ${found}건 발견 : humanize 미통과"
  exit 1
fi

echo "✓ 금지 패턴 0건 : humanize 통과"
exit 0
