# report 산출물 구조

`.html`은 생성물이라 레포에 커밋하지 않는다. 실제 제작은 아래를 따른다.

## 베이스

완성형 보일러플레이트를 복제해 시작한다 (인라인 CSS·인쇄 친화·역피라미드 구조):

```
skills/report/templates/report.html.txt   →  복제 후 .html 로 저장
```

## 노하우 참조

- 결론 먼저(역피라미드)·종류별 골격·독자별 깊이·수치 다루는 법 : `reference/structures.md`

## 검증

```bash
bash ../scripts/verify.sh 만든-보고서.html
# ✓ HARD 위반 0건 : report 통과
```

자동 게이트(외부의존성 0·구두점·구조) + 육안(결론 먼저·수치 출처·한계)을 **둘 다** 통과해야 완료다.
