# Skill Integration

Install this standard into skills so users do not need to repeat the full UI
pipeline in every prompt.

## Principle

The phrase "follow the skill/harness and shared button/modal/color systems" must
live inside skill and harness instructions, not only inside user prompts.

After installation, a normal user request such as:

```text
<game>/<screen> UI 작업 진행해줘.
```

should still cause Codex to read or verify:

- `ui-system-inventory.yaml`
- `button-system.yaml`
- `modal-system.yaml`
- `color-tokens.yaml`
- component blueprints, skins, asset plan, Phaser spec, and harness docs

## Required Skill Hooks

Patch these skill or agent documents when they exist.

### `gen-ui-concept`

- Always read existing `ui-system-inventory.yaml`, `button-system.yaml`,
  `modal-system.yaml`, and `color-tokens.yaml`.
- If a required foundation rule is missing or ambiguous, record the question in
  the concept note instead of inventing final policy.

### `extract-design-system`

- Audit foundation systems before screen-specific extraction.
- Create or update `ui-system-inventory.yaml`, `button-system.yaml`,
  `modal-system.yaml`, and `color-tokens.yaml` when needed.
- If a required rule is unclear, add it to
  `ui-system-inventory.yaml:unresolved_foundation_questions` and ask the user.
- Reference shared button roles, modal sections, and color tokens in component
  blueprints and skins.

### `prepare-phaser-nine-slice`

- Read `button-system.yaml` for button, tab, chip, dock, CTA, and icon-button
  skins.
- Read `modal-system.yaml` for modal frame or sheet skins.
- Do not approve button/modal 9-slice skins that bypass shared systems.

### `gen-ui-assets`

- Read button, modal, and color systems when generating related assets.
- Confirm generated button/modal/state-color assets map to the relevant shared
  system and `asset-plan.yaml`.

### `gen-phaser-ui-spec`

- Read foundation systems when the surface uses buttons, modals, or semantic
  UI colors.
- Include foundation source paths and shared UI usage in the spec.
- Do not write local button/modal/color styling into the spec.

### `build-phaser-ui-runtime`

- Use shared button roles, modal shell/section contracts, and semantic color
  tokens during runtime implementation.
- If a rule is missing, update the foundation docs or ask the user; do not make
  a screen-local runtime rule.

### `design-review`

- Check that visible buttons, modals, and UI colors trace back to shared
  systems.
- Mark `WARN` or `ERROR` when UI bypasses those systems.
- Suggest a system-file edit or user question, not vague taste feedback.

## Harness Hook

Patch Phaser/UI harness docs with a UI foundation gate:

- Check `ui-system-inventory.yaml` before new UI work.
- Route buttons to `button-system.yaml`.
- Route modals to `modal-system.yaml`.
- Route action/status/selection/rarity colors to `color-tokens.yaml`.
- Record unresolved decisions as user questions before runtime implementation.

