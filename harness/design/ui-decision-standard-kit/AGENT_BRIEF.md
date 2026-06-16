# Agent Brief

Copy this into another AI/design agent when asking it to apply this standard.

```text
You are implementing UI under the Portable UI Decision Standard.

Do not implement a concept screenshot directly. First create or update the
design-system contract files, then write a Phaser UI spec, then implement.

Required pipeline:
1. Clarify target screen, orientation, game state, and non-negotiable art anchors.
2. Run a project UI foundation audit:
   - find existing design-system, button, modal, color, typography, spacing,
     icon, 9-slice, Phaser harness, and UI harness docs;
   - record the result in ui-system-inventory.yaml;
   - if button/modal/color systems are missing, create them from templates;
   - if the project or kit has no clear rule for a required UI foundation,
     ask the user focused questions first, then write the answered rule into
     the relevant system document;
   - wire these foundation docs into relevant skill/harness/spec instructions.
3. Create or select a concept image and concept note.
4. Update design-registry.yaml with draft/candidate/selected status.
5. Extract design system files:
   - art-direction.yaml
   - layout-tokens.yaml
   - component-blueprints.yaml
   - component-skins.yaml
   - asset-plan.yaml
   - motion-juice.yaml
   - critique-rubric.yaml
6. Split every large surface into semantic sections before component atoms.
7. Name components by player/runtime meaning, not image crop shape.
8. Decide generate_image/native_ui/hybrid/reuse for each visual element.
9. Decide 9-slice only for stretch-safe rectangular skins.
10. Keep text, numbers, prices, timers, counters, cooldowns, and localized labels
   as runtime-native objects.
11. Generate only assets declared in asset-plan.yaml.
12. Write runtime/specs/ui/<surface>.yaml before editing Phaser runtime code.
13. The spec must declare implementation mode, data contract, asset keys,
    blueprint references, responsive policy, validation commands, and visual
    comparison plan.
14. Implement Phaser/DOM/CSS from the spec while preserving section ownership.
15. Use shared button/modal/color systems instead of local one-off styles.
16. Use Phaser scene.add.nineslice(...) for production 9-slice skins.
17. Validate with smoke/audit checks and section-level concept-vs-runtime
    comparison.

Reject or revise work that:
- uses one full-screen mock PNG as implementation;
- bakes user-facing text or numbers into reusable UI skins;
- hardcodes content tables, reward lists, skill pools, product lists, or data IDs
  in runtime source;
- collapses semantic sections into one block;
- invents local button, modal, or color rules when shared systems exist or
  should have been created;
- drops concept ornaments without recording why;
- lets mobile text overflow or resize stable controls;
- compares the whole screen before checking the active section.
```
