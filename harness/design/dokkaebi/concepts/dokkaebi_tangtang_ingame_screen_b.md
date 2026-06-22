# Dokkaebi TangTang Ingame Screen B

Status: candidate
Created: 2026-06-23
Target runtime: Godot
Source image: `harness/design/dokkaebi/concepts/dokkaebi_tangtang_ingame_screen_b.png`
Generator source: `/Users/yangjinhwan/.codex/generated_images/019eef95-0696-7252-a94e-02dc2be0d525/ig_0d4a0925afc97ea5016a3957c7d00881919475d8a28cbeb4f7.png`

## Intent

Lock the visual direction for the first TangTang-style Haeil in-game HUD after the Godot prototype adopted the `ninja2` survivor battle screen structure.

This concept should be treated as a visual target for the already-runnable `godot-dokkaebi` battle layout, not as a new layout proposal.

## Art Anchor

- Haeil reference: user-provided clipboard image, not committed to the repo.
- Runtime reference: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-ingame-tangtang-haeil-core.png`.
- Previous mood reference: `dokkaebi_ingame_haeil_concept_a`, but with less key-art looseness and more implementation discipline.
- Identity anchors: blue headband with gold talisman plate, long black hair, blue/black robe, red glove accent, spear silhouette, water-blue slash VFX.

## Composition Rules

- Preserve the portrait 9:16 survivor combat layout.
- Top HUD stays split into hero panel, timer/stage panel, run ledger, and pause button.
- A thin wave/progress strip sits below the top HUD and must not become a bulky banner.
- Haeil remains centered in the playfield with an open readability circle.
- Enemy density surrounds Haeil, but common enemies stay smaller and less saturated than Haeil.
- Bottom-left joystick and bottom-right three-button cluster remain fixed touch controls.
- Bottom EXP bar stays full-width and safe-area aware.
- No level-up card modal is shown in this concept; this is the active-combat state.

## UI Direction

- Use dark lacquer/ink panels with thin gold trim for combat HUD.
- Use water-blue for Haeil skills, slash effects, EXP highlights, and pickup readability.
- Use teal spirit-fire for collectible pickups and magic feedback.
- Use warm lantern gold/orange only for counters, progress pips, and warning accents.
- Keep text as runtime-native labels; any generated text or numerals in the concept are placeholders.
- Skill buttons should use circular icon wells with cooldown rings, not rectangular text buttons.

## Implementation Notes

- Do not implement this as one full-screen PNG. Split it into runtime layers:
  - `BattleWorld`: ground, props, enemies, pickups, Haeil, skill VFX.
  - `TopHud`: Haeil panel, timer/stage, run ledger, pause.
  - `WaveTrack`: thin progress strip and stage pips.
  - `TouchControls`: joystick and three circular action buttons.
  - `RunExpBar`: bottom EXP progress with level badge.
- Haeil, enemies, pickups, VFX, cooldown numbers, HP, EXP, timers, and counters must remain live runtime objects.
- Generated bitmap work should be limited to reusable skins/icons later: panel frames, circular button rims, pickup icons, and skill icons.
- The concept includes more detailed enemy art than the current prototype; final sprite production should preserve the small-mobile silhouette first.
- The current Godot prototype should continue to use simple draw/runtime shapes until the button/modal/color systems are defined.

## Target Runtime Notes

- Target project: `harness/runtime/godot-dokkaebi`.
- Current runnable screen: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-ingame-tangtang-haeil-core.png`.
- Next recipe candidate: a Godot UI recipe for `DokkaebiTangTangBattleHud` after `button-system.yaml`, `modal-system.yaml`, and `color-tokens.yaml` exist.
- The screen should remain compatible with the prototype's current 540x960 viewport.

## Foundation Gaps

The project still needs shared UI foundation files before recipe generation:

- `ui-system-inventory.yaml`
- `button-system.yaml`
- `modal-system.yaml`
- `color-tokens.yaml`

Focused follow-up question for those files: should `dokkaebi` combat UI use the darker lacquer/gold frame language from this B concept as the default battle skin, while lobby and modal surfaces use warmer parchment?

## Prompt Summary

Portrait 9:16 mobile survivor combat HUD mockup for Haeil in a Korean folklore night arena, preserving the current Godot prototype layout: top hero/timer/ledger HUD, thin wave track, centered Haeil with water spear slash, many small 요귀, bottom-left joystick, bottom-right three circular action buttons, and bottom EXP bar.
