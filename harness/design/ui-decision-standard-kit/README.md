# Portable UI Decision Standard Kit

This kit is a repo-independent handoff of our current UI decision rules.
It lets another team apply the same concept-to-runtime pipeline without cloning
the original monorepo.

## What This Kit Standardizes

- How a UI concept becomes an implementation-ready design system.
- How large screens are split into semantic sections before components.
- How component contracts, generated assets, Phaser runtime specs, and visual QA
  connect to each other.
- How to decide between native UI, generated bitmaps, hybrid components, and
  Phaser 9-slice skins.

## Recommended File Layout

Use any project root, then create this layout:

```text
design/<game>/
  design-registry.yaml
  concepts/
    <concept-id>.md
    <concept-id>.png
  art-direction.yaml
  layout-tokens.yaml
  component-blueprints.yaml
  component-skins.yaml
  asset-plan.yaml
  motion-juice.yaml
  critique-rubric.yaml

runtime/specs/ui/
  <surface>.yaml

runtime/assets/<game>/
  ui/
```

## Quick Start

1. Copy the files in `templates/` into your project.
2. Run the UI foundation audit:
   - find existing button, modal, color, typography, spacing, icon, and
     design-system documents;
   - connect existing documents to this kit;
   - create missing foundation documents from the templates.
3. Fill `design-registry.yaml` and one concept note under `concepts/`.
4. Mark one concept as `selected`.
5. Extract design rules into `art-direction.yaml`, `layout-tokens.yaml`,
   `component-blueprints.yaml`, `component-skins.yaml`, `asset-plan.yaml`,
   `motion-juice.yaml`, and `critique-rubric.yaml`.
6. Decide 9-slice candidates before generating or wiring rectangular skins.
7. Generate only the assets declared in `asset-plan.yaml`.
8. Write a Phaser UI spec under `runtime/specs/ui/`.
9. Implement runtime code from the spec.
10. Review each semantic section with concept-vs-runtime comparison before
   approving the surface.

## Foundation Audit

Before the first UI surface is implemented, check whether the target project
already has these systems:

- button system;
- modal/dialog system;
- color tokens;
- typography rules;
- spacing/layout tokens;
- icon rules;
- UI skin or 9-slice policy;
- Phaser/UI harness documentation.

If a system exists, link it from the kit files and preserve local conventions.
If it does not exist, create the minimum contract from the matching template
before building screens. Buttons and modals should be shared systems, not
screen-local inventions.

## Included Documents

- `UI_DECISION_STANDARD.md`: the actual rules.
- `PHASER_HANDOFF.md`: Phaser-specific implementation checklist.
- `AGENT_BRIEF.md`: copy-pasteable instructions for a designer or AI agent.
- `SKILL_INTEGRATION.md`: exact skill/harness hooks so users do not need to repeat the pipeline in every prompt.
- `SLACK_SHARE.md`: concise Korean share text for Slack or messenger handoff.
- `templates/`: starter files for a new game or screen.

## Status Vocabulary

- `draft`: exploratory, may conflict with later choices.
- `candidate`: plausible direction, not yet the source of truth.
- `selected`: human-approved visual source.
- `extracted`: selected concept has design-system files.
- `pilot`: implementation exists, not fully approved.
- `approved`: section/surface passed contract, runtime, and visual gates.
