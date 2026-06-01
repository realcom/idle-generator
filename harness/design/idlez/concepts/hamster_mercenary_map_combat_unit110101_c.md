# Hamster Mercenary Map Combat Unit 110101 C

## Intent

Third map-combat concept for the hamster mercenary direction. This version uses `unit_110101.png` from the example patchresources as the primary visual reference, so the squad reads as repeated variants of the real in-game hamster unit rather than a generic hamster family.

## Primary Reference

- `harness/examples/patchresources/UIAssets/Images/unit_110101.png`

## Character Rules

- Base unit must preserve the `unit_110101` identity: orange-gold hamster face, cream muzzle and belly, tiny ears, pink cheeks, green leafy hood or cape with spiral pattern, short sword, and thick dark outline.
- Squad roles can vary through small gear overlays, but the base face, hood silhouette, and color blocking should stay consistent.
- Avoid drifting toward white hamsters, bears, cats, or new mascot designs.
- Runtime sprites should prioritize the green hood silhouette and orange face because those remain readable even at small mobile scale.

## Composition Rules

- Portrait 9:16 mobile map combat.
- 3/4 top-down orthographic forest map with tiled grass, winding dirt path, logs, stumps, bushes, mushrooms, flowers, and a right-side portal objective.
- Main swarm is above center and fights around the path.
- Bottom center joystick remains visible but lightweight.
- Enemies, drops, HP bars, damage numbers, and EXP labels should support readability without covering the hamster silhouettes.

## UI Direction

- Compact top HUD with level, combat power, gold, gems, and menu.
- Left-side resource stack for map drops/materials.
- Small mission card near top center.
- Right-side round utility buttons for settings, bag, speed, and auto.
- Generated text is placeholder only and should be rebuilt with native UI.

## Implementation Notes

- This is the strongest candidate so far for the playable-unit visual target because it uses the actual example patchresources unit image.
- For production, generate or hand-author role sprites as `unit_110101` equipment variants rather than replacing the base character.
- Future concept passes should explore map scale and path readability while keeping this hamster identity locked.

## Source Image

Generated with built-in `image_gen` using `unit_110101.png` as the primary reference.

![Hamster mercenary map combat unit 110101 C](hamster_mercenary_map_combat_unit110101_c.png)
