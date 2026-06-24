# Dokkaebi Outgame Home Iteration Log v4

Date: 2026-06-23
Target: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-outgame-home.png`
Concept: `harness/design/dokkaebi/concepts/dokkaebi_outgame_home_tangtang_concept_a.png`

## Iterations

1. Baseline review: v2 UI cards improved, but primitive courtyard and old hero kept the whole screen below concept quality. Verdict: ERROR for hero_stage.
2. Generated original outgame courtyard background with built-in imagegen. No UI, no character, no concept crop. Verdict: PASS source.
3. Generated original Haeil lobby hero with built-in imagegen on chroma-key background. Verdict: PASS source.
4. Added `postprocess_dokkaebi_outgame_scene_imagegen_v2.py` to preserve source, remove chroma-key, and fit runtime sizes. Verdict: PASS provenance.
5. Integrated `outgame_courtyard_bg_v2.png` into Godot `_draw_home_background`. Verdict: PASS visual jump.
6. Integrated `haeil_lobby_v2.png` into `Section_HeroStage`, hiding the old generated sprite. Verdict: PASS identity.
7. Ran Godot import/check/smoke/capture after scene-level assets. Verdict: PASS runtime.
8. Added label outline handling for native Godot labels. Verdict: PASS readability.
9. Raised label-back ColorRect z-order so dark label bands sit above card artwork and below text. Verdict: PASS layering.
10. Replaced right quickbar progress bars with diamond pip rows to better match the concept language. Verdict: PASS section style.
11. Added bottom nav selected tab v2 asset and removed the old selected button stylebox from the active selected tab. Verdict: PASS asset consistency.
12. Added profile medallion icon fill so the top-left chip no longer reads as an empty placeholder. Verdict: PASS topbar polish.
13. Moved bottom tab labels above the lower trim and raised label z-index. Verdict: PASS label readability.
14. Added `dokkaebi.outgame.background.courtyard_v2` and `dokkaebi.outgame.hero.haeil_lobby_sprite_v2` to asset-plan. Verdict: PASS harness traceability.
15. Added scene-level v2 assets to component-blueprints and Godot recipe required keys. Verdict: PASS contract.
16. Ran `design_blueprint_validate.py dokkaebi`. Verdict: PASS.
17. Ran `godot_ui_recipe_validate.py --strict`. Verdict: PASS.
18. Ran `phaser_nineslice_audit.py dokkaebi`. Verdict: PASS.
19. Final micro-adjust: shifted Haeil slightly left and lifted bottom tab labels 2px. Verdict: PASS full-screen balance.
20. Final check: Godot check-only, home smoke, non-headless capture, concept-crop artifact search. Verdict: PASS with residual WARN only for future fine art polish.

## Final QA Artifacts

- Full compare: `harness/design/dokkaebi/compare/dokkaebi_outgame_full_compare_v4.png`
- Section compare: `harness/design/dokkaebi/compare/dokkaebi_outgame_sections_compare_v4.png`
- Asset sheet: `harness/design/dokkaebi/compare/dokkaebi_outgame_imagegen_v2_asset_sheet.png`
- Runtime capture: `harness/runtime/godot-dokkaebi/screenshots/dokkaebi-outgame-home.png`

## Residual Notes

- UI text, values, labels, pips, and notification dots remain Godot-native.
- No `concept_v2` crop assets or concept preload references remain.
- The current screen is visually close enough for a high-quality pilot pass; next polish should target animation, hover/pressed states, and optional section-specific ornament atoms.
