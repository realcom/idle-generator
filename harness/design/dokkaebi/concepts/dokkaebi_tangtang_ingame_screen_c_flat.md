# Dokkaebi TangTang Ingame Screen C Flat

Status: candidate
Created: 2026-06-23
Target runtime: Godot
Source image: `harness/design/dokkaebi/concepts/dokkaebi_tangtang_ingame_screen_c_flat.png`
Generator source: `/Users/yangjinhwan/.codex/generated_images/019eef95-0696-7252-a94e-02dc2be0d525/ig_0756091a459d21a9016a395db4214481919849cb52eecb2200.png`

## Intent

Correct the B concept's main visual problem: the battle characters were too large and too illustrated.

This C concept keeps the same TangTang-style HUD layout but pushes the playfield toward flat, small, top-down 2D runtime sprites. This is closer to the intended Godot prototype direction.

## Art Anchor

- Haeil reference: user-provided clipboard image, not committed to the repo.
- Runtime reference: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-ingame-tangtang-haeil-core.png`.
- Revision target: `dokkaebi_tangtang_ingame_screen_b` for HUD structure only, not for character scale.
- Character style target: flat SD 2D tokens; at most a lightly flattened 3D-to-2D look.

## Composition Rules

- Preserve the portrait 9:16 survivor combat layout.
- Haeil must stay small in the center, roughly 7-9% of screen height including spear and readable body.
- Common enemies should stay smaller, roughly 4-6% of screen height.
- Elite enemies can be modestly larger, but should not dominate the playfield.
- Skill VFX should be a clean readable flat arc, not a cinematic wave illustration.
- The playfield should feel like a live game board with many movable tokens, not a painted battle poster.
- Top HUD, wave track, joystick, action buttons, and EXP bar remain stable.

## UI Direction

- HUD can remain dark lacquer/gold with water-blue accents.
- Gameplay sprites should be simpler and flatter than the HUD art.
- Text remains runtime-native placeholder UI.
- Circular skill buttons may be polished, but their icons should not imply that the playfield characters are high-detail illustrations.

## Implementation Notes

- Treat C as the preferred unit-scale and playfield-style reference over B.
- Keep B useful for HUD frame language, but reject its large illustrated Haeil/enemy scale.
- Future sprite generation should produce small readable Haeil/enemy sheets, not scene illustration crops.
- Godot runtime should keep the current top-down draw/sprite scale discipline: Haeil readable but not heroic-large.
- When generating unit assets, ask for "flat 2D top-down mobile survivor sprites" and specify target display sizes.

## Target Runtime Notes

- Target project: `harness/runtime/godot-dokkaebi`.
- Current runnable screen: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-ingame-tangtang-haeil-core.png`.
- C should inform the next visual pass before producing final unit sprites or comparing runtime captures.

## Foundation Notes

Existing foundation files now exist under `harness/design/dokkaebi/`. The key new rule from this concept is unit-scale/style, not a new button or modal policy.

## Prompt Summary

Portrait 9:16 mobile survivor combat HUD for Haeil, correcting the prior concept by making all playfield characters much smaller, flatter, and more 2D, with a top-down game-runtime feel rather than a painted action illustration.
