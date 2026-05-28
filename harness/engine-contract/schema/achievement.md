# Schema Card: Achievement

엔진 클래스: `ResourceAchievement` (`Commons/Resources/ResourceAchievement.proto`). 정의 계층.
업적 = 진행도 기반 목표(처치/획득/도달 등). `condition`이 카운트되는 이벤트 종류를, `targetProgress`가 목표치를 정의한다.

## 핵심 필드

| 필드 (#) | 타입 | 의미 | 참조 |
| --- | --- | --- | --- |
| `id` (100) | int32 | 업적 dataId | — |
| `name` (200) | string | 표시명(스트링 키) | Strings |
| `type` (101) | enum Type | 분류 — Normal(101)/Daily(201)/Weekly(202)/Ranking(203)/EventPass(301)/Mission(401) | — |
| `tags` (1) | repeated Tag | 분류 (`HideDisplay`로 표시 숨김 가능) | Tags |
| `order` (201) | int32 | 정렬 순서 | — |
| `initialOpen` (300) | bool | 시작부터 보임 (false면 부모/조건으로 해금) | — |
| `clientAchievement` (301) | bool | 클라이언트 카운트(서버 검증 안 함) | — |
| `condition` (302) | enum Condition | 진행 카운트 이벤트 종류 (아래) | engine-bound |
| `conditionValue1` (303) | int32 | 조건 인자 1 (대상 dataId 등) | → 조건별 |
| `conditionValue2` (304) | int32 | 조건 인자 2 (등급/레벨 등) | → 조건별 |
| `targetProgress` (305) | int32 | 목표 진행도 | — |
| `initialProgress` (313) | int32 | 시작 시 가산 | — |
| `repeatable` (306) | bool | 반복 가능 (Daily/Weekly에 자주) | — |
| `autoReward` (307) | bool | 완료 시 보상 자동 지급(false면 수동 클레임) | — |
| `rewardAddItemGroups` (2) | repeated AddItemGroup | 완료 보상 | → Item.id |
| `rewardRequiredItemDataId` (312) | int32 | 보상 수령 전 필요 아이템 | → Item.id |
| `rewardLevelReferenceItemDataId` (315) | int32 | 보상 레벨 참조 아이템 | → Item.id |
| `rewardMailDays` (500) | int32 | 메일 보상 유효 일수 | — |
| `popupArgs` (3) | map<string,string> | 팝업 인자(예: `Popup_Attendance` 시즌 코드) | — |
| `startAt` (102) | Timestamp | 시즌/이벤트 시작 | — |
| `untilAt` (103) | Timestamp | 시즌/이벤트 종료 | — |

## 계층(부모-자식)

| 필드 (#) | 의미 |
| --- | --- |
| `parentAchievementDataId` (310) | 부모 업적 id |
| `childAchievementDataIds` (308) | 자식 업적 id 목록 |
| `openChildrenOnComplete` (309) | 완료 시 자식들을 해금 |
| `progressParentOnComplete` (311) | 완료 시 부모 진행 +1 |
| `dayResetOpenRequiredAchievementDataId` (314) | 일일 리셋 시 해금 조건(선행 업적) |

> 트리: 부모 1개 → 자식 N개. Daily Mission이 부모, 개별 일일 미션이 자식인 식. `progressParentOnComplete`로 "5개 클리어 시 보너스" 패턴.

## 랭킹

| 필드 (#) | 의미 |
| --- | --- |
| `rankingItemDataId` (400) | 랭킹 점수로 쓸 Item.id (보통 점수 통화) |
| `rankingDelayDays` (401) | 정산 지연일 |

## Condition (진행 이벤트) — 주요만

`engine-bound`. 액션 어휘처럼 엔진이 정의한 enum만 사용 가능. 새 종류는 엔진 작업 필요.

| 대역 | 도메인 | 대표 enum |
| --- | --- | --- |
| 1-9999 | Achievement | `EnableAchievement`, `CompleteAchievement`, `ClaimRewardAchievement`, `AchievementProgressDay` |
| 10000-10099 | Acquire Item | `AcquireItemAny`, `AcquireItem`, `AcquireItemLevel`, `AcquireItemGrade`, `AcquireWeaponItemAny`, `AcquireEquipmentItemGrade` … 슬롯/카테고리별 다수 |
| 10100-10199 | Has Item | `HasItem`, `HasItemLevel` |
| 10200-10299 | Use Item | `UseItemAny`, `UseItem`, `UseUnitItemAvatar` |
| 10300-10399 | Create Item | `CreateItemAny`, `CreateItemRecipe` |
| 10400-10499 | Buy Item | `BuyItemAny`, `BuyItemProduct`, `BuyItemProductAction` |
| 10500-10599 | Level Up Item | `LevelUpItemAny`, `LevelUpItem`, `ExpUpItem` |
| 10600-10699 | Consume Item | `ConsumeItemAny`, `ConsumeItem` |
| 20000-29999 | Map | `KillUnitAny`, `KillUnit`, `WinGameAny`, `WinGame`, `WinGameGroup`, `LoseGame*`, `JoinGame*`, `WinWave` |
| 30000-39999 | Player | `Login`, `AcquireReferral`, `AcquirePremiumReferral`, `HasReferrals`, `DayReset`, `WeekReset`, `RankingReset`, `OnlineAtHour` |
| 40000-49999 | Mission | `MissionAcquireWeapon*`, `MissionSellWeapon`, `MissionUnitLevelUp`, `MissionUnitHpBelow`, `MissionUnitNoDamageDuration`, `MissionAcquireTrait*`, `MissionGoldBalance`, `MissionInventoryExpand`, `MissionInventoryFull` |
| 50000-59999 | Skill | `UseSkillAny`, `UseSkill` |

> 정본은 `ResourceAchievement.proto`의 `Condition` enum. 추출 가능 시 별도 `engine-contract/achievement-condition-catalog.md`로 분리 권장.

## conditionValue1/2 사용 예

| Condition | value1 | value2 |
| --- | --- | --- |
| `KillUnit` | Unit.id | (미사용) |
| `AcquireItem` | Item.id | (미사용) |
| `AcquireItemGrade` | Item.id | grade |
| `AcquireWeaponItemAnyGrade` | (미사용) | grade |
| `HasItemLevel` | Item.id | 요구 레벨 |
| `LevelUpItem` | Item.id | (미사용) |
| `WinGame` | Map.id | (미사용) |
| `WinGameGroup` | mapGroup tag/id | (미사용) |
| `MissionUnitLevelUp` | Unit.id | 요구 레벨 |
| `UseSkill` | Skill.id | (미사용) |
| `OnlineAtHour` | hour(0~23) | (미사용) |

→ 정확한 의미는 엔진 카운트 처리부(서버/클라) 참고. 헷갈리면 엔진팀 확인 후 작성.

### 레벨업 보상 관례

플레이어 레벨업에 따라 별도 포인트를 지급해야 할 때는 신규 엔진 훅을 만들기보다
`LevelUpItem` 업적을 우선 사용한다. `conditionValue1`에는 프로필의
`reserved_ids.playerLevel` 아이템 id를 넣고, `targetProgress: 1`, `repeatable: true`,
`autoReward: true`로 두면 플레이어 레벨 아이템이 1회 레벨업할 때마다 보상이 자동 지급된다.

## 전역(Global) 예약 dataId

`ResourceAchievement.Global.DataId` — 엔진 코드에서 직접 참조하는 시스템 업적 dataId 셋. proto의 field number와 실제 dataId는 다르다. 실제 값은 게임별 `Achievements.json.achievementGlobal.dataId`와 `game-profile reserved_ids.achievement.*`가 정본이다.

| 키 | 의미 |
| --- | --- |
| `tutorialComplete` | 메인 튜토리얼 완료 |
| `tutorialSteps[]` | 단계별 튜토리얼 |
| `ingameTutorialEnter` | 인게임 튜토리얼 진입 |
| `sentFeedback` | 피드백 전송 |
| `reviewedOnStore` | 스토어 리뷰 |
| `chapterEnterAgainCondition` | 챕터 재진입 조건 |
| `battleUnlock` | 전투 해금 |
| `equipmentSlotUnlock{Head/Chest/Gloves/Boots/Necklace/Ring}` | 장비 슬롯 해금 |
| `petSlotUnlocks[]` | 펫 슬롯 해금 |
| `abilityRoot` | 능력 트리 루트 |
| `equipmentPetUnlock` | 장비 펫 해금 |
| `lobbyDungeonUnlock` | 로비 던전 해금 |
| `premiumDailyReward` | 프리미엄 일일 보상 |
| `inventoryAutoSpawnUnlock` | 인벤토리 자동 소환 해금 |

## 참조 그래프

```
ResourceAchievement
  ├─ id                              ←  Item.requiredAchievementDataIds[]  (잠금)
  │                                  ←  Item.IsLockedByAchievement (장비 슬롯)
  ├─ rewardAddItemGroups[].addItems[].itemDataId → Item.id
  ├─ rewardRequiredItemDataId / rewardLevelReferenceItemDataId → Item.id
  ├─ rankingItemDataId               → Item.id
  ├─ parentAchievementDataId          → Achievement.id
  ├─ childAchievementDataIds[]        → Achievement.id
  ├─ dayResetOpenRequiredAchievementDataId → Achievement.id
  └─ conditionValue1/2 (Condition별)  → Unit.id / Item.id / Map.id / Skill.id
```

## 작성 규칙

- **condition + value1/2 + targetProgress + autoReward**가 골격. 진행도 증가는 엔진/서버가 condition별로 자동 처리(트리거 직접 호출 불필요한 경우 多).
- **사용자 정의 카운트가 필요한 경우만** behavior 트리거에서 `increaseAchievementProgress`(있다면) 호출 — 우선 condition enum로 표현 시도.
- 보상은 `rewardAddItemGroups` 우선. 내부 항목 필드는 `addItems`를 쓴다(`adds`는 과거 alias).
- 승인된 업적은 `content/<game>/achievements/approved/*.yaml`에 둔다. 컴파일러는 이 경로와 `achievements/*.achievement.yaml`을 함께 읽는다.
- 트리(부모-자식)는 일일/주간 미션 묶음에 활용. `progressParentOnComplete`로 "N개 완료 보너스" 자연스럽게.
- `clientAchievement: true`는 서버 검증이 없는 가벼운 업적에만 (보상이 큰 건 false).
- `Tag.HideDisplay`로 시스템성 업적(`equipmentSlotUnlock*` 같은)을 UI에서 숨김.
- 예약 id는 reserved_ids에서 끌어다 쓰고, 신규 업적은 `profile.id_ranges.achievement` 대역에서 할당.
