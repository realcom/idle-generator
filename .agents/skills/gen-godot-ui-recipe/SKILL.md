---
name: gen-godot-ui-recipe
description: "디자인 토큰, asset-plan, 선택된 UI 시안, component-blueprints를 바탕으로 Godot Control scene/theme 생성을 위한 harness/godot recipe YAML을 작성한다. Godot UI, .tscn, Theme, NinePatchRect, Control atom, Godot 런타임 포팅 작업 전에 사용."
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
---

# Generate Godot UI Recipe

Purpose: define what Godot should build before any `.tscn`, `.tres`, Theme, or GDScript runtime work changes.

## Always read

- `harness/godot/GODOT_UI_HARNESS.md`
- `harness/godot/registries/control-atoms.yaml`
- `harness/design/COMPONENT_BLUEPRINTS.md`
- `harness/design/<game>/ui-system-inventory.yaml` if it exists.
- `harness/design/<game>/button-system.yaml` when the surface includes buttons, tabs, chips, docks, CTAs, or icon buttons.
- `harness/design/<game>/modal-system.yaml` when the surface includes dialogs, popups, overlays, sheets, or modal shells.
- `harness/design/<game>/color-tokens.yaml` when the surface maps runtime colors, states, rarity, status, or action colors.
- `harness/design/<game>/art-direction.yaml`
- `harness/design/<game>/layout-tokens.yaml`
- `harness/design/<game>/component-blueprints.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/design/<game>/asset-plan.yaml`
- `harness/runtime/NINE_SLICE_UI.md` when the surface uses generated UI skins.
- Relevant concept note under `harness/design/<game>/concepts/`.
- Existing Godot runtime files when the target surface already exists.

## Output

Write recipes under:

`harness/godot/recipes/ui/{slug}.yaml`

Use `harness/design/ui-decision-standard-kit/templates/godot-ui-recipe.template.yaml` as the starting shape when there is no local convention.

## Recipe must include

- target Godot project, owner scene/script, and generated scene/theme/resource output paths.
- backend `godot_control`.
- source concept and design source paths.
- component blueprint surface, section, and component ids used by the recipe.
- Control atoms from `harness/godot/registries/control-atoms.yaml`.
- generated/reused asset keys from `asset-plan.yaml`, limited to Godot-capable or shared assets; record warnings when existing assets are not yet marked `platforms: [godot]`.
- TextureAtom assets used by generated scenes must declare `godot.target_path` inside `harness/runtime/godot-<game>/assets/generated/...`; shared `harness/runtime/assets/<game>/...` paths can be sources but are not valid `.tscn` `Texture2D` ext_resources.
- `content_insets`, padding, gaps, text clamp rules, and ornament layers from `component-blueprints.yaml`.
- `slice_hints` and intended `NinePatchRect` or `StyleBoxTexture` usage when a rectangular skin is used.
- shared button roles, modal sections/shells, and semantic color token groups.
- data bindings as symbolic keys.
- validation commands, screenshot path, and blockers.

## Workflow

1. Run `python3 harness/tools/design_blueprint_validate.py <game>` before writing a recipe that depends on component blueprints.
2. Identify the surface and semantic sections from `component-blueprints.yaml`.
3. Map each component to Godot Control atoms. Prefer scene/theme atoms over ad hoc code-only style overrides.
4. Map asset keys from `asset-plan.yaml`; add `godot:` usage notes only when the asset is truly consumed by Godot.
5. Decide 9-slice usage: `NinePatchRect` for scene nodes or `StyleBoxTexture` for Theme-owned states.
6. Write the recipe and keep it declarative.
7. Run `python3 harness/godot/validators/godot_ui_recipe_validate.py --recipe <recipe>`.
8. If validation warns that an asset is not marked Godot-capable, either update `asset-plan.yaml` deliberately or keep the warning as an explicit blocker.

## Rules

- A recipe is source; generated Godot scene/theme work happens in `build-godot-ui-runtime`.
- Do not edit Godot scripts, scenes, Theme resources, or generated assets in this skill.
- Do not invent component anatomy, spacing, or style locally when `component-blueprints.yaml`, `button-system.yaml`, `modal-system.yaml`, or `color-tokens.yaml` already define it.
- Do not bake text, numbers, cooldowns, prices, or localized labels into generated bitmap assets.
- Do not use one full-screen concept PNG as a Godot implementation.
- Preserve section boundaries from `component-blueprints.yaml` in the future scene tree.
