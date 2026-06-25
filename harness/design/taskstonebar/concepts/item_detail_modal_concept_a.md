# Item Detail Modal Concept A

## Intent

Create a dedicated desktop-window item detail modal for stones and equipment. The modal should feel like a small RPG program window opened from the center inventory grid, not a tooltip or full-screen popup.

## Art Anchor

- Parent direction: `main_ui_concept_e_refined_current_mockup_b`
- Modal/window foundation: `taskstonebar_window_modal_system`
- Runtime anchor: existing Godot `ModalHost` over the three-window workshop and persistent bottom combat strip.

## Composition Rules

- The bottom combat strip remains visible behind the modal.
- The shell uses the shared black-iron `window_frame_9slice`, burgundy `window_title_bar_9slice`, dark body well, close icon, and fixed title ornament.
- Header, body, and footer stay separate native regions.
- Left side owns a large selected item slot preview.
- Right side owns item identity: native item name, category/grade/level line, and a short safe-use hint.
- Lower body owns a stat/detail list plus compact state chips for ownership and irreversible actions.
- Footer actions stay native buttons and change by item type.

## UI Direction

- Title: `아이템 상세 정보` as native text.
- Body sections:
  - `ItemDetailIdentityPanel`
  - `ItemDetailStatList`
  - `ItemDetailWarningChipRow`
  - `ItemDetailActionFooter`
- Equipment example actions: close, equip, upgrade preview.
- Stone example actions: close, equip, drag merge.

## Implementation Notes

- Do not bake item names, counts, warning copy, stats, or button labels into image assets.
- Use `NinePatchRect` or `StyleBoxTexture` for frame, title, body, slots, and footer button skins.
- The large item icon remains a slot-native composition: slot frame skin plus runtime icon/badge/count.
- Text clamp is single-line for title/subtitle and up to five rows for the stat list.

## Target Runtime Notes

- Godot owner: `harness/runtime/godot-taskstonebar/scripts/main.gd`
- Runtime modal name: `Modal_InventoryItemDetail`
- Capture scripts:
  - `res://scripts/tools/capture_item_detail_modals.gd`
- QA compare target:
  - `harness/design/taskstonebar/qa/item-detail-modal-compare-iteration-*.png`

## Source Image

![Item detail modal concept A](item_detail_modal_concept_a.png)
