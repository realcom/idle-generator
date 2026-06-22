# Dokkaebi Ingame Haeil Concept A

Status: candidate
Created: 2026-06-22
Target runtime: Godot
Source image: `harness/design/dokkaebi/concepts/dokkaebi_ingame_haeil_concept_a.png`

## Intent

Define the first in-game battle HUD direction for the Haeil prototype.

The screen should prioritize survivor readability: Haeil in the center, clear enemy pressure, visible pickups, compact HUD, and a thumb-friendly control layout.

## Art Anchor

- Haeil reference: user-provided clipboard image, not committed to the repo.
- Runtime identity: blue headband, long black hair, spear silhouette, water-blue slash VFX.
- Combat fantasy: Haeil clears night forest 요귀 with sweeping water arcs and spear movement.

## Composition Rules

- Haeil remains at screen center with a readable water-slash radius.
- Enemies surround from all sides, but their bodies must stay smaller/duller than Haeil.
- A larger elite/boss warning is allowed near the top-right, with a red-orange danger ring.
- Top HUD is compact and sticks to the safe area.
- Bottom-left joystick and bottom-right skill buttons follow mobile survivor conventions.
- EXP bar spans the bottom edge and must not be hidden by the navigation indicator.

## UI Direction

- Top-left: Haeil portrait, level, HP bar.
- Top-center: timer/stage badge.
- Top-right: pause/settings and currency chips.
- Bottom-left: translucent joystick.
- Bottom-right: three circular skill buttons with cooldown rings.
- Bottom edge: long EXP bar with level marker.
- Enemy warnings use red-orange; Haeil skills use water-blue; pickups use blue/gold/teal.

## Godot Runtime Notes

- Use one `Node2D` gameplay layer and a separate `CanvasLayer` HUD.
- Suggested scene split:
  - `Node2D/BattleWorld`: map, units, pickups, VFX.
  - `CanvasLayer/HUD`: fixed portrait UI controls.
  - `Control/TopHud`: portrait, HP, timer, pause.
  - `Control/TouchControls`: joystick and skill buttons.
  - `TextureProgressBar` for HP/EXP/cooldowns.
- Skill buttons should be native Godot controls with generated icons, not one baked HUD image.
- VFX should start as runtime particles/line arcs; graduate to bitmap atlases only after readability is proven.

## Implementation Notes

- The concept currently leans toward zombie-like silhouettes in some enemies. Replace final enemies with `잡귀`, `망령`, `도깨비 하수`, and `부적술사` silhouettes from the Dokkaebi enemy families.
- Keep background low-detail. Dense grass, stones, and talisman papers must not hide pickups.
- Haeil's SD battle sprite needs a stronger in-game silhouette than the NPC SD library: bigger headband, stronger spear, clear blue robe shape.
- Visible generated text is placeholder only; final HUD text must be runtime-native.

## Foundation Gaps

The project does not yet have the following `dokkaebi` UI foundation files:

- `ui-system-inventory.yaml`
- `button-system.yaml`
- `modal-system.yaml`
- `color-tokens.yaml`

The in-game HUD especially needs tokenized button sizes, safe-area offsets, cooldown ring style, HP/EXP bar style, and enemy warning treatment before Godot recipe generation.

## Prompt Summary

Portrait 9:16 mobile survivor combat HUD mockup with Haeil centered in a night forest arena, water slash VFX, surrounding 요귀, compact top HUD, bottom joystick, skill buttons, and EXP bar for a Godot runtime target.
