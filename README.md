# loop-kit

> 공정·품질 기반 Claude Code 스킬 키트.
> 모든 스킬에 **실행 가능한 검증 게이트**가 내장되어 있다.

대부분의 스킬 모음은 "무엇을 만드나"에 집중한다. loop-kit은 **"어떻게 만들고, 됐는지 어떻게 확인하나"**에 집중한다. 스킬마다 만들고 끝이 아니라, 됐는지 검사하는 스크립트가 함께 들어 있다.

## 세 가지 차이

1. **게이트 내장** : 모든 스킬에 `verify.sh`가 있다. 마크다운 체크리스트가 아니라 exit code로 통과·실패가 갈린다.
2. **의존성 제로** : Python·외부 패키지 없이 Claude만으로 동작한다. 설치 즉시 쓴다.
3. **과정이 보인다** : AI가 블랙박스로 뚝딱 내놓지 않는다. 왜 이렇게 했는지, 무엇을 검사했는지 보여준다.

> 숫자가 아니라 신뢰. 176개보다, 모두 실제로 동작하고 검증되는 적은 수.

## 설치

```bash
# 1. 마켓플레이스 등록
/plugin marketplace add only-victory/loop-kit

# 2. 플러그인 설치
/plugin install loop-kit@loop-kit

# 3. 플러그인 리로드 (설치 후 반드시)
/reload-plugins
```

리로드 후 스킬은 네임스페이스가 붙는다 : `/loop-kit:humanize`

## 스킬 카탈로그

| 스킬 | 무엇을 | 검증 게이트 |
|------|--------|-------------|
| `/loop-kit:humanize` | AI 슬롭 제거 + 문체 결 4종 (공식·에세이·대화·SNS) | 슬롭 심각도 등급 + 변경률 가드 |
| `/loop-kit:slide` | 프로젝터용 HTML 슬라이드 덱 (디자인 결 4종) | 구두점·외부 의존성·시각 모티프 린트 |
| `/loop-kit:report` | 단일 HTML 보고서 (보고서 결 3종 : 임원·분석·현황) | 외부 의존성 0개·역피라미드·권고 섹션 검사 |
| `/loop-kit:promo` | 교육 홍보 웹페이지 (디자인 결 4종) | 제목·CTA·footer·구두점 검사 |

> 현재 `v0.8.0` : humanize 문체 결 4종 / report 보고서 결 3종 / promo 디자인 결 4종 전면 업그레이드.

## 스킬 구조 (기여 규약)

모든 스킬은 동일한 골든 템플릿을 따른다.

```
skills/<name>/
├── SKILL.md            # 사용법 + 검증 기준 (frontmatter: name, description)
├── scripts/verify.sh   # 실행 가능한 검증 게이트 (exit 0 = 통과)
└── examples/           # before/after 예시
```

- `SKILL.md`의 [검증] 섹션은 `${CLAUDE_SKILL_DIR}/scripts/verify.sh`를 호출한다.
- `verify.sh`는 "기계적으로 확실히 틀린 것"만 막는다. 의미·자연스러움은 체크리스트로 사람이 확인한다.

## 라이선스

[MIT](./LICENSE) — 상업 이용·수정 자유. 저작권 표시만 유지하면 된다.
