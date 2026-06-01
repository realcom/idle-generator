# Hamster Mercenary Map Combat Default Hamster B

## Intent

Second map-combat concept for the hamster mercenary direction. This version uses the project default hamster atlas as the main character identity reference, while keeping the vertical 2D field-combat layout from concept A.

## Reference Inputs

- `engine/client/Client/Assets/PatchResources/Units/Characters/Assets/hamsterAngel.png`
- `engine/client/Client/Assets/PatchResources/Units/Characters/Assets/hamsternpc_public.png`
- `harness/design/idlez/concepts/hamster_mercenary_map_combat_concept_a.png`

## Character Rules

- Base unit must read as the default hamster: cream body and face, soft pink cheeks, tiny ears, dark chocolate outline, and simple chibi proportions.
- Role gear should be an overlay on the same hamster body: sword, shield, spear, bow, staff, cloak, miner or backpack.
- Avoid drifting into yellow bear, cat, or generic mascot faces.
- At runtime scale, face shape and cheek circles are more important than tiny costume detail.

## Composition Rules

- Portrait 9:16 mobile field combat.
- 3/4 top-down orthographic forest map with green tile rhythm and winding dirt path.
- Main hamster swarm stays above center; joystick remains bottom center.
- Enemies, drops, EXP, damage numbers, and hit effects should frame the swarm without burying the unit silhouettes.
- Right-side portal/objective can act as a map progression affordance.

## UI Direction

- Compact top HUD and resource stack are still valid from concept A.
- UI labels in this generated image are placeholders only.
- Native implementation should rebuild text, icons, HP bars, counters, and joystick separately.

## Implementation Notes

- This is the better candidate for downstream sprite/style extraction because the hamsters preserve the current asset identity more closely than concept A.
- Future asset generation should crop or redraw individual role hamsters from this direction, using the default atlas as the stronger constraint.
- Keep map density high enough for exploration, but reserve clear pockets around units for selection, pathing, and damage feedback.

## Source Image

Generated with built-in `image_gen` using the project hamster atlas files as visual references.

![Hamster mercenary map combat default hamster B](hamster_mercenary_map_combat_default_hamster_b.png)
