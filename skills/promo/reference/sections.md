# 섹션 카탈로그 : 내용이 섹션을 정한다

섹션을 먼저 고르고 내용을 끼워넣지 않는다.
**전하려는 정보의 성격**이 섹션 선택을 정한다.

---

## 필수 섹션 (순서 유지)

| 섹션 | 역할 | HTML 클래스 |
|------|------|-------------|
| `header` | 프로그램명 + Hero 카피 + eyebrow 배지 | `.header` `.header-title` `.eyebrow` |
| `meta-chips` | 대상·기간·인원·장소·마감 한눈에 | `.meta-wrap` `.meta-row` `.chip` |
| `info-table` | 교육 개요 key-value 표 | `.info-table` |
| `curriculum` | 회차별 커리큘럼 (3종 중 선택) | `.timeline` / `.curri-grid` / `.curri-stack` |
| `apply-box` | 신청 CTA + 마감일 | `.apply-box` `.apply-btn` |
| `footer` | FF Academy 로고 + 문의처 | `.footer` |

---

## 선택 섹션 — 언제 쓰나

| 섹션 | 언제 쓰나 | 안티 |
|------|-----------|------|
| `ticker` | 관련 업종·키워드 무한 스크롤. 시각 임팩트가 필요할 때 | 콘텐츠와 무관한 키워드 |
| `brief` | 복잡한 배경 설명이 필요할 때 (1~2 문단) | 간단한 프로그램에 불필요한 서론 |
| `notice` | 마감 임박·선발 기준·특이사항 공지 | 일반 정보 (info-table로 충분) |
| `recommend-grid` | "이런 분께 추천" 페르소나가 2~4개일 때 | 막연한 대상("누구나") |
| `goals` | 교육 목표 아웃컴이 3개 이상일 때 | 목표가 1개면 header-sub에 통합 |
| `how-block` | 독특한 운영 방식 설명 (스터디·소규모 집중반 등) | 일반 강의 구조 |
| `stats-bar` | 누적 수강생·만족도 등 신뢰 수치가 있을 때 | 수치가 없거나 약할 때 |
| `instructor-card` | 강사 신뢰가 핵심인 프로그램 | 강사 미정이거나 팀 강의 |
| `conditions` | 수료 조건이 있을 때 (출석·과제 등) | 조건이 없는 자유 수강 |

---

## 커리큘럼 형식 3종

### timeline (날짜 중심 — 대면+자기주도 혼합)
- 강의 날짜가 핵심일 때
- `.tl-dot.live` (대면·강의), `.tl-dot.self` (자기주도) 구분 도트
- 날짜 배지가 오른쪽에 정렬됨

```html
<div class="timeline">
  <div class="tl-item">
    <div class="tl-dot live"></div>
    <div class="tl-head">
      <span class="tl-num">01</span>
      <span class="tl-title">회차 제목</span>
      <span class="tl-date">5/7 (수)</span>
    </div>
    <div class="tl-body">회차 내용 설명</div>
    <div class="tl-tags"><span class="tag live">대면 강의</span></div>
  </div>
</div>
```

### curri-grid (주차 압축 — 단기과정 전체 개요)
- 3~4주 과정에서 전체를 빠르게 보여줄 때
- 3열 그리드, 각 카드에 accent 상단 보더

```html
<div class="curri-grid">
  <div class="curri-card">
    <div class="week">WEEK 01</div>
    <div class="week-title">주차 제목</div>
    <ul><li>주요 내용 1</li><li>주요 내용 2</li></ul>
  </div>
</div>
```

### curri-stack (세션 상세 — 회차별 깊이 있는 설명)
- 각 회차에 설명이 많을 때
- 왼쪽 배지(회차번호·형태) + 오른쪽 내용

```html
<div class="curri-stack">
  <div class="curri-item">
    <div class="curri-badge">
      <span class="cb-n">01</span>
      <span class="cb-label">강의</span>
    </div>
    <div class="curri-content">
      <div class="ct-title">세션 제목</div>
      <div class="ct-body">세션 내용 설명</div>
    </div>
  </div>
</div>
```

---

## 섹션 조합 추천

| 프로그램 유형 | 권장 섹션 조합 |
|---|---|
| **단일 특강 (1회)** | header + meta + notice + info-table + instructor + apply |
| **단기과정 (2~4주)** | header + meta + recommend + info-table + goals + curri-grid + conditions + apply |
| **정규과정 (5주+)** | ticker + header + stats-bar + meta + brief + recommend + info-table + goals + timeline + instructor + conditions + apply |
| **스터디** | header + meta + how-block + info-table + curri-stack + conditions + apply |
| **워크숍** | header + meta + recommend + info-table + goals + curri-stack + instructor + apply |
