---
name: gen-phaser-ui-spec
description: "디자인 토큰, asset-plan, 선택된 시안을 바탕으로 Phaser/HTML 런타임용 UI 구현 명세 YAML을 작성한다."
argument-hint: "[게임 id] [화면/모달 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion
model: sonnet
---

# Generate Phaser UI Spec

Purpose: define what the Phaser harness should build before runtime JS/HTML/CSS is changed.

## Always read

- `harness/runtime/PHASER_HARNESS.md`
- `harness/design/<game>/art-direction.yaml`
- `harness/design/<game>/layout-tokens.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/design/<game>/asset-plan.yaml`
- `harness/runtime/NINE_SLICE_UI.md` when the surface uses generated UI skins.
- Relevant concept note under `harness/design/<game>/concepts/`
- Existing UI runtime files when the target surface already exists.

## Output

Write specs under:

`harness/runtime/specs/ui/{slug}.yaml`

## Spec must include

- target runtime page or surface, such as `idlez-phaser.html` or `phaser-ui-harness.html`
- implementation mode: `dom_overlay`, `phaser_canvas`, or `hybrid`
- source concept and design source paths
- screen orientation, responsive width/height policy, and safe-area policy
- HUD, combat arena, modal, dock, or tab regions as applicable
- asset keys from `asset-plan.yaml`, limited to `platforms: [phaser]` or shared assets
- 9-slice skin keys, `slice_hints`, and target min/default/max sizes when `phaser.usage: phaser_nineslice`
- CSS/design token mapping and Phaser graphics usage
- modal ids, route/query fixtures, or scenario ids when relevant
- validation commands, screenshot paths, and blockers

## Rules

- A spec is source; runtime JS/HTML/CSS changes happen in `build-phaser-ui-runtime`.
- Do not write Unity recipe or prefab instructions here.
- Prefer DOM overlay for text-heavy modal/layout UI and Phaser canvas for combat, particles, board visuals, and sprite-heavy effects.
- Prefer Phaser 4 WebGL `phaser_nineslice` for generated rectangular UI skins; do not specify CSS as the production 9-slice renderer.
- Keep text and data bindings symbolic when content/runtime data is not ready.
- Include smoke targets from `PHASER_HARNESS.md` so the build step knows how to verify the surface.
