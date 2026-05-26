---
id: mushroomer-tier4-weapon-growth
bind: { type: item, match: { tag: WeaponTier4Growth } }
levels: 1..30
output: float
clamp: { min: 0 }
targets:
  - field: "equipAddStats[Attack].value"
    formula: weapon_attack
  - field: "equipAddStats[CooldownPercent].value"
    formula: cooldown
  - field: "equipAddStats[AttackSpeedPercent].value"
    formula: attack_speed
  - field: "equipAddStats[BossDamageEfficiencyPercent].value"
    formula: boss_damage
---

# T4 무기 성장

## weapon_attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 380 |
| growth | 1.15 |

## cooldown(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 6 |
| growth | 1.02 |

## attack_speed(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 9 |
| growth | 1.02 |

## boss_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 13 |
| growth | 1.025 |
