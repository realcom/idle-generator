---
id: mushroomer-tier3-weapon-growth
bind: { type: item, match: { tag: WeaponTier3Growth } }
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

# T3 무기 성장

## weapon_attack(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 150 |
| growth | 1.15 |

## cooldown(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 4 |
| growth | 1.02 |

## attack_speed(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 6 |
| growth | 1.02 |

## boss_damage(level)
`value = base * pow(growth, level - 1)`

| param | value |
| --- | --- |
| base | 8 |
| growth | 1.025 |
