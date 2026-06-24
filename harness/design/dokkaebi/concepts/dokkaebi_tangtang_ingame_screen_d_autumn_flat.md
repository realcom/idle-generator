# Dokkaebi TangTang Ingame Screen D Autumn Flat

Status: selected
Created: 2026-06-23
Target runtime: Godot
Source image: `harness/design/dokkaebi/concepts/dokkaebi_tangtang_ingame_screen_d_autumn_flat.png`
Generator source: `/Users/yangjinhwan/.codex/generated_images/019eef95-0696-7252-a94e-02dc2be0d525/ig_016ab6a4833498a6016a3960928c448191893422a8a5d9bfe6.png`

## Intent

Select the third flat 2D variation as the working in-game visual target.

This direction keeps the small flat survivor-game unit scale from C, while adding a stronger Dokkaebi-world map identity through the dry autumn village yard, fallen leaves, dirt/stone path, carts, barrels, talisman papers, and muted red foliage.

## Art Anchor

- Haeil reference: user-provided clipboard image, not committed to the repo.
- Runtime reference: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-ingame-tangtang-haeil-core.png`.
- Unit scale reference: `dokkaebi_tangtang_ingame_screen_c_flat`.
- Selected map tone: dry autumn abandoned village / Joseon yard.

## Composition Rules

- Preserve portrait 9:16 survivor combat layout.
- Haeil stays small and centered, roughly 7-9% of screen height including spear readability.
- Common enemies stay roughly 4-6% of screen height.
- Elite enemy can be larger but must remain a token, not a boss illustration.
- Center combat lane stays open; carts, fences, barrels, foliage, and roof hints stay near edges.
- Water slash VFX remains a flat readable arc, not a cinematic wave.
- Top HUD, wave track, joystick, three action buttons, and EXP bar stay stable.

## UI Direction

- Keep dark lacquer/gold HUD language.
- The autumn ground palette can be warmer than C, but skill accents remain water-blue/teal.
- Fallen leaves and talisman papers are world props, not UI decoration.
- Generated text is placeholder; runtime implementation uses native labels.

## Implementation Notes

- Treat D as the current visual target for map tone and active combat presentation.
- Use C as supporting evidence for unit scale if D drifts too detailed during production.
- Future unit sprites should stay flat and compact, even if the environment gets more polished.
- The first playable Godot pass can keep simple runtime sprites while moving the ground palette and prop placement toward this autumn village tone.

## Target Runtime Notes

- Target project: `harness/runtime/godot-dokkaebi`.
- Current runnable screen: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-ingame-tangtang-haeil-core.png`.
- Next runtime edit target: retune `godot-dokkaebi` world colors/props/enemy palette toward autumn village while keeping current movement and combat loop.

## Prompt Summary

Portrait 9:16 mobile survivor combat HUD for Haeil in a flat 2D top-down autumn abandoned village, with small runtime-scale units, open center combat readability, dark lacquer HUD, water-blue spear slash, folklore enemies, bottom joystick/action controls, and bottom EXP bar.
