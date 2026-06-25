# 스타일 프리셋 : 색 테마 · 톤 · 밀도

인터뷰 0단계에서 아래를 **구조화된 선택지**(선택 UI 또는 번호 목록)로 제시하고, 고른 값을 적용한다. 자유 입력이 아니라 **고르게** 한다. (색·톤이 빈약해지는 걸 막는 핵심.)

---

## 1. 색 테마 (5종)

고른 테마의 `:root` 블록을 `templates/deck.html.txt`의 `:root`에 **통째로 교체**한다.

### ① 딥 다크 · 블루퍼플 (기본) — 테크·세련
```css
:root{
  --bg-base:#0a0a0f; --bg-elev-1:#13131a; --bg-elev-2:#1c1c26;
  --text-hi:#f5f5fa; --text-md:#cfcfdc; --text-lo:#8a8aa0;
  --border-subtle:#22222e; --border-base:#2e2e3d;
  --accent-blue:#5b8cff; --accent-purple:#a371ff;
  --accent-grad:linear-gradient(90deg,#5b8cff,#a371ff);
  --success:#4ade80; --warning:#fbbf24; --danger:#ff6b7a; --info:#60a5fa;
}
```

### ② 미드나잇 모노 — 절제·보고형 (그레이스케일)
```css
:root{
  --bg-base:#0c0c0e; --bg-elev-1:#16161a; --bg-elev-2:#202026;
  --text-hi:#f4f4f6; --text-md:#c8c8d0; --text-lo:#86868f;
  --border-subtle:#23232a; --border-base:#33333d;
  --accent-blue:#aeb4be; --accent-purple:#dfe3ea;
  --accent-grad:linear-gradient(90deg,#aeb4be,#e2e5ea);
  --success:#9fcfae; --warning:#d8c89a; --danger:#d99aa3; --info:#a8b4c2;
}
```

### ③ 웜 앰버 — 따뜻함·캐주얼
```css
:root{
  --bg-base:#100c08; --bg-elev-1:#1a140d; --bg-elev-2:#241c12;
  --text-hi:#fbf3e8; --text-md:#e3d6c4; --text-lo:#a8957c;
  --border-subtle:#2a2014; --border-base:#3a2c1b;
  --accent-blue:#fbbf24; --accent-purple:#fb7185;
  --accent-grad:linear-gradient(90deg,#fbbf24,#fb7185);
  --success:#86c98a; --warning:#fbbf24; --danger:#fb7185; --info:#f0a85a;
}
```

### ④ 하이 콘트라스트 — 대형 강당·접근성 (순흑백 강대비)
```css
:root{
  --bg-base:#000000; --bg-elev-1:#0d0d0d; --bg-elev-2:#1a1a1a;
  --text-hi:#ffffff; --text-md:#ededed; --text-lo:#b8b8b8;
  --border-subtle:#2a2a2a; --border-base:#3d3d3d;
  --accent-blue:#4d9fff; --accent-purple:#c08bff;
  --accent-grad:linear-gradient(90deg,#4d9fff,#c08bff);
  --success:#5ee08a; --warning:#ffce3a; --danger:#ff7a88; --info:#66aaff;
}
```

### ⑤ 라이트 — 인쇄·주간 발표 (밝은 배경)
```css
:root{
  --bg-base:#f7f7fb; --bg-elev-1:#ffffff; --bg-elev-2:#eef0f6;
  --text-hi:#141420; --text-md:#3a3a48; --text-lo:#6b6b7a;
  --border-subtle:#e3e4ec; --border-base:#d2d4df;
  --accent-blue:#3b6cff; --accent-purple:#7b3ff0;
  --accent-grad:linear-gradient(90deg,#3b6cff,#7b3ff0);
  --success:#1f9d57; --warning:#b9821a; --danger:#d63d52; --info:#2f6fe0;
}
```
> 라이트 테마는 그림자·테두리 대비가 약해질 수 있으니 카드에 `border:1px solid var(--border-base)`를 명시한다.

---

## 2. 톤 (4종) — 생성 방식이 달라진다

| 톤 | 레이아웃 편향 | 텍스트 | 타이포 |
|----|---------------|--------|--------|
| **임팩트** | hero·stats-split 多, 장당 1메시지 엄격 | 최소 (키워드 중심) | 크게 |
| **교육** | definition-card·steps-list·예시 多 | 친절한 설명문, 용어 풀이 | 표준 |
| **보고** | comparison-table·수치, 결론 먼저 | 밀도 높음, 근거·출처 명시 | 표준 |
| **스토리** | quote·전환 강조, 훅 강하게 | 내러티브 흐름 | 표준~크게 |

## 3. 밀도 (3종) — 분량 가이드

| 밀도 | 장 수 | 용도 |
|------|-------|------|
| **압축** | 5~8장 | 핵심만, 짧은 발표 |
| **표준** | 10~15장 | 일반 발표 |
| **상세** | 20장+ | 교육·워크숍 |

---

## 적용 순서

1. 색 테마 1개 → 해당 `:root` 블록으로 교체
2. 톤 1개 → 레이아웃·텍스트량 편향 반영
3. 밀도 1개 → 장 수 결정
4. 그다음 내용 인터뷰(주제·목적·청중)로 진행
