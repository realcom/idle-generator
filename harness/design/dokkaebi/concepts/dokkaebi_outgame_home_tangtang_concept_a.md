# Dokkaebi Outgame Home TangTang Concept A

Status: selected
Created: 2026-06-23
Target runtime: Godot
Source image: `harness/design/dokkaebi/concepts/dokkaebi_outgame_home_tangtang_concept_a.png`
Generator source: `/Users/yangjinhwan/.codex/generated_images/019ef0b9-4c8c-7af0-9000-9c2b2536099b/ig_0200bd666f4d9487016a3988438e488191b4b02377c3956c27.png`

## Intent

Define the first implementation target for the Dokkaebi mobile outgame home.

The screen should behave like a fast survivor-action lobby: the player can read resources, claim rewards, inspect events, and start a sortie without leaving the first viewport. It uses TangTang-style lobby ergonomics as a structural reference only, while keeping Dokkaebi World's folklore art, Haeil identity, and native Godot UI implementation.

## Art Anchor

- Haeil identity: long black hair, deep blue headband, small gold talisman plate, blue-black robe, red glove accent, and water-blue spear energy.
- World setting: Joseon autumn village courtyard at dusk with lanterns, dark wood gates, talisman papers, spirit-fire well, and muted red leaves.
- UI material: warmer parchment and dark wood for outgame panels; thin talisman-gold trim; water-blue accents for Haeil/progression.

## Composition Rules

- Preserve portrait 9:16 mobile layout at 540x960 reference.
- Top safe area owns profile, stamina/resource chips, currency chips, and mailbox/notification.
- Haeil stands slightly left-of-center and remains the identity anchor, but does not block event cards or the sortie CTA.
- Right event rail owns repeatable campaign cards: daily mission, equipment/relic, boss/raid, locked future feature, and reward chest.
- Lower middle owns two compact cards: reward chest/progression and training/loadout status.
- Lower-right/center owns the largest warm lantern-gold sortie CTA.
- Bottom dock owns five icon-first tabs: home, yokai/collection, weapon/loadout, talisman/mission, shop.
- Text in the concept is placeholder only. Runtime labels, numbers, prices, timers, and localized Korean strings stay Godot-native.

## UI Direction

- Outgame surfaces use warmer parchment than combat HUD, but retain dark lacquer/ink frames so the game still feels connected to the in-game HUD.
- Primary CTA uses lantern gold/orange and should be the strongest touch target on the screen.
- Water-blue and spirit-teal accents are used sparingly for Haeil energy, resource icons, progress fills, and selected tab.
- Event cards use fixed icon art or native symbols plus runtime labels; no text is baked into generated card images.
- Bottom dock uses stable rectangular tab cells, 8px or smaller corner language, and icon-first hierarchy.

## Godot Runtime Notes

- Target project: `harness/runtime/godot-dokkaebi`.
- Add a home mode before active battle. `main.gd` should show the generated home Control scene on startup and enter the existing survival run when the sortie action is triggered.
- Suggested scene split:
  - `GeneratedDokkaebiOutgameHome`: native Control overlay built from recipe.
  - `OutgameHomePrimitives`: lightweight runtime draw layer for courtyard background, Haeil hero, and decorative glow until final sprite/background assets are generated.
  - Existing `tangtang_battle_hud.tscn` remains battle-only and is hidden on the home screen.
- Use the existing generated battle panel texture as a temporary dark frame where appropriate, but add outgame-specific asset keys so the future skin pass can replace them cleanly.

## Implementation Notes

- Do not implement the concept as a full-screen PNG.
- The first Godot pass may use native ColorRect, Label, Button, ProgressBar, and draw primitives for home background/hero art.
- Generated bitmap usage should be limited to reusable skins/icons after the layout is validated: parchment panels, sortie CTA skin, event card frames, resource icons, bottom dock tab icons, and Haeil lobby portrait/sprite.
- The concept shows dramatic illustration detail; runtime should compress this into readable mobile layers and keep UI text native.

## Foundation Notes

Existing `dokkaebi` foundations cover battle first. This outgame surface adds:

- home/lobby semantic sections to `component-blueprints.yaml`
- outgame button roles for sortie CTA, dock tabs, event cards, and resource chips
- warmer parchment/lobby color token mapping
- outgame asset keys in `asset-plan.yaml`

## Prompt Summary

Portrait 9:16 mobile outgame home UI concept for Dokkaebi World, inspired by survivor-action lobby ergonomics: Haeil in an autumn Joseon courtyard, top resources, right event rail, lower reward/training cards, large sortie CTA, and icon-first bottom navigation, with all production text left native for Godot.
