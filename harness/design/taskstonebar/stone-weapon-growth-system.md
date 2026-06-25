# Taskstonebar Stone Weapon Growth System

## Goal

The core combat verb is simple: the player equips stones, and each equipped stone throws itself on its own cooldown. Slots start at 1 and can grow to 10. A stone is both a weapon and a build piece, so every stone needs a readable combat lane, a growth curve, and a market/economy identity.

## Authoring Model

Stones are authored as `Item.category: Weapon` with `type: Hammer` because the legacy engine contract has no native `Stone` weapon enum. The stone identity comes from tags and an ignored overlay:

```yaml
category: Weapon
type: Hammer
tags: [Weapon, StoneWeapon, StoneSlot, Taskstonebar]
equipSkillDataIds: [300102]

_stoneWeapon:
  stage: 1
  slotRole: basic
  cooldownModel: independent
  throwSkillDataId: 300102
```

`idlez_compile.py` skips keys starting with `_`, so the engine JSON remains legacy-safe. Godot/server runtime builders can read `_stoneWeapon` from source YAML.

## Slot Rules

| Slots | Gate |
| --- | --- |
| 1 | Start |
| 2 | Clear map 500110 |
| 3 | Player level 12 |
| 4 | Cube level 4 |
| 5 | Clear map 500140 |
| 6 | Player level 35 |
| 7 | Clear map 500170 |
| 8 | Boss core crafting |
| 9 | Player level 75 |
| 10 | Clear map 500200 |

Duplicate stones are allowed by default. A stone with `UniqueStone` in tags is limited to one equipped copy.

## Combat Scheduler

Each equipped slot owns a timer:

```text
effectiveCooldown = Skill.cooldown
  * _stoneWeapon.cooldownMultiplier
  * (1 - clamp(CooldownPercent, -80, 80) / 100)
```

When a timer reaches zero, the slot casts the stone's first `equipSkillDataIds` skill and resets. Targeting is skill-owned: `Nearest` for basic farming, `HighestHp` for boss stones, `Random` for wide chaos stones.

This gives us clean tuning knobs:

- Stone item level changes stats.
- Skill changes hit shape, cooldown, damage budget, and buff behavior.
- Slot unlocks change build density without changing individual stone definitions.

## Growth Axes

| Axis | Data | Use |
| --- | --- | --- |
| Level | `requiredExps`, `equipAddStats.value[]`, `levelUpMaterialItemGroups` | Per-stone linear ownership growth |
| Grade | `grade` | Breakthrough/enhancement bucket, visible in market naming |
| Rarity | `rarity` | Drop/craft identity and market tier |
| Evolution stage | `_stoneWeapon.stage`, `StoneStageXX` tag | The 1-10 stone identity ladder |
| Effect lane | `_stoneWeapon.slotRole`, tags, skill behavior | Build differentiation |

Recommended first cap is level 10. Raise the cap only after the first 100-map balance pass is stable.

## Evolution Stages

| Stage | Item | Lane | Combat Identity |
| --- | --- | --- | --- |
| 1 | `조약돌` | basic | Fast basic single-target throw |
| 2 | `이끼돌` | moss | Slow and drop utility |
| 3 | `균열돌` | crack | Heavy impact with crit scaling |
| 4 | `태양석` | solar | Early area and boss pressure |
| 5 | `서리돌` | frost | Area slow and cooldown support |
| 6 | `용암돌` | lava | Delayed area burst for monster farming |
| 7 | `번개돌` | thunder | Fast chain throw and attack speed builds |
| 8 | `달빛돌` | moon | Critical multi-hit boss pressure |
| 9 | `별심돌` | starcore | Late-game boss/area burst |
| 10 | `태초돌` | origin | Unique final stone with triple wave and luck |

Stages are not the same as equip slots. A player can have up to 10 slots, and each slot can hold any valid stone instance. The stage ladder defines stone identity and progression depth; the slot system defines build density.

## Merge Data Model

Stage progression uses recipe-based merging:

```text
two copies of stage N stone -> stage N merge recipe -> one copy of stage N+1 stone
```

The stone itself remains a `Weapon` item. The transition is carried by a separate `Recipe` item tagged with `EquipmentCombineRecipe`, `AutoCombineAvailable`, and `StoneMergeRecipe`.

| Stage | Source | Recipe | Result |
| --- | --- | --- | --- |
| 1 -> 2 | `200202` | `200212` | `200203` |
| 2 -> 3 | `200203` | `200213` | `200204` |
| 3 -> 4 | `200204` | `200214` | `200205` |
| 4 -> 5 | `200205` | `200215` | `200206` |
| 5 -> 6 | `200206` | `200216` | `200207` |
| 6 -> 7 | `200207` | `200217` | `200208` |
| 7 -> 8 | `200208` | `200218` | `200209` |
| 8 -> 9 | `200209` | `200219` | `200210` |
| 9 -> 10 | `200210` | `200220` | `200211` |

Authoring rules:

- Stage 2-10 stones set `parentId` to the previous stage item id.
- Stage 1-9 stones set `_stoneWeapon.merge.recipeItemDataId` and `_stoneWeapon.merge.nextItemDataId`.
- Stage 10 sets `_stoneWeapon.merge.enabled: false` and is terminal.
- Each recipe uses two `materialItemGroups`, each with `{ id: source, count: 1 }`. Do not express this as a single group with `count: 2`, because the legacy combine popup counts sub-material slots from `materialItemGroups.Count - 1`.
- Result add groups explicitly grant the next stone at `level: 1`. Current server recipe creation does not preserve the consumed main stone level, so this is intentional until a runtime rule says otherwise.
- The Godot `StoneMerge` UI should read `StoneMergeRecipe` tags plus `_stoneMergeRecipe` overlays, then submit the selected two stone instances through the recipe creation path.

## Effect Lanes

| Lane | Intended Feel | First Content |
| --- | --- | --- |
| basic | Fast, clean single-target throw | `조약돌` |
| moss | Slower throw with movement slow and drop utility | `이끼돌` |
| crack | Heavy impact, crit scaling, small multi-target hit | `균열돌` |
| solar | Expensive area/boss stone | `태양석` |
| frost | Area control and cooldown support | `서리돌` |
| lava | Monster farming burst | `용암돌` |
| thunder | Fast chain hits | `번개돌` |
| moon | Critical multi-hit pressure | `달빛돌` |
| starcore | Late boss/area burst | `별심돌` |
| origin | Unique final stone | `태초돌` |
| cube | Cooldown/extra throw manipulation | Later season |

Keep each launch stone readable. If every stone has three conditional effects, the 10-slot board becomes unreadable fast.

## Balance Guardrails

Early 1-3 slots should feel busy but not like a projectile hose. The combined throw interval should not go below roughly 0.35 seconds before midgame.

For 8-10 slots, individual non-basic stones should generally stay at or above 0.8 seconds. Area stones should start around 2.6 seconds or slower unless their damage is deliberately low.

The first target DPS budget is:

```text
same-tier 10 stone loadout ~= 18-28% of same-level normal monster HP per second
boss-focused loadout ~= 12-18% of same-level boss HP per second before raid modifiers
```

## Economy Rules

Stones may be marketable before equip. Equipping, leveling, rerolling, or revealing hidden rolls should bind the exact instance to the server DB. Market-visible identity should be finite and searchable: rarity, grade bucket, lane, season, and maybe option family.

Feed and sink materials for launch:

- `200101` 조약돌 파편: basic feed
- `200102` 이끼 광석: lane feed and mid upgrades
- `200103` 큐브 촉매: breakthrough/crafting pressure

The design goal is not only stronger stones. It is a reason to keep burning low-tier drops even late in the season.
