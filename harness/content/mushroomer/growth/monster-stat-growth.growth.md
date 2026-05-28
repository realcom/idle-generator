---
id: mushroomer-sporeling-stat-growth
bind: { type: unit, match: { id: 110201 } }
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

# 이끼 포자 스테이지 성장

## hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 60 |
| growth | 1.12 |

## attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 4 |
| growth | 1.105 |

## defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 1 |
| growth | 1.09 |
