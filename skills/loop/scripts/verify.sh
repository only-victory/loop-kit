#!/usr/bin/env bash
# loop-kit / loop : 루프 정의 검증 게이트
# 사용법 : bash verify.sh <루프-정의-md>
# 통과   : exit 0 (HARD 위반 0건) / 실패 : exit 1 / 사용법오류 : exit 2
#
# 검사 대상은 루프 "정의" 문서다 (reference/<루프>.md). 각 단계가 계약을 다 명시했는지,
# 사람 체크포인트가 있는지, 미작성 칸이 없는지를 본다. "검증 없으면 예쁜 쓰레기"를 루프에도 적용.
set -uo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" || ! -f "$TARGET" ]]; then
  echo "사용법 : bash verify.sh <루프-정의-md>" >&2
  exit 2
fi

fail=0
warn=0

# ── HARD : 통과를 막는 규약 위반 ──────────────────────────────

# 구두점 : em-dash·en-dash 금지 → 콜론(:)
# (macOS BSD grep·Linux GNU grep 공통 동작. UTF-8 셸 기준 한글 오탐 없음 : 타 스킬 게이트와 동일 방식)
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  echo "  ✗ [구두점 : em/en-dash → 콜론(:)] $line"; fail=$((fail + 1))
done < <(grep -nE "[—–]" "$TARGET" 2>/dev/null || true)

# 계약표 파싱 : 헤더(6컬럼) → 구분선 → 데이터 행. 각 행 6칸 채움·담당 검사.
report=$(awk '
  function trim(s){ gsub(/^[[:space:]]+|[[:space:]]+$/,"",s); return s }
  BEGIN{ hdr=0; inhdr=0; indata=0; stages=0; human=0 }
  {
    line=$0
    if(line ~ /^[[:space:]]*\|/){
      if(!hdr && line ~ /단계/ && line ~ /입력/ && line ~ /처리/ && line ~ /출력/ && line ~ /게이트/ && line ~ /담당/){
        hdr=1; inhdr=1; next
      }
      if(hdr && inhdr && !indata){
        if(line ~ /^[[:space:]]*\|[[:space:]:|-]+\|?[[:space:]]*$/){ indata=1; next }
      }
      if(indata){
        body=line
        sub(/^[[:space:]]*\|/,"",body); sub(/\|[[:space:]]*$/,"",body)
        n=split(body, cells, "|")
        if(n!=6){ printf("BADCOLS\t%d\t%d\n", NR, n); next }
        stages++
        for(i=1;i<=6;i++){
          c=trim(cells[i]); t=c; gsub(/`/,"",t)
          if(t=="" || index(t,"___")>0 || t=="…" || t=="-" || toupper(t) ~ /TODO/ || t ~ /^<.*>$/){
            printf("EMPTY\t%d\n", NR); break
          }
        }
        last=trim(cells[6])
        if(last ~ /사람/) human++
        next
      }
    } else {
      if(indata) indata=0
    }
  }
  END{ printf("HDR\t%d\nSTAGES\t%d\nHUMAN\t%d\n", hdr, stages, human) }
' "$TARGET")

hdr=$(printf '%s\n' "$report" | awk -F'\t' '$1=="HDR"{print $2}')
stages=$(printf '%s\n' "$report" | awk -F'\t' '$1=="STAGES"{print $2}')
human=$(printf '%s\n' "$report" | awk -F'\t' '$1=="HUMAN"{print $2}')

if [[ "${hdr:-0}" -ne 1 ]]; then
  echo "  ✗ [구조 : 계약표 헤더 없음 — 단계·입력·처리·출력·게이트·담당 6컬럼 필요]"; fail=$((fail + 1))
fi
while IFS= read -r row; do
  ln=$(printf '%s' "$row" | awk -F'\t' '{print $2}')
  cols=$(printf '%s' "$row" | awk -F'\t' '{print $3}')
  echo "  ✗ [구조 : 계약표 컬럼 수 6 아님(${cols}) : ${ln}행]"; fail=$((fail + 1))
done < <(printf '%s\n' "$report" | grep '^BADCOLS' || true)
while IFS= read -r row; do
  ln=$(printf '%s' "$row" | awk -F'\t' '{print $2}')
  echo "  ✗ [미작성 : 빈 칸 또는 ___/TODO 계약 : ${ln}행]"; fail=$((fail + 1))
done < <(printf '%s\n' "$report" | grep '^EMPTY' || true)
if [[ "${stages:-0}" -lt 1 ]]; then
  echo "  ✗ [구조 : 단계 행 0개 — 계약표가 비었음]"; fail=$((fail + 1))
fi
if [[ "${human:-0}" -lt 1 ]]; then
  echo "  ✗ [원칙 : 사람 체크포인트 0개 — 담당이 전부 기계면 슬롭을 스케일하는 것]"; fail=$((fail + 1))
fi

# ── WARN : 품질 경고 ──────────────────────────────────────────
grep -qF "어댑터" "$TARGET" || \
  { echo "  ⚠ [범용성 : 소스·싱크에 어댑터 표기 없음 — 환경 결합이 박혀 재사용이 어려울 수 있음]"; warn=$((warn + 1)); }

# ── 판정 ──────────────────────────────────────────────────────
echo ""
echo "루프 단계 : ${stages:-0}개"
if [[ "$fail" -gt 0 ]]; then
  echo "✗ HARD 위반 ${fail}건 (경고 ${warn}건) : loop 미통과"; exit 1
fi
echo "✓ HARD 위반 0건 (경고 ${warn}건) : loop 통과"
exit 0
