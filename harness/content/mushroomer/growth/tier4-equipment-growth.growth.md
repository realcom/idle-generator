---
id: mushroomer-tier4-equipment-growth
bind: { type: item, match: { tag: EquipmentTier4Growth } }
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

# T4 장비 성장

## hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 2500 |
| growth | 1.13 |

## attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 200 |
| growth | 1.13 |

## defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 155 |
| growth | 1.12 |

## crit(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 12 |
| growth | 1.025 |

## drop(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 10 |
| growth | 1.02 |

## crit_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 52 |
| growth | 1.03 |

## boss_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 16 |
| growth | 1.025 |

## move(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 0.65 |
| growth | 1.01 |
