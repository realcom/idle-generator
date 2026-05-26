---
id: mushroomer-equipment-attack-growth
bind: { type: item, match: { tag: EquipmentAttackGrowth } }
levels: 1..30
output: float
clamp: { min: 0 }
targets:
  - field: "equipAddStats[Attack].value"
    formula: equip_attack
---

# 장갑 공격력 성장

## equip_attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 10 |
| growth | 1.13 |
