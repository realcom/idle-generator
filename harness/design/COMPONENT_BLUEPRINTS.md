# Component Blueprints

Purpose: make UI extraction implementation-ready before asset generation, Phaser specs, or Unity recipes.

`component-blueprints.yaml` is the semantic UI contract for each game. It sits between selected concept art and downstream runtime work:

```text
selected concept
  -> component-blueprints.yaml
  -> component-skins.yaml + asset-plan.yaml
  -> Phaser spec / Unity recipe
  -> runtime or prefab implementation
```

## Required File

For any game with an extracted UI design system, create:

```text
harness/design/<game>/component-blueprints.yaml
```

The file is required before writing new Phaser UI specs, Unity UI recipes, or generated UI assets for a selected concept.

## Required Top-Level Shape

```yaml
version: "1.0"
game: <game>
status: draft | pilot | extracted | approved
purpose: "Semantic component decomposition layer between selected concepts, generated assets, and runtime layout."

source_concepts:
  primary:
    id: concept_id
    note: concepts/example.md
    image: concepts/example.png

runtime_targets:
  phaser_dom_overlay:
    spec: ../../runtime/specs/ui/example.yaml
    page: ../../runtime/example.html
    owner: ../../runtime/src/example.js

extraction_rules:
  semantic_first: []
  sizing_language: {}

surfaces:
  ExampleSurface:
    intent: ""
    orientation: portrait_9_16
    reference_size_px: { width: 440, height: 782 }
    sections:
      top_bar:
        role: ""
        components: []
        layout_contract: {}
      content_body:
        role: ""
        components: []
        layout_contract: {}
      bottom_bar:
        role: ""
        components: []
        layout_contract: {}
    component_tree: []
    layout_contract: {}

components:
  ExampleComponent:
    role: ""
    mode: native_ui | generate_image | hybrid | reuse
    anatomy: []
    box_model: {}

asset_dependency_matrix: {}
runtime_token_mapping: {}
review_gate:
  pass_conditions: []
  blockers: []
```

## Extraction Rules

Name components by player or runtime meaning before naming skins or files. Good names describe the job: `SkillChoiceCard`, `TopResourceLedger`, `GrowthStatCard`, `FrameOrnamentLayer`. Weak names describe a picture crop: `gold_box`, `left_png`, `pretty_panel`.

Every component should remain explainable if all bitmaps are temporarily removed. That means core layout must be made of slots, data bindings, text rules, touch rules, and state rules, not one full-screen mock image.

## Section Decomposition

Large UI should not go directly from full concept to individual components. Split the surface into semantic sections first, then run the same extraction process inside each section.

Examples:

- home screen: `top_resource_bar`, `board_area`, `selected_building_panel`, `bottom_nav`
- combat HUD: `top_hud`, `combat_playfield`, `objective_strip`, `controls`, `exp_bar`
- modal: `frame`, `header`, `choice_body`, `footer`
- shop: `category_tabs`, `product_grid`, `currency_header`, `purchase_footer`

Each surface must declare `sections`:

```yaml
surfaces:
  HousingHome:
    sections:
      top_resource_bar:
        role: "Shows persistent currencies and profile status."
        process_scope: section
        components:
          - ProfileCard
          - ResourceLedger
        layout_contract:
          anchor: top_safe_area
          height_px: 88
        asset_keys:
          - ninja2.ui.topbar.cluster_skins
      board_area:
        role: "Owns the interactive settlement board."
        process_scope: section
        components:
          - HexBoard
          - BuildingSpriteLayer
        layout_contract:
          anchor: middle
          scroll_policy: pan_clamped
```

Section rules:

- Name sections by gameplay or interaction meaning, not by visual position alone.
- A section owns a coherent workflow, such as navigation, resource reading, choice comparison, board manipulation, or purchase confirmation.
- Each section lists the components it owns.
- Components in `component_tree` should belong to at least one section.
- Cross-section dependencies must be explicit. For example, `bottom_nav` may open a `shop_modal`, but it should not own the shop product grid.
- Section boundaries should preserve integration behavior: safe area, z-order, scroll/pan ownership, pointer capture, and whether it may overlap the playfield.

### Section Mini-Pipeline

For big screens, run this loop per section:

```text
section brief
  -> section anatomy/components
  -> section box model and responsive behavior
  -> section skin/assets/ornaments
  -> section spec or recipe mapping
  -> section visual QA
  -> surface integration QA
```

Do not approve a full surface if one section is still only a pretty crop with no component contract.

### Concept Comparison Iteration

Runtime work must compare each implemented section against the selected concept before broadening the edit scope. The comparison is a production artifact, not an informal screenshot check.

For every visual section pass, keep:

- selected concept image path and crop rectangle
- runtime screenshot path and crop rectangle
- normalized comparison board path
- section verdict: `PASS`, `WARN`, or `ERROR`
- concrete next edit scope, such as `HeroPortraitStatus.box_model`, `TopResourcePill.content_insets`, or `SortieCtaButton.skin`

Use the compare helper so concept and runtime are scaled consistently:

```bash
python3 harness/tools/design_visual_compare.py \
  --concept /tmp/concept_top_band.png \
  --candidate /tmp/runtime_home.png \
  --candidate-crop 30,0,440,100 \
  --out /tmp/top_band_compare.png \
  --label-concept "CONCEPT top_identity_band" \
  --label-candidate "RUNTIME top_identity_band"
```

Iteration rules:

- Compare only the section currently being worked on before judging the whole screen.
- Normalize shell width and crop bounds before giving visual feedback.
- Treat large meaning drift as `ERROR`; do not recursively micro-adjust the wrong component.
- Treat correct meaning but weak proportions, padding, or visual weight as `WARN`; iterate on box model, content insets, and asset anatomy.
- Move to the next section only after the current section has a compare board and an explicit verdict.

## Box Model Contract

Repeated or touchable components must define stable layout contracts:

- `min_height_px`, `min_width_px`, or target size policy
- `content_insets_px`
- `padding_px`
- `gap_px`
- responsive reductions for narrow mobile widths
- text clamp and overflow policy
- state changes that must not resize the component

Do not derive text padding from 9-slice borders. `slice_hints` and `content_insets` are different contracts.

## Skin Contract

Rectangular generated skins need both:

```yaml
skin_contract:
  asset_key: ninja2.ui.panel.parchment_9slice
  usage: phaser_nineslice_or_dom_preview
  slice_hints_px: { left: 28, right: 28, top: 28, bottom: 28 }
  content_insets_px: { left: 14, right: 14, top: 34, bottom: 16 }
```

- `slice_hints_px` protects bitmap corners and edge caps while stretching.
- `content_insets_px` tells runtime where text, icons, chips, and hit targets may live.

Text, numbers, localized labels, prices, timers, pips, badges, and cooldowns should stay native runtime objects unless a concept explicitly marks them as decorative-only.

## Icon Asset Contract

Final player-facing UI icons are generated bitmap assets, not procedural placeholders. For `ui_icon_set`, tab icons, side-rail icons, resource icons, status glyphs, and button glyph atoms:

- Use built-in `imagegen`/`image_gen` for the source artwork unless the component explicitly reuses an already approved native/vector icon system.
- Use local scripts only for deterministic post-processing: chroma-key removal, alpha cleanup, grid crop, resize, packing, naming, and audit metadata.
- Record the imagegen source in `asset-plan.yaml` with `generated_with`, `source_path`, and, when transparency is produced locally, `alpha_source_path`.
- Do not approve CSS, emoji, Pillow-drawn, or Phaser Graphics placeholder icons as final UI icon assets without an explicit blueprint exception explaining why the icon is a runtime primitive rather than generated art.

## Ornament Layer

Concepts often show crests, vines, corner leaves, badges, clasps, knots, or gems attached to a frame. Do not force these into a stretchable 9-slice skin unless they are truly stretch-safe.

Use a separate component:

```yaml
FrameOrnamentLayer:
  role: "Carries fixed border decorations without baking them into the stretchable panel skin."
  mode: hybrid
  anatomy:
    - CrestOrnament
    - PanelCornerOrnament[top_left]
    - PanelCornerOrnament[top_right]
  asset_contract:
    asset_key: ninja2.ui.level_choice.frame_ornaments_v1
    usage: fixed_sprite_set
    background: transparent
    not_nine_slice: true
```

The ornament layer sits above the panel skin and below readable content. It must not affect grid sizing, card sizing, text padding, or touch targets.

## Asset Dependency Matrix

Every generated UI asset used by a blueprint should appear in `asset_dependency_matrix`.

```yaml
asset_dependency_matrix:
  ninja2.ui.panel.parchment_9slice:
    component_slots:
      - LevelChoicePanel.skin
      - SkillChoiceCard.skin
    slice_hints_px: { left: 28, right: 28, top: 28, bottom: 28 }
    content_insets_by_slot:
      LevelChoicePanel: { left: 14, right: 14, top: 34, bottom: 16 }
    must_not_bake:
      - title_text
      - skill_name_text
      - icons
```

`asset-plan.yaml` owns file paths, generation status, platform paths, and prompt notes. `component-blueprints.yaml` owns why the asset exists and where it fits inside a component.

## Runtime Token Mapping

When runtime CSS variables, Phaser constants, or Unity recipe values come from a blueprint, list them:

```yaml
runtime_token_mapping:
  css_custom_properties:
    --level-grid-gap: components.SkillChoiceGrid.box_model.gap_px.target
    --level-card-min-height: components.SkillChoiceCard.box_model.min_height_px.target
  existing_css_classes:
    ".choice": SkillChoiceCard
```

This makes visual regressions traceable. Magic numbers in runtime code should either be legacy, local physics/gameplay values, or mapped back to a blueprint/layout token.

## Gate

A blueprint can move from `pilot` to `approved` only when:

- every surface has semantic sections with clear ownership
- every component in the surface tree belongs to at least one section
- repeated components have explicit anatomy, slots, states, and box model
- rectangular generated skins separate `slice_hints` from `content_insets`
- fixed border ornaments are extracted as an `ornament_layer` when not stretch-safe
- generated assets are referenced through `asset_dependency_matrix` and `asset-plan.yaml`
- runtime/spec/recipe files list the blueprint as a design source
- visual QA confirms text does not overflow at target and narrow mobile widths

## Validation

Run:

```bash
python3 harness/tools/design_blueprint_validate.py <game>
```

Use `--strict` when a surface is ready to be promoted from pilot to approved.
