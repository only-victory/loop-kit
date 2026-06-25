# report 예시 : 단일 HTML 보고서 골격

`.html` 파일은 레포에 커밋하지 않는다 (생성물이므로). 아래는 산출물의 뼈대다.

```html
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>2026년 2분기 원격근무 현황</title>
<style>
  body{max-width:760px;margin:40px auto;padding:0 24px;
       font-family:system-ui,sans-serif;line-height:1.7;color:#1a1a1a;}
  h1{font-size:28px;} h2{font-size:20px;margin-top:32px;}
  .summary{background:#f4f6fb;padding:16px 20px;border-radius:8px;}
  table{border-collapse:collapse;width:100%;} td,th{border:1px solid #ddd;padding:8px;}
</style>
</head>
<body>
  <h1>2026년 2분기 원격근무 현황</h1>
  <p>작성일 : 2026-06-25 · 작성자 : 인사팀</p>

  <div class="summary">
    <strong>요약 :</strong> 원격근무 도입 후 회의 시간은 줄었으나 협업 지표는 부서별 편차가 크다.
  </div>

  <h2>1. 핵심 수치</h2>
  <table>...</table>

  <h2>2. 근거 · 한계</h2>
  <p>데이터 출처 : 사내 설문(N=120, 응답률 78%). 단일 분기 데이터로 추세 단정 불가.</p>
</body>
</html>
```

## 검증

```bash
bash ../scripts/verify.sh 만든-보고서.html
# ✓ HARD 위반 0건 : report 통과
```

- 외부 폰트·CDN·스크립트 0개 — 모든 스타일이 `<style>` 안에 있음
- 구두점은 콜론(`:`)만
- 결론(요약)이 본문보다 먼저
