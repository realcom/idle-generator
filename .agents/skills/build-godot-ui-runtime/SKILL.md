---
name: build-godot-ui-runtime
description: "harness/godot recipe를 Godot Control scene, Theme, .tres 리소스, 런타임 GDScript에 반영하고 Godot headless check, smoke, screenshot QA로 검증한다. Godot UI 구현, .tscn/.tres 생성, NinePatchRect 적용 시 사용."
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
---

# Build Godot UI Runtime

Purpose: convert a reviewed Godot UI recipe into working Godot scene/theme/runtime output and verify it through the Godot project.

## Always read

- The recipe under `harness/godot/recipes/ui/`.
- `harness/godot/GODOT_UI_HARNESS.md`
- `harness/godot/registries/control-atoms.yaml`
- `harness/design/COMPONENT_BLUEPRINTS.md`
- `harness/design/<game>/button-system.yaml` when the recipe references shared button roles.
- `harness/design/<game>/modal-system.yaml` when the recipe references shared modal shells or sections.
- `harness/design/<game>/color-tokens.yaml` when the recipe references semantic color tokens.
- `harness/design/<game>/component-blueprints.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/design/<game>/asset-plan.yaml`
- `harness/runtime/NINE_SLICE_UI.md` when the recipe references `slice_hints`.
- Target Godot project files, commonly:
  - `harness/runtime/godot-<game>/project.godot`
  - `harness/runtime/godot-<game>/scenes/main.tscn`
  - owner script named in the recipe
  - relevant `scripts/tools/*smoke.gd` and capture scripts

## Workflow

1. Run `python3 harness/godot/validators/godot_ui_recipe_validate.py --recipe <recipe>` before editing.
2. Run `python3 harness/tools/design_blueprint_validate.py <game>` when the recipe references component blueprints.
3. Inspect the target Godot project and existing scene/script ownership.
4. Create or update generated scene/theme/resource outputs declared by the recipe.
   - Prefer `python3 harness/godot/builders/godot_ui_recipe_build.py --recipe <recipe>` for declarative Control atoms before hand-editing generated files.
   - Prefer a small Godot Editor/headless builder script when saving `PackedScene`, `Theme`, or `.tres` resources is fragile.
   - Keep generated outputs under clearly marked generated folders.
   - Put TextureAtom `godot.target_path` files inside `harness/runtime/godot-<game>/assets/generated/...` so generated `.tscn` files can reference imported `Texture2D` resources.
5. Wire generated outputs into the owner scene/script with the smallest runtime change that preserves existing state/data flow.
6. Use shared button roles, modal sections, semantic color tokens, and asset-plan paths. Do not introduce screen-local styling unless the recipe explicitly allows it.
7. Use `NinePatchRect` or `StyleBoxTexture` for reusable rectangular generated skins and preserve `slice_hints`; use fixed `TextureRect`/Sprite nodes for icons, ornaments, pickups, portraits, and VFX.
8. Run:
   - `python3 harness/godot/validators/godot_ui_recipe_validate.py --recipe <recipe> --strict`
   - `python3 harness/godot/builders/godot_ui_recipe_build.py --recipe <recipe>`
   - `godot --headless --path harness/runtime/godot-<game> --import` after builder copies or changes project-local assets.
   - `godot --headless --path harness/runtime/godot-<game> --scene res://scenes/generated/<surface>.tscn --quit-after 1`
   - `godot --headless --path harness/runtime/godot-<game> --check-only --script res://scripts/main.gd`
   - the recipe smoke commands, such as `res://scripts/tools/smoke.gd`
9. For visual surfaces, run a non-headless capture script and inspect the screenshot.
10. For selected concept implementation, create a section compare board with `harness/tools/design_visual_compare.py`.
11. Report generated paths, touched runtime files, smoke/audit results, screenshot path, compare board path, and remaining blockers.

## Rules

- Do not put one full-screen concept PNG over the runtime as the implementation.
- Do not collapse blueprint sections into one undifferentiated scene group when the surface has top/body/bottom, modal header/body/footer, or similar semantic regions.
- Do not bake text, labels, numbers, cooldowns, prices, or localized strings into generated bitmap assets.
- Do not scatter new colors and button states across screen scripts when they belong in a generated Theme or reusable style helper.
- Do not hand-edit large generated `.tscn` files when a builder script or Godot API save path is safer.
- If a generated output would replace a hand-authored scene, ask before replacing it.
- If Godot capture requires a non-headless renderer, run the capture command without `--headless` and inspect the saved PNG before finalizing.
