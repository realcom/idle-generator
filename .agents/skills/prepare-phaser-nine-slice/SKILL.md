---
name: prepare-phaser-nine-slice
description: "Phaser UI skin을 9-slice로 쓸지 판정하고 asset-plan, Phaser UI spec, Unity sliced_sprite 계약에 slice_hints와 phaser_nineslice 사용 방침을 반영한다. 버튼, 패널, 모달 프레임, dock, tab, chip, card 같은 generated UI skin의 사용 여부를 정할 때 사용."
argument-hint: "[게임 id] [asset key 또는 UI surface]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
model: sonnet
---

# Prepare Phaser Nine Slice

Purpose: make the 9-slice decision before UI assets, Phaser specs, or runtime code drift into CSS/background hacks.

## Always read

- `harness/runtime/NINE_SLICE_UI.md`
- `harness/design/COMPONENT_BLUEPRINTS.md`
- `harness/design/<game>/component-blueprints.yaml`
- `harness/design/<game>/asset-plan.yaml`
- `harness/design/<game>/component-skins.yaml`
- Relevant `harness/runtime/specs/ui/*.yaml` when a UI spec already exists.
- Relevant runtime files only when validating an existing implementation.

## Workflow

1. Identify candidate UI skins: panel, modal frame, button body, dock, tab, card, chip, toast, slot frame, progress frame.
2. Reject non-candidates early: characters, buildings, icons, backgrounds, hex tiles, pickups, VFX, atlases, and spritesheets.
3. For each candidate, verify the bitmap can stretch:
   - no baked text or numbers
   - stable rectangular silhouette
   - clean corner caps and edge caps
   - center area can stretch or tile without visible artifacts
   - target size is larger than `left + right` and `top + bottom`
4. If the concept has border ornaments, corner clusters, crests, badges, vines, or clasps, decide whether they are stretch-safe:
   - stretch-safe frame material can stay in the 9-slice skin
   - non-stretch-safe decoration must become a fixed ornament sprite layer in `component-blueprints.yaml`
5. Record or revise the blueprint and asset-plan contract:
   - `component-blueprints.yaml` `skin_contract.slice_hints_px`
   - `component-blueprints.yaml` `skin_contract.content_insets_px`
   - `component-blueprints.yaml` `asset_dependency_matrix`
   - `slice_hints: { left, right, top, bottom }`
   - `phaser.usage: phaser_nineslice`
   - `unity.usage: sliced_sprite` when Unity shares the asset
   - separate state files when cap geometry differs by state
6. Ensure Phaser UI specs call out the chosen skin, content insets, ornament layers, and dimensions; runtime implementation should use Phaser 4.1 WebGL `scene.add.nineslice(...)`.
7. Run `python3 harness/tools/design_blueprint_validate.py <game>` and `python3 harness/tools/phaser_nineslice_audit.py <game>`; also run the relevant Phaser smoke/screenshot when the surface is visual.

## Rules

- Do not bake labels, prices, counters, cooldowns, or localized text into 9-slice skins.
- Do not use CSS as the production 9-slice renderer. CSS is acceptable for debug or DOM-only previews.
- Prefer Phaser graphics for plain rounded boxes and simple progress bars.
- Prefer fixed images or sprites for small fixed-size widgets.
- Prefer fixed transparent ornament sprites for non-stretch-safe frame decorations.
- Keep Unity and Phaser cap insets identical unless an intentional platform divergence is documented.
- Do not implement unrelated runtime UI while preparing the 9-slice contract.

## Output

Report:

- Candidate assets accepted for 9-slice.
- Candidate assets rejected and why.
- Asset-plan/spec files updated.
- Audit and smoke commands run, with results.
