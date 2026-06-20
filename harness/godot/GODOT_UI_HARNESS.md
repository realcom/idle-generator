# Godot UI Harness

Purpose: make Godot a first-class target for UI concepts, generated assets, and component blueprints.

## Source Order

1. `harness/design/<game>/concepts/*.md|png`
2. `harness/design/<game>/ui-system-inventory.yaml`
3. `harness/design/<game>/button-system.yaml`, `modal-system.yaml`, `color-tokens.yaml`
4. `harness/design/<game>/component-blueprints.yaml`
5. `harness/design/<game>/component-skins.yaml`
6. `harness/design/<game>/asset-plan.yaml`
7. `harness/godot/recipes/ui/*.yaml`
8. `harness/runtime/godot-<game>/`

Concept screenshots are references only. Godot output must be native Control scenes, themes, scripts, and imported assets.

## Recipe Contract

Godot UI work starts with a recipe under `harness/godot/recipes/ui/`.

Recipes describe:

- target Godot project, owner scene/script, and generated output paths
- source design documents and component blueprint refs
- Control atom names from `harness/godot/registries/control-atoms.yaml`
- required asset keys from `asset-plan.yaml`
- native text/data bindings and fixture ownership
- validation commands and screenshot paths

Run:

```bash
python3 harness/godot/validators/godot_ui_recipe_validate.py --recipe harness/godot/recipes/ui/<surface>.yaml
```

Build generated Godot outputs with:

```bash
python3 harness/godot/builders/godot_ui_recipe_build.py --recipe harness/godot/recipes/ui/<surface>.yaml
```

## Godot Mapping Rules

- Rectangular scalable skins use `NinePatchRect` or `StyleBoxTexture`.
- Use `slice_hints` for bitmap cap borders and `content_insets` for native layout. Do not merge them.
- Text, numbers, prices, cooldowns, Korean labels, and timers stay native `Label` or control state.
- Icons, portraits, pickups, props, characters, VFX atoms, and circular action glyphs stay fixed `TextureRect` or Sprite nodes.
- Use `Theme` or `.tres` style resources for reusable colors, fonts, button states, and panel styles instead of scattering style overrides in screen scripts.
- Generated scenes should live under a clearly marked generated folder, for example `harness/runtime/godot-<game>/scenes/generated/`.
- Generated themes/resources should live under `harness/runtime/godot-<game>/themes/generated/` or `resources/generated/`.
- Texture assets referenced by generated `.tscn` files must have a `godot.target_path` inside the Godot project, for example `harness/runtime/godot-<game>/assets/generated/...`. Shared `harness/runtime/assets/<game>/...` files may be used as copy sources, but Godot `Texture2D` ext_resources need project-local imported files.
- Do not hand-write large `.tscn` files when a small GDScript builder can instantiate and save `PackedScene`/`Theme` resources through Godot APIs.

## Validation

Minimum validation for Godot UI changes:

```bash
python3 harness/tools/design_blueprint_validate.py <game>
python3 harness/godot/validators/godot_ui_recipe_validate.py --recipe harness/godot/recipes/ui/<surface>.yaml
python3 harness/godot/builders/godot_ui_recipe_build.py --recipe harness/godot/recipes/ui/<surface>.yaml
godot --headless --path harness/runtime/godot-<game> --import
godot --headless --path harness/runtime/godot-<game> --scene res://scenes/generated/<surface>.tscn --quit-after 1
godot --headless --path harness/runtime/godot-<game> --check-only --script res://scripts/main.gd
godot --headless --path harness/runtime/godot-<game> --script res://scripts/tools/<surface>_smoke.gd
```

For visual UI work, capture a screenshot and compare the same semantic section against the selected concept with `harness/tools/design_visual_compare.py`.
