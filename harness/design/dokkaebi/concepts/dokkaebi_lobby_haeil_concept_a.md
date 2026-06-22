# Dokkaebi Lobby Haeil Concept A

Status: candidate
Created: 2026-06-22
Target runtime: Godot
Source image: `harness/design/dokkaebi/concepts/dokkaebi_lobby_haeil_concept_a.png`

## Intent

Define the first lobby/home direction for the Haeil-led prototype.

The screen should feel like a usable mobile RPG lobby, not a key art poster: the player can see resources, missions, navigation, and a clear sortie action while Haeil remains the anchor.

## Art Anchor

- Haeil reference: user-provided clipboard image, not committed to the repo.
- Readable identity: deep blue tied headband, small gold talisman plate, long black hair, blue/black robe, red accent, spear silhouette.
- World tone: Joseon-inspired training courtyard, lantern light, talisman workshop, spirit-fire well, night forest edge.

## Composition Rules

- Haeil stands left-of-center, large enough to establish identity but not blocking menu actions.
- The right rail owns events, daily missions, and short timed offers.
- The bottom dock owns repeatable systems: sortie, gear, skill/talisman, companion, shop.
- The main sortie CTA sits bottom-right and uses warm gold/orange, distinct from water-blue Haeil accents.
- The left-bottom mission panel is useful but secondary; it should not compete with sortie.

## UI Direction

- Panels use parchment, ink-brush borders, dark wood, and small gold frames.
- Primary action color: lantern gold/orange.
- Character/action accent: Haeil water blue.
- Magic/resource accent: spirit teal.
- Use icon-first buttons where possible; text labels are runtime-native and should be rewritten.

## Godot Runtime Notes

- Root scene: `Control` with `CanvasLayer` for fixed portrait UI.
- Suggested layout:
  - `TextureRect` full-screen lobby background.
  - `TextureRect` Haeil hero sprite anchored to lower-left/center.
  - `HBoxContainer` top resources with icon+label chips.
  - `VBoxContainer` right event rail.
  - `PanelContainer` mission card at lower-left.
  - `HBoxContainer` bottom navigation dock.
  - `Button` or `TextureButton` sortie CTA at lower-right.
- Keep text as Godot `Label`, not baked into generated images.
- Generate 9-slice skins later for parchment panels, event buttons, dock, and sortie CTA.

## Implementation Notes

- The concept image includes generated Korean-like text. Treat all visible text as placeholder only.
- Final UI should use proper Korean strings, iconography, and localized labels.
- Haeil's final lobby sprite should be a project asset, not extracted from this concept image.
- The background can be split into a reusable courtyard image and native UI overlays.

## Foundation Gaps

The project does not yet have the following `dokkaebi` UI foundation files:

- `ui-system-inventory.yaml`
- `button-system.yaml`
- `modal-system.yaml`
- `color-tokens.yaml`

These should be created before Godot recipe generation so button sizes, panel radii, typography, and icon states do not drift.

## Prompt Summary

Portrait 9:16 mobile RPG lobby UI mockup for a Korean folklore survivor RPG starring Haeil, with a Joseon night training courtyard, parchment UI, resource chips, event rail, bottom nav, and a large sortie CTA.
