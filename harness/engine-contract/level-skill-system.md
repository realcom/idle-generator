# Level-Linked Skill System

레벨과 연계된 스킬트리는 엔진 확장 없이 기존 ResourceItem/ResourceAchievement 경로로 표현한다.

## 흐름

1. 플레이어 레벨은 `reserved_ids.playerLevel` 아이템 레벨로 본다.
2. 플레이어 레벨업마다 `LevelUpItem(playerLevel)` 반복 업적이 자동 완료되고, 레벨 포인트 아이템을 지급한다.
3. 스킬은 `Item.category: Skill` 아이템으로 보유/강화한다. 실제 전투 효과는 `skillDataId`가 가리키는 `ResourceSkill`이다.
4. 스킬 해금은 `Item.category: Recipe` 학습 아이템으로 표현한다. 레시피는 레벨 포인트와 스킬 재료를 소비하고 스킬 아이템을 지급한다.
5. 플레이어 레벨 제한은 숨김 업적 `HasItemLevel(playerLevel, N)`으로 만든 뒤, 스킬/레시피의 `requiredAchievementDataIds`에 연결한다.

## 프로필 선언

`harness/game-profiles/<game>.profile.yaml`:

```yaml
progression:
  skill_tree:
    tree_id: Mushroomer
    player_level_item_id: 1
    level_point_item_id: 200107
    level_point_grant:
      via: achievement
      achievement_id: 600107
      condition: LevelUpItem
      player_level_item_id: 1
      grant_per_player_level_up: 1
    early_spend_each_level_until: 20
    level_gate_achievements:
      - { player_level: 5, achievement_id: 600113 }
```

컴파일러는 이 선언이 있으면 다음을 검증한다.

- 레벨 포인트 지급 업적이 `repeatable: true`, `autoReward: true`이고 레벨 포인트를 지급하는가
- 레벨 게이트 업적이 `HasItemLevel`로 플레이어 레벨 아이템을 참조하는가
- `early_spend_each_level_until`까지는 매 레벨업 후 최소 1개의 스킬 해금/강화 선택지가 있는가
- 스킬 아이템의 `skillDataId`, `LevelPointItemDataId`, `RequiredPlayerLevel`, 선행 스킬 참조가 유효한가
- 레시피가 같은 레벨 게이트와 레벨 포인트 비용을 가지고, 대상 스킬 아이템을 지급하는가

## 스킬 아이템 popupArgs

런타임/UI가 읽는 최소 메타:

```yaml
popupArgs:
  SkillTree: "Mushroomer"
  SkillTreeNode: "AoE"
  ChildrenSkillItemDataIds: "200404"
  UnlockRecipeItemDataId: "200405"
  UnlockCostLevelPoint: "2"
  LevelPointItemDataId: "200107"
  RequiredSkillItemDataIds: "200401"
  RequiredSkillLevel: "3"
  RequiredPlayerLevel: "8"
  MaxSkillLevel: "5"
```

이 값들은 엔진 필드는 아니지만, harness/runtime과 Unity UI가 같은 데이터를 읽도록 하는 안정적인 계약이다.

## Mushroomer 기준 트리

`mushroomer`의 초기 스킬트리는 1/5/8/12 이후 30레벨부터 10레벨 단위로 100까지 확장한다.

| level | skill item | resource skill | branch |
| --- | --- | --- | --- |
| 1 | 200401 포자 충격서 | 300101 포자 충격 | Root |
| 5 | 200402 균사 폭발서 | 300102 균사 폭발 | AoE |
| 8 | 200403 왕포자 강타서 | 300103 왕포자 강타 | Boss |
| 12 | 200404 포자 각성서 | 300104 포자 각성 | Buff |
| 30 | 200408 이끼 회오리서 | 300105 이끼 회오리 | AoE2 |
| 40 | 200409 균핵 분쇄서 | 300106 균핵 분쇄 | Boss2 |
| 50 | 200410 달빛 포자진서 | 300107 달빛 포자진 | Merge |
| 60 | 200411 심연 포자비서 | 300108 심연 포자비 | Rain |
| 70 | 200412 왕버섯 분노서 | 300109 왕버섯 분노 | Rage |
| 80 | 200413 균사 유성서 | 300110 균사 유성 | Meteor |
| 90 | 200414 포자 대폭주서 | 300111 포자 대폭주 | Overrun |
| 100 | 200415 포자 심장서 | 300112 포자 심장 | Ultimate |
