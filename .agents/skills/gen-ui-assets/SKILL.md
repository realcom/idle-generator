---
name: gen-ui-assets
description: "harness/design/<game>/asset-plan.yaml을 기준으로 genimg UI 에셋을 생성하고 실제 파일 경로, 상태, 재사용 여부를 갱신한다."
argument-hint: "[게임 id] [asset-plan 경로 또는 asset key]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
model: sonnet
---

# Generate UI Assets

Purpose: execute the image-asset portion of a reviewed design system without touching Unity or Phaser implementation code.

## Always read

- `harness/design/<game>/asset-plan.yaml`
- `harness/design/<game>/art-direction.yaml`
- `harness/design/COMPONENT_BLUEPRINTS.md`
- `harness/design/<game>/component-blueprints.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/runtime/NINE_SLICE_UI.md` when the asset plan contains UI skins or `slice_hints`.
- Source concept notes/images referenced by the asset plan.
- Existing assets under `harness/design/<game>/assets/`, `harness/assets/<game>/`, and runtime/platform folders when referenced.

## Workflow

1. Select assets with `mode: generate_image` or `mode: hybrid` and `priority: must` or `should`, unless the user asks for a narrower key.
2. Confirm each selected UI asset appears in `component-blueprints.yaml:asset_dependency_matrix` when it is part of a reusable component.
3. Reuse existing matching assets when `mode: reuse` or an equivalent generated file already exists.
4. Generate raster assets with genimg/imagegen using the `prompt_notes`, `background`, `target_size`, `states`, `variants`, and platform notes from `asset-plan.yaml`.
   - For player-facing UI icons (`type: ui_icon_set`, tab/side/resource/status/button glyph atoms), use built-in imagegen/image_gen for the source artwork. Local scripts may only post-process imagegen output: chroma-key removal, alpha cleanup, crop, resize, packing, naming, and audit metadata.
5. Save files to the declared `target_path` or platform-specific target path.
6. Preserve transparent backgrounds for icons, frames, button skins, panels, ornament layers, and effects unless the plan says opaque.
7. For 9-slice candidates, keep borders visually clean and record final slice hints; use `phaser.usage: phaser_nineslice` or `phaser_nineslice_set`.
8. For border/corner/crest decorations that are not stretch-safe, generate fixed transparent ornament sprites and keep `slice_hints: null`.
9. Update `asset-plan.yaml` with actual paths, status, generation notes, and any blocked assets.
10. Run `python3 harness/tools/design_blueprint_validate.py <game>` when asset dependency mappings changed.
11. Run `python3 harness/tools/phaser_nineslice_audit.py <game>` when 9-slice candidates or `slice_hints` changed.

## Rules

- Do not edit Unity prefabs, Phaser runtime JS, or HTML/CSS in this skill.
- Do not bake text, numbers, or localized labels into reusable UI skins unless the asset plan explicitly marks the asset as illustrative only.
- Prefer separate state/variant files over sprite sheets unless the downstream platform already expects an atlas.
- Keep generated assets reusable across Unity and Phaser when the visual can be shared.
- Do not mark icons, portraits, backgrounds, hex tiles, buildings, characters, VFX, atlases, or spritesheets as 9-slice assets.
- Do not approve CSS, emoji, Pillow-drawn, or Phaser Graphics placeholder icons as final UI icon assets unless the blueprint explicitly classifies that glyph as a runtime primitive instead of generated artwork.
- Do not bake ornament layers into stretchable 9-slice skins unless the blueprint explicitly marks them stretch-safe.
