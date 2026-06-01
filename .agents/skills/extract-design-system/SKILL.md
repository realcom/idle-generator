---
name: extract-design-system
description: "선택된 UI 시안에서 art-direction, layout tokens, component skins, motion juice, critique rubric을 추출해 harness/design/<game>/에 저장한다."
argument-hint: "[게임 id] [concept md/png 경로]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion
model: sonnet
---

# Extract Design System

Purpose: turn an approved or selected concept image into reusable design harness sources.

## Always read

- The selected concept note and image.
- `harness/design/<game>/design-registry.yaml`.
- Existing design source files to avoid overwriting decisions accidentally.

## Outputs

Create or update:

- `harness/design/<game>/art-direction.yaml`
- `harness/design/<game>/layout-tokens.yaml`
- `harness/design/<game>/component-skins.yaml`
- `harness/design/<game>/motion-juice.yaml`
- `harness/design/<game>/critique-rubric.yaml`

## Workflow

1. Identify the concept's non-negotiables: orientation, screen regions, character identity, material language, and core loop.
2. Extract visual tokens: palette, outlines, materials, typography treatment, spacing/region ratios.
3. Extract component skins: repeated cards, buttons, mission cards, HUD strips, tab bars, feedback elements.
4. Extract motion and reward feedback rules only when visible or implied by gameplay.
5. Add blocker checks and weighted critique criteria.
6. Update the design registry status to `extracted` or leave `selected` if human approval is still pending.

## Rules

- Keep files declarative and implementation-neutral where possible.
- Record source concept ids in every output.
- Do not invent engine bindings here; those belong in Unity UI recipes.
