# slide 산출물 구조

`.html`은 생성물이라 레포에 커밋하지 않는다. 실제 제작은 아래를 따른다.

## 베이스

0단계에서 고른 **디자인 결**의 완성형 보일러플레이트를 복제해 시작한다 (폰트·색·키보드/터치 내비·카운터·접근성 내장):

```
skills/slide/templates/deck.editorial.html.txt   에디토리얼 (다크 지면)
skills/slide/templates/deck.swiss.html.txt        스위스 그리드 (라이트)
skills/slide/templates/deck.retro.html.txt        레트로 터미널 (네온, edu 팔레트)
skills/slide/templates/deck.soft.html.txt          소프트 글래스 (인디고)
        →  하나 복제 후 .html 로 저장
```

각 결은 같은 컴포넌트 클래스를 공유한다(content·two-column·stats-split·comparison-table·steps-list·principle·quote·code·module-intro·outro). 더 특수한 컴포넌트(diagram-flow·definition-card·prompt-box·failure-mode·session-index·curriculum·assignment·image)가 필요하면 확장 카탈로그 `templates/deck.html.txt`에서 가져온다.

각 `<section class="slide">` 안에 한 장씩 채운다. **한 장 = 메시지 한 개.**

## 노하우 참조

- 이야기 골격(훅→문제→주장→근거→행동) : `reference/narrative.md`
- 메시지별 레이아웃 선택 기준 : `reference/layouts.md`

## 검증

```bash
bash ../scripts/verify.sh 만든-슬라이드.html
# 슬라이드 수 : N장
# ✓ HARD 위반 0건 : slide 통과
```

자동 게이트(구두점·외부의존성·구조·접근성) + 육안 체크리스트(1장1메시지·행동촉구·가독성)를 **둘 다** 통과해야 완료다.
