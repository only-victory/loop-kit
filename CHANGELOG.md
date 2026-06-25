# Changelog

이 프로젝트의 모든 주요 변경을 기록한다. [SemVer](https://semver.org/lang/ko/)를 따른다.

## [0.1.0] : 2026-06-25

### 추가

- 레포 골격 : 플러그인 + 마켓플레이스 구조 (`.claude-plugin/marketplace.json`, `plugin.json`)
- 스킬 골든 템플릿 확립 : `SKILL.md` + `scripts/verify.sh` + `examples/`
- `humanize` 스킬 : 한국어 AI 슬롭 제거 + 검증 게이트(`verify.sh`)
- `slide` 스킬 : 프로젝터용 HTML 슬라이드 덱 + 구두점·외부의존성·모티프 검증 게이트
- `report` 스킬 : 단일 HTML 보고서 + 의존성 제로 자체완결성 검증 게이트
- MIT 라이선스

> 모든 게이트는 통과(exit 0)·실패(exit 1) fixture로 동작 검증 완료.
