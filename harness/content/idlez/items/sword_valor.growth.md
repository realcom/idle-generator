---
id: sword-valor-attack
bind: { type: item, match: { id: 200201 } }
levels: 1..30
output: float
clamp: { min: 0 }
targets:
  - field: "equipAddStats[Attack].value"
    formula: atk
---

# 용사의 검 — 강화 레벨별 공격력

## atk(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 16 |
| growth | 1.18 |
