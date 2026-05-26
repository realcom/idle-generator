---
name: balance-review
description: "성장곡선·경제·드롭/천장을 시뮬레이션으로 검증한다. 전투력 vs 스테이지 요구치, 환생 주기, 골드 흐름, 기대 획득률, '벽' 위치를 수치로 리포트."
argument-hint: "[게임 id] [대상: 전체 | 시스템명 | 파일경로]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion
model: sonnet
agent: economy-balancer
---

# 밸런스 리뷰 (시뮬레이션)

키우기게임의 생사: 곡선이 길게 재밌게 굴러가는가. 식을 펼쳐 수치로 확인한다.

## 콘텐츠 로드 규칙

콘텐츠는 `harness/pipeline/content-organization.md` 구조를 따른다.

- **승인된 콘텐츠만 리뷰**: `harness/content/<game>/<category>/approved/*.yaml`이 기본.
- **draft 포함 옵션**: 사용자가 명시하면 `_drafts/{id}_{name}_v#.yaml`까지 포함 (예: 새 시스템 사전 검증).
- **카탈로그 조회**: `harness/content/<game>/<category>/_index.yaml`에서 대상 후보 빠르게 검색 (id/name/tags/status).

## 단계
1. **대상 파악**: 인자에서 시스템/파일. 없으면 AskUserQuestion(성장/경제/드롭 중 + draft 포함 여부).
2. **소스 로드**:
   - 각 카테고리의 `_index.yaml`로 대상 후보 추림 (id, file 추출).
   - 관련 `harness/content/<game>/growth/*.growth.md`(식, 식 파일은 평탄 구조 허용).
   - `harness/content/<game>/rewards/approved/*.yaml`(드롭/AddItemGroup).
   - `harness/game-profiles/<game>.profile.yaml`(가드레일·idle·prestige).
3. **시뮬**(Bash): 식을 펼쳐 레벨별 값 배열 생성 → 플레이어 정책(가성비 업그레이드 우선) 가정으로 전진:
   - 전투력 P(t) vs 스테이지 요구치 R(s) 곡선, 스테이지 N 도달 시간
   - 환생 주기·이득, 골드 faucet/sink 균형, "벽" 위치
   - 드롭: 기대 획득률, pity 천장까지 평균 시도
4. **리포트**: 표/수치 + 위험 신호(과도한 벽·인플레·광고 의존). 가드레일 위반 표시.
   - 참조한 파일/_index 행을 출처로 명시 (id 기준).
5. **튜닝 제안**: 식 파라미터 조정안(diff 한 줄 수준)을 제시, 사용자 결정.
   - 변경 대상이 `approved/`라면 새 _v# draft를 만들 것을 권고(직접 수정 금지).

## 원칙
- 막연한 평가 금지. "스테이지 50에서 P/R=0.6으로 벽" 처럼 구체 수치.
- 배열을 고치지 말고 **식 파라미터**를 고친다.
- `approved/`는 읽기만. 수정이 필요하면 담당 스킬에서 `_drafts/_v#`로.
