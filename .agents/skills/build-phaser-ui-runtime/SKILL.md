---
name: build-phaser-ui-runtime
description: "harness/runtime UI spec을 Phaser/HTML/CSS 런타임에 반영하고 phaser smoke, asset audit, 브라우저 스크린샷 QA로 검증한다."
argument-hint: "[Phaser UI spec 경로]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
model: sonnet
---

# Build Phaser UI Runtime

Purpose: convert a reviewed Phaser UI spec into working runtime code and verify it in the browser harness.

## Always read

- The spec file under `harness/runtime/specs/ui/`.
- `harness/runtime/PHASER_HARNESS.md`
- `harness/design/COMPONENT_BLUEPRINTS.md`
- `harness/design/<game>/component-blueprints.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/design/<game>/asset-plan.yaml`
- `harness/runtime/NINE_SLICE_UI.md` when the spec or asset plan references `slice_hints`.
- Relevant runtime files, commonly:
  - `harness/runtime/src/idlez-phaser/hud.js`
  - `harness/runtime/src/idlez-phaser/modal-system.js`
  - `harness/runtime/src/idlez-phaser/design-system.js`
  - `harness/runtime/phaser-ui-harness.html`
  - `harness/runtime/idlez-phaser.html`

## Workflow

1. Run the relevant baseline smoke from the spec or `PHASER_HARNESS.md`.
2. Run `python3 harness/tools/design_blueprint_validate.py <game>` when the spec references component blueprints.
3. Implement the spec in Phaser/HTML/CSS runtime files using existing design-system helpers when possible.
4. Map runtime CSS variables, Phaser constants, DOM classes, and asset keys back to `component-blueprints.yaml` when the blueprint defines them.
5. Keep blueprint sections as recognizable runtime ownership groups, such as separate DOM containers, Phaser layers, layout helper calls, or clear code regions.
6. Wire generated/reused assets by key and path; do not invent new asset names that bypass `asset-plan.yaml`.
7. Keep DOM text, labels, and numbers outside generated skin bitmaps.
8. Use Phaser 4 WebGL `scene.add.nineslice(...)` for `phaser_nineslice` skins and preserve the asset-plan `slice_hints`; use fixed image sprites for blueprint ornament layers.
9. Run Phaser smoke after changes, including `--no-browser` and a screenshot run when the surface is visual.
10. Run `python3 harness/tools/phaser_asset_audit.py <game>` when assets were added or remapped.
11. Run `python3 harness/tools/phaser_nineslice_audit.py <game>` when 9-slice skins or their mappings changed.
12. Run `python3 harness/tools/design_blueprint_validate.py <game> --strict` before approving a blueprint-backed surface.
13. For visual UI sections, create a concept-vs-runtime compare board with `harness/tools/design_visual_compare.py` before moving to the next section.
   - Crop concept and runtime to the same semantic section.
   - Normalize shell width, especially when the runtime is centered inside a wider browser screenshot.
   - Record `PASS`, `WARN`, or `ERROR` and the next edit scope.
14. Open or inspect the screenshot/browser result. Check at minimum:
   - canvas and DOM overlay are nonblank
   - text fits at mobile width
   - modal/dock/HUD regions do not hide combat unintentionally
   - generated skins/icons render instead of missing image placeholders
   - interactions or query fixtures named in the spec work
15. Report touched runtime files, screenshot path, compare board path, smoke/audit results, and any blocked verification.

## Rules

- Do not edit Unity recipes, Editor builders, or prefabs in this skill.
- Do not put one full-screen mock PNG over the runtime as the implementation.
- Prefer existing runtime modules over adding a new framework or dependency.
- Do not implement production 9-slice with CSS backgrounds when a Phaser runtime skin is available.
- Do not drop blueprint-defined ornament layers just because the base panel/card skin renders correctly.
- Do not collapse blueprint sections into one undifferentiated runtime block when the surface has top/body/bottom, modal header/body/footer, or similar semantic regions.
- Do not keep recursive micro-adjusting when the compare board shows the runtime is following a rejected or wrong concept. Reset that section to the selected source concept first.
- If a visual target differs from Unity, record the intentional divergence in the spec or design notes.
