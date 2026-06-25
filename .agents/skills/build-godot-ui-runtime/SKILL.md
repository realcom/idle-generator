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
4. Split the surface into semantic sections from the recipe and component blueprints before building.
   - Work section-by-section, such as top HUD, combat/body area, side rail, growth dock, modal header/body/footer, or status panel groups.
   - Record the active section, concept crop, runtime capture crop, and output nodes/resources before moving on.
   - Do not broaden the edit scope until the current section has a visual comparison and the major spacing/style issues are addressed.
5. Create or update generated scene/theme/resource outputs declared by the recipe for the active section.
   - Prefer `python3 harness/godot/builders/godot_ui_recipe_build.py --recipe <recipe>` for declarative Control atoms before hand-editing generated files.
   - Prefer a small Godot Editor/headless builder script when saving `PackedScene`, `Theme`, or `.tres` resources is fragile.
   - Keep generated outputs under clearly marked generated folders.
   - Put TextureAtom `godot.target_path` files inside `harness/runtime/godot-<game>/assets/generated/...` so generated `.tscn` files can reference imported `Texture2D` resources.
6. Tune layout deliberately for the active section.
   - Check padding, margins, content insets, anchors, grow directions, alignment, fixed dimensions, minimum sizes, and text clamp behavior against `component-blueprints.yaml` and the concept.
   - Prefer container-driven layout that remains stable across target viewports instead of hard-coded per-node offsets.
   - When the concept spacing is not fully specified, infer conservative values from adjacent blueprint tokens and record the inference in the recipe or implementation notes.
7. Use `NinePatchRect` or `StyleBoxTexture` for reusable rectangular generated skins and preserve `slice_hints`.
   - Use 9-slice for panels, cards, buttons, tabs, chips, docks, modal frames, and stretchable frames.
   - Validate that slice margins keep corners and borders crisp at the target sizes.
   - Use fixed `TextureRect`/Sprite nodes for icons, ornaments, pickups, portraits, and VFX.
8. Wire generated outputs into the owner scene/script with the smallest runtime change that preserves existing state/data flow.
9. Use shared button roles, modal sections, semantic color tokens, and asset-plan paths. Do not introduce screen-local styling unless the recipe explicitly allows it.
10. Run:
   - `python3 harness/godot/validators/godot_ui_recipe_validate.py --recipe <recipe> --strict`
   - `python3 harness/godot/builders/godot_ui_recipe_build.py --recipe <recipe>`
   - `godot --headless --path harness/runtime/godot-<game> --import` after builder copies or changes project-local assets.
   - `godot --headless --path harness/runtime/godot-<game> --scene res://scenes/generated/<surface>.tscn --quit-after 1`
   - `godot --headless --path harness/runtime/godot-<game> --check-only --script res://scripts/main.gd`
   - the recipe smoke commands, such as `res://scripts/tools/smoke.gd`
11. For visual surfaces, run a non-headless capture script and inspect the screenshot.
12. For selected concept implementation, create a section compare board with `harness/tools/design_visual_compare.py`.
   - Compare the active runtime section against the matching concept crop, not only the full screen.
   - Check proportion, padding, margin, alignment, hierarchy, 9-slice stretching, asset identity, and readable text placement.
   - Save or report the compare board path for every section that was implemented or changed.
13. Iterate on the active section until it is acceptably close to the selected concept.
   - Repeat section implementation, padding/margin/alignment tuning, 9-slice adjustment, capture, and compare.
   - Continue until the remaining differences are either minor, intentionally documented, or blocked by missing assets/runtime constraints.
   - Only then move to the next section.
14. Report generated paths, touched runtime files, smoke/audit results, screenshot paths, compare board paths by section, iteration count, and remaining blockers.

## Rules

- Do not put one full-screen concept PNG over the runtime as the implementation.
- Do not collapse blueprint sections into one undifferentiated scene group when the surface has top/body/bottom, modal header/body/footer, or similar semantic regions.
- Do not mark a visual section done after one pass when padding, margins, alignment, or 9-slice stretching still visibly diverge from the concept.
- Do not compare only the full screen when a section-level crop can reveal spacing, hierarchy, or skinning problems more clearly.
- Do not bake text, labels, numbers, cooldowns, prices, or localized strings into generated bitmap assets.
- Do not scatter new colors and button states across screen scripts when they belong in a generated Theme or reusable style helper.
- Do not hand-edit large generated `.tscn` files when a builder script or Godot API save path is safer.
- If a generated output would replace a hand-authored scene, ask before replacing it.
- If Godot capture requires a non-headless renderer, run the capture command without `--headless` and inspect the saved PNG before finalizing.
