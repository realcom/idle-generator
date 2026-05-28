---
id: mushroomer-sporeking-stat-growth
bind: { type: unit, match: { id: 110501 } }
levels: 1..40
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

# 포자 대왕 보스 성장

## hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 900 |
| growth | 1.16 |

## attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 12 |
| growth | 1.12 |

## defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 4 |
| growth | 1.10 |
