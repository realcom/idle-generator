---
id: mushroomer-tier3-equipment-growth
bind: { type: item, match: { tag: EquipmentTier3Growth } }
levels: 1..30
output: float
clamp: { min: 0 }
targets:
  - field: "equipAddStats[Hp].value"
    formula: hp
  - field: "equipAddStats[Attack].value"
    formula: attack
  - field: "equipAddStats[Defense].value"
    formula: defense
  - field: "equipAddStats[CriticalPercent].value"
    formula: crit
  - field: "equipAddStats[ItemDropPercent].value"
    formula: drop
  - field: "equipAddStats[CriticalDamagePercent].value"
    formula: crit_damage
  - field: "equipAddStats[BossDamageEfficiencyPercent].value"
    formula: boss_damage
  - field: "equipAddStats[MoveSpeed].value"
    formula: move
---

# T3 장비 성장

## hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 900 |
| growth | 1.13 |

## attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 75 |
| growth | 1.13 |

## defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 58 |
| growth | 1.12 |

## crit(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 8 |
| growth | 1.025 |

## drop(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 7 |
| growth | 1.02 |

## crit_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 28 |
| growth | 1.03 |

## boss_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 10 |
| growth | 1.025 |

## move(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 0.45 |
| growth | 1.01 |
