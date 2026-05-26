# slime-jelly — sellPrice 곡선 (재료 시리즈)

대상: `items/200111_낡은슬라임젤리`, `items/200112_일반슬라임젤리`, `items/200113_빛나는슬라임젤리`

## 식

```
sellPrice(grade) = 20 × 5^(grade - 1)
```

| grade | rarity | sellPrice |
| ----- | ------ | --------- |
| 1     | Common | 20        |
| 2     | Rare   | 100       |
| 3     | Epic   | 500       |

## 근거

- 5배 비율은 idlez 가죽 시리즈(200101~200103)와 유사한 곡선 (실측 필요 시 balance-review).
- monotonic increasing — 시리즈 일관성 보장.
- Epic 등급은 pityGroup 적용 권장 (드롭 천장 — 출처 reward에서 설정).

## 출처 매핑

| Item.id | drop_from Unit | drop weight (참고) |
| ------- | -------------- | ------------------ |
| 200111  | 110201 (초록 슬라임) | 높음 (60%) |
| 200112  | 110201          | 중 (30%) |
| 200113  | 110201          | 낮음 (10%, pityGroup) |

> 실제 weight·천장은 `rewards/_drafts/<id>_meadow_slime_drops_v#.yaml`에서 결정.
