---
id: mushroomer-equipment-hp-growth
bind: { type: item, match: { tag: EquipmentHpGrowth } }
levels: 1..30
output: float
clamp: { min: 0 }
targets:
  - field: "equipAddStats[Hp].value"
    formula: equip_hp
---

# 방어구 체력 성장

## equip_hp(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 120 |
| growth | 1.13 |
