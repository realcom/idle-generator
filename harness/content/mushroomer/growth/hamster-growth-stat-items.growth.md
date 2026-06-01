---
id: mushroomer-hamster-growth-stat-items
bind: { type: item, match: { tag: HamsterGrowthStat } }
levels: 1..81
output: float
clamp: { min: 0 }
targets:
  - field: "addStats[Attack].value"
    formula: attack
  - field: "addStats[Hp].value"
    formula: hp
  - field: "addStats[AttackSpeedPercent].value"
    formula: attack_speed
  - field: "addStats[CriticalDamagePercent].value"
    formula: critical_damage
---

# 성장 Stat 아이템

## attack(level)
`value = gain * level`

| param | value |
| --- | --- |
| gain | 5 |

## hp(level)
`value = gain * level`

| param | value |
| --- | --- |
| gain | 45 |

## attack_speed(level)
`value = gain * level`

| param | value |
| --- | --- |
| gain | 4 |

## critical_damage(level)
`value = gain * level`

| param | value |
| --- | --- |
| gain | 10 |
