# Window Title Bar Concept C - Forged Rail

## Intent

`Status`, `돌지기`, `포탈`, `SkillTree` 등 모든 desktop-manager window가 공유할 단일 title bar chrome 시안이다. 기존 런타임에서 창마다 다른 상단바를 쓰거나 hatch/rivet/help 장식이 겹쳐 깨지는 문제를 막고, `WindowTitleBarChrome` 공용 컴포넌트의 시각 기준을 고정한다.

## Art Anchor

- Parent direction: `main_ui_concept_e_refined_current_mockup_b`
- Window system reference: `taskstonebar_window_modal_system`
- Runtime component: `harness/runtime/godot-taskstonebar/scripts/ui/window_title_bar_chrome.gd`
- Palette: black iron, deep burgundy title plate, antique gold bevel/rail, carved stone edge, sparse moss and ruby accent pixels.

## Composition Rules

- Only the title bar is in scope; body panels and full windows are not part of this concept.
- Use Variant C as the selected runtime direction: black-iron cap, burgundy plate, gold lower rail, small center crest notch, ruby focus bead, and tiny moss accents.
- Title text remains a native centered `Label`; generated image text is placeholder only.
- The close button is a native square icon button on the far right.
- Optional minimize/collapse button sits directly left of the close button and must not reuse the close icon.
- Avoid the previous large diagonal hatch, oversized rivets, and crowded help button.

## UI Direction

The title bar should read as a compact forged UI rail rather than a decorative banner. It needs enough personality to support the stone-workshop fantasy, but must stay quiet because the windows are small and often overlap.

## Implementation Notes

- Implement as native Godot `Control` composition, not a single baked title-bar bitmap.
- Preserve stable layout constants: 42px title height, 10px inset, 42px close/minimize hit areas, 82px title label side inset.
- Runtime atoms:
  - `ProgramTitleBar`
  - `Rect_ProgramTitleBarBurgundyFill`
  - `Line_TitleBarPlateTopHighlight`
  - `Line_TitleBarPlateBottomShadow`
  - `Line_ProgramTitleBarBottom`
  - `Panel_TitleBarIronCap`
  - `Line_TitleBarIronCapTopHighlight`
  - `Line_TitleBarIronCapBottomShadow`
  - `Panel_TitleBarLeftIronEndcap`
  - `Panel_TitleBarRightIronEndcap`
  - `Panel_TitleBarLeftStoneBadge`
  - `Panel_TitleBarLeftStoneBadgeInner`
  - `Panel_TitleBarLeftStoneChip`
  - `Line_TitleBarLeftStoneChipHighlight`
  - `Panel_TitleBarCenterCrest`
  - `Panel_TitleBarCenterCrestInner`
  - `Line_TitleBarLeftGoldTick`
  - `Line_TitleBarRightGoldTick`
  - `Line_TitleBarGoldRailHighlight`
  - `Line_TitleBarGoldRailShadow`
  - `Panel_TitleBarRubyBeadGlow`
  - `Panel_TitleBarRubyBead`
  - `Panel_TitleBarMossAccent`
  - `Panel_TitleBarMossAccent2`
  - `Line_TitleBarButtonTopHighlight`
  - `Line_TitleBarButtonInnerShadow`
  - `Line_TitleBarMinimizeGlyph`
- Keep text, state labels, title names, and button glyphs runtime-native.

## Target Runtime Notes

- Godot owner: `harness/runtime/godot-taskstonebar/scripts/ui/window_title_bar_chrome.gd`
- Smoke: `res://scripts/tools/window_title_bar_chrome_smoke.gd`
- Apply to generated windows and runtime windows through the same `WindowTitleBarChrome.apply(...)` API.

## Foundation Gaps / Questions

- No blocking gap. Future focus/alert states can make the ruby bead brighter or add a one-pixel gold glow, but the current concept only applies the normal/focused workshop window appearance.

## Prompt Summary

Generated with built-in `image_gen` in `ui-mockup` mode as a title-bar-only concept board. The prompt requested three compact pixel-art title bar variants for Taskstonebar/Grow Stone 2, with black iron frame material, burgundy title plate, antique gold bevels, carved stone edges, moss/ruby accent pixels, native text slots, close/minimize controls, and no full app screenshot.

## Source

- Generated image source: `/Users/yangjinhwan/.codex/generated_images/019efff3-1c56-71d1-a420-0c460d11c6bb/ig_03f68e8a5296e51e016a41a364a890819194b96d1770c60455.png`
- Workspace copy: `harness/design/taskstonebar/concepts/window_title_bar_concept_c_forged_rail.png`

![Window title bar concept C forged rail](window_title_bar_concept_c_forged_rail.png)
