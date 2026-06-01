---
id: mushroomer-player-stat-growth
bind: { type: unit, match: { id: 110111 } }
levels: 1..80
output: float
clamp: { min: 1 }
targets:
  - field: "addStats[Hp].value"
    formula: hp
  - field: "addStats[Attack].value"
    formula: attack
  - field: "addStats[Defense].value"
    formula: defense
---

# 버섯 용사 성장

## hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 900 |
| growth | 1.0 |

## attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 80 |
| growth | 1.0 |

## defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 1 |
| growth | 1.0 |
