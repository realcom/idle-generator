# Combat Map Progress Badge Concept A/B

## Intent

Rework the rough bottom-right map progress widget into a deliberate `TaskbarCombatStrip` subcomponent before touching runtime code again. The badge should make current map progression glanceable without becoming a second toast, an AUTO panel, or a copied reference ornament.

## Art Anchor

- Parent direction: `main_ui_concept_e_refined_current_mockup_b`
- Runtime surface: bottom `TaskbarCombatStrip`
- Reference role: growstone2-style compact battle HUD crop, used only for information hierarchy: current area marker, route silhouette, next-node marker, wave progress bar, and pointer.
- Project identity: black iron frame, carved brown stone, antique gold bevels, moss/stone accents, blue portal energy, purple wave progress.

## Composition Rules

- The widget stays in the bottom-right combat strip, below or near `RareDropToast`, but it must never read as a duplicate item-acquisition toast.
- Target runtime footprint is compact: approximately `200x84` logical pixels before combat-window scale, with no tall blank black panel.
- Left third: blue portal/orb or map-token sprite that signals current area. It must be small enough to avoid covering enemies.
- Middle third: carved stone route silhouette or stacked rocks, not empty black geometry.
- Right third: gold-framed next node / boss marker tile. This tile can hold a runtime icon, but not baked text or numbers.
- Bottom row: purple progress fill, small triangular pointer, and tick marks. The pointer follows `wave_state` or `map_progress`.
- Layering must stay readable at compact taskbar scale: frame -> route silhouette -> portal glow -> progress track -> pointer.

## UI Direction

- Variant A is closer to the original reference hierarchy and is useful for understanding the minimum element set.
- Variant B is the stronger candidate for Taskstonebar because it separates the blue map anchor, route silhouette, marker tile, and progress bar more clearly.
- Implementation should use Variant B's clarity, then compress the vertical size and reduce empty frame mass.
- Candidate crop for downstream work: `combat_map_progress_badge_concept_b_candidate.png`

## Implementation Notes

- Do not bake map name, stage number, wave number, item text, or Korean labels into the visual asset.
- Prefer native Godot `Control` composition for the progress bar, pointer, and tick states.
- Treat the blue portal/orb, route silhouette, and next-node tile as either small generated textures or deterministic `TextureRect` atoms, not generic `PanelContainer` blobs.
- If implemented as a new component blueprint, suggested name: `CombatMapProgressBadge`.
- Data bindings should be small: `current_map`, `current_stage`, `wave_state`, `map_progress`.
- This badge should replace the rough temporary `RuntimeCombatMapProgress` look, not expand the combat strip height.

## Target Runtime Notes

- Godot owner: `harness/runtime/godot-taskstonebar/scripts/main.gd`
- Current temporary node: `RuntimeCombatMapProgress`
- Existing related components:
  - `TaskbarCombatStrip`
  - `StageBadge`
  - `RareDropToast`
  - `EnemyStack`
- Runtime QA should capture:
  - compact combat smoke at `960x236`
  - focused crop of the badge against the growstone2 reference crop
  - state with item toast active and no duplicate acquisition banner

## Foundation Gaps / Questions

- `CombatMapProgressBadge` is not yet registered in `component-blueprints.yaml`.
- `asset-plan.yaml` does not yet define route silhouette or portal orb texture keys for this badge.
- The exact mapping of pointer progress is still a runtime decision: current wave ratio, stage route ratio, or blended map progress.

## Prompt Summary

Generated with built-in `image_gen` in `ui-mockup` mode. The prompt asked for two polished pixel-art variants of a compact bottom-right combat map progress mini HUD, preserving only the reference crop's information hierarchy while avoiding direct copying, duplicate item toast language, AUTO controls, and baked text.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019f018d-9054-7551-b3ab-4754df0ad503/ig_09bc1b4dd8141435016a41484ecb248191a9853a3ac24ecdc2.png`
- Workspace copy: `harness/design/taskstonebar/concepts/combat_map_progress_badge_concept_a_b.png`
- Candidate crop: `harness/design/taskstonebar/concepts/combat_map_progress_badge_concept_b_candidate.png`

![Combat map progress badge concept A/B](combat_map_progress_badge_concept_a_b.png)

![Combat map progress badge concept B candidate](combat_map_progress_badge_concept_b_candidate.png)
