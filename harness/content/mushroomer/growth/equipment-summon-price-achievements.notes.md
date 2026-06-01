# equipment-summon-level-achievements

장비 소환 상품 `200503`은 숨김 업적 `600124..600133`의 클리어 수로 소환레벨을 계산한다.
레벨이 오르면 가격도 오르고, 보상 샘플링에서는 높은 `tier` 장비의 가중치가 함께 오른다.

| completed achievement | summon level | summon count reached | monster soul cost |
| --- | ---: | ---: | ---: |
| 0 | 1 | 0 | 10 |
| 1 | 2 | 5 | 15 |
| 2 | 3 | 10 | 20 |
| 3 | 4 | 15 | 25 |
| 4 | 5 | 20 | 30 |
| 5 | 6 | 25 | 35 |
| 6 | 7 | 30 | 40 |
| 7 | 8 | 35 | 45 |
| 8 | 9 | 40 | 50 |
| 9 | 10 | 45 | 55 |
| 10 | 11 | 50 | 60 |

Formula: `cost = baseMaterialCount + completedTargetAchievementCount * regenCount`.
Summon level: `level = completedTargetAchievementCount + 1`.
Reward weight: `effectiveWeight = baseWeight * (1 + (level - 1) * (tier - 1) * 0.22)`.
