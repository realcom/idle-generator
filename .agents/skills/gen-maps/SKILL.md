---
name: gen-maps
description: "맵/던전 여러 개를 한 번에 제작 (챕터/시즌/랭크 시리즈 단위). 챕터 1~10 던전, 이벤트 시즌 7일, 랭크 1~5 던전 등 같은 type·다른 난이도/보상의 맵 N개를 일관되게 양산. 단일은 gen-map."
argument-hint: "[게임 id] [시리즈 설명: 예: '1장 던전 10개 (스테이지별 난이도/보상 차등)']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 맵 벌크 생성 (챕터/시즌/랭크)

같은 type의 맵 N개를 **일관된 난이도 곡선**으로 양산한다. 공통 보드 규칙 + 변동 차원(스테이지/난이도/보상) + 묶음 검수.

## 사용 시나리오
- **챕터 던전**: 1장 던전 10개 (1-1~1-10) — 적 스케일 증가
- **시즌 이벤트**: 7일 일일 던전 — 요일별 보상 변동
- **랭크 시리즈**: 브론즈/실버/골드/플래티넘/다이아 — 난이도 곡선
- **레이드 라인업**: 주간 보스 5종 — 보스만 다름, 보상 구조 같음
- **튜토리얼 체인**: 초보자 1~5 — 가르치는 메커닉 단계별

## 콘텐츠 저장 규칙

- **draft**: `harness/content/<game>/maps/_drafts/{id}_{name}_v#.yaml`
- **approved**: `harness/content/<game>/maps/approved/{id}_{name}.yaml`
- **_index.yaml**: 시리즈 일괄 등록 (`series: <family-key>`, `stage_no` 태그)

## 항상 먼저 읽는다
- `harness/engine-contract/schema/map.md` — type, boardConstants, 웨이브
- `harness/engine-contract/behavior-format.md` — 웨이브 trigger (domain: map)
- `harness/engine-contract/reference-graph.md` — Unit.id, AddItemGroup → Item.id
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.map, 밸런스 가드레일
- `harness/content/<game>/maps/_index.yaml`
- `harness/content/<game>/units/_index.yaml` (적 편성용)
- `harness/content/<game>/items/_index.yaml` (보상용)

## 단계

1. **시리즈 정의**(AskUserQuestion):
   - **공통 type**(Dungeon/Raid/Rank/Event/Lobby)
   - **공통 보드 규칙**(boardConstants)
   - **변동 차원**: 스테이지 / 난이도 / 챕터 / 요일
   - **인스턴스 수** (5~20)
2. **난이도/보상 표 작성**:
   - 표 (열: id·name·stage_no·요구전투력·웨이브 수·적 편성·클리어 보상·드롭 보상)
   - 곡선 함수로 자동 채우기 (예: 요구전투력 = base × 1.3^stage)
   - 예시:
     ```
     | stage | name        | req_power | waves | enemies              | clear_reward     | drop_pool |
     | ----- | ----------- | --------- | ----- | -------------------- | ---------------- | --------- |
     | 1-1   | 초원 입구   | 100       | 3     | 110201×5             | gold 1000, exp 50| 700001    |
     | 1-2   | 초원 깊은곳 | 150       | 4     | 110201×6, 110202×2   | gold 1500, exp 75| 700001~02 |
     | ...   | ...         | ...       | ...   | ...                  | ...              | ...       |
     ```
3. **ID 일괄 할당**: `profile.id_ranges.map` 대역 → 연속 ID (또는 챕터 코드 규칙).
4. **요구 전투력 곡선**(economy-balancer): **식 1개**로 스테이지별 곡선 → `harness/content/<game>/growth/{family-key}-stage-power.growth.md`. balance-review로 '벽' 위치 검증.
5. **정의 N개 생성**(content-designer, **병렬**):
   - 각 인스턴스: `harness/content/<game>/maps/_drafts/{id}_{name}_v1.yaml`
   - 공통: type, boardConstants
   - 변동: 적 편성(Unit.id), 보상(AddItemGroup)
6. **웨이브 로직 패턴**(behavior-author):
   - 공통 패턴(스폰 타이밍·이벤트)이면 트리거 1개 + 멤버가 N번 참조
   - 특수 보스 페이즈만 멤버별 짝지움
7. **보상 일괄 검토**:
   - 모든 itemDataId가 `items/_index.yaml`의 approved에 실재 확인
   - 보상 곡선(스테이지별 골드/exp 증가량) 일관성 체크
8. **_index 일괄 등록**: `maps/_index.yaml`에 N행 (`series`, `stage_no`, `chapter` 태그).
9. **묶음 검수**(content-reviewer + balance-review):
   - 요구 전투력 monotonic
   - 보상 곡선 일관, 벽 위치 분석
   - 적·아이템 참조 무결성 일괄
10. **사용자 검수**: 표 + 샘플 2개(초반/후반) 파일. 곡선 그래프 첨부 권장.
11. **일괄 승인**: `_drafts/*_vN.yaml` → `approved/*.yaml`.

## 원칙
- **공통 보드 1회, 곡선 식 1회**.
- 스테이지 _index에 `chapter`/`stage_no` 태그로 진행 순서 추적.
- 적·보상 참조는 _index의 approved에 실재해야 — 미리 만들거나 같은 라운드 _drafts.
- **balance-review 필수** — 곡선이 '벽' 만들지 않는지.
- N > 20면 챕터 단위로 분할.

## 다른 스킬과의 협업
- 단일 맵은 `/gen-map`
- 챕터 적 시리즈 → `/gen-units` 먼저
- 클리어 보상 아이템 → `/gen-items` 먼저 또는 placeholder
- 곡선 시뮬레이션 → `/balance-review`
- 챕터 보스 → `/gen-unit` 단독
