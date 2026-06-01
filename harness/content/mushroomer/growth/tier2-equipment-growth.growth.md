---
id: mushroomer-tier2-equipment-growth
bind: { type: item, match: { tag: EquipmentTier2Growth } }
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

# T2 장비 성장

## hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 320 |
| growth | 1.13 |

## attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 28 |
| growth | 1.13 |

## defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 22 |
| growth | 1.12 |

## crit(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 5 |
| growth | 1.025 |

## drop(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 4 |
| growth | 1.02 |

## crit_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 14 |
| growth | 1.03 |

## boss_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 6 |
| growth | 1.025 |

## move(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 0.3 |
| growth | 1.01 |
