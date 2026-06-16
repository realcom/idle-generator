# Phaser Handoff Checklist

Use this checklist when handing a selected UI concept to a Phaser implementer.

## 1. Before Runtime Code

- Run the UI foundation audit first:
  - find existing button, modal, color, typography, spacing, icon, 9-slice, and
    Phaser/UI harness docs;
  - record them in `ui-system-inventory.yaml`;
  - create missing `button-system.yaml`, `modal-system.yaml`, and
    `color-tokens.yaml` from templates;
  - connect those foundation files to relevant skills, harness docs, specs, and
    runtime helpers.
- Confirm `design-registry.yaml` marks the concept as `selected`.
- Confirm the concept note includes intent, art anchor, composition rules,
  UI direction, implementation notes, and target runtime notes.
- Create or update:
  - `art-direction.yaml`
  - `layout-tokens.yaml`
  - `component-blueprints.yaml`
  - `component-skins.yaml`
  - `asset-plan.yaml`
- `motion-juice.yaml`
- `critique-rubric.yaml`
- `ui-system-inventory.yaml`
- `button-system.yaml`
- `modal-system.yaml`
- `color-tokens.yaml`
- Split the target surface into sections before defining component atoms.
- Decide assetization mode for each visual element.
- Decide 9-slice candidates before generating or wiring skins.

## 2. Phaser UI Spec Requirements

Write `runtime/specs/ui/<surface>.yaml` before touching runtime code.

The spec must include:

- target page or surface;
- implementation mode: `dom_overlay`, `phaser_canvas`, or `hybrid`;
- source concept and design-system paths;
- surface, section, and component IDs from `component-blueprints.yaml`;
- orientation, responsive policy, and safe-area policy;
- asset keys from `asset-plan.yaml`;
- content insets, gaps, clamp rules, ornament layers, and 9-slice hints;
- data contract with concrete sources for text, numbers, lists, IDs, and icons;
- references to shared button/modal/color systems when the surface uses them;
- fixture or query route used by smoke tests;
- visual iteration plan with concept/runtime crop targets;
- validation commands and screenshot paths.

## 3. Runtime Build Rules

- Prefer existing runtime helpers and design-system modules.
- Preserve blueprint section ownership in code structure.
- Use shared button, modal, and color tokens instead of screen-local styles.
- Keep text, labels, numbers, and localized strings outside generated bitmaps.
- Load assets by declared key/path from `asset-plan.yaml`.
- Use Phaser WebGL `scene.add.nineslice(...)` for production 9-slice skins.
- Render fixed ornament sprites separately from stretchable base skins.
- Keep DOM overlays for text-heavy modals and layout UI.
- Keep Phaser canvas for combat, board visuals, sprite-heavy effects, and
  particles.
- Put demo data in scenario/spec fixtures, not runtime source files.

## 4. Suggested Validation

Adapt these commands to your project:

```bash
python3 tools/design_blueprint_validate.py <game>
python3 tools/phaser_asset_audit.py <game>
python3 tools/phaser_nineslice_audit.py <game>
python3 tools/phaser_data_contract_audit.py <game> --spec runtime/specs/ui/<surface>.yaml
python3 tools/phaser_data_contract_audit.py <game> --spec runtime/specs/ui/<surface>.yaml --strict
python3 tools/phaser_smoke.py <game> --runtime runtime/<page>.html --expect ui --screenshot /tmp/<surface>.png
```

For visual work, create section compare boards:

```bash
python3 tools/design_visual_compare.py \
  --concept /tmp/concept-section.png \
  --candidate /tmp/runtime-screenshot.png \
  --candidate-crop x,y,w,h \
  --out /tmp/<surface>-<section>-compare.png \
  --label-concept "CONCEPT <section>" \
  --label-candidate "RUNTIME <section>"
```

## 5. Handoff Report

Every implementation handoff should report:

- runtime files changed;
- assets added or remapped;
- spec path;
- screenshot path;
- compare board path per section;
- smoke/audit results;
- PASS/WARN/ERROR verdict;
- remaining blockers or intentional divergence.
