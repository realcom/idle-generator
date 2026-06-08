---
name: extract-design-system
description: "선택된 UI 시안에서 design system과 assetization plan을 추출해 art direction, tokens, skins, genimg 대상, critique rubric을 harness/design/<game>/에 저장한다."
argument-hint: "[게임 id] [concept md/png 경로]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion
model: sonnet
---

# Extract Design System

Purpose: turn an approved or selected concept image into reusable design harness sources and a concrete asset-generation plan.

This skill is the analysis step after concept generation. It decides what should become generated image assets, what should remain runtime-native UI, and how downstream Phaser specs or Unity recipes should combine both.

## Always read

- The selected concept note and image.
- `harness/design/<game>/design-registry.yaml`.
- `harness/design/COMPONENT_BLUEPRINTS.md`
- `harness/runtime/NINE_SLICE_UI.md` when assetizing rectangular UI skins.
- Existing design source files to avoid overwriting decisions accidentally.
- Existing generated assets or asset manifests under `harness/design/<game>/` or `harness/assets/` when present.

## Outputs

Create or update:

- `harness/design/<game>/art-direction.yaml`
- `harness/design/<game>/layout-tokens.yaml`
- `harness/design/<game>/component-blueprints.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/design/<game>/asset-plan.yaml`
- `harness/design/<game>/motion-juice.yaml`
- `harness/design/<game>/critique-rubric.yaml`

## Workflow

1. Identify the concept's non-negotiables: orientation, screen regions, character identity, material language, and core loop.
2. Extract visual tokens: palette, outlines, materials, typography treatment, spacing/region ratios.
3. Decompose semantic components before assetization:
   - Split each large UI surface into semantic sections first, such as top tabs, content body, board area, bottom nav, modal header, modal body, or footer.
   - For each section, record role, owned components, layout contract, process scope, key assets, and section-specific QA focus.
   - Name each component by player/runtime meaning, not by bitmap shape.
   - Define anatomy, slots, states, data bindings, repeatability, touch target rules, and text clamp rules.
   - Define box-model contracts: min/default size, content insets, padding, gaps, and responsive reductions.
   - Separate `slice_hints` for bitmap stretching from `content_insets` for text/icon layout.
   - Extract border ornaments, corner clusters, crests, badges, vines, and other decorative attachments as a fixed `ornament_layer` when they are not stretch-safe.
   - Record which slots are generated assets, fixed sprites, native text, native graphics, or hybrid assemblies.
   - Record section crop guidance when the selected concept will be implemented in runtime, so later visual iteration compares the same semantic region rather than arbitrary screenshots.
4. Analyze assetization before writing component skins:
   - `generate_image`: visual pieces that need genimg output, such as backgrounds, portraits, icons, textured frames, reward effects, ornate buttons, or 9-slice panel skins.
   - `native_ui`: pieces best built from layout/recipe primitives, such as text, simple panels, progress bars, grids, lists, and spacing rules.
   - `hybrid`: components that combine native layout with generated skins or icons.
   - `reuse`: existing assets that should be referenced instead of regenerated.
5. Write `asset-plan.yaml` with source concept ids, asset keys, shared/platform-specific intended file paths, generation prompt notes, transparent/opaque background requirements, target sizes, slice/border hints, states, variants, and downstream usage.
6. Extract component skins from the assetization decision: repeated cards, buttons, mission cards, HUD strips, tab bars, feedback elements, and their dependency on generated assets.
7. Extract motion and reward feedback rules only when visible or implied by gameplay.
8. Add blocker checks and weighted critique criteria, including whether required image assets are specified precisely enough for generation.
9. Update the design registry status to `extracted` or leave `selected` if human approval is still pending.
10. Run `python3 harness/tools/design_blueprint_validate.py <game>` when `component-blueprints.yaml` was created or changed.

## Asset Plan Shape

Keep `asset-plan.yaml` declarative. Prefer this shape unless the existing project already has a stricter convention:

```yaml
source_concepts:
  - concept_id
assetization_summary:
  generate_image: []
  native_ui: []
  hybrid: []
  reuse: []
assets:
  - key: ui.panel.example
    type: nine_slice_panel | icon | background | portrait | effect | button_skin | frame | texture
    mode: generate_image | native_ui | hybrid | reuse
    platforms: [phaser, unity]
    target_path: harness/design/<game>/assets/example.png
    usage:
      - component-skins.yaml:example_component
    prompt_notes: ""
    background: transparent | opaque
    target_size: { width: 256, height: 256 }
    slice_hints: { left: 24, right: 24, top: 24, bottom: 24 }
    states: [normal]
    variants: []
    phaser:
      usage: phaser_nineslice | phaser_nineslice_set | img | canvas_sprite | atlas_region | css_background
      target_path: harness/runtime/assets/ui/example.png
    unity:
      usage: sliced_sprite | sprite | raw_image
      target_path: engine/client/Client/Assets/Resources/HarnessPreview/GeneratedSprites/example.png
      slice_hints: { left: 24, right: 24, top: 24, bottom: 24 }
    priority: must | should | nice
    blocking_reason: ""
```

## Rules

- Keep files declarative and implementation-neutral where possible.
- Record source concept ids in every output.
- Do not generate images in this skill; describe the genimg-ready assets so a later asset-generation step can execute them.
- Do not invent engine or runtime bindings here; those belong in `gen-unity-ui-recipe` or `gen-phaser-ui-spec`.
- Do not mark registry status as `extracted` if required `must` assets are ambiguous.
- Do not skip `component-blueprints.yaml` for any selected UI concept that will produce reusable runtime components.
- Do not jump from a full-screen concept directly to component atoms when the UI has multiple semantic sections; define the sections first and run the extraction loop per section.
- Do not leave visual QA as a whole-screen screenshot only; large UI surfaces need section-level crop guidance for concept-vs-runtime comparison.
