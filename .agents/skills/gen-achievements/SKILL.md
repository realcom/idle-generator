---
name: gen-achievements
description: "업적 여러 개를 한 번에 제작 (일일 미션 묶음, 누적 단계 트리, 챕터 클리어 시리즈, 부모-자식 묶음 등). 같은 type·condition 패턴의 업적 N개를 일관되게 양산. 단일은 gen-achievement."
argument-hint: "[게임 id] [시리즈 설명: 예: '일일 미션 5종', '슬라임 누적 처치 10/100/1000/10000']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 업적 벌크 생성 (시리즈/단계/트리)

같은 type·condition 패턴의 업적 N개를 **목표·보상 표**로 양산한다. 단계 트리(targetProgress 1/10/100/...) 또는 부모-자식 묶음 처리.

## 사용 시나리오
- **누적 단계 트리**: "슬라임 처치 10 → 100 → 1000 → 10000" (같은 condition, targetProgress 단계)
- **일일 미션 패키지**: Daily type 5종 (다른 condition, 일관 보상 곡선)
- **챕터 클리어 시리즈**: WinGameGroup 1장~10장 (chapter id만 다름)
- **부모-자식 트리**: 부모 1 + 자식 N (progressParentOnComplete)
- **시즌 패스**: EventPass type 30일 출석 + 보너스 묶음
- **랭킹 보상 라인업**: Ranking type 일주일/한 달 단위 묶음

## 콘텐츠 저장 규칙

- **draft**: `harness/content/<game>/achievements/_drafts/{id}_{name}_v#.yaml`
- **approved**: `harness/content/<game>/achievements/approved/{id}_{name}.yaml`
- **_index.yaml**: 시리즈 일괄 등록 (`series`, `parent_id` 태그)

## 항상 먼저 읽는다
- **`harness/engine-contract/schema/achievement.md` ⭐** — type, Condition enum, conditionValue1/2 표, 부모-자식
- `harness/engine-contract/reference-graph.md` — Item.requiredAchievementDataIds 백참조
- `harness/engine-contract/schema/reward.md` — rewardAddItemGroups
- `harness/game-profiles/<game>.profile.yaml` — id_ranges.achievement, reserved_ids
- `harness/content/<game>/achievements/_index.yaml`
- `harness/content/<game>/items/_index.yaml` (보상 대상)
- `harness/content/<game>/units/_index.yaml` (KillUnit value1)

## 단계

1. **시리즈 정의**(AskUserQuestion):
   - **공통 type**(Normal/Daily/Weekly/Ranking/EventPass/Mission)
   - **공통 condition**(KillUnit/WinGameGroup/AcquireItem 등) — 또는 시리즈 안에서 condition 다양
   - **변동 차원**: targetProgress 단계 / chapter / 요일 / 부모-자식
   - **인스턴스 수** (3~30)
   - **부모 유무**: 부모 1 + 자식 N 트리인가? 또는 평면 시리즈인가?
2. **변동 표 작성**:
   - 표 (열: id·name·type·condition·value1·value2·target·repeatable·reward 요약·parent_id)
   - 누적 단계 트리 예시:
     ```
     | id    | name              | condition  | value1 | target  | parent | reward summary       |
     | ----- | ----------------- | ---------- | ------ | ------- | ------ | -------------------- |
     | 600002| 슬라임처치10      | KillUnit   | 110201 | 10      | 600001 | gold 500, exp 100   |
     | 600003| 슬라임처치100     | KillUnit   | 110201 | 100     | 600001 | gold 2000, exp 500  |
     | 600004| 슬라임처치1000    | KillUnit   | 110201 | 1000    | 600001 | gold 10000, ruby 5  |
     | 600005| 슬라임처치10000   | KillUnit   | 110201 | 10000   | 600001 | gold 50000, ruby 30 |
     ```
   - 일일 미션 예시 (다른 condition):
     ```
     | id    | name        | type  | condition         | target | repeatable | reward       |
     | ----- | ----------- | ----- | ----------------- | ------ | ---------- | ------------ |
     | 601001| 일일로그인  | Daily | Login             | 1      | true       | gold 1000    |
     | 601002| 일일처치    | Daily | KillUnitAny       | 50     | true       | exp 500      |
     | 601003| 일일클리어  | Daily | WinGameAny        | 3      | true       | ruby 1       |
     | 601004| 일일강화    | Daily | LevelUpItemAny    | 5      | true       | gold 2000    |
     | 601005| 일일상품    | Daily | BuyItemProduct    | 1      | true       | ruby 5       |
     ```
3. **ID 일괄 할당**: `profile.id_ranges.achievement` 대역. 부모 + 자식이면 부모 1개 + 자식 N개 연속.
4. **목표/보상 곡선**(economy-balancer):
   - 단계 트리면 targetProgress 곡선 (10/100/1000/... = 10^n)
   - 보상 곡선 일관 (단계별 ×2~×5 등) → `harness/content/<game>/growth/{family-key}-achievement-reward.growth.md`
5. **정의 N개 생성**(content-designer, **병렬**):
   - 각 인스턴스: `harness/content/<game>/achievements/_drafts/{id}_{name}_v1.yaml`
   - 공통 필드(type, condition, value1) 동일
   - 변동: targetProgress, conditionValue2, rewardAddItemGroups, parentAchievementDataId
6. **부모-자식 트리 구성** (있을 때):
   - 부모: `childAchievementDataIds: [자식 id N개]`, `progressParentOnComplete: true`
   - 자식: `parentAchievementDataId: 부모 id`
   - 한 라운드에 부모+자식 같이 _drafts 생성
7. **잠금 백참조 일괄** (있을 때):
   - 시리즈가 잠금 게이트면 대상 Item들 `requiredAchievementDataIds`에 추가하는 새 _v# draft (gen-item 흐름)
8. **_index 일괄 등록**: `achievements/_index.yaml`에 N행 (`series`, `parent_id` 태그, `refs: {units, items, parent}`).
9. **묶음 검수**(content-reviewer):
   - 단계 곡선 monotonic (target 작은→큰)
   - 보상 곡선 일관
   - 부모-자식 ID 양방향 참조
   - 보상 댕글링 0 (모든 itemDataId가 items approved에 실재)
   - reserved_ids 충돌 없음
10. **사용자 검수**: 표 + 샘플 1~2 파일.
11. **일괄 승인**: `_drafts/*_vN.yaml` → `approved/*.yaml`.

## 원칙
- **condition은 engine-bound** — schema 카드 enum에 있는 것만. 없으면 엔진 추가 플래그.
- **진행 카운트는 엔진** — condition + value1/2로 표현. 트리거 직접 호출은 최후 수단.
- **부모-자식 양방향**: 부모 childAchievementDataIds ↔ 자식 parentAchievementDataId 동시 갱신.
- **시스템 reserved_ids 재할당 금지**.
- 단계 트리는 target 곡선 — 너무 빡세지 않게 balance-review 권장.

## 다른 스킬과의 협업
- 단일 업적은 `/gen-achievement`
- 보상 묶음 분리 → `rewards/_drafts/`
- 잠금 백참조 → `/gen-item(s)`로 `requiredAchievementDataIds`
- 곡선 가드레일 → `/balance-review` (target/reward 곡선)
- 부모-자식 큰 묶음 → `/new-content`로 발산 후 위임
