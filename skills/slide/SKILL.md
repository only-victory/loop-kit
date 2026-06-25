---
name: slide
description: 프로젝터·대형 화면용 HTML 슬라이드 덱을 제작한다. 다크 테마, 단일 HTML 파일, 키보드·터치 내비게이션이 내장된 자체완결 문서다. 강의·발표·교육 자료를 슬라이드로 만들 때, 사용자가 "슬라이드 만들어줘", "발표자료", "PPT 대신 HTML로 만들어줘"라고 할 때 사용한다.
---

# /slide : HTML 슬라이드 제작

원거리 시청(프로젝터·대형 모니터) 환경에 최적화된 다크 테마 슬라이드를 **단일 HTML 파일**로 만든다. 외부 의존성 없이 브라우저로 바로 연다.

## 산출물

- `.html` 파일 1개 (CSS·JS 인라인, 외부 CDN 불러오지 않음)
- 키보드(`←/→`, `Space`, `f` 전체화면)·터치 스와이프 내비게이션 내장
- 좌상단 심볼 `✦`, 우하단 카운터 `{현재} / {전체}`

## 디자인 토큰 (이 값을 기준으로 작성)

```css
/* 컬러 */
--bg-base:#0a0a0f; --bg-elev-1:#13131a; --bg-elev-2:#1c1c26;
--text-hi:#f5f5fa; --text-md:#cfcfdc; --text-lo:#8a8aa0;
--border-subtle:#22222e; --border-base:#2e2e3d;
--accent-blue:#5b8cff; --accent-purple:#a371ff;
--accent-grad:linear-gradient(90deg,#5b8cff,#a371ff);
--success:#4ade80; --warning:#fbbf24; --danger:#ff6b7a; --info:#60a5fa;
```

타이포(이 크기보다 작게 쓰지 않는다):

| 용도 | 크기 | 두께 |
|------|------|------|
| Hero / Outro 타이틀 | `clamp(58px,8vw,114px)` | 800 |
| 본문 H1 | 60px | 700 |
| 섹션 H2 | 36–48px | 700 |
| 본문·목록 | 18–20px | 400 |
| 캡션·메타 | 14px | 500 |

간격은 `4/8/12/16/24/32/48/64/96/128px`만 사용한다.

## 구두점 규칙 (필수)

라벨·부연의 구분자는 **콜론(`:`)**. em-dash(`—`)·en-dash(`–`) 금지.
(합성어 하이픈 `Wi-Fi`, 범위 `5~10일`은 정상)

## 레이아웃 타입

`hero · title · content · two-column · code · image · definition-card ·
module-intro · diagram-flow · comparison-table · steps-list · stats-split ·
quote · principle · outro` 등에서 내용에 맞게 고른다.

## 절차

1. 목차·세션 구조를 먼저 잡는다 (커리큘럼 → 세션 → 슬라이드).
2. 슬라이드별 레이아웃 타입을 정하고 디자인 토큰으로 작성한다.
3. 키보드·터치 내비게이션 JS를 인라인으로 넣는다.
4. 검증 스크립트로 규약 위반을 확인한다 (아래 [검증]).

## 검증 (필수 — loop-kit 게이트)

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/verify.sh <만든-슬라이드.html>
```

검사 항목:

- [ ] (HARD) em-dash/en-dash 0건 → 콜론 사용
- [ ] (HARD) 외부 CDN script/stylesheet 0건 → 단일 파일 자체완결
- [ ] (WARN) 좌상단 심볼 `✦` 존재
- [ ] (사람) 폰트 크기가 위 최소값 이상, 간격이 스케일 내
- [ ] (사람) 프로젝터에서 뒷자리까지 읽힘

## 체인 예시

```
brief  →  slide  →  발표
slide  →  export-pdf  →  백업 배포
```
