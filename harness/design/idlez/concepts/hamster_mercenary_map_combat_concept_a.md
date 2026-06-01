# Hamster Mercenary Map Combat Concept A

## Intent

`우르르 용병단`-like vertical mobile field combat direction for a hamster mercenary game. The screen should read as a playable 2D map first: a small squad moves through a forest field, clusters around monsters, and keeps fighting while the player steers or idles.

## Art Anchor

- Existing hamster identity from `hamsterAngel` and `hamsternpc_public`: round cream/golden faces, tiny ears, soft cheeks, thick dark outline.
- Hamsters are tiny but role-readable through equipment silhouettes: sword, shield, staff, spear, bow, miner helmet, backpack.
- Monsters stay simple and soft, mostly jelly/slime silhouettes, so the hamster squad remains the hero signal.

## Composition Rules

- Portrait 9:16 mobile screenshot.
- Top-down or 3/4 orthographic 2D map, not side-view combat.
- Green tiled forest floor with winding dirt paths, logs, stumps, bushes, rocks, mushrooms, flowers, and sparkles.
- Main battle cluster sits above center so the bottom virtual joystick has breathing room.
- Right side can hold a glowing portal/objective and compact utility buttons.
- Floating damage numbers, EXP labels, HP bars, coins, leaves, and impact puffs must remain small and readable.

## UI Direction

- Compact top HUD: level badge, combat power, gold, gems, and menu.
- Left vertical resource stack for materials gathered on the map.
- Small mission card near the top center, using final game text later in Unity/uGUI.
- Right-side round buttons for settings, bag, speed, and auto.
- Bottom center virtual joystick, translucent and non-dominant.
- No persistent bottom growth dock in this direction.

## Implementation Notes

- Treat this as a gameplay camera and density target for Phaser/runtime prototyping before Unity prefab work.
- Unit sprites need extremely clear silhouettes at small scale; role gear should be readable even if facial detail collapses.
- Map tile pattern should be subtle enough that movement paths and enemy HP bars stay legible.
- UI text in the generated image is placeholder only; rebuild text and icons from native UI atoms.

## Source Image

Generated with built-in `image_gen` from a prompt using the user's attached map-combat screenshot as composition reference only.

![Hamster mercenary map combat concept A](hamster_mercenary_map_combat_concept_a.png)
