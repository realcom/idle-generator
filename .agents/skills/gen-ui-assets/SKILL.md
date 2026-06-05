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
- `harness/design/<game>/component-skins.yaml`
- `harness/runtime/NINE_SLICE_UI.md` when the asset plan contains UI skins or `slice_hints`.
- Source concept notes/images referenced by the asset plan.
- Existing assets under `harness/design/<game>/assets/`, `harness/assets/<game>/`, and runtime/platform folders when referenced.

## Workflow

1. Select assets with `mode: generate_image` or `mode: hybrid` and `priority: must` or `should`, unless the user asks for a narrower key.
2. Reuse existing matching assets when `mode: reuse` or an equivalent generated file already exists.
3. Generate raster assets with genimg/imagegen using the `prompt_notes`, `background`, `target_size`, `states`, `variants`, and platform notes from `asset-plan.yaml`.
4. Save files to the declared `target_path` or platform-specific target path.
5. Preserve transparent backgrounds for icons, frames, button skins, panels, and effects unless the plan says opaque.
6. For 9-slice candidates, keep borders visually clean and record final slice hints; use `phaser.usage: phaser_nineslice` or `phaser_nineslice_set`.
7. Update `asset-plan.yaml` with actual paths, status, generation notes, and any blocked assets.
8. Run `python3 harness/tools/phaser_nineslice_audit.py <game>` when 9-slice candidates or `slice_hints` changed.

## Rules

- Do not edit Unity prefabs, Phaser runtime JS, or HTML/CSS in this skill.
- Do not bake text, numbers, or localized labels into reusable UI skins unless the asset plan explicitly marks the asset as illustrative only.
- Prefer separate state/variant files over sprite sheets unless the downstream platform already expects an atlas.
- Keep generated assets reusable across Unity and Phaser when the visual can be shared.
- Do not mark icons, portraits, backgrounds, hex tiles, buildings, characters, VFX, atlases, or spritesheets as 9-slice assets.
