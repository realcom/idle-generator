---
name: gen-ui-concept
description: "게임 UI 시안을 생성하고 harness/design/<game>/concepts에 이미지+노트로 저장한다. 인게임 HUD, 하단바, 팝업, 상점, 보상 화면 등 디자인 방향을 먼저 잡을 때 사용."
argument-hint: "[게임 id] [화면/목표 설명]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion
model: sonnet
---

# UI Concept Generation

Purpose: create visual concepts before prefab or recipe work. Use this when the user needs the game's "face" decided first.

## Always read

- `harness/design/<game>/design-registry.yaml` if it exists.
- Existing `harness/design/<game>/concepts/*.md` for prior directions.
- Relevant source art under `engine/client/Client/Assets/PatchResources/Units/Characters/Assets/` when character style matters.

## Workflow

1. Clarify target screen, orientation, game state, and must-preserve art anchors.
2. Generate 1-3 concept images with `imagegen` when a raster mockup is needed.
3. Save selected or promising outputs to `harness/design/<game>/concepts/{slug}.png`.
4. Add a matching `{slug}.md` with:
   - intent
   - art anchor
   - composition rules
   - UI direction
   - implementation notes
   - source image link
5. Update `harness/design/<game>/design-registry.yaml` with status `draft`, `candidate`, or `selected`.

## Rules

- Do not jump directly to Unity prefab generation.
- Concepts may use pseudo text; exact typography is solved later.
- If using references from another game, capture composition and gameplay feel only, not exact art, labels, or UI.
- Preserve project character identity over external references.
