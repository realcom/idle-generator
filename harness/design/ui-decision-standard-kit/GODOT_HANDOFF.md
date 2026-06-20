# Godot Handoff Checklist

Use this checklist when handing a selected UI concept to a Godot implementer.

## 1. Before Runtime Code

- Confirm the selected concept is registered in `design-registry.yaml`.
- Confirm shared UI foundations exist or unresolved decisions are recorded:
  - `ui-system-inventory.yaml`
  - `button-system.yaml`
  - `modal-system.yaml`
  - `color-tokens.yaml`
- Create or update:
  - `art-direction.yaml`
  - `layout-tokens.yaml`
  - `component-blueprints.yaml`
  - `component-skins.yaml`
  - `asset-plan.yaml`
  - `motion-juice.yaml`
  - `critique-rubric.yaml`
- Split the screen into semantic sections before deciding Godot nodes.
- Decide which elements are generated image assets, native Control UI, hybrid assemblies, or reused assets.
- Decide Godot 9-slice candidates before generating or wiring skins.

## 2. Godot Recipe Requirements

Write `harness/godot/recipes/ui/<surface>.yaml` before touching Godot scenes or scripts.

The recipe must include:

- target Godot project, owner scene/script, and generated output paths;
- source concept and design-system paths;
- surface, section, and component IDs from `component-blueprints.yaml`;
- Control atoms from `harness/godot/registries/control-atoms.yaml`;
- asset keys from `asset-plan.yaml`;
- 9-slice hints, content insets, fixed ornament layers, and native layout gaps;
- data bindings and fixture/smoke ownership;
- validation commands and screenshot paths.

## 3. Runtime Build Rules

- Prefer generated `PackedScene`, `Theme`, `.tres`, and small reusable scripts over one-off screen code.
- Preserve blueprint section ownership in the scene tree.
- Use shared button roles, modal shell contracts, and semantic color tokens.
- Keep text, labels, numbers, cooldowns, prices, and localized strings outside generated bitmaps.
- Use `NinePatchRect` or `StyleBoxTexture` for reusable rectangular skins.
- Use fixed `TextureRect` or Sprite nodes for icons, portraits, characters, VFX, pickups, and ornaments.
- Do not implement a full concept screenshot as a texture overlay.
- Do not scatter new colors and style overrides across screen scripts when they belong in a `Theme` or generated style resource.

## 4. Suggested Validation

```bash
python3 harness/tools/design_blueprint_validate.py <game>
python3 harness/godot/validators/godot_ui_recipe_validate.py --recipe harness/godot/recipes/ui/<surface>.yaml
godot --headless --path harness/runtime/godot-<game> --check-only --script res://scripts/main.gd
godot --headless --path harness/runtime/godot-<game> --script res://scripts/tools/<surface>_smoke.gd
```

For visual work, create section compare boards:

```bash
python3 harness/tools/design_visual_compare.py \
  --concept /tmp/concept-section.png \
  --candidate /tmp/godot-screenshot.png \
  --candidate-crop x,y,w,h \
  --out /tmp/<surface>-<section>-godot-compare.png \
  --label-concept "CONCEPT <section>" \
  --label-candidate "GODOT <section>"
```

## 5. Handoff Report

Every Godot implementation handoff should report:

- recipe path;
- generated scene/theme/resource paths;
- Godot scripts changed;
- assets added or remapped;
- smoke/capture commands and results;
- screenshot and compare board paths;
- PASS/WARN/ERROR verdict;
- remaining blockers or intentional divergence.
