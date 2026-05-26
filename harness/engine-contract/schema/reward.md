# Schema Card: Reward / Drop (공유 부품)

엔진 타입: `AddItem` / `AddItemGroup` / `TraitItemGroup` (`Commons/Types/AddItem.proto`),
보조: `MaterialItem`/`MaterialItemGroup` (`Types/MaterialItem.proto`), `ItemOption`/`ItemOptionGroup` (`Types/ItemOption.proto`).

보상/드롭/가챠는 **단일 부품**으로 통일돼 있다. 던전 드롭, 유닛 처치 드롭, 가챠, 상자 개봉, 판매·분해 보상, 출석/일일 보상이 전부 `AddItemGroup`을 쓴다.

## AddItem (드롭 1건)

| 필드 (#) | 타입 | 의미 |
| --- | --- | --- |
| `itemDataId` (1) | int32 | 줄 아이템 → Item.id |
| `count` / `minCount` / `maxCount` (2/3/4) | int64 | 수량(고정/범위) |
| `level` / `minLevel` / `maxLevel` (5/6/7) | int32 | 아이템 레벨 |
| `exp` / `minExp` / `maxExp` (10/11/12) | int64 | 경험치 보상 |
| `days`/`hours`/`minutes` (8/13/14) | int32 | 기간제 아이템 |
| `weight` (9) | float | 가중 추첨용 가중치 |
| `group` (15) | int32 | 추첨 그룹 |
| `pityGroup` (16) | int32 | ★ 천장 그룹 |
| `isCore` (200) | bool | 핵심 보상 표시 |
| `hideInRewardPreview` (17) | bool | 미리보기 숨김 |

## AddItemGroup (드롭 테이블)

| 필드 | 의미 |
| --- | --- |
| `addItems[]` | 후보 AddItem 목록 |
| `probPercent` | 이 그룹 발동 확률 |
| `rank` | 등급/순위 |
| `shouldAddAll` | true=전부 지급, false=가중 추첨 |
| `level` / `levelReferenceItemDataId` | 보상 레벨 결정 |

추첨 의미: `probPercent`로 그룹 발동 여부를 먼저 판정한다. `shouldAddAll=true`면 발동 시 `addItems[]` 전부 지급, `false`면 `addItems[].weight`로 1개를 가중 추첨한다.

## YAML 작성 예

```yaml
rewardAddItemGroups:
  - shouldAddAll: true
    probPercent: 100
    addItems:
      - { itemDataId: 5, minCount: 100, maxCount: 200, isCore: true }
      - { itemDataId: 6, count: 30 }

  - shouldAddAll: false
    probPercent: 25
    addItems:
      - { itemDataId: 200102, count: 1, weight: 70, group: 2 }
      - { itemDataId: 200103, count: 1, weight: 30, group: 2, pityGroup: 1 }
```

`addItems`가 정본 필드다. `adds`는 과거 작성물 호환 alias로 컴파일러가 받아주지만 새 콘텐츠에는 쓰지 않는다.

## MaterialItemGroup (비용/재료)

강화·제작·리롤 비용. `materialItems[].id`(→Item.id) + `count` + `minLevel/maxLevel`, `shouldAllValid`. 사용처: `Item.levelUpMaterialItemGroups`, `productMaterialItemGroups`, `rerollMaterialItemGroups`.

## ItemOptionGroup (장비 랜덤 옵션 = affix)

`options[].{grade, group, weight, minLevel, maxLevel, addStats[](→UnitStatType)}`. 장비의 `options`(13000) 필드에서 등급별 affix 풀로 사용. 가챠와 동일한 weight 추첨 패턴.

## TraitItemGroup (특성 보상)

레벨업/조우/골드카드 시 특성 추첨 (`type: LevelUp/Encounter/GoldCardFlip`, `unitDataId`, `probPercent`).

## 작성 규칙 (소스 YAML)

`content/<game>/rewards/*.reward.yaml` 또는 유닛/맵/아이템 정의 내 인라인. 예시는 `content/idlez/rewards/`.

- 모든 `itemDataId`는 실재 Item.id여야 함 (검증기 필수 체크).
- `count/minCount/maxCount`와 `exp/minExp/maxExp`는 int64라서 산출 JSON에서는 문자열이 된다. YAML에서는 숫자로 쓴다.
- `minCount/maxCount`, `minLevel/maxLevel`, `minExp/maxExp`는 양끝 포함 범위다.
- `pityGroup`은 현재 엔진 구현상 `Tag.Pity`가 붙은 Product 구매 경로에서 `bonusCounts`/`bonusItemDataIds`와 함께 동작한다. 일반 유닛 드롭·업적·스카우트에서는 천장 카운터가 자동 저장되지 않는다.
- 확률·가중치 합·천장 카운트는 `tools/validate`가 검산(기대 획득률 산출 가능).
