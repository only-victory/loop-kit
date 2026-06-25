# slide 예시 : 단일 HTML 슬라이드 골격

`.html` 파일은 레포에 커밋하지 않는다 (생성물이므로). 아래는 산출물의 뼈대다.

```html
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<style>
  :root{
    --bg-base:#0a0a0f; --text-hi:#f5f5fa; --text-md:#cfcfdc; --text-lo:#8a8aa0;
    --accent-grad:linear-gradient(90deg,#5b8cff,#a371ff);
  }
  body{margin:0;background:var(--bg-base);color:var(--text-md);
       font-family:system-ui,sans-serif;}
  .slide{min-height:100vh;display:none;place-content:center;padding:64px;}
  .slide.active{display:grid;}
  .mark{position:fixed;top:24px;left:24px;color:var(--text-lo);}   /* ✦ */
  .counter{position:fixed;bottom:24px;right:24px;color:var(--text-lo);}
  h1{font-size:60px;font-weight:700;color:var(--text-hi);}
</style>
</head>
<body>
  <div class="mark">✦</div>

  <section class="slide active"><h1>제목 : 강조어</h1></section>
  <section class="slide"><h1>두 번째 슬라이드</h1></section>

  <div class="counter"><span id="cur">1</span> / <span id="tot">2</span></div>
<script>
  // 키보드(←/→, Space, f)·터치 스와이프 내비게이션을 인라인으로 넣는다.
  // (생략 — 실제 산출물에는 전체 구현 포함)
</script>
</body>
</html>
```

## 검증

```bash
bash ../scripts/verify.sh 만든-슬라이드.html
# ✓ HARD 위반 0건 : slide 통과
```

- 구두점은 콜론(`:`)만 — `제목 — 강조어`(X) → `제목 : 강조어`(O)
- 외부 CDN 불러오지 않음 — CSS·JS 모두 인라인
- 좌상단 `✦`, 우하단 카운터 필수
