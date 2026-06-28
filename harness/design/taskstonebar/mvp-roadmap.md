# Taskstonebar / 돌키우기2 MVP Roadmap

## 1. Data Slice

- Profile: `harness/game-profiles/taskstonebar.profile.yaml`
- Content: one player, two monsters, one boss, one starter weapon, three marketable materials, one dungeon.
- Compile target: `python3 harness/tools/idlez_compile.py taskstonebar`
- Economy overlay: `harness/design/taskstonebar/yaml-economy-contract.yaml`
- System skeleton: `harness/design/taskstonebar/steam-market-mmo-system.md`

## 2. Visual Slice

- Primary asset root: `assets/growstone2/`.
- Use the original 돌키우기1 assets first:
  - `UI/` for popup/tab/button/slot/shop frames
  - `unit/` for original unit and character references
  - `effect/` for skill, critical, level-up, shield, solarstone effects
  - `map/` for town, mine, dungeon, field backdrops
- Repack for Godot atlas, frame slicing, 9-slice, and import presets without changing the original visual identity.
- Generate new assets only when the original asset pool cannot cover a Steam/Godot/season requirement.

## 3. Runtime Slice

- First runtime target: Godot transparent taskbar strip plus MMO workshop panels.
- Reuse the local prototype layout ideas:
  - bottom combat strip
  - status panel
  - stone/merge panel
  - portal panel
- Add Steam login/inventory refresh stubs early.
- Keep game logic data-driven where possible so later content comes from `harness/build/taskstonebar/*.json` plus `_economy` overlay manifest.

## 4. System Slice

- Server authoritative MMO loop from the first economy slice:
  - mine channel online session
  - server-side drop roll
  - Steam Inventory grant for marketable drops
  - DB-only progress for gold/EXP/stage
- Production and staging require a server from day one.
- `local_sandbox` may use mock/embedded server logic, but Steam Inventory and marketable drops are disabled and saves never migrate to live.
- No in-game exchange. Godot opens Steam Market/Inventory surfaces.
- Add cube functions in order: alchemy, 9-to-1 synthesis, catalyst refining.
- Keep offline reward to gold/EXP/basic ore only; catalyst and high ore remain online-only.

## 5. Economy Slice

- Every marketable drop must also be food or cube fuel.
- Initial marketable items:
  - `200101 조약돌 파편`
  - `200102 이끼 광석`
  - `200103 큐브 촉매`
- First sinks:
  - stone feed
  - cube XP
  - synthesis
  - starter weapon reforge
  - clan mine donation placeholder

## 6. Asset Economy Expansion

- Equipment, characters, pets, mines, skills, traits, cosmetics, and chests are all in scope.
- Random options use the existing `ResourceItem.options / optionCounts` schema.
- Steam Market-facing random assets use one of three modes:
  - `sealed_roll`: tradeable before reveal, server-bound after reveal
  - `visible_bucket`: option family/tier visible in name/tags
  - `bound_instance`: exact random values live only in server DB and cannot be traded
- Market-critical option data must be visible via ItemDef, tags, or `market_hash_name`; hidden dynamic props are not a price source.

## 7. Class And Formation Slice

- Classes are real combat roles, not just cosmetics.
- Launch class targets:
  - `돌수호자`: tank / boss stability
  - `돌팔매꾼`: ranged DPS / fast farming
  - `광부`: farming support / ore and chest bonus
  - `태양석 주술사`: buff-heal / formation sustain
- Party means owned-character formation, not multiplayer matchmaking.
- Formation hunting is server-side from the first MMO version:
  - 1~4 account-owned characters
  - account-level marketable drop rolls
  - per-character contribution
  - class composition bonus
  - no last-hit loot ownership
  - rare drop clan/world log
- Formation slot unlocks:
  - slot 1: start
  - slot 2: first boss clear
  - slot 3: cube level 4
  - slot 4: rune/mark node or upper mine milestone
- Marketable class assets:
  - class unlock ticket
  - class shard
  - class skin
  - class equipment chest
