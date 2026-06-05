# 4X Housing Display Study

Date: 2026-06-02

## Goal

기존 모바일 4X/전략 게임의 도시, 기지, 영지, 정착지 화면이 어떤 방식으로 표시되는지 조사하고, `ninja2`의 하우징 화면에 적용할 표시 문법을 정리한다.

`ninja2` 현재 방향:

- SurvivalBattle: ultra-flat 2D top-down arcade survivors-like field.
- HousingHome: 2D Spine-style 주민/수호자 + 3D풍 건물/헥스 보드 하이브리드.

## Sources

- Rise of Kingdoms: Lost Crusade, Google Play: https://play.google.com/store/apps/details?hl=en_US&id=com.lilithgame.roc.gp
- Lords Mobile: Kingdom Wars, Google Play: https://play.google.com/store/apps/details?hl=en_US&id=com.igg.android.lordsmobile
- Whiteout Survival, Google Play: https://play.google.com/store/apps/details?hl=en_US&id=com.gof.global
- State of Survival: Zombie War, Google Play: https://play.google.com/store/apps/details?hl=en_US&id=com.kingsgroup.sos
- Kingshot, App Store: https://apps.apple.com/us/app/kingshot/id6739554056
- Kingshot, Google Play: https://play.google.com/store/apps/details?id=com.run.tower.defense
- Top War: Battle Game, Google Play: https://play.google.com/store/apps/details?hl=en_US&id=com.topwar.gp
- Evony: The King's Return, Google Play: https://play.google.com/store/apps/details?hl=en_US&id=com.topgamesinc.evony
- Age of Origins, Google Play: https://play.google.com/store/apps/details?hl=en_US&id=com.camelgames.aoz

## Display Patterns

### 1. Seamless World-City Map

Example: Rise of Kingdoms.

The city is not only a separate home screen. It belongs to the world map hierarchy and can be reached through zoom/navigation. This makes the base feel like part of the 4X territory layer.

Observed display traits:

- World map and individual cities are visually connected.
- City identity is reinforced through civilization-specific architecture.
- Fog/exploration and alliance territory sit near the base fantasy.
- The base is less cozy-home and more strategic map asset.

Use for `ninja2`:

- Not for MVP main housing screen.
- Useful later if Alliance4X expands the sanctuary into territory nodes.
- Keep a future rule: sanctuary hex board can become a world-map node, but first MVP should stay as a separate readable HousingHome.

### 2. Fixed Kingdom/Turf Screen

Examples: Lords Mobile, Evony.

The player gets a dedicated kingdom/city home where major buildings are spatially arranged. The main action is upgrading, training, research, hero management, and resource collection.

Observed display traits:

- Dense 2.5D/isometric-looking city or castle layout.
- Important buildings are always visible, often with level labels, bubbles, and upgrade markers.
- Top resource bar and side buttons are always present.
- Strong "owning a kingdom" fantasy.
- Architecture skins/civilization themes matter.

Use for `ninja2`:

- This supports the hybrid housing direction.
- 3D풍 buildings are valuable because the player repeatedly returns to the home screen.
- Use architecture upgrades as visual rewards: shrine roof, lantern glow, extra props, garden density.

### 3. Central Survival Settlement

Examples: Whiteout Survival, State of Survival.

The base is framed as a survival settlement. A central building or survival engine anchors the screen: furnace, shelter, headquarters, shrine, or command center.

Observed display traits:

- One central building defines the home identity.
- People/residents/workers make the base feel alive.
- Resource/idle loops are visible through bubbles, production timers, and collection states.
- Expansion is often tied to reclaiming land, warmth, safety, population, or defense.

Use for `ninja2`:

- Make `등불 신전` the visual anchor.
- 주민 sprites are important, not decorative. They should signal production, morale, and upgrades.
- The home fantasy should be "safe sanctuary" rather than "war base".
- Growth state can be shown by lantern radius, clean tiles, plants, and resident count.

### 4. Grid/Merge/Base Board

Example: Top War.

The base becomes a board with explicit placement, merging, decoration, and quick upgrade readability.

Observed display traits:

- Buildings and units are treated like movable/mergeable board assets.
- The base is more readable than realistic.
- Decorating the base is part of identity.
- Upgrade feedback is immediate and visual.

Use for `ninja2`:

- Keep explicit hex tile states.
- Show `empty`, `locked`, `fogged`, `expandable`, `built`, and `selected` without relying on text.
- Buildings can be collectible tokens even if rendered in a 3D-ish style.
- Avoid full free-placement complexity in MVP; use fixed hex slots.

### 5. Current Hot Reference: Idle Survival Town

Example: Kingshot.

Kingshot is a current-market example of the survival-town 4X formula. The store positioning calls it an idle medieval survival game, but the visible product promise and user discussion point toward town/base building, resource management, alliance competition, hero recruitment, and kingdom progression.

Observed display traits:

- The base/town is the emotional center, not just a menu background.
- Town Center or central civic building becomes the key upgrade target.
- Survival pressure gives meaning to production, defense, population, and technology.
- Multiple resource counters and upgrade prompts are always close to the main town screen.
- Decorative town skins and march skins are important long-term visual rewards.
- The ad hook can be more action/minigame-like, but the retained core is town building plus 4X systems.

Use for `ninja2`:

- Treat the sanctuary as a "survival town" rather than only a cute decoration board.
- Central `등불 신전` should be functionally equivalent to Town Center/Furnace: unlocks, safety radius, resident cap, and board expansion.
- Make resource/upgrade pressure obvious on the home screen: production bubbles, upgrade arrows, locked/fogged expansion tiles, and dispatch CTA.
- 주민 should communicate labor and survival, not just ambience: carrying wood, maintaining lanterns, tending herbs, repairing fogged tiles.
- Future cosmetics can follow Kingshot-style skin logic: shrine skin, tile border skin, resident costume, sortie march/return effect.
- Avoid copying the medieval governor fantasy; use cozy sanctuary language and lantern/forest motifs.

### 6. Ruin Reclaim / Population Recovery

Example: Age of Origins.

Base progression is framed as reclaiming overrun buildings, rescuing survivors, gathering resources, and restoring a city.

Observed display traits:

- Locked/ruined spaces become buildable over time.
- Population/recruited survivors are tied to city growth.
- Restored areas visually contrast with ruined/fogged areas.

Use for `ninja2`:

- Fogged hexes should look like misty/uncleansed forest.
- Expansion can be "purify/restore tile" rather than "buy land".
- Residents can unlock from clearing fog tiles or upgrading houses.

### 7. Skins, Decorations, and Cultural Architecture

Examples: Rise of Kingdoms, Evony, Top War, State of Survival, Kingshot.

Many 4X games give cities/base screens long-term value through visual customization: civilization architecture, base skins, decorations, frames, and collection halls.

Observed display traits:

- Architecture style communicates player identity.
- Decorations are monetizable and event-friendly.
- Skins often change the whole city or central building silhouette.

Use for `ninja2`:

- MVP can ship with one architecture style: cozy lantern sanctuary.
- Future skins can swap shrine roof, lantern color, resident costumes, and tile borders.
- Avoid changing core tile readability when applying skins.

## What This Means For Ninja2

Recommended direction:

- Keep SurvivalBattle flat and highly readable.
- Let HousingHome be prettier and more dimensional.
- Use a separate HousingHome screen, not a world-map-integrated city for MVP.
- Present housing as a hex-grid sanctuary with a central `등불 신전`.
- Use 3D풍 pre-rendered building sprites for ownership/upgrade appeal.
- Use 2D Spine-style residents and guardian sprites for life and character continuity.
- Keep the UI language shared with battle: thick outlines, resource colors, compact HUD, clear CTA.
- Borrow Kingshot's strategic lesson, not its theme: the home screen must continuously advertise "upgrade town, protect people, expand territory, prepare sortie."

## Housing Screen Must-Haves

- Central anchor building: `등불 신전`.
- Central progression role: `등불 신전` acts as Town Center/Furnace equivalent.
- Hex tile states:
  - built
  - selected
  - empty build pad
  - locked
  - fogged
  - expandable cost tile
- Building feedback:
  - Lv label
  - production bubble
  - upgrade arrow
  - collect state
  - timer/progress bar
- Resident feedback:
  - idle near relevant buildings
  - carrying resources
  - tending herbs
  - guarding shrine
  - returning from sortie
- Navigation:
  - top resources
  - side quest/mail/event rail
  - bottom tabs
  - large sortie button
  - selected building panel

## MVP Recommendation

Use this split:

- Battle assets: flat 2D sprite sheets, repeated enemies, simple VFX.
- Housing buildings: 3D-stylized pre-rendered sprites or AI-assisted sprite atlas.
- Housing characters: 2D Spine or Spine-ready sprite rigs.
- Board implementation: fixed hex coordinates with y-sort for characters and buildings.
- Future 4X layer: sanctuary board can later project into alliance territory/world map, but should not be required for the first survival + housing loop.
