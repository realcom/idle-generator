# Taskstonebar / 돌키우기2 UI Feature Requirements

## 1. Purpose

이 문서는 기획/시스템 문서를 기준으로 `돌키우기2 / Taskstonebar` UI가 반드시 지원해야 하는 기능을 정의한다.

범위는 두 단계로 나눈다.

- `MVP`: 첫 Godot taskbar/workshop vertical slice에 반드시 필요한 기능.
- `Expansion-ready`: 프로필과 경제 문서에 이미 들어온 장비, 캐릭터, 직업, 펫, 편성, 클랜/시즌 기능을 나중에 붙일 수 있도록 미리 자리만 잡는 기능.

이 문서의 결과물은 `ui-system-inventory.yaml`의 컴포넌트 목록과 이후 Godot UI recipe의 근거가 된다.

## 2. Source Documents

- `harness/game-profiles/taskstonebar.profile.yaml`
- `harness/design/taskstonebar/main-ui-design.md`
- `harness/design/taskstonebar/mvp-roadmap.md`
- `harness/design/taskstonebar/steam-market-mmo-system.md`
- `harness/design/taskstonebar/yaml-economy-contract.yaml`
- `harness/content/taskstonebar/**`
- TBH system summary attachment

## 3. Product Loop To Support

```text
Steam login / local_sandbox entry
→ taskbar combat auto-runs in 작업표시줄 동굴
→ server/mock rolls drops
→ non-market progress goes to DB/cache
→ marketable drops sync to Steam Inventory in live/staging
→ player chooses: feed stone, drag-merge stones, equip/bind, or open Steam Market
→ active stone inventory and equipment storage grow
→ portal depth, boss, clan/season sinks unlock
```

## 4. Hard UI Decisions

### Desktop Window / Taskbar Metaphor

Taskstonebar is not a full-screen mobile idle game. It should feel like a small desktop companion app.

Required:

- Every popup, modal, portal, inventory, and status surface must read as a movable desktop window: title bar, close affordance, framed body, shadow, and clear window focus.
- Closing a workshop window must never imply combat stopped. It only hides or collapses that window.
- The bottom combat strip is the product anchor: a taskbar-like always-on combat lane that can remain visible while the wider workshop UI is minimized.
- `taskbar_mode` means only the compact combat strip/status band remains visible above the OS taskbar motif; `workshop_mode` expands the floating windows back over it.
- Modal scrims may dim the desktop windows, but the combat strip context should remain readable unless a blocking account/security dialog truly requires full attention.

Not allowed:

- Full-screen opaque modals that make the UI feel like a normal mobile menu.
- Bottom inventory/navigation docks that compete with the combat taskbar lane.
- Treating the combat strip as decorative background instead of the persistent game surface.

### No In-Game Exchange

UI must never look like an internal auction house.

Allowed:

- `Steam Inventory refresh`
- `Open on Steam Market`
- marketable/tradable badges
- cached price hint placeholder if later implemented

Not allowed:

- in-game order book
- buy/sell listing form
- internal bid/ask graph
- client-side item minting or drop decision UI

### Server Authority Must Be Visible

The UI should show the current server/economy mode because live market items cannot be trusted to local saves.

Modes:

- `live`: real Steam Inventory, marketable drops enabled.
- `staging`: sandbox/test inventory, test drops.
- `local_sandbox`: Steam Inventory disabled, marketable drops disabled, saves cannot migrate.

### Offline Rewards Are Limited

Offline UI must clearly separate:

- Allowed offline: gold, EXP, basic ore.
- Online-only: chests, catalysts, high ore, boss cores, marketable rare drops.

### Marketable Items Are Also Burn Fuel

Every marketable drop needs item UI that makes four choices understandable:

- feed
- drag stone merge
- synthesize / refine
- open Steam Market

## 5. MVP Functional Requirements

### 5.1 App Shell And Runtime Modes

Required functions:

- Enter `taskbar_mode`.
- Expand from taskbar strip into `workshop_mode`.
- Minimize/collapse workshop windows while keeping the taskbar combat strip visible.
- Restore the last focused workshop window set from the taskbar combat strip.
- Keep OS taskbar visible in the visual model.
- Show server mode state.
- Show Steam login/sync state.
- Handle local sandbox warnings.

Primary UI surfaces:

- `DesktopOverlayRoot`
- `TopResourceBar`
- `UtilityIconCluster`
- `ServerModeBadge`
- `SteamSyncStatus`
- `TaskbarCombatStrip`
- `WorkshopWindowSet`

MVP data:

- runtime mode
- server mode
- Steam auth state
- inventory sync timestamp
- connection state

### 5.2 Taskbar Combat

Required functions:

- Show current map/stage: `작업표시줄 동굴`, `Stage 1-2`, region name.
- Remain readable as the primary surface when status/inventory/portal windows are minimized.
- Avoid requiring any modal/window to understand current combat, enemy HP, stage, or latest drop.
- Show player character `작업돌지기`.
- Show current enemy/boss.
- Show HP bars, damage numbers, projectile, hit impact.
- Show auto combat state.
- Show skill trigger for `돌팔매`.
- Show drop log and rare drop toast.
- Distinguish normal, elite, boss encounters.
- Do not use a bottom inventory dock in the main mockup; the bottom taskbar area is reserved for the combat scene.

Primary UI surfaces:

- `TaskbarCombatStrip`
- `StageBadge`
- `CombatLane`
- `HeroCombatSprite`
- `EnemyStack`
- `EnemyHpBar`
- `DamageNumberLayer`
- `ProjectileLayer`
- `AutoCombatToggle`
- `AutoSkillToggle`
- `LootTicker`
- `RareDropToast`
- `CombatSceneShortcutDock`

MVP data:

- `Map.id: 500101`
- `Unit.id: 110111, 110201, 110202, 110501`
- `Skill.id: 300101`
- current wave
- enemy HP/max HP
- player skill cooldown
- drop events

### 5.3 Resource And Progress Counters

Required functions:

- Show gold, ruby, EXP, level, basic materials, catalyst, chest queue.
- Show online-only materials with a distinct badge.
- Keep counters compact enough for desktop overlay.
- Animate gains from combat/logs into counters.

Primary UI surfaces:

- `TopResourceBar`
- `ResourceCounter`
- `GainFlyout`
- `InventoryCapacityChip`

MVP data:

- gold `Item.id: 5`
- ruby/free ruby `Item.id: 3/4`
- EXP `Item.id: 6`
- player level `Item.id: 1`
- `200101 조약돌 파편`
- `200102 이끼 광석`
- `200103 큐브 촉매`

### 5.4 Status And Growth

Required functions:

- Show current stone/character level, EXP, HP/durability.
- Show combat/farming stats.
- Show rune/mark tree summary.
- Show stat point or skill point state if available.
- Explain which bonuses affect farming, bossing, drops, and cube economy.

Primary UI surfaces:

- `StatusWindow`
- `StonePortraitPanel`
- `StatList`
- `ProgressBar`
- `RuneMarkTree`
- `GrowthBonusList`
- `DetailedStatsModal`

MVP data:

- Hp
- Attack
- Defense
- CriticalPercent
- CriticalDamagePercent
- AttackSpeed
- MoveSpeed
- ExpPercent
- ItemDropPercent
- SellPricePercent
- BossDamageEfficiencyPercent
- BossDamageTakenEfficiencyPercent
- ScalePercent

### 5.5 Center Hero: Stone Inventory And Equipment Storage

Required functions:

- Follow the density and interaction language of a TBH-style `Hero` panel.
- Show the stone keeper / character portrait as the center anchor.
- Show class/role label and level.
- Show equipment, pet, rune, and stone slots around the character.
- Split inventory into `StoneInventoryPanel` and `EquipmentStoragePanel` under a `StoneEquipmentTabBar`.
- Only one inventory panel is visible at a time; `돌` is the default active tab and `장비` toggles into the same body area.
- `StoneInventoryPanel` accepts stones only.
- `EquipmentStoragePanel` stores equipment, runes, pets, accessories, chests, and non-stone items.
- Inventory tab bodies use a 6-column by 5-row visible grid in the main mockup.
- Stone inventory slots unlock from top-left to bottom-right.
- Only stones placed in active stone inventory slots run cooldown and attack.
- Inactive stone inventory slots can hold stones but do not attack.
- Each active stone slot must show cooldown state.
- Preserve 돌키우기 identity through active stones, cooldowns, and drag-merge, not a separate merge tab.
- Use a TBH-style bottom `KeeperIconDock` instead of text CTA buttons.
- Allow drag-merging same-tier stones inside the stone inventory.
- Show drag target, merge preview, and merge result feedback.
- Show starter weapon reforge cost.
- Show success/failure or exchange result when recipe has probability later.

Primary UI surfaces:

- `HeroInventoryWindow`
- `CharacterPortrait`
- `EquipmentSlotGrid`
- `StoneSlotGrid`
- `StoneInventoryPanel`
- `EquipmentStoragePanel`
- `ActiveStoneSlot`
- `StoneCooldownIndicator`
- `DragMergeGhost`
- `DragMergePreview`
- `FeedMeter`
- `FeedTray`
- `MaterialGrid`
- `RecipePreview`
- `PrimaryActionButton`
- `ConsumeConfirmModal`
- `CraftResultModal`

MVP data:

- `200101.sinks.feed_xp`
- `200102.sinks.feed_xp`
- `200103.sinks.feed_xp`
- `_economy.sinks.recipes`
- owned character items
- active stone slot unlock count
- stone slot cooldown state
- stone inventory items
- equipment storage items
- item counts
- recipe requirements
- server consume response

### 5.6 Inventory

Required functions:

- Show Steam Inventory assets and DB-bound items together without confusing ownership.
- Filter by material, catalyst, equipment, character, pet, cosmetic, chest.
- Show marketable/tradable/online-only/bound/sealed states.
- Show stack count and market lot size.
- Show item sinks: feed XP, cube XP, alchemy gold, recipes.
- Show item source/faucet and daily cap if useful.
- Provide actions based on item state.

Primary UI surfaces:

- `InventoryWindow`
- `InventoryTabBar`
- `ItemGrid`
- `ItemCard`
- `ItemTooltip`
- `ItemActionMenu`
- `OwnershipBadge`
- `MarketBadge`
- `OnlineOnlyBadge`
- `BoundBadge`
- `SteamInventoryRefreshButton`

MVP data:

- `Item.category`
- `_economy.role`
- `_economy.steam.enabled`
- `_economy.steam.marketable`
- `_economy.steam.tradable`
- `_economy.stack.market_lot_size`
- `_economy.supply.online_only`
- `_economy.sinks`
- server-bound item state

### 5.7 Portal And Stage Progression

Required functions:

- Show act/stage path.
- Show a TBH-style difficulty selector and Act tabs above the map.
- Show a parchment route map rather than a plain grid.
- Show current stage and next stage.
- Show boss node.
- Show recommended level/risk when available.
- Let player enter/auto-advance/retry.

Primary UI surfaces:

- `PortalWindow`
- `PortalDifficultySelect`
- `ActTabBar`
- `ParchmentRouteMap`
- `StageNode`
- `BossNode`
- `BossGateModal`

MVP data:

- map id/name/type
- stage progress
- enemy dropAddItemGroups

### 5.8 Rewards, Chests, And Drop Logs

Required functions:

- Show normal drops quickly without interrupting combat.
- Show marketable/rare drops with stronger feedback.
- Show chest queue and open/claim actions.
- Show boss reward and pity hints if configured.
- Show offline return summary.
- Route Steam-granted items to inventory refresh.

Primary UI surfaces:

- `LootTicker`
- `RareDropToast`
- `RewardQueue`
- `ChestCard`
- `RewardClaimModal`
- `OfflineReturnModal`
- `SteamGrantToast`

MVP data:

- drop item id/count
- source unit/map
- rarity
- marketable flag
- online-only flag
- chest queue count
- offline reward payload

### 5.9 Steam Inventory And Market Links

Required functions:

- Login/sync state.
- Refresh inventory.
- Show sync errors and stale cache.
- Open Steam Inventory page.
- Open Steam Market page for a selected item.
- Disable market actions in local sandbox.
- Explain why local_sandbox drops are not live assets.

Primary UI surfaces:

- `SteamSyncStatus`
- `SteamInventoryRefreshButton`
- `SteamActionMenu`
- `ExternalLinkConfirmModal`
- `ServerModeWarningBanner`
- `SyncErrorToast`

MVP data:

- auth state
- inventory sync state
- itemdefid
- market_hash_name
- server mode
- external link URL or request id

## 6. Expansion-Ready Functional Requirements

### 6.1 Classes

Required later:

- Show class roles: tank, ranged DPS, farming support, buff-heal.
- Show per-character contribution.
- Show class unlock ticket/shards/skins as marketable assets.

Primary UI surfaces:

- `ClassRoleBadge`
- `CharacterCard`
- `ClassUnlockModal`

### 6.2 Equipment And Random Options

Required later:

- Show equipment slots.
- Show sealed roll, visible bucket, and bound instance modes.
- Reveal sealed item, consuming Steam asset and creating DB-bound item.
- Show option family/tier before trade when market-facing.
- Equip/reroll/enhance with bind warnings.
- Show starter weapon reforge in MVP but leave full equipment as expansion.

Primary UI surfaces:

- `EquipmentPanel`
- `EquipmentSlot`
- `OptionBucketBadge`
- `SealedItemCard`
- `RevealConfirmModal`
- `BindWarningModal`
- `ReforgePanel`
- `EnhancePanel`

### 6.3 Pets

Required later:

- Show pet eggs/shards/skins as marketable assets.
- Reveal or hatch into server-bound pet state.
- Equip pets to character/formation.
- Show passive bonus even when not in combat if design keeps TBH-like passive pet rule.

Primary UI surfaces:

- `PetCollectionPanel`
- `PetCard`
- `PetSlot`
- `PetHatchModal`
- `PetPassiveList`

### 6.4 Clan Mine And Season

Required later:

- Donate materials to clan mine.
- Show group progress and buff unlocks.
- Show season ranking and burn targets.
- Craft season skins with old materials.
- Show irreversible donation/craft confirmation.

Primary UI surfaces:

- `ClanMinePanel`
- `DonationPanel`
- `SeasonPanel`
- `SeasonRankList`
- `SeasonCraftPanel`
- `DonationConfirmModal`

## 7. Required UI State Tags

Every relevant item/card/action must support these tags.

| Tag | Meaning | UI Use |
| --- | --- | --- |
| `marketable` | Can become Steam Market asset | Market badge, Steam action |
| `tradable` | Can be traded | Trade badge if exposed |
| `bound` | Server DB-bound, not marketable | Lock badge, disabled market action |
| `sealed` | Tradeable before reveal | Reveal action, mystery tooltip |
| `visible_bucket` | Market-facing option tier visible | Option family/tier badge |
| `online_only` | Cannot be earned offline | Online badge |
| `burnable` | Can be consumed by feed/drag-merge/donation | Burn warning |
| `irreversible` | Action cannot be undone | Confirm modal |
| `local_sandbox_only` | Mock save/drop | Warning badge |
| `stale_inventory` | Steam cache is old | Refresh prompt |

## 8. Modal Requirements

MVP required:

- Consume confirm: feed/drag-merge/synthesis.
- External link confirm: Steam Market/Inventory.
- Offline return.
- Reward claim.
- Sync error.
- Server mode warning.

Expansion required:

- Reveal sealed item.
- Bind on equip/reroll/enhance.
- Class unlock.
- Pet hatch.
- Clan donation.
- Season craft.

## 9. Toast And Log Requirements

Combat must not pause for normal rewards.

Toast tiers:

- `minor`: gold, EXP, common fragment.
- `notable`: online-only ore, chest, elite drop.
- `rare`: catalyst, boss core, marketable sealed item.
- `system`: Steam sync, server mode, inventory stale, local sandbox warning.

Log channels:

- combat log
- loot log
- system log
- formation contribution log
- world rare drop log later

## 10. MVP Screen Priority

The first implementation should prioritize:

1. `TaskbarCombatStrip`
2. `HeroInventoryWindow`
3. `InventoryWindow`
4. `PortalWindow`
5. `StatusWindow`
6. `SteamSyncStatus`
7. `RewardClaimModal`
8. `ConsumeConfirmModal`

Everything else can be represented as disabled tabs, placeholder badges, or future surfaces until the data exists.

## 11. Open Questions

- Should the center window title be `돌지기`, `Hero`, or `인벤토리`?
- Should `party` copy be avoided entirely in early UI because the profile defines account formation, not multiplayer party?
- Should `Steam Market` copy be explicit, or should MVP use neutral `외부 거래 보기` until app/store policy wording is final?
- Should chest opening exist in MVP, or should chest cards only be online reward previews until chest itemdefs are added?
- How much of random option UI should appear before equipment content exists?
