---
id: mushroomer-equipment-defense-growth
bind: { type: item, match: { tag: EquipmentDefenseGrowth } }
levels: 1..30
output: float
clamp: { min: 0 }
targets:
  - field: "equipAddStats[Defense].value"
    formula: equip_defense
---

# 방어 장비 성장

## equip_defense(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 8 |
| growth | 1.12 |
