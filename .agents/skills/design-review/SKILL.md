---
name: design-review
description: "UI 시안, 디자인 토큰, Phaser spec, Unity recipe, 스크린샷을 기준으로 모바일성·전투 가시성·캐릭터 정체성·구현 가능성을 리뷰한다."
argument-hint: "[게임 id] [concept/recipe/screenshot 경로]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, AskUserQuestion
model: sonnet
---

# Design Review

Purpose: act as the design gate before approving concepts, extracted design systems, Phaser runtime UI, or Unity prefabs.

## Always read

- `harness/design/<game>/critique-rubric.yaml`
- relevant concept note/image, Phaser spec/runtime screenshot, or Unity recipe/prefab screenshot
- `harness/design/<game>/art-direction.yaml`
- `harness/design/<game>/layout-tokens.yaml`
- `harness/design/COMPONENT_BLUEPRINTS.md`
- `harness/design/<game>/component-blueprints.yaml`
- `harness/design/<game>/asset-plan.yaml` when implementation assets are involved
- Existing section compare boards or screenshots produced by `harness/tools/design_visual_compare.py` when reviewing implemented UI.

## Review order

1. Check blockers first:
   - wrong orientation
   - combat hidden by UI
   - hamster identity lost
   - non-mobile layout
   - unreadable priority information
2. Score weighted criteria from the rubric.
3. Run `python3 harness/tools/design_blueprint_validate.py <game>` when component blueprints exist.
4. Check whether each surface is split into semantic sections with clear ownership, such as top tabs, content body, board area, bottom nav, modal header/body/footer, or control dock.
5. Check whether repeated components have anatomy, slot, state, box-model, text clamp, skin, asset, and ornament-layer contracts.
6. For implemented visual UI, create or inspect a normalized concept-vs-runtime compare board per active section:
   - Crop the selected concept and runtime screenshot to the same semantic section.
   - Normalize shell width and scale using `python3 harness/tools/design_visual_compare.py`.
   - Judge the section as `PASS`, `WARN`, or `ERROR` before broadening to another section.
7. For Unity recipes, also run `python3 harness/unity/validators/ui_prefab_validate.py` when applicable.
8. For Phaser runtime work, run the relevant `phaser_smoke.py` and `phaser_asset_audit.py` commands when applicable.
9. Give concrete changes as token, blueprint, asset-plan, spec, recipe, or runtime edits, not vague taste comments.

## Output

- PASS/WARN/ERROR with evidence.
- Comparison board path and the concept/runtime crops used when visual runtime exists.
- Suggested next edits.
- Whether the concept can move to `selected`, `extracted`, or `approved`.

## Rules

- Lead with risks and blockers.
- Do not approve attractive images that cannot become repeatable UI atoms.
- Do not approve an extracted UI system that skips `component-blueprints.yaml` for reusable UI.
- Do not approve a large UI surface that jumps directly from full concept to atoms without section decomposition.
- Do not approve scalable panel/card/button skins that mix up `slice_hints` and `content_insets`.
- Do not approve concept border ornaments being silently dropped; they should be either generated as fixed ornament sprites or explicitly rejected with rationale.
- Do not reject a concept only because text is imperfect; concept text is allowed to be pseudo text.
- Do not compare Phaser and Unity screenshots as pixel-perfect targets; check that they preserve the same design system and intentional platform differences.
- Do not recursively tune a section that is semantically based on the wrong concept; mark it `ERROR`, reset the section source, and rebuild from the selected concept.
- Do not advance to the next large section until the current section has a compare board and explicit next edit scope.
