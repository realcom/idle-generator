---
id: mushroomer-weapon-attack-growth
bind: { type: item, match: { tag: WeaponAttackGrowth } }
levels: 1..30
output: float
clamp: { min: 0 }
targets:
  - field: "equipAddStats[Attack].value"
    formula: weapon_attack
---

# 무기 공격력 성장

## weapon_attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 22 |
| growth | 1.145 |
