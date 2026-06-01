---
id: mushroomer-tier5-equipment-growth
bind: { type: item, match: { tag: EquipmentTier5Growth } }
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

# T5 장비 성장

## hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 7000 |
| growth | 1.13 |

## attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 540 |
| growth | 1.13 |

## defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 420 |
| growth | 1.12 |

## crit(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 18 |
| growth | 1.025 |

## drop(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 15 |
| growth | 1.02 |

## crit_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 90 |
| growth | 1.03 |

## boss_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 25 |
| growth | 1.025 |

## move(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 0.9 |
| growth | 1.01 |
