# 테마 프리셋 (4종)

인터뷰 0단계에서 **선택 창으로 고르게** 한다.
고른 테마의 `:root` 블록을 `templates/promo.html.txt`의 `:root`에 **통째로 교체**한다.

---

## ① 다크 골드 (기본) — 세련·테크·프리미엄

참조 레퍼런스 : ff-aca.github.io/web/notice/section/

```css
:root{
  --bg:#0a0b0d; --surface:#15171c; --surface-2:#1b1e25;
  --border:#2a2d35; --border-soft:#20232a;
  --text-hi:#f3f2ed; --text-md:#d5d7df; --text-lo:#9fa1a8;
  --accent:#dfb839; --accent-bright:#e8c75a;
  --accent-dim:rgba(223,184,57,.12); --accent-border:rgba(223,184,57,.25);
  --teal:#4abf9b; --teal-dim:rgba(74,191,155,.12);
  --danger:#e05c5c; --danger-dim:rgba(224,92,92,.10);
}
/* header-title em : color:var(--accent) */
/* apply-btn : background:var(--accent); color:#1a1505 */
/* stats-bar : background:var(--accent) */
```

---

## ② 라이트 블루 — 전문·신뢰·데이터

참조 레퍼런스 : ff-academy.github.io/notice/data/index.html

```css
:root{
  --bg:#f0f4ff; --surface:#ffffff; --surface-2:#f8f9ff;
  --border:#dde3f5; --border-soft:#e8ecf8;
  --text-hi:#1a1f36; --text-md:#5a6282; --text-lo:#9ba4c0;
  --accent:#3d5bf6; --accent-bright:#5571ff;
  --accent-dim:rgba(61,91,246,.08); --accent-border:rgba(61,91,246,.2);
  --teal:#0ea5e9; --teal-dim:rgba(14,165,233,.1);
  --danger:#dc2626; --danger-dim:rgba(220,38,38,.08);
}
/* header-title em : gradient clip linear-gradient(135deg,#3d5bf6,#7c3aed) */
/* apply-btn : background:var(--accent); color:#fff */
/* stats-bar : background:var(--accent) */
```

`header-title em` 그라데이션 적용 방법:
```css
.header-title em{
  background:linear-gradient(135deg,#3d5bf6,#7c3aed);
  -webkit-background-clip:text;background-clip:text;color:transparent;
}
```

---

## ③ 라이트 크림 — 따뜻·친근·교육적

참조 레퍼런스 : ff-academy.github.io/notice/aibasic/index.html

```css
:root{
  --bg:#fafaf7; --surface:#ffffff; --surface-2:#f4f3ee;
  --border:#e8e6df; --border-soft:#eeece6;
  --text-hi:#18181a; --text-md:#5a5955; --text-lo:#9a9890;
  --accent:#d4a800; --accent-bright:#f5c800;
  --accent-dim:rgba(212,168,0,.10); --accent-border:rgba(212,168,0,.25);
  --teal:#2563eb; --teal-dim:rgba(37,99,235,.08);
  --danger:#dc2626; --danger-dim:rgba(220,38,38,.08);
}
/* header-title em : 마커펜 효과 */
/* apply-btn : background:var(--accent-bright); color:#18181a */
/* stats-bar : background:var(--text-hi) */
```

`header-title em` 마커펜 효과:
```css
.header-title em{
  background:var(--accent-bright);
  padding:0 6px 2px;border-radius:4px;color:#18181a;
}
```

---

## ④ 네이비 블루 — 비즈니스·격식·LinkedIn 스타일

참조 레퍼런스 : ff-academy.github.io/notice/linkedin/

```css
:root{
  --bg:#f7f4ee; --surface:#ffffff; --surface-2:#f2ede4;
  --border:#e8e4dc; --border-soft:#ede8e0;
  --text-hi:#0a1628; --text-md:#3a4258; --text-lo:#8a8a8a;
  --accent:#0077b5; --accent-bright:#00a0dc;
  --accent-dim:rgba(0,119,181,.08); --accent-border:rgba(0,119,181,.2);
  --teal:#c8972a; --teal-dim:rgba(200,151,42,.12);  /* 이 테마에서 teal = gold */
  --danger:#dc2626; --danger-dim:rgba(220,38,38,.08);
  --navy:#0a1628;
}
/* header : background:var(--navy) 로 덮음 (header-inner text-hi=#fff) */
/* header-title em : color:#f0c060 */
/* apply-btn : background:var(--accent); color:#fff; border-radius:2px */
/* stats-bar : background:var(--accent) */
```

네이비 테마는 header 배경을 별도로 지정:
```css
.header{ background: var(--navy); }
.header .header-title{ color: #ffffff; }
.header .header-sub{ color: rgba(255,255,255,0.75); }
.header .eyebrow{ color: #f0c060; }
.header .eyebrow::before{ background: #f0c060; }
```

---

## 테마 선택 기준

| 상황 | 추천 테마 |
|------|-----------|
| 기술·AI·데이터 분야 고급 과정 | ① 다크 골드 |
| 직무 교육·분석·리포트 성격 | ② 라이트 블루 |
| 사내 교육·워크숍·입문 과정 | ③ 라이트 크림 |
| 비즈니스 스킬·네트워킹·LinkedIn | ④ 네이비 블루 |
