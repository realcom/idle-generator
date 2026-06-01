---
name: gen-achievement
description: "업적 1종을 완성형(정의+진행 조건+보상+에셋 키)으로 생성하는 수직 슬라이스. '몬스터 100마리 처치', '스테이지 50 도달', '특정 아이템 획득' 등 진행도 기반 목표를 만들 때 사용."
argument-hint: "[게임 id] [업적 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion
model: sonnet
---

# 업적 생성 (수직 슬라이스)

한 업적을 정의→조건/진행→보상→연결(잠금/부모-자식)→에셋까지 완성한다. 인자 없으면 사용법 출력 후 정지.

## 콘텐츠 저장 규칙 (필수)

산출물은 `harness/pipeline/content-organization.md` 규칙을 따른다.

- **파일명**: `{id}_{name}.yaml` (예: `600001_첫처치.yaml`)
- **draft**: `harness/content/<game>/achievements/_drafts/{id}_{name}_v#.yaml`
- **approved**: `harness/content/<game>/achievements/approved/{id}_{name}.yaml`
- **_index.yaml**: `harness/content/<game>/achievements/_index.yaml`에 행 등록/갱신.

## 항상 먼저 읽는다
- **`harness/engine-contract/schema/achievement.md` ⭐** — ResourceAchievement 전체 필드, Type/Condition enum, conditionValue1/2 사용표, 참조 그래프, Global 예약 id
- `harness/engine-contract/reference-graph.md` — achievementDataId 참조처(주로 Item.requiredAchievementDataIds, ranking)
- `harness/engine-contract/schema/reward.md` — `rewardAddItemGroups`의 AddItemGroup 구조
- `harness/game-profiles/<game>.profile.yaml` — `id_ranges.achievement` 대역, `reserved_ids.achievement` 시스템 예약
- `harness/pipeline/content-organization.md` — 저장 레이아웃·_index 형식
- `harness/content/<game>/achievements/_index.yaml` (있다면) — 기존 id, 패턴 확인
- 기존 샘플(예: `harness/content/idlez/achievements/first_kill.achievement.yaml`)

## 단계

### 1. 분류 결정 (AskUserQuestion)
- **type**: `Normal`(일반)/`Daily`/`Weekly`/`Ranking`/`EventPass`/`Mission` 중. 반복성·기간이 결정됨.
- **condition**: 진행을 카운트할 이벤트 종류 (schema 카드의 Condition 표 참고).
  - 처치/사냥 → `KillUnit` / `KillUnitAny`
  - 스테이지 클리어 → `WinGame` / `WinGameAny` / `WinGameGroup`
  - 아이템 획득 → `AcquireItem` / `AcquireItemAny` / `AcquireItemGrade` / 슬롯·카테고리별 다수
  - 아이템 보유 → `HasItem` / `HasItemLevel`
  - 아이템 강화 → `LevelUpItem` / `LevelUpItemAny`
  - 상품 구매 → `BuyItemProduct` / `BuyItemAny`
  - 스킬 사용 → `UseSkill` / `UseSkillAny`
  - 로그인/리셋 → `Login` / `DayReset` / `WeekReset`
  - 미션 특화(Mission type 전용) → `Mission*`
  - 시스템 진척 → `EnableAchievement`/`CompleteAchievement`/`ClaimRewardAchievement`/`AchievementProgressDay`
- 어휘에 없는 종류면 "엔진 Condition enum 추가 필요"로 플래그하고 가장 가까운 대체 제시 (condition은 engine-bound).

### 2. 세부 결정 (AskUserQuestion)
- **conditionValue1 / conditionValue2**: 선택한 condition별 의미가 다름 (schema 카드의 표 참고).
  - 예: `KillUnit` → value1 = Unit.id
  - 예: `AcquireItemGrade` → value1 = Item.id, value2 = grade
  - 예: `MissionUnitLevelUp` → value1 = Unit.id, value2 = 요구 레벨
- **targetProgress**: 목표치(1 = 단발, N = 누적). `initialProgress`로 시작값 가산도 가능.
- **autoReward**: 자동 지급(true) vs 수동 클레임(false).
- **initialOpen**: 시작부터 보임 vs 부모/조건 해금.
- **repeatable**: Daily/Weekly에 자주 true.
- **부모/자식 관계**: 부모 업적(`parentAchievementDataId`) 또는 자식 묶음(`childAchievementDataIds`, `openChildrenOnComplete`, `progressParentOnComplete`).
- **시즌**: 이벤트/패스면 `startAt`/`untilAt`/`popupArgs`(예: `Popup_Attendance` + 시즌 코드).
- **랭킹**: Ranking type이면 `rankingItemDataId`(점수 통화 Item.id), `rankingDelayDays`.
- **잠금 아이템 연결**: 이 업적이 해금 게이트인지(`equipmentSlotUnlock*` 패턴) — 해당 Item 정의의 `requiredAchievementDataIds`에 백참조.
- **보상**: `rewardAddItemGroups`(AddItemGroup 배열, 인라인 가능) / `rewardRequiredItemDataId`(수령 전제 아이템) / `rewardMailDays`(메일 유효일).

### 3. ID 할당
- 시스템 업적이면 `profile.reserved_ids.achievement.*`에서 매핑 확인 (재할당 금지).
- 신규는 `profile.id_ranges.achievement` 대역(idlez 기준 600000~699999)에서 `_index.yaml` 스캔 후 다음 빈 id.

### 4. 정의 (Task content-designer)
`harness/content/<game>/achievements/_drafts/{id}_{name}_v1.yaml` 작성. schema 카드 필드만 사용:

```yaml
# 600002_슬라임100마리.yaml — 예: 슬라임 100마리 처치
id: 600002
type: Normal
tags: []
order: 10

initialOpen: true
clientAchievement: false

condition: KillUnit         # 이벤트 종류 (engine-bound)
conditionValue1: 110201     # Unit.id — 초록 슬라임
conditionValue2: 0
targetProgress: 100
initialProgress: 0
repeatable: false
autoReward: true

rewardAddItemGroups:
  - addItems:
      - { itemDataId: 5, count: 50000 }      # 골드 50000
      - { itemDataId: 3, count: 30, weight: 100 }  # 루비 30 (가챠형이면 weight)

name: "슬라임 100마리 처치"
# popupArgs: {}  # Popup 사용 시
# parentAchievementDataId: 600100
# childAchievementDataIds: []
# openChildrenOnComplete: false
# progressParentOnComplete: false
```

- 보상이 별도 묶음 재사용형이면 `rewards/_drafts/{reward_id}_{name}_v1.yaml`로 분리하고 `$ref`(엔진 컴파일러 지원 여부 확인). 단발이면 인라인.
- 부모-자식 트리(예: 일일 미션 5종 + 보너스): 부모 1 + 자식 N을 한 라운드에 같이 만들고 _index에 함께 등록.

### 5. 보상 정의 (Task economy-balancer/content-designer)
- 인라인이면 4 단계에서 처리.
- 분리형이면 `rewards/_drafts/{id}_{name}_v1.yaml`로 AddItemGroup, `rewards/_index.yaml` 등록.

### 6. 진행 트리거 (Task behavior-author, **필요한 경우만**)
- **대부분 불필요** — 엔진이 `condition` enum에 따라 자동으로 카운트한다 (KillUnit, AcquireItem, WinGame 등).
- 어휘에 없는 커스텀 카운팅이 정말 필요하면 behavior YAML로 `increaseAchievementProgress`(액션 어휘에 있을 때만) 호출. 없으면 엔진 메서드 추가 필요로 플래그.

### 7. 잠금 백참조 (Task content-designer, 필요 시)
- 이 업적이 잠금 게이트라면 대상 Item의 `requiredAchievementDataIds`에 이 id를 추가하도록 **gen-item 흐름으로 별도 _v# draft 생성**.
- 예: 새 무기가 "슬라임 100마리 처치" 후 해금 → 무기 정의 _v#에 `requiredAchievementDataIds: [600002]`.

### 8. 에셋 (asset-producer, 선택)
- 업적 자체엔 sprite 필드 없음(현 proto). UI 아이콘은 일반적으로 `name`/`tags` 기반 또는 popup 측 처리. 새 카테고리 아이콘이 필요하면 별도 합의.

### 9. _index 등록
`harness/content/<game>/achievements/_index.yaml`에 행 추가:

```yaml
- id: 600002
  name: "슬라임 100마리 처치"
  file: _drafts/600002_슬라임100마리_v1.yaml
  status: draft
  created_at: 2026-05-23T...Z
  created_by: gen-achievement
  reviewer: null
  reviewed_at: null
  type: Normal
  condition: KillUnit
  refs:
    units: [110201]            # conditionValue1
    items: [5, 3]              # rewardAddItemGroups
    parent: null
    children: []
  tags: [Combat, Tutorial]
```

### 10. 사용자 검수
- draft 파일 + (있다면) reward draft + 잠금 백참조 변경안 함께 제시.
- 피드백이면 `_v2`로 재생성(이전 v 보존, _index의 file 갱신).

### 11. 승인 (content-reviewer 통과 후)
- draft → `approved/{id}_{name}.yaml` 이동(버전 접미사 제거).
- `_index`의 `status: approved`, `reviewer`, `reviewed_at` 갱신.
- 연관 변경(reward draft, item _v#)도 같이 승인 흐름.

## 산출 예 (참고)
- `harness/content/idlez/achievements/approved/600001_첫처치.yaml` (Normal, KillUnitAny, target 10)
- `harness/content/idlez/achievements/approved/600002_슬라임100마리.yaml` (Normal, KillUnit, value1=110201, target 100)
- `harness/content/idlez/achievements/approved/600100_일일미션_부모.yaml` + `600101~600105_*` (자식 5종, `progressParentOnComplete`)
- `harness/content/idlez/achievements/_index.yaml`에 모두 등록

## 원칙
- **condition은 engine-bound** — schema 카드의 Condition enum에 있는 것만. 없는 종류는 엔진 추가 작업이며 behavior로 우회 불가.
- **진행 카운트는 엔진이** — 가능하면 condition + value1/2로 표현. 트리거 직접 호출은 최후 수단.
- **보상 댕글링 0** — `rewardAddItemGroups`의 itemDataId는 `items/_index.yaml`의 approved에 실재.
- **시스템 업적 재할당 금지** — `reserved_ids.achievement.*`의 id는 콘텐츠가 신규 생성 시 사용하지 않음 (엔진 코드가 직접 참조).
- AI는 `_drafts/`에만 쓴다. `approved/` 이동은 사용자 승인 액션.
- 같은 id 재생성은 `_v#` 번호 올림.
- `Tag.HideDisplay`는 시스템성 업적(슬롯 해금 등)에만 — 사용자 노출 업적엔 사용 금지.

## 다른 스킬과의 협업
- 분리형 보상 묶음 → content-designer/economy-balancer로 `rewards/_drafts/` 작성
- 커스텀 카운터 → `/gen-trigger` (단, condition으로 표현 불가할 때만)
- 잠금 아이템 백참조 → `/gen-item`에서 `requiredAchievementDataIds`에 이 id 추가하는 새 _v# draft
- 곡선/누적 목표 가드레일 → `/balance-review` (targetProgress 너무 빡센지)
- 부모-자식 트리 일괄 생성 → `/new-content`로 묶음 발산
