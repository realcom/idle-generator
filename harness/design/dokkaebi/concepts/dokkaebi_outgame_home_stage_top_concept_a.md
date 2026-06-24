# Dokkaebi Outgame Home Stage Top Concept A

Status: candidate
Created: 2026-06-23
Target runtime: Godot
Source image: `harness/design/dokkaebi/concepts/dokkaebi_outgame_home_stage_top_concept_a.png`
Generator source: `/Users/yangjinhwan/.codex/generated_images/019ef0b9-4c8c-7af0-9000-9c2b2536099b/ig_066523b8838bec2e016a39d3cb82cc8191bde3f709297bdfef.png`

## Intent

Explore a revised outgame home composition where the player can immediately read the current campaign/stage from the top area.

The new element is a compact current-stage plaque, not a large banner. It should answer "where am I now?" while preserving the fast TangTang-style lobby flow: resource scan, event rail, progression cards, sortie CTA, and bottom navigation.

## Art Anchor

- Base direction: `dokkaebi_outgame_home_tangtang_concept_a`.
- Haeil remains the left-center identity anchor with blue headband, talisman plate, spear, and water-blue spirit energy.
- The stage indicator uses dark lacquer, parchment, talisman-gold trim, and a small water-blue flame/pip accent.
- The visible example stage is `가을 폐촌 1-1`, matching the current autumn village outgame/battle context.

## Composition Rules

- Keep portrait 9:16 at 540x960 reference.
- Top safe area still owns profile, stamina/resources, currency chips, and mailbox.
- Add the current-stage plaque below or tucked into the top resource row, centered enough to be noticed but not tall enough to hide Haeil or the courtyard horizon.
- The plaque should include:
  - current chapter/stage label,
  - a small next-arrow affordance,
  - 4-5 progress pips or a short chapter progression line.
- Right event rail remains vertically readable.
- Lower cards and sortie CTA continue to own the lower action zone.
- Bottom navigation stays as independent per-tab cells.

## UI Direction

- The stage plaque is an information component, not a CTA.
- Use cream/gold native text on a dark lacquer interior with parchment edge/corner ornaments.
- Water-blue should be a small accent on the stage marker/pip, not a full fill.
- Runtime labels and stage numbers must remain native Godot `Label` text. Do not bake final Korean strings into the bitmap.
- If the top row feels crowded in runtime, resource chips should compress before the stage plaque becomes a banner.

## Implementation Notes

- Add a semantic component such as `HomeCurrentStageBadge` or `HomeStagePlaque` under the outgame top section.
- Suggested runtime bounds at 540x960:
  - `Section_CurrentStage`: x 174, y 82, width 210-230, height 58-66, or
  - merge into `Section_TopResourceBar` as a second-row center plaque if the top bar height is raised.
- The plaque frame can be a generated 9-slice skin, but text, progress pips, arrow, and selected/available state remain native.
- The sortie CTA should repeat the stage in smaller form only if it improves action confidence; avoid duplicating too much text.
- Do not use this concept as a full-screen PNG implementation.

## Target Runtime Notes

- Target project: `harness/runtime/godot-dokkaebi`.
- Likely recipe follow-up: update `harness/godot/recipes/ui/dokkaebi-outgame-home.yaml` to add a `current_stage` section/component.
- Likely runtime follow-up: add `meta.current_stage.label`, `meta.current_stage.progress_ratio` or `meta.current_stage.pips`, and render through native labels/pips.
- Existing `bottom_nav` per-cell shell direction should be preserved.

## Foundation Gaps Or Questions

- No blocking foundation gaps. Button, modal, color, component, and asset-plan files exist.
- Typography remains not formalized as a standalone file; runtime should use the existing compact native label treatment until typography tokens are extracted.
- Follow-up question: should tapping the stage plaque open chapter select, or is chapter select only available through the sortie CTA?

## Prompt Summary

Portrait 9:16 Dokkaebi World outgame home concept with Haeil in an autumn Joseon courtyard, existing top resources/right event rail/lower reward cards/sortie CTA/bottom tabs, plus a compact top-center current-stage plaque reading `가을 폐촌 1-1` with progress pips and a next-arrow affordance.
